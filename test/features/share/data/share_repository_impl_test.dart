import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/database/app_database.dart';
import 'package:busic/features/share/data/share_repository_impl.dart';
import 'package:busic/features/share/domain/models/shared_playlist.dart';
import 'package:busic/features/search_and_parse/data/parse_repository.dart';
import 'package:busic/features/search_and_parse/domain/models/audio_stream_info.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_folder.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_item.dart';
import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/domain/models/page_info.dart';

/// Mock ParseRepository，用于测试时模拟 B 站 API
class MockParseRepository implements ParseRepository {
  final Map<String, BvidInfo> _videoInfoMap = {};

  /// 注册模拟的视频信息
  void registerVideoInfo(String bvid, BvidInfo info) {
    _videoInfoMap[bvid] = info;
  }

  @override
  Future<BvidInfo> getVideoInfo(String bvid) async {
    final info = _videoInfoMap[bvid];
    if (info == null) {
      throw Exception('视频不存在: $bvid');
    }
    return info;
  }

  @override
  Future<AudioStreamInfo> getAudioStream(
    String bvid,
    int cid, {
    int? quality,
  }) async {
    throw UnimplementedError('测试中不需要');
  }

  @override
  Future<List<BvidInfo>> searchVideos(
    String keyword, {
    int page = 1,
    int pageSize = 20,
  }) async {
    throw UnimplementedError('测试中不需要');
  }

  @override
  Future<List<AudioStreamInfo>> getAvailableQualities(
    String bvid,
    int cid,
  ) async {
    throw UnimplementedError('测试中不需要');
  }

  @override
  Future<({String imgKey, String subKey})> fetchWbiKeys() async {
    throw UnimplementedError('测试中不需要');
  }

  @override
  Future<List<BiliFavFolder>> getFavoriteFolders(int mid) async {
    throw UnimplementedError('测试中不需要');
  }

  @override
  Future<List<BiliFavItem>> getFavoriteFolderItems(
    int mediaId, {
    void Function(int fetched, int total)? onProgress,
  }) async {
    throw UnimplementedError('测试中不需要');
  }
}

void main() {
  late AppDatabase db;
  late MockParseRepository mockParseRepo;
  late ShareRepositoryImpl shareRepo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    mockParseRepo = MockParseRepository();
    shareRepo = ShareRepositoryImpl(db: db, parseRepo: mockParseRepo);
  });

  tearDown(() async {
    await db.close();
  });

  group('exportPlaylist', () {
    test('导出歌单包含正确的歌曲信息', () async {
      // 插入歌曲
      final songId1 = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1export01',
              cid: 1001,
              originTitle: '原始标题1',
              originArtist: '歌手1',
              customTitle: const Value('自定义标题1'),
            ),
          );

      final songId2 = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1export02',
              cid: 2002,
              originTitle: '原始标题2',
              originArtist: '歌手2',
            ),
          );

      // 创建歌单
      final playlistId = await db.into(db.playlists).insert(
            PlaylistsCompanion.insert(
              name: '导出测试歌单',
              sortOrder: const Value(0),
            ),
          );

      // 关联歌曲
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

      final exported = await shareRepo.exportPlaylist(playlistId);

      expect(exported.name, '导出测试歌单');
      expect(exported.version, 1);
      expect(exported.songs, hasLength(2));
      expect(exported.songs[0].bvid, 'BV1export01');
      expect(exported.songs[0].cid, 1001);
      expect(exported.songs[0].customTitle, '自定义标题1');
      expect(exported.songs[1].bvid, 'BV1export02');
      expect(exported.songs[1].customTitle, isNull);
    });

    test('导出不存在的歌单应抛出异常', () async {
      expect(
        () => shareRepo.exportPlaylist(99999),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('encodeForClipboard / decodeFromClipboard', () {
    test('编码和解码应还原原始数据', () {
      const playlist = SharedPlaylist(
        name: '分享歌单',
        songs: [
          SharedSong(bvid: 'BV1codec01', cid: 1001),
          SharedSong(
            bvid: 'BV1codec02',
            cid: 2002,
            customTitle: '自定义',
            customArtist: '自定义歌手',
          ),
        ],
      );

      final encoded = shareRepo.encodeForClipboard(playlist);
      expect(encoded, startsWith('busic://playlist/'));

      final decoded = shareRepo.decodeFromClipboard(encoded);
      expect(decoded.name, '分享歌单');
      expect(decoded.version, 1);
      expect(decoded.songs, hasLength(2));
      expect(decoded.songs[0].bvid, 'BV1codec01');
      expect(decoded.songs[0].customTitle, isNull);
      expect(decoded.songs[1].bvid, 'BV1codec02');
      expect(decoded.songs[1].customTitle, '自定义');
      expect(decoded.songs[1].customArtist, '自定义歌手');
    });

    test('编码格式应为 busic://playlist/ + base64', () {
      const playlist = SharedPlaylist(
        name: 'test',
        songs: [SharedSong(bvid: 'BV1test', cid: 1)],
      );

      final encoded = shareRepo.encodeForClipboard(playlist);
      expect(encoded, startsWith('busic://playlist/'));

      // 提取 base64 部分并验证可解码
      final base64Part = encoded.substring('busic://playlist/'.length);
      final jsonStr = utf8.decode(base64Decode(base64Part));
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      expect(json['n'], 'test');
      expect(json['s'], hasLength(1));
    });

    test('JSON 键名应使用缩写', () {
      const playlist = SharedPlaylist(
        name: '测试',
        songs: [
          SharedSong(
            bvid: 'BV1short',
            cid: 123,
            customTitle: 'ct',
            customArtist: 'ca',
          ),
        ],
      );

      // toJson() 不会深层转换嵌套对象，需做完整 JSON 往返
      final json = jsonDecode(jsonEncode(playlist.toJson())) as Map<String, dynamic>;
      // 验证使用缩写键名
      expect(json.containsKey('v'), isTrue);
      expect(json.containsKey('n'), isTrue);
      expect(json.containsKey('s'), isTrue);
      final songJson = (json['s'] as List).first as Map<String, dynamic>;
      expect(songJson.containsKey('b'), isTrue);
      expect(songJson.containsKey('c'), isTrue);
      expect(songJson.containsKey('ct'), isTrue);
      expect(songJson.containsKey('ca'), isTrue);
    });

    test('customTitle/customArtist 为 null 时不应序列化', () {
      const playlist = SharedPlaylist(
        name: '测试',
        songs: [SharedSong(bvid: 'BV1null', cid: 1)],
      );

      final json = jsonDecode(jsonEncode(playlist.toJson())) as Map<String, dynamic>;
      final songJson = (json['s'] as List).first as Map<String, dynamic>;
      expect(songJson.containsKey('ct'), isFalse);
      expect(songJson.containsKey('ca'), isFalse);
    });

    test('解码时前缀不匹配应抛出 FormatException', () {
      expect(
        () => shareRepo.decodeFromClipboard('invalid data'),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('不是 BuSic 歌单数据'),
        )),
      );
    });

    test('解码时 Base64 无效应抛出 FormatException', () {
      expect(
        () => shareRepo.decodeFromClipboard('busic://playlist/!!!invalid!!!'),
        throwsA(isA<FormatException>()),
      );
    });

    test('解码时 JSON 无效应抛出 FormatException', () {
      // 有效 Base64 但 JSON 无效
      final invalidBase64 = base64Encode(utf8.encode('not json'));
      expect(
        () => shareRepo.decodeFromClipboard('busic://playlist/$invalidBase64'),
        throwsA(isA<FormatException>()),
      );
    });

    test('解码时版本号过高应抛出 FormatException', () {
      final futureJson =
          jsonEncode({'v': 999, 'n': 'test', 's': []});
      final base64Str = base64Encode(utf8.encode(futureJson));

      expect(
        () => shareRepo.decodeFromClipboard('busic://playlist/$base64Str'),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('升级'),
        )),
      );
    });

    test('解码时歌曲列表为空应抛出 FormatException', () {
      final emptyJson = jsonEncode({'v': 1, 'n': 'empty', 's': []});
      final base64Str = base64Encode(utf8.encode(emptyJson));

      expect(
        () => shareRepo.decodeFromClipboard('busic://playlist/$base64Str'),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('没有歌曲'),
        )),
      );
    });

    test('解码时应支持首尾空白', () {
      const playlist = SharedPlaylist(
        name: '空白测试',
        songs: [SharedSong(bvid: 'BV1ws', cid: 1)],
      );

      final encoded = shareRepo.encodeForClipboard(playlist);
      // 添加首尾空白
      final decoded = shareRepo.decodeFromClipboard('  $encoded  \n');
      expect(decoded.name, '空白测试');
    });
  });

  group('importPlaylist', () {
    test('导入时本地已有歌曲应复用', () async {
      // 预先插入一首歌曲
      await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1reuse01',
              cid: 5001,
              originTitle: '本地已有',
              originArtist: '本地歌手',
            ),
          );

      // 注册另一首的 API 返回
      mockParseRepo.registerVideoInfo(
        'BV1new01',
        const BvidInfo(
          bvid: 'BV1new01',
          title: 'API标题',
          owner: 'API歌手',
          coverUrl: 'https://example.com/cover.jpg',
          pages: [
            PageInfo(cid: 6001, page: 1, partTitle: '分P标题', duration: 180),
          ],
        ),
      );

      const playlist = SharedPlaylist(
        name: '导入测试',
        songs: [
          SharedSong(bvid: 'BV1reuse01', cid: 5001),
          SharedSong(bvid: 'BV1new01', cid: 6001),
        ],
      );

      final progressUpdates = <(int, int)>[];
      final result = await shareRepo.importPlaylist(
        playlist,
        onProgress: (current, total) {
          progressUpdates.add((current, total));
        },
      );

      expect(result.reused, 1);
      expect(result.imported, 1);
      expect(result.failed, 0);
      expect(result.playlistId, isPositive);

      // 验证进度回调
      expect(progressUpdates, hasLength(2));
      expect(progressUpdates.last, (2, 2));

      // 验证数据库
      final songs = await db.select(db.songs).get();
      expect(songs, hasLength(2));

      final psSongs = await (db.select(db.playlistSongs)
            ..where((t) => t.playlistId.equals(result.playlistId)))
          .get();
      expect(psSongs, hasLength(2));
    });

    test('导入时可选覆盖歌单名称', () async {
      mockParseRepo.registerVideoInfo(
        'BV1name01',
        const BvidInfo(
          bvid: 'BV1name01',
          title: '标题',
          owner: '歌手',
          coverUrl: '',
          pages: [PageInfo(cid: 1, page: 1, partTitle: '', duration: 0)],
        ),
      );

      const playlist = SharedPlaylist(
        name: '原始名称',
        songs: [SharedSong(bvid: 'BV1name01', cid: 1)],
      );

      final result = await shareRepo.importPlaylist(
        playlist,
        overrideName: '自定义名称',
      );

      final playlists = await db.select(db.playlists).get();
      final imported = playlists.firstWhere((p) => p.id == result.playlistId);
      expect(imported.name, '自定义名称');
    });

    test('API 拉取失败时应记录失败但不阻塞', () async {
      // 不注册 BV1fail01 的 API 返回，模拟拉取失败
      const playlist = SharedPlaylist(
        name: '部分失败测试',
        songs: [
          SharedSong(bvid: 'BV1fail01', cid: 9001),
        ],
      );

      final result = await shareRepo.importPlaylist(playlist);

      expect(result.failed, 1);
      expect(result.imported, 0);
      expect(result.failedBvids, ['BV1fail01']);
      expect(result.playlistId, isPositive);
    });
  });

  group('导出 → 剪贴板 → 导入往返', () {
    test('歌单导出编码后解码应还原', () async {
      // 插入数据
      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BV1trip01',
              cid: 3001,
              originTitle: '往返标题',
              originArtist: '往返歌手',
              customTitle: const Value('自定义往返'),
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
              songId: songId,
              sortOrder: const Value(0),
            ),
          );

      // 导出
      final exported = await shareRepo.exportPlaylist(playlistId);
      // 编码
      final encoded = shareRepo.encodeForClipboard(exported);
      // 解码
      final decoded = shareRepo.decodeFromClipboard(encoded);

      expect(decoded.name, '往返歌单');
      expect(decoded.songs, hasLength(1));
      expect(decoded.songs.first.bvid, 'BV1trip01');
      expect(decoded.songs.first.cid, 3001);
      expect(decoded.songs.first.customTitle, '自定义往返');
    });
  });
}
