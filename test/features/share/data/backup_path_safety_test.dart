import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/database/app_database.dart';
import 'package:busic/features/share/data/sync_repository_impl.dart';
import 'package:busic/features/share/domain/models/app_backup.dart';
import 'package:busic/features/share/domain/models/shared_playlist.dart';

/// 备份/恢复中的下载路径安全性测试
///
/// 验证：
/// 1. 导出备份不包含 localPath 和 audioQuality
/// 2. 在另一台设备恢复备份不会引入无效的下载路径
/// 3. 有下载记录的歌曲在备份中只保留 bvid/cid/自定义字段
/// 4. 恢复后的歌曲 localPath 为 null（不会继承源设备的路径）
/// 5. 覆盖导入时保留本地已有歌曲的 localPath
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late SyncRepositoryImpl syncRepo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    syncRepo = SyncRepositoryImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  // ────────────────────────────────────────────────────────────────
  //  SECTION 1: 导出备份不含 localPath
  // ────────────────────────────────────────────────────────────────

  group('备份导出不含下载路径', () {
    test('有 localPath 的歌曲导出后 SharedSong 不含路径字段', () async {
      // 插入一首已下载的歌曲
      await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1backup01',
              cid: 1001,
              originTitle: '已下载歌曲',
              originArtist: '歌手',
              localPath: const Value('/data/user/0/com.example/cache/song.m4s'),
              audioQuality: const Value(30280),
              customTitle: const Value('自定义标题'),
            ),
          );

      final backup = await syncRepo.exportFullBackup();

      expect(backup.songs, hasLength(1));

      // SharedSong 只有 bvid, cid, customTitle, customArtist
      final song = backup.songs.first;
      expect(song.bvid, 'BV1backup01');
      expect(song.cid, 1001);
      expect(song.customTitle, '自定义标题');

      // 验证 JSON 中不包含 localPath 或 audioQuality
      final json = jsonDecode(jsonEncode(backup.toJson())) as Map<String, dynamic>;
      final songsJson = json['songs'] as List;
      final songJson = songsJson.first as Map<String, dynamic>;

      expect(songJson.containsKey('localPath'), false);
      expect(songJson.containsKey('local_path'), false);
      expect(songJson.containsKey('audioQuality'), false);
      expect(songJson.containsKey('audio_quality'), false);
    });

    test('多首歌（有和无 localPath）导出后都不含路径信息', () async {
      // 有下载
      await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1backup02',
              cid: 2001,
              originTitle: '已下载歌曲A',
              originArtist: '歌手A',
              localPath: const Value('/cache/songA.m4s'),
              audioQuality: const Value(30280),
            ),
          );

      // 无下载
      await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1backup03',
              cid: 2002,
              originTitle: '未下载歌曲B',
              originArtist: '歌手B',
            ),
          );

      final backup = await syncRepo.exportFullBackup();
      expect(backup.songs, hasLength(2));

      // 两首歌都不应含路径
      final json = jsonDecode(jsonEncode(backup.toJson())) as Map<String, dynamic>;
      final songsJson = json['songs'] as List;

      for (final s in songsJson) {
        final m = s as Map<String, dynamic>;
        expect(m.containsKey('localPath'), false);
        expect(m.containsKey('local_path'), false);
      }
    });

    test('SharedSong 模型不含 localPath 字段定义', () {
      // 验证 SharedSong 的 toJson 输出不含路径相关键
      const song = SharedSong(
        bvid: 'BV1verify01',
        cid: 3001,
        customTitle: '标题',
        customArtist: '歌手',
      );

      final json = song.toJson();

      // SharedSong JSON 键为缩写：b, c, ct, ca
      expect(json.containsKey('b'), true);   // bvid
      expect(json.containsKey('c'), true);   // cid
      expect(json.containsKey('ct'), true);  // customTitle
      expect(json.containsKey('ca'), true);  // customArtist

      // 不应包含任何路径相关字段
      expect(json.containsKey('localPath'), false);
      expect(json.containsKey('local_path'), false);
      expect(json.containsKey('audioQuality'), false);
      expect(json.containsKey('audio_quality'), false);
      expect(json.containsKey('filePath'), false);
      expect(json.containsKey('file_path'), false);
    });
  });

  // ────────────────────────────────────────────────────────────────
  //  SECTION 2: 恢复备份不会引入无效路径
  // ────────────────────────────────────────────────────────────────

  group('恢复备份不引入无效路径', () {
    test('合并导入的新歌曲 localPath 应为 null', () async {
      final now = DateTime.now();
      final backup = AppBackup(
        appVersion: '1.0.0',
        createdAt: now,
        playlists: [
          BackupPlaylist(
            originalId: 1,
            name: '导入歌单',
            sortOrder: 0,
            createdAt: now,
          ),
        ],
        songs: const [
          SharedSong(bvid: 'BV1import01', cid: 4001),
          SharedSong(bvid: 'BV1import02', cid: 4002, customTitle: '自定义'),
        ],
        playlistSongs: const [
          BackupPlaylistSong(
            playlistId: 1,
            bvid: 'BV1import01',
            cid: 4001,
            sortOrder: 0,
          ),
          BackupPlaylistSong(
            playlistId: 1,
            bvid: 'BV1import02',
            cid: 4002,
            sortOrder: 1,
          ),
        ],
      );

      await syncRepo.importBackupMerge(backup);

      // 检查所有导入的歌曲
      final songs = await db.select(db.songs).get();
      expect(songs, hasLength(2));

      for (final song in songs) {
        // localPath 必须为 null — 不会从备份引入任何路径
        expect(song.localPath, isNull,
            reason: '歌曲 ${song.bvid} 不应有 localPath');
        expect(song.audioQuality, 0,
            reason: '歌曲 ${song.bvid} audioQuality 应为 0');
      }
    });

    test('覆盖导入时已有歌曲保留本地 localPath', () async {
      // 先在本地下载一首歌
      await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1keep01',
              cid: 5001,
              originTitle: '本地已下载',
              originArtist: '歌手',
              localPath: const Value('/local/cache/kept.m4s'),
              audioQuality: const Value(30280),
            ),
          );

      // 创建一个歌单
      final plId = await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(name: '旧歌单'),
          );
      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(playlistId: plId, songId: 1),
          );

      // 备份包含同一首歌和一首新歌
      final now = DateTime.now();
      final backup = AppBackup(
        appVersion: '1.0.0',
        createdAt: now,
        playlists: [
          BackupPlaylist(
            originalId: 1,
            name: '新歌单',
            sortOrder: 0,
            createdAt: now,
          ),
        ],
        songs: const [
          SharedSong(bvid: 'BV1keep01', cid: 5001), // 与本地已有歌曲相同
          SharedSong(bvid: 'BV1new01', cid: 5002),  // 全新歌曲
        ],
        playlistSongs: const [
          BackupPlaylistSong(
              playlistId: 1, bvid: 'BV1keep01', cid: 5001, sortOrder: 0),
          BackupPlaylistSong(
              playlistId: 1, bvid: 'BV1new01', cid: 5002, sortOrder: 1),
        ],
      );

      final result = await syncRepo.importBackupOverwrite(backup);
      expect(result.songsSkipped, 1); // BV1keep01 已存在，跳过
      expect(result.songsCreated, 1); // BV1new01 是新的

      // 验证本地已有歌曲的 localPath 保留
      final keptSong = await (db.select(db.songs)
            ..where((t) => t.bvid.equals('BV1keep01')))
          .getSingle();
      expect(keptSong.localPath, '/local/cache/kept.m4s');
      expect(keptSong.audioQuality, 30280);

      // 新歌曲没有 localPath
      final newSong = await (db.select(db.songs)
            ..where((t) => t.bvid.equals('BV1new01')))
          .getSingle();
      expect(newSong.localPath, isNull);
      expect(newSong.audioQuality, 0);
    });

    test('导出 → 在另一台设备导入的完整往返不会泄漏路径', () async {
      // ─── 设备 A：有下载的歌曲 ───
      await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1round01',
              cid: 6001,
              originTitle: '设备A歌曲',
              originArtist: '歌手',
              localPath: const Value('C:\\Users\\A\\AppData\\busic\\song.m4s'),
              audioQuality: const Value(30280),
              customTitle: const Value('我的歌'),
            ),
          );

      final plId = await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(name: '我的歌单'),
          );
      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(playlistId: plId, songId: 1),
          );

      // 导出备份
      final backup = await syncRepo.exportFullBackup();

      // 验证备份中不含路径
      expect(backup.songs.first.bvid, 'BV1round01');
      final backupJson = jsonDecode(jsonEncode(backup.toJson()));
      final songJsonList = (backupJson as Map)['songs'] as List;
      expect(
        (songJsonList.first as Map).containsKey('localPath'),
        false,
      );

      // ─── 设备 B：导入备份 ───
      final dbB = AppDatabase.forTesting(NativeDatabase.memory());
      final syncRepoB = SyncRepositoryImpl(db: dbB);

      final importResult = await syncRepoB.importBackupMerge(backup);
      expect(importResult.songsCreated, 1);
      expect(importResult.errors, 0);

      // 设备 B 上的歌曲不应有任何设备 A 的路径
      final songsB = await dbB.select(dbB.songs).get();
      expect(songsB, hasLength(1));
      expect(songsB.first.localPath, isNull,
          reason: '设备B不应继承设备A的本地路径');
      expect(songsB.first.audioQuality, 0,
          reason: '设备B没有缓存，audioQuality应为0');

      // 自定义标题应保留
      expect(songsB.first.customTitle, '我的歌');

      await dbB.close();
    });
  });

  // ────────────────────────────────────────────────────────────────
  //  SECTION 3: AppBackup 不含下载任务
  // ────────────────────────────────────────────────────────────────

  group('备份不含下载任务', () {
    test('有进行中的下载任务时导出备份不包含任务数据', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1task01',
              cid: 7001,
              originTitle: '有任务的歌曲',
              originArtist: '歌手',
            ),
          );

      // 创建下载任务
      await db.into(db.downloadTasks).insert(
            DownloadTasksCompanion.insert(
              songId: songId,
              status: const Value(1), // downloading
              progress: const Value(50),
              filePath: const Value('/cache/downloading.m4s'),
            ),
          );

      final backup = await syncRepo.exportFullBackup();

      // AppBackup 模型中根本没有 download_tasks 字段
      final json = jsonDecode(jsonEncode(backup.toJson())) as Map<String, dynamic>;
      expect(json.containsKey('downloadTasks'), false);
      expect(json.containsKey('download_tasks'), false);
    });

    test('已完成的下载任务也不会出现在备份中', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1task02',
              cid: 7002,
              originTitle: '已完成下载的歌曲',
              originArtist: '歌手',
              localPath: const Value('/cache/done.m4s'),
              audioQuality: const Value(30280),
            ),
          );

      await db.into(db.downloadTasks).insert(
            DownloadTasksCompanion.insert(
              songId: songId,
              status: const Value(2), // completed
              progress: const Value(100),
              filePath: const Value('/cache/done.m4s'),
              quality: const Value(30280),
            ),
          );

      final backup = await syncRepo.exportFullBackup();

      // 歌曲在备份中，但没有路径
      expect(backup.songs, hasLength(1));
      expect(backup.songs.first.bvid, 'BV1task02');

      // JSON 中不含下载任务数据
      final json = jsonDecode(jsonEncode(backup.toJson())) as Map<String, dynamic>;
      expect(json.containsKey('downloadTasks'), false);
    });
  });

  // ────────────────────────────────────────────────────────────────
  //  SECTION 4: 多歌单共享歌曲的备份恢复
  // ────────────────────────────────────────────────────────────────

  group('多歌单共享歌曲的备份恢复', () {
    test('同一首歌在多个歌单中，导出后只出现一次在 songs 列表', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1multi01',
              cid: 8001,
              originTitle: '多歌单共享歌曲',
              originArtist: '歌手',
              localPath: const Value('/cache/multi.m4s'),
              audioQuality: const Value(30280),
            ),
          );

      // 三个歌单引用同一首歌
      for (var i = 0; i < 3; i++) {
        final plId = await db.into(db.playlists).insert(
              PlaylistsCompanion.insert(name: '歌单${i + 1}'),
            );
        await db.into(db.playlistSongs).insert(
              PlaylistSongsCompanion.insert(
                playlistId: plId,
                songId: songId,
                sortOrder: Value(0),
              ),
            );
      }

      final backup = await syncRepo.exportFullBackup();

      // songs 列表应该只有一首歌（去重）
      expect(backup.songs, hasLength(1));
      expect(backup.songs.first.bvid, 'BV1multi01');

      // playlistSongs 应有三条关联
      expect(backup.playlistSongs, hasLength(3));

      // 验证所有关联都指向同一首歌
      for (final ps in backup.playlistSongs) {
        expect(ps.bvid, 'BV1multi01');
        expect(ps.cid, 8001);
      }
    });

    test('恢复多歌单共享歌曲后，歌曲只创建一次', () async {
      final now = DateTime.now();
      final backup = AppBackup(
        appVersion: '1.0.0',
        createdAt: now,
        playlists: [
          BackupPlaylist(
              originalId: 1, name: '恢复歌单X', sortOrder: 0, createdAt: now),
          BackupPlaylist(
              originalId: 2, name: '恢复歌单Y', sortOrder: 1, createdAt: now),
        ],
        songs: const [
          SharedSong(bvid: 'BV1restore01', cid: 9001),
        ],
        playlistSongs: const [
          BackupPlaylistSong(
              playlistId: 1, bvid: 'BV1restore01', cid: 9001, sortOrder: 0),
          BackupPlaylistSong(
              playlistId: 2, bvid: 'BV1restore01', cid: 9001, sortOrder: 0),
        ],
      );

      final result = await syncRepo.importBackupMerge(backup);
      expect(result.songsCreated, 1);
      expect(result.playlistsCreated, 2);

      // 歌曲表只有一条
      final songs = await db.select(db.songs).get();
      expect(songs, hasLength(1));
      expect(songs.first.localPath, isNull);

      // 两个歌单都关联到同一首歌
      final psSongs = await db.select(db.playlistSongs).get();
      expect(psSongs, hasLength(2));

      final songIds = psSongs.map((ps) => ps.songId).toSet();
      expect(songIds, hasLength(1)); // 同一个 songId
    });
  });
}
