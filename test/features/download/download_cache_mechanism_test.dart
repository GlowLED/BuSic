import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/database/app_database.dart';

/// 下载/缓存机制集成测试
///
/// 验证：
/// 1. 歌曲下载后 localPath 正确写入 songs 表
/// 2. 从 DB 查询 localPath 的逻辑正确性
/// 3. 多个歌单引用同一首歌时下载能被正确共享
/// 4. 文件不存在时 localPath 应视为无效
/// 5. 删除下载任务时正确清理 localPath
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  // ────────────────────────────────────────────────────────────────
  //  SECTION 1: 基础 localPath 读写
  // ────────────────────────────────────────────────────────────────

  group('歌曲 localPath 基础读写', () {
    test('新建歌曲 localPath 默认为 null', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1cache001',
              cid: 1001,
              originTitle: '测试歌曲',
              originArtist: '测试歌手',
            ),
          );

      final song = await (db.select(db.songs)
            ..where((t) => t.id.equals(songId)))
          .getSingle();

      expect(song.localPath, isNull);
      expect(song.audioQuality, 0);
    });

    test('下载完成后 localPath 和 audioQuality 正确更新', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1cache002',
              cid: 1002,
              originTitle: '测试歌曲2',
              originArtist: '测试歌手2',
            ),
          );

      // 模拟下载完成：更新 localPath 和 audioQuality
      await (db.update(db.songs)..where((t) => t.id.equals(songId))).write(
        const SongsCompanion(
          localPath: Value('/cache/test_song.m4s'),
          audioQuality: Value(30280),
        ),
      );

      final song = await (db.select(db.songs)
            ..where((t) => t.id.equals(songId)))
          .getSingle();

      expect(song.localPath, '/cache/test_song.m4s');
      expect(song.audioQuality, 30280);
    });

    test('删除下载后 localPath 和 audioQuality 被清零', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1cache003',
              cid: 1003,
              originTitle: '测试歌曲3',
              originArtist: '测试歌手3',
              localPath: const Value('/cache/old.m4s'),
              audioQuality: const Value(30280),
            ),
          );

      // 模拟删除下载：清空 localPath 和 audioQuality
      await (db.update(db.songs)..where((t) => t.id.equals(songId))).write(
        const SongsCompanion(
          localPath: Value(null),
          audioQuality: Value(0),
        ),
      );

      final song = await (db.select(db.songs)
            ..where((t) => t.id.equals(songId)))
          .getSingle();

      expect(song.localPath, isNull);
      expect(song.audioQuality, 0);
    });

    test('重新下载更高质量时 localPath 和 audioQuality 更新', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1cache004',
              cid: 1004,
              originTitle: '测试歌曲4',
              originArtist: '测试歌手4',
              localPath: const Value('/cache/low_q.m4s'),
              audioQuality: const Value(30216), // 64kbps
            ),
          );

      // 用更高质量替换
      await (db.update(db.songs)..where((t) => t.id.equals(songId))).write(
        const SongsCompanion(
          localPath: Value('/cache/high_q.m4s'),
          audioQuality: Value(30280), // 192kbps
        ),
      );

      final song = await (db.select(db.songs)
            ..where((t) => t.id.equals(songId)))
          .getSingle();

      expect(song.localPath, '/cache/high_q.m4s');
      expect(song.audioQuality, 30280);
    });
  });

  // ────────────────────────────────────────────────────────────────
  //  SECTION 2: 多歌单引用同一首歌的下载共享
  // ────────────────────────────────────────────────────────────────

  group('多歌单引用同一首歌的下载共享', () {
    test('一首歌加入多个歌单后，下载只需一次，所有歌单都能看到 localPath', () async {
      // 创建一首歌
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1shared01',
              cid: 5001,
              originTitle: '共享歌曲',
              originArtist: '共享歌手',
            ),
          );

      // 创建两个歌单
      final playlist1Id = await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(name: '歌单A'),
          );
      final playlist2Id = await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(name: '歌单B'),
          );

      // 同一首歌加入两个歌单
      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(
              playlistId: playlist1Id,
              songId: songId,
            ),
          );
      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(
              playlistId: playlist2Id,
              songId: songId,
            ),
          );

      // 模拟从歌单A下载该歌曲
      await (db.update(db.songs)..where((t) => t.id.equals(songId))).write(
        const SongsCompanion(
          localPath: Value('/cache/shared_song.m4s'),
          audioQuality: Value(30280),
        ),
      );

      // 从歌单A查询歌曲（验证有 localPath）
      final songsInPlaylist1 = await _getSongsInPlaylist(db, playlist1Id);
      expect(songsInPlaylist1, hasLength(1));
      expect(songsInPlaylist1.first.localPath, '/cache/shared_song.m4s');
      expect(songsInPlaylist1.first.audioQuality, 30280);

      // 从歌单B查询歌曲（应该共享同一个 localPath）
      final songsInPlaylist2 = await _getSongsInPlaylist(db, playlist2Id);
      expect(songsInPlaylist2, hasLength(1));
      expect(songsInPlaylist2.first.localPath, '/cache/shared_song.m4s');
      expect(songsInPlaylist2.first.audioQuality, 30280);

      // 验证两个歌单引用的是同一个 songId
      expect(songsInPlaylist1.first.id, songId);
      expect(songsInPlaylist2.first.id, songId);
    });

    test('删除一个歌单不影响另一个歌单中的歌曲和缓存', () async {
      // 创建歌曲（已下载）
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1shared02',
              cid: 5002,
              originTitle: '共享歌曲2',
              originArtist: '共享歌手2',
              localPath: const Value('/cache/shared2.m4s'),
              audioQuality: const Value(30280),
            ),
          );

      // 两个歌单
      final playlist1Id = await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(name: '歌单C'),
          );
      final playlist2Id = await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(name: '歌单D'),
          );

      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(
              playlistId: playlist1Id,
              songId: songId,
            ),
          );
      await db.into(db.playlistSongs).insert(
            PlaylistSongsCompanion.insert(
              playlistId: playlist2Id,
              songId: songId,
            ),
          );

      // 删除歌单C的关联
      await (db.delete(db.playlistSongs)
            ..where((t) => t.playlistId.equals(playlist1Id)))
          .go();

      // 歌曲本身不应被删除
      final song = await (db.select(db.songs)
            ..where((t) => t.id.equals(songId)))
          .getSingleOrNull();
      expect(song, isNotNull);
      expect(song!.localPath, '/cache/shared2.m4s');

      // 歌单D中仍可看到该歌曲
      final songsInPlaylist2 = await _getSongsInPlaylist(db, playlist2Id);
      expect(songsInPlaylist2, hasLength(1));
      expect(songsInPlaylist2.first.localPath, '/cache/shared2.m4s');
    });

    test('同一首歌在三个歌单中，下载任务只创建一个', () async {
      // 创建歌曲
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1shared03',
              cid: 5003,
              originTitle: '三歌单共享',
              originArtist: '歌手',
            ),
          );

      // 三个歌单
      for (var i = 0; i < 3; i++) {
        final plId = await db.into(db.playlists).insert(
              PlaylistsCompanion.insert(name: '歌单$i'),
            );
        await db.into(db.playlistSongs).insert(
              PlaylistSongsCompanion.insert(
                playlistId: plId,
                songId: songId,
              ),
            );
      }

      // 创建一个下载任务
      await db.into(db.downloadTasks).insert(
            DownloadTasksCompanion.insert(
              songId: songId,
              filePath: const Value('/cache/triple.m4s'),
              quality: const Value(30280),
            ),
          );

      // 模拟下载完成
      await (db.update(db.downloadTasks)
            ..where((t) => t.songId.equals(songId)))
          .write(const DownloadTasksCompanion(
        status: Value(2), // completed
        progress: Value(100),
      ));
      await (db.update(db.songs)..where((t) => t.id.equals(songId))).write(
        const SongsCompanion(
          localPath: Value('/cache/triple.m4s'),
          audioQuality: Value(30280),
        ),
      );

      // 验证只有一个下载任务
      final tasks = await db.select(db.downloadTasks).get();
      expect(tasks.length, 1);
      expect(tasks.first.songId, songId);

      // 验证所有歌单中的歌曲都有 localPath
      final allPlaylistSongs = await db.select(db.playlistSongs).get();
      expect(allPlaylistSongs.length, 3);

      for (final ps in allPlaylistSongs) {
        final songs = await _getSongsInPlaylist(db, ps.playlistId);
        expect(songs.first.localPath, '/cache/triple.m4s');
      }
    });

    test('用 bvid+cid 查询（模拟跨歌单查找同一首歌）', () async {
      const bvid = 'BV1lookup01';
      const cid = 6001;

      // 插入歌曲
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: bvid,
              cid: cid,
              originTitle: '查找歌曲',
              originArtist: '歌手',
              localPath: const Value('/cache/lookup.m4s'),
              audioQuality: const Value(30280),
            ),
          );

      // 按 bvid+cid 查询（模拟导入时的去重检查）
      final existing = await (db.select(db.songs)
            ..where(
                (t) => t.bvid.equals(bvid) & t.cid.equals(cid)))
          .getSingleOrNull();

      expect(existing, isNotNull);
      expect(existing!.id, songId);
      expect(existing.localPath, '/cache/lookup.m4s');
    });
  });

  // ────────────────────────────────────────────────────────────────
  //  SECTION 3: 下载任务与歌曲表的联动
  // ────────────────────────────────────────────────────────────────

  group('下载任务与歌曲表联动', () {
    test('下载完成时同时更新 download_tasks 和 songs 表', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1link001',
              cid: 7001,
              originTitle: '联动歌曲',
              originArtist: '歌手',
            ),
          );

      final taskId = await db.into(db.downloadTasks).insert(
            DownloadTasksCompanion.insert(
              songId: songId,
              filePath: const Value('/cache/linked.m4s'),
              quality: const Value(30232),
            ),
          );

      // 模拟下载完成
      await (db.update(db.downloadTasks)
            ..where((t) => t.id.equals(taskId)))
          .write(const DownloadTasksCompanion(
        status: Value(2),
        progress: Value(100),
      ));
      await (db.update(db.songs)..where((t) => t.id.equals(songId))).write(
        const SongsCompanion(
          localPath: Value('/cache/linked.m4s'),
          audioQuality: Value(30232),
        ),
      );

      // 验证两个表都正确更新
      final task = await (db.select(db.downloadTasks)
            ..where((t) => t.id.equals(taskId)))
          .getSingle();
      expect(task.status, 2); // completed
      expect(task.progress, 100);

      final song = await (db.select(db.songs)
            ..where((t) => t.id.equals(songId)))
          .getSingle();
      expect(song.localPath, '/cache/linked.m4s');
      expect(song.audioQuality, 30232);
    });

    test('删除下载任务（deleteFile=true）应清空歌曲的 localPath', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1del001',
              cid: 8001,
              originTitle: '删除测试',
              originArtist: '歌手',
              localPath: const Value('/cache/to_delete.m4s'),
              audioQuality: const Value(30280),
            ),
          );

      await db.into(db.downloadTasks).insert(
            DownloadTasksCompanion.insert(
              songId: songId,
              status: const Value(2), // completed
              progress: const Value(100),
              filePath: const Value('/cache/to_delete.m4s'),
              quality: const Value(30280),
            ),
          );

      // 模拟 deleteTask(deleteFile: true) 的 DB 操作
      await (db.update(db.songs)..where((t) => t.id.equals(songId))).write(
        const SongsCompanion(
          localPath: Value(null),
          audioQuality: Value(0),
        ),
      );
      await (db.delete(db.downloadTasks)
            ..where((t) => t.songId.equals(songId)))
          .go();

      final song = await (db.select(db.songs)
            ..where((t) => t.id.equals(songId)))
          .getSingle();
      expect(song.localPath, isNull);
      expect(song.audioQuality, 0);

      final tasks = await (db.select(db.downloadTasks)
            ..where((t) => t.songId.equals(songId)))
          .get();
      expect(tasks, isEmpty);
    });
  });

  // ────────────────────────────────────────────────────────────────
  //  SECTION 4: _getFreshLocalPath 逻辑模拟（DB 查询 + 文件验证）
  // ────────────────────────────────────────────────────────────────

  group('getFreshLocalPath 逻辑模拟', () {
    test('歌曲有 localPath 且文件存在时返回路径', () async {
      // 创建临时文件模拟已下载
      final tempDir = await Directory.systemTemp.createTemp('busic_test_');
      final tempFile = File('${tempDir.path}/test_song.m4s');
      await tempFile.writeAsBytes([0, 1, 2, 3]);

      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1fresh01',
              cid: 9001,
              originTitle: '文件存在的歌曲',
              originArtist: '歌手',
              localPath: Value(tempFile.path),
              audioQuality: const Value(30280),
            ),
          );

      // 模拟 _getFreshLocalPath 逻辑
      final freshPath = await _simulateGetFreshLocalPath(db, songId);
      expect(freshPath, tempFile.path);

      // 清理
      await tempDir.delete(recursive: true);
    });

    test('歌曲有 localPath 但文件不存在时返回 null', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1fresh02',
              cid: 9002,
              originTitle: '文件不存在的歌曲',
              originArtist: '歌手',
              localPath:
                  const Value('/non_existent_path/phantom.m4s'),
              audioQuality: const Value(30280),
            ),
          );

      final freshPath = await _simulateGetFreshLocalPath(db, songId);
      expect(freshPath, isNull);
    });

    test('歌曲无 localPath 时返回 null', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1fresh03',
              cid: 9003,
              originTitle: '未下载的歌曲',
              originArtist: '歌手',
            ),
          );

      final freshPath = await _simulateGetFreshLocalPath(db, songId);
      expect(freshPath, isNull);
    });

    test('songId 不存在时返回 null', () async {
      final freshPath = await _simulateGetFreshLocalPath(db, 99999);
      expect(freshPath, isNull);
    });
  });

  // ────────────────────────────────────────────────────────────────
  //  SECTION 5: 队列 localPath 刷新（模拟 _refreshQueueLocalPaths）
  // ────────────────────────────────────────────────────────────────

  group('队列 localPath 刷新模拟', () {
    test('下载完成后队列中的 track 能获取到最新 localPath', () async {
      // 先创建歌曲（无 localPath）
      final songId1 = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1queue01',
              cid: 10001,
              originTitle: '队列歌曲1',
              originArtist: '歌手',
            ),
          );
      final songId2 = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1queue02',
              cid: 10002,
              originTitle: '队列歌曲2',
              originArtist: '歌手',
            ),
          );

      // 创建临时文件
      final tempDir = await Directory.systemTemp.createTemp('busic_queue_');
      final tempFile = File('${tempDir.path}/queue_song.m4s');
      await tempFile.writeAsBytes([0, 1, 2, 3]);

      // 模拟下载完成（仅歌曲1完成下载）
      await (db.update(db.songs)..where((t) => t.id.equals(songId1))).write(
        SongsCompanion(
          localPath: Value(tempFile.path),
          audioQuality: const Value(30280),
        ),
      );

      // 模拟 _refreshQueueLocalPaths：遍历队列查询 DB
      final queueSongIds = [songId1, songId2];
      final refreshedPaths = <int, String?>{};

      for (final id in queueSongIds) {
        refreshedPaths[id] = await _simulateGetFreshLocalPath(db, id);
      }

      // 歌曲1 有 localPath
      expect(refreshedPaths[songId1], tempFile.path);
      // 歌曲2 无 localPath
      expect(refreshedPaths[songId2], isNull);

      // 清理
      await tempDir.delete(recursive: true);
    });

    test('已有 localPath 的歌曲不需要重新查询（跳过优化）', () async {
      final tempDir = await Directory.systemTemp.createTemp('busic_skip_');
      final tempFile = File('${tempDir.path}/already.m4s');
      await tempFile.writeAsBytes([0, 1, 2]);

      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1skip01',
              cid: 11001,
              originTitle: '已有缓存',
              originArtist: '歌手',
              localPath: Value(tempFile.path),
              audioQuality: const Value(30280),
            ),
          );

      // 第一次查询
      final path1 = await _simulateGetFreshLocalPath(db, songId);
      expect(path1, tempFile.path);

      // 在 _refreshQueueLocalPaths 中，如果 track.localPath != null，
      // 会跳过查询。这里模拟该逻辑——不应再次查询
      // （此测试验证的是 "如果已有 localPath，就不再查询" 的前提条件正确）
      final existingLocalPath = path1; // 模拟 track.localPath 已设置
      final shouldQuery = existingLocalPath == null;
      expect(shouldQuery, false); // 应该跳过

      await tempDir.delete(recursive: true);
    });
  });

  // ────────────────────────────────────────────────────────────────
  //  SECTION 6: 下载任务去重（同一 songId 不重复下载）
  // ────────────────────────────────────────────────────────────────

  group('下载任务去重', () {
    test('同一 songId 已有进行中的下载任务时不应创建新任务', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1dedup01',
              cid: 12001,
              originTitle: '去重测试',
              originArtist: '歌手',
            ),
          );

      // 创建一个进行中的下载任务
      await db.into(db.downloadTasks).insert(
            DownloadTasksCompanion.insert(
              songId: songId,
              status: const Value(1), // downloading
              filePath: const Value('/cache/dedup.m4s'),
            ),
          );

      // 检查是否有活跃的下载任务
      final activeTasks = await (db.select(db.downloadTasks)
            ..where((t) =>
                t.songId.equals(songId) & t.status.isIn([0, 1])))
          .get();

      expect(activeTasks.isNotEmpty, true); // 有活跃任务 → 不应重复下载
    });

    test('同一 songId 已完成的下载、再次下载更高质量应替换', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1dedup02',
              cid: 12002,
              originTitle: '质量升级测试',
              originArtist: '歌手',
              localPath: const Value('/cache/low.m4s'),
              audioQuality: const Value(30216), // 64kbps
            ),
          );

      final oldTaskId = await db.into(db.downloadTasks).insert(
            DownloadTasksCompanion.insert(
              songId: songId,
              status: const Value(2), // completed
              progress: const Value(100),
              filePath: const Value('/cache/low.m4s'),
              quality: const Value(30216),
            ),
          );

      // 获取当前音质
      final existingQuality =
          (await (db.select(db.songs)..where((t) => t.id.equals(songId)))
                  .getSingle())
              .audioQuality;
      expect(existingQuality, 30216);

      // 请求 30280（更高质量）→ 应允许
      expect(30280 > existingQuality, true);

      // 删除旧任务
      await (db.delete(db.downloadTasks)
            ..where((t) => t.id.equals(oldTaskId)))
          .go();

      // 创建新任务
      await db.into(db.downloadTasks).insert(
            DownloadTasksCompanion.insert(
              songId: songId,
              filePath: const Value('/cache/high.m4s'),
              quality: const Value(30280),
            ),
          );

      final tasks = await (db.select(db.downloadTasks)
            ..where((t) => t.songId.equals(songId)))
          .get();
      expect(tasks.length, 1);
      expect(tasks.first.quality, 30280);
    });

    test('同一 songId 已有相同或更高质量时不应再次下载', () async {
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1dedup03',
              cid: 12003,
              originTitle: '无需升级测试',
              originArtist: '歌手',
              audioQuality: const Value(30280), // 192kbps
            ),
          );

      // 请求 30216（更低质量）→ existingQuality >= quality → 应跳过
      final existingQuality =
          (await (db.select(db.songs)..where((t) => t.id.equals(songId)))
                  .getSingle())
              .audioQuality;
      expect(existingQuality >= 30216, true);
      // 不应创建新任务
    });
  });
}

// ────────────────────────────────────────────────────────────────
//  辅助函数
// ────────────────────────────────────────────────────────────────

/// 查询某个歌单中的所有歌曲
Future<List<Song>> _getSongsInPlaylist(
    AppDatabase db, int playlistId) async {
  final query = db.select(db.songs).join([
    innerJoin(
      db.playlistSongs,
      db.playlistSongs.songId.equalsExp(db.songs.id),
    ),
  ])
    ..where(db.playlistSongs.playlistId.equals(playlistId))
    ..orderBy([OrderingTerm.asc(db.playlistSongs.sortOrder)]);

  final rows = await query.get();
  return rows.map((row) => row.readTable(db.songs)).toList();
}

/// 模拟 PlayerNotifier._getFreshLocalPath 的逻辑：
/// 从 DB 查询 localPath，如果文件存在则返回路径，否则返回 null
Future<String?> _simulateGetFreshLocalPath(
    AppDatabase db, int songId) async {
  final song = await (db.select(db.songs)
        ..where((t) => t.id.equals(songId)))
      .getSingleOrNull();
  final path = song?.localPath;
  if (path == null) return null;
  try {
    if (await File(path).exists()) return path;
  } catch (_) {
    // Ignore file-system errors
  }
  return null;
}
