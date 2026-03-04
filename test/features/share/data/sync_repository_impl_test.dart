import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/database/app_database.dart';
import 'package:busic/features/share/data/sync_repository_impl.dart';
import 'package:busic/features/share/domain/models/app_backup.dart';
import 'package:busic/features/share/domain/models/shared_playlist.dart';

void main() {
  // 往返测试会创建多个数据库实例，抑制 drift 告警
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

  group('exportFullBackup', () {
    test('空数据库导出应返回空备份', () async {
      final backup = await syncRepo.exportFullBackup();

      expect(backup.version, 1);
      expect(backup.appVersion, isNotEmpty);
      expect(backup.playlists, isEmpty);
      expect(backup.songs, isEmpty);
      expect(backup.playlistSongs, isEmpty);
    });

    test('导出包含歌单和歌曲', () async {
      // 插入歌曲
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1test001',
              cid: 1001,
              originTitle: '测试歌曲1',
              originArtist: '测试歌手1',
              customTitle: const Value('自定义标题'),
              customArtist: const Value(null),
            ),
          );

      final songId2 = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1test002',
              cid: 2002,
              originTitle: '测试歌曲2',
              originArtist: '测试歌手2',
            ),
          );

      // 插入歌单
      final playlistId = await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(
              name: '测试歌单',
              sortOrder: const Value(0),
            ),
          );

      // 关联歌曲
      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(
              playlistId: playlistId,
              songId: songId,
              sortOrder: const Value(0),
            ),
          );
      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(
              playlistId: playlistId,
              songId: songId2,
              sortOrder: const Value(1),
            ),
          );

      final backup = await syncRepo.exportFullBackup();

      expect(backup.playlists, hasLength(1));
      expect(backup.playlists.first.name, '测试歌单');
      expect(backup.playlists.first.originalId, playlistId);
      expect(backup.songs, hasLength(2));
      expect(backup.songs[0].bvid, 'BV1test001');
      expect(backup.songs[0].customTitle, '自定义标题');
      expect(backup.songs[1].bvid, 'BV1test002');
      expect(backup.songs[1].customTitle, isNull);
      expect(backup.playlistSongs, hasLength(2));
      expect(backup.playlistSongs[0].bvid, 'BV1test001');
      expect(backup.playlistSongs[1].bvid, 'BV1test002');
    });
  });

  group('importBackupMerge', () {
    test('合并导入到空数据库', () async {
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
          SharedSong(bvid: 'BV1abc001', cid: 1001),
          SharedSong(bvid: 'BV1abc002', cid: 2002, customTitle: '自定义'),
        ],
        playlistSongs: const [
          BackupPlaylistSong(
            playlistId: 1,
            bvid: 'BV1abc001',
            cid: 1001,
            sortOrder: 0,
          ),
          BackupPlaylistSong(
            playlistId: 1,
            bvid: 'BV1abc002',
            cid: 2002,
            sortOrder: 1,
          ),
        ],
      );

      final result = await syncRepo.importBackupMerge(backup);

      expect(result.playlistsCreated, 1);
      expect(result.playlistsMerged, 0);
      expect(result.songsCreated, 2);
      expect(result.songsSkipped, 0);
      expect(result.errors, 0);

      // 验证数据库内容
      final playlists = await db.select(db.playlists).get();
      expect(playlists, hasLength(1));
      expect(playlists.first.name, '导入歌单');

      final songs = await db.select(db.songs).get();
      expect(songs, hasLength(2));

      final psSongs = await db.select(db.playlistSongs).get();
      expect(psSongs, hasLength(2));
    });

    test('合并导入时已有歌曲应跳过', () async {
      // 先插入一首歌曲
      await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1abc001',
              cid: 1001,
              originTitle: '已有标题',
              originArtist: '已有歌手',
            ),
          );

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
          SharedSong(bvid: 'BV1abc001', cid: 1001),
          SharedSong(bvid: 'BV1abc002', cid: 2002),
        ],
        playlistSongs: const [
          BackupPlaylistSong(
            playlistId: 1,
            bvid: 'BV1abc001',
            cid: 1001,
            sortOrder: 0,
          ),
          BackupPlaylistSong(
            playlistId: 1,
            bvid: 'BV1abc002',
            cid: 2002,
            sortOrder: 1,
          ),
        ],
      );

      final result = await syncRepo.importBackupMerge(backup);

      expect(result.songsSkipped, 1);
      expect(result.songsCreated, 1);
      expect(result.playlistsCreated, 1);

      // 歌曲表应有 2 首（1 已有 + 1 新建）
      final songs = await db.select(db.songs).get();
      expect(songs, hasLength(2));
    });

    test('合并导入时同名歌单应合并', () async {
      // 先创建同名歌单
      await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(
              name: '已有歌单',
              sortOrder: const Value(0),
            ),
          );

      final now = DateTime.now();
      final backup = AppBackup(
        appVersion: '1.0.0',
        createdAt: now,
        playlists: [
          BackupPlaylist(
            originalId: 1,
            name: '已有歌单',
            sortOrder: 0,
            createdAt: now,
          ),
          BackupPlaylist(
            originalId: 2,
            name: '新歌单',
            sortOrder: 1,
            createdAt: now,
          ),
        ],
        songs: const [],
        playlistSongs: const [],
      );

      final result = await syncRepo.importBackupMerge(backup);

      expect(result.playlistsMerged, 1);
      expect(result.playlistsCreated, 1);

      final playlists = await db.select(db.playlists).get();
      expect(playlists, hasLength(2));
    });
  });

  group('importBackupOverwrite', () {
    test('覆盖导入应清空歌单和关联、保留已有歌曲', () async {
      // 先插入歌曲、歌单、关联
      final existingSongId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1exist01',
              cid: 9999,
              originTitle: '已有歌曲',
              originArtist: '已有歌手',
              localPath: const Value('/cache/test.mp3'),
            ),
          );

      final existingPlaylistId = await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(
              name: '旧歌单',
              sortOrder: const Value(0),
            ),
          );

      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(
              playlistId: existingPlaylistId,
              songId: existingSongId,
            ),
          );

      // 覆盖导入
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
          SharedSong(bvid: 'BV1new001', cid: 3001),
        ],
        playlistSongs: const [
          BackupPlaylistSong(
            playlistId: 1,
            bvid: 'BV1new001',
            cid: 3001,
            sortOrder: 0,
          ),
        ],
      );

      final result = await syncRepo.importBackupOverwrite(backup);

      expect(result.playlistsCreated, 1);
      expect(result.playlistsMerged, 0);
      expect(result.songsCreated, 1);

      // 旧歌单应被清除
      final playlists = await db.select(db.playlists).get();
      expect(playlists, hasLength(1));
      expect(playlists.first.name, '新歌单');

      // 旧歌曲记录应保留（含 localPath）
      final songs = await db.select(db.songs).get();
      expect(songs, hasLength(2)); // 已有 + 新建

      // 旧关联应被清除，新关联已建立
      final psSongs = await db.select(db.playlistSongs).get();
      expect(psSongs, hasLength(1));
    });

    test('覆盖导入时已有歌曲(bvid+cid)应跳过', () async {
      // 先插入相同 bvid+cid 的歌曲
      await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1same001',
              cid: 5001,
              originTitle: '已有标题',
              originArtist: '已有歌手',
            ),
          );

      final now = DateTime.now();
      final backup = AppBackup(
        appVersion: '1.0.0',
        createdAt: now,
        playlists: [
          BackupPlaylist(
            originalId: 1,
            name: '覆盖歌单',
            sortOrder: 0,
            createdAt: now,
          ),
        ],
        songs: const [
          SharedSong(bvid: 'BV1same001', cid: 5001),
        ],
        playlistSongs: const [
          BackupPlaylistSong(
            playlistId: 1,
            bvid: 'BV1same001',
            cid: 5001,
            sortOrder: 0,
          ),
        ],
      );

      final result = await syncRepo.importBackupOverwrite(backup);

      expect(result.songsSkipped, 1);
      expect(result.songsCreated, 0);

      // 歌曲表仍只有 1 首
      final songs = await db.select(db.songs).get();
      expect(songs, hasLength(1));
    });
  });

  group('导出 → 导入往返测试', () {
    test('导出后合并导入应还原数据', () async {
      // 插入测试数据
      final songId1 = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1round01',
              cid: 7001,
              originTitle: '往返歌曲1',
              originArtist: '歌手1',
              customTitle: const Value('自定义1'),
            ),
          );

      final songId2 = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1round02',
              cid: 7002,
              originTitle: '往返歌曲2',
              originArtist: '歌手2',
            ),
          );

      final playlistId = await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(
              name: '往返歌单',
              sortOrder: const Value(0),
            ),
          );

      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(
              playlistId: playlistId,
              songId: songId1,
              sortOrder: const Value(0),
            ),
          );
      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(
              playlistId: playlistId,
              songId: songId2,
              sortOrder: const Value(1),
            ),
          );

      // 导出
      final backup = await syncRepo.exportFullBackup();

      expect(backup.playlists, hasLength(1));
      expect(backup.songs, hasLength(2));
      expect(backup.playlistSongs, hasLength(2));

      // 新建另一个数据库，合并导入
      final db2 = AppDatabase.forTesting(NativeDatabase.memory());
      final syncRepo2 = SyncRepositoryImpl(db: db2);

      final result = await syncRepo2.importBackupMerge(backup);

      expect(result.playlistsCreated, 1);
      expect(result.songsCreated, 2);
      expect(result.errors, 0);

      // 验证新数据库中的数据
      final playlists = await db2.select(db2.playlists).get();
      expect(playlists, hasLength(1));
      expect(playlists.first.name, '往返歌单');

      final songs = await db2.select(db2.songs).get();
      expect(songs, hasLength(2));
      final bvids = songs.map((s) => s.bvid).toSet();
      expect(bvids, containsAll(['BV1round01', 'BV1round02']));

      // 验证自定义标题保留
      final song1 = songs.firstWhere((s) => s.bvid == 'BV1round01');
      expect(song1.customTitle, '自定义1');

      final psSongs = await db2.select(db2.playlistSongs).get();
      expect(psSongs, hasLength(2));

      await db2.close();
    });

    test('导出后覆盖导入应还原数据', () async {
      // 插入测试数据
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1ow001',
              cid: 8001,
              originTitle: '覆盖测试歌曲',
              originArtist: '歌手',
            ),
          );

      final playlistId = await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(
              name: '覆盖测试歌单',
              sortOrder: const Value(0),
            ),
          );

      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(
              playlistId: playlistId,
              songId: songId,
            ),
          );

      // 导出
      final backup = await syncRepo.exportFullBackup();

      // 新数据库，先插入一些数据
      final db2 = AppDatabase.forTesting(NativeDatabase.memory());
      final syncRepo2 = SyncRepositoryImpl(db: db2);

      await db2.into(db2.playlists).insert(
            PlaylistsCompanion.insert(
              name: '应被清除的歌单',
              sortOrder: const Value(0),
            ),
          );

      // 覆盖导入
      final result = await syncRepo2.importBackupOverwrite(backup);

      expect(result.playlistsCreated, 1);
      expect(result.errors, 0);

      // 旧歌单应不存在
      final playlists = await db2.select(db2.playlists).get();
      expect(playlists, hasLength(1));
      expect(playlists.first.name, '覆盖测试歌单');

      await db2.close();
    });
  });

  group('AppBackup JSON 序列化', () {
    test('AppBackup 应正确序列化和反序列化', () {
      final now = DateTime.now();
      final backup = AppBackup(
        appVersion: '1.0.0',
        createdAt: now,
        playlists: [
          BackupPlaylist(
            originalId: 1,
            name: '测试歌单',
            sortOrder: 0,
            createdAt: now,
          ),
        ],
        songs: const [
          SharedSong(bvid: 'BV1json01', cid: 100),
        ],
        playlistSongs: const [
          BackupPlaylistSong(
            playlistId: 1,
            bvid: 'BV1json01',
            cid: 100,
            sortOrder: 0,
          ),
        ],
      );

      // toJson() 不深层转换嵌套对象，需做 JSON 往返确保可反序列化
      final json = jsonDecode(jsonEncode(backup.toJson())) as Map<String, dynamic>;
      final restored = AppBackup.fromJson(json);

      expect(restored.version, backup.version);
      expect(restored.appVersion, backup.appVersion);
      expect(restored.playlists, hasLength(1));
      expect(restored.playlists.first.name, '测试歌单');
      expect(restored.songs, hasLength(1));
      expect(restored.songs.first.bvid, 'BV1json01');
      expect(restored.playlistSongs, hasLength(1));
    });
  });
}
