import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/app_backup.dart';
import '../domain/models/shared_playlist.dart';
import '../domain/models/sync_state.dart';
import 'sync_repository.dart';

/// [SyncRepository] 的具体实现
///
/// 使用 Drift 数据库进行完整数据的导出和导入。
class SyncRepositoryImpl implements SyncRepository {
  final AppDatabase _db;

  /// 当前 App 版本号
  static const _appVersion = '1.0.0';

  SyncRepositoryImpl({required AppDatabase db}) : _db = db;

  @override
  Future<AppBackup> exportFullBackup() async {
    // 导出所有歌单
    final playlistRows = await (_db.select(_db.playlists)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();

    final backupPlaylists = playlistRows.map((row) {
      return BackupPlaylist(
        originalId: row.id,
        name: row.name,
        coverUrl: row.coverUrl,
        sortOrder: row.sortOrder,
        createdAt: row.createdAt,
      );
    }).toList();

    // 导出所有歌曲（去重，精简为 SharedSong）
    final songRows = await _db.select(_db.songs).get();
    final backupSongs = songRows.map((row) {
      return SharedSong(
        bvid: row.bvid,
        cid: row.cid,
        customTitle: row.customTitle,
        customArtist: row.customArtist,
      );
    }).toList();

    // 导出歌单-歌曲关联关系（使用 bvid+cid 替代本地 ID）
    final psRows = await _db.select(_db.playlistSongs).get();
    final backupPlaylistSongs = <BackupPlaylistSong>[];

    // 构建 songId -> (bvid, cid) 映射
    final songMap = <int, ({String bvid, int cid})>{};
    for (final song in songRows) {
      songMap[song.id] = (bvid: song.bvid, cid: song.cid);
    }

    for (final ps in psRows) {
      final songInfo = songMap[ps.songId];
      if (songInfo != null) {
        backupPlaylistSongs.add(BackupPlaylistSong(
          playlistId: ps.playlistId,
          bvid: songInfo.bvid,
          cid: songInfo.cid,
          sortOrder: ps.sortOrder,
        ));
      }
    }

    return AppBackup(
      appVersion: _appVersion,
      createdAt: DateTime.now(),
      playlists: backupPlaylists,
      songs: backupSongs,
      playlistSongs: backupPlaylistSongs,
    );
  }

  @override
  Future<ImportResult> importBackupMerge(AppBackup backup) async {
    var playlistsCreated = 0;
    var playlistsMerged = 0;
    var songsCreated = 0;
    var songsSkipped = 0;
    var errors = 0;
    final warnings = <String>[];

    // 1. 歌曲合并：按 bvid+cid 匹配
    // 仅同步 customTitle / customArtist，不覆盖本地已有的元数据
    final songIdMap = <String, int>{}; // "bvid:cid" -> 本地 songId

    for (final song in backup.songs) {
      final key = '${song.bvid}:${song.cid}';
      try {
        final existing = await (_db.select(_db.songs)
              ..where(
                  (t) => t.bvid.equals(song.bvid) & t.cid.equals(song.cid)))
            .getSingleOrNull();

        if (existing != null) {
          songIdMap[key] = existing.id;
          songsSkipped++;
        } else {
          // 新歌曲：因为备份中不含完整元数据，使用占位信息
          final songId = await _db.into(_db.songs).insert(
                SongsCompanion.insert(
                  bvid: song.bvid,
                  cid: song.cid,
                  originTitle: song.customTitle ?? '未知标题',
                  originArtist: song.customArtist ?? '未知歌手',
                  customTitle: Value(song.customTitle),
                  customArtist: Value(song.customArtist),
                ),
              );
          songIdMap[key] = songId;
          songsCreated++;
        }
      } catch (e) {
        errors++;
        warnings.add('歌曲导入失败: ${song.bvid} - $e');
        AppLogger.error('合并导入歌曲失败: ${song.bvid}', tag: 'Sync', error: e);
      }
    }

    // 2. 歌单合并：按名称匹配
    final playlistIdMap = <int, int>{}; // 备份 originalId -> 本地 playlistId

    for (final bp in backup.playlists) {
      try {
        final existing = await (_db.select(_db.playlists)
              ..where((t) => t.name.equals(bp.name)))
            .getSingleOrNull();

        if (existing != null) {
          playlistIdMap[bp.originalId] = existing.id;
          playlistsMerged++;
        } else {
          final newId = await _db.into(_db.playlists).insert(
                PlaylistsCompanion.insert(
                  name: bp.name,
                  coverUrl: Value(bp.coverUrl),
                  sortOrder: Value(bp.sortOrder),
                ),
              );
          playlistIdMap[bp.originalId] = newId;
          playlistsCreated++;
        }
      } catch (e) {
        errors++;
        warnings.add('歌单导入失败: ${bp.name} - $e');
        AppLogger.error('合并导入歌单失败: ${bp.name}', tag: 'Sync', error: e);
      }
    }

    // 3. 关联关系重建
    for (final bps in backup.playlistSongs) {
      final localPlaylistId = playlistIdMap[bps.playlistId];
      final key = '${bps.bvid}:${bps.cid}';
      final localSongId = songIdMap[key];

      if (localPlaylistId != null && localSongId != null) {
        try {
          await _db.into(_db.playlistSongs).insert(
                PlaylistSongsCompanion.insert(
                  playlistId: localPlaylistId,
                  songId: localSongId,
                  sortOrder: Value(bps.sortOrder),
                ),
                mode: InsertMode.insertOrIgnore,
              );
        } catch (e) {
          // 关联已存在，忽略
        }
      }
    }

    return ImportResult(
      playlistsCreated: playlistsCreated,
      playlistsMerged: playlistsMerged,
      songsCreated: songsCreated,
      songsSkipped: songsSkipped,
      errors: errors,
      warnings: warnings,
    );
  }

  @override
  Future<ImportResult> importBackupOverwrite(AppBackup backup) async {
    var playlistsCreated = 0;
    var songsCreated = 0;
    var songsSkipped = 0;
    var errors = 0;
    final warnings = <String>[];

    // 1. 清空关联关系和歌单（保留 Songs 表，避免丢失本地缓存）
    await _db.delete(_db.playlistSongs).go();
    await _db.delete(_db.playlists).go();

    // 2. 导入歌曲（已有的跳过）
    final songIdMap = <String, int>{};

    for (final song in backup.songs) {
      final key = '${song.bvid}:${song.cid}';
      try {
        final existing = await (_db.select(_db.songs)
              ..where(
                  (t) => t.bvid.equals(song.bvid) & t.cid.equals(song.cid)))
            .getSingleOrNull();

        if (existing != null) {
          songIdMap[key] = existing.id;
          songsSkipped++;
        } else {
          final songId = await _db.into(_db.songs).insert(
                SongsCompanion.insert(
                  bvid: song.bvid,
                  cid: song.cid,
                  originTitle: song.customTitle ?? '未知标题',
                  originArtist: song.customArtist ?? '未知歌手',
                  customTitle: Value(song.customTitle),
                  customArtist: Value(song.customArtist),
                ),
              );
          songIdMap[key] = songId;
          songsCreated++;
        }
      } catch (e) {
        errors++;
        warnings.add('歌曲导入失败: ${song.bvid} - $e');
      }
    }

    // 3. 重建歌单
    final playlistIdMap = <int, int>{};

    for (final bp in backup.playlists) {
      try {
        final newId = await _db.into(_db.playlists).insert(
              PlaylistsCompanion.insert(
                name: bp.name,
                coverUrl: Value(bp.coverUrl),
                sortOrder: Value(bp.sortOrder),
              ),
            );
        playlistIdMap[bp.originalId] = newId;
        playlistsCreated++;
      } catch (e) {
        errors++;
        warnings.add('歌单创建失败: ${bp.name} - $e');
      }
    }

    // 4. 重建关联关系
    for (final bps in backup.playlistSongs) {
      final localPlaylistId = playlistIdMap[bps.playlistId];
      final key = '${bps.bvid}:${bps.cid}';
      final localSongId = songIdMap[key];

      if (localPlaylistId != null && localSongId != null) {
        try {
          await _db.into(_db.playlistSongs).insert(
                PlaylistSongsCompanion.insert(
                  playlistId: localPlaylistId,
                  songId: localSongId,
                  sortOrder: Value(bps.sortOrder),
                ),
                mode: InsertMode.insertOrIgnore,
              );
        } catch (e) {
          // 忽略重复关联
        }
      }
    }

    return ImportResult(
      playlistsCreated: playlistsCreated,
      playlistsMerged: 0,
      songsCreated: songsCreated,
      songsSkipped: songsSkipped,
      errors: errors,
      warnings: warnings,
    );
  }
}
