import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/logger.dart';
import '../../search_and_parse/data/parse_repository.dart';
import '../domain/models/shared_playlist.dart';
import '../domain/models/share_state.dart';
import 'share_repository.dart';

/// [ShareRepository] 的具体实现
///
/// 使用 Drift 数据库读取歌单数据，通过 B 站 API 拉取元数据。
class ShareRepositoryImpl implements ShareRepository {
  final AppDatabase _db;
  final ParseRepository _parseRepo;

  /// 剪贴板编码前缀
  static const _clipboardPrefix = 'busic://playlist/';

  /// 当前支持的最大格式版本号
  static const _maxSupportedVersion = 1;

  /// 并发拉取控制（避免触发 B 站频率限制）
  static const _maxConcurrency = 3;

  ShareRepositoryImpl({
    required AppDatabase db,
    required ParseRepository parseRepo,
  })  : _db = db,
        _parseRepo = parseRepo;

  @override
  Future<SharedPlaylist> exportPlaylist(int playlistId) async {
    // 获取歌单信息
    final playlistRow = await (_db.select(_db.playlists)
          ..where((t) => t.id.equals(playlistId)))
        .getSingleOrNull();
    if (playlistRow == null) {
      throw StateError('歌单不存在: $playlistId');
    }

    // 获取歌单中的歌曲（按 sortOrder 排序）
    final query = _db.select(_db.songs).join([
      innerJoin(
        _db.playlistSongs,
        _db.playlistSongs.songId.equalsExp(_db.songs.id),
      ),
    ])
      ..where(_db.playlistSongs.playlistId.equals(playlistId))
      ..orderBy([OrderingTerm.asc(_db.playlistSongs.sortOrder)]);

    final rows = await query.get();
    final songs = rows.map((row) {
      final song = row.readTable(_db.songs);
      return SharedSong(
        bvid: song.bvid,
        cid: song.cid,
        // 仅当用户修改过时才包含自定义字段
        customTitle: song.customTitle,
        customArtist: song.customArtist,
      );
    }).toList();

    return SharedPlaylist(
      name: playlistRow.name,
      songs: songs,
    );
  }

  @override
  String encodeForClipboard(SharedPlaylist playlist) {
    final jsonStr = jsonEncode(playlist.toJson());
    final base64Str = base64Encode(utf8.encode(jsonStr));
    return '$_clipboardPrefix$base64Str';
  }

  @override
  SharedPlaylist decodeFromClipboard(String data) {
    final trimmed = data.trim();

    // 校验前缀
    if (!trimmed.startsWith(_clipboardPrefix)) {
      throw const FormatException('剪贴板内容不是 BuSic 歌单数据');
    }

    // 提取 Base64 部分
    final base64Str = trimmed.substring(_clipboardPrefix.length);
    if (base64Str.isEmpty) {
      throw const FormatException('数据格式错误，无法解析');
    }

    // Base64 解码
    final String jsonStr;
    try {
      jsonStr = utf8.decode(base64Decode(base64Str));
    } catch (e) {
      throw const FormatException('数据格式错误，无法解析');
    }

    // JSON 反序列化
    final Map<String, dynamic> jsonMap;
    try {
      jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      throw const FormatException('歌单数据损坏或版本不兼容');
    }

    // 版本兼容性检查
    final version = jsonMap['v'] as int? ?? 1;
    if (version > _maxSupportedVersion) {
      throw const FormatException('请升级 BuSic 后再导入');
    }

    final playlist = SharedPlaylist.fromJson(jsonMap);

    // 歌曲列表为空校验
    if (playlist.songs.isEmpty) {
      throw const FormatException('歌单中没有歌曲');
    }

    return playlist;
  }

  @override
  Future<ShareImportResult> importPlaylist(
    SharedPlaylist playlist, {
    String? overrideName,
    void Function(int current, int total)? onProgress,
  }) async {
    final playlistName = overrideName ?? playlist.name;
    final total = playlist.songs.length;
    var imported = 0;
    var reused = 0;
    var failed = 0;
    final failedBvids = <String>[];
    final songIds = <int>[];

    // 创建歌单
    final playlistId = await _db.into(_db.playlists).insert(
          PlaylistsCompanion.insert(name: playlistName),
        );

    // 逐首处理歌曲（使用信号量控制并发）
    final semaphore = _Semaphore(_maxConcurrency);
    final futures = <Future<_SongProcessResult>>[];

    for (final song in playlist.songs) {
      futures.add(_processSong(song, semaphore));
    }

    final results = await Future.wait(futures);
    for (int i = 0; i < results.length; i++) {
      final result = results[i];
      switch (result.status) {
        case _SongStatus.imported:
          imported++;
          songIds.add(result.songId!);
        case _SongStatus.reused:
          reused++;
          songIds.add(result.songId!);
        case _SongStatus.failed:
          failed++;
          failedBvids.add(playlist.songs[i].bvid);
      }
      onProgress?.call(i + 1, total);
    }

    // 批量关联到歌单
    if (songIds.isNotEmpty) {
      await _db.batch((batch) {
        for (int i = 0; i < songIds.length; i++) {
          batch.insert(
            _db.playlistSongs,
            PlaylistSongsCompanion.insert(
              playlistId: playlistId,
              songId: songIds[i],
              sortOrder: Value(i),
            ),
            mode: InsertMode.insertOrIgnore,
          );
        }
      });
    }

    return ShareImportResult(
      playlistId: playlistId,
      imported: imported,
      reused: reused,
      failed: failed,
      failedBvids: failedBvids,
    );
  }

  /// 处理单首歌曲：检查本地是否已有，否则通过 API 拉取元数据
  Future<_SongProcessResult> _processSong(
    SharedSong song,
    _Semaphore semaphore,
  ) async {
    try {
      await semaphore.acquire();

      // 检查本地是否已有该歌曲
      final existing = await (_db.select(_db.songs)
            ..where(
                (t) => t.bvid.equals(song.bvid) & t.cid.equals(song.cid)))
          .getSingleOrNull();

      if (existing != null) {
        semaphore.release();
        return _SongProcessResult(_SongStatus.reused, existing.id);
      }

      // 本地不存在，通过 B 站 API 拉取元数据
      try {
        final videoInfo = await _parseRepo.getVideoInfo(song.bvid);
        final page = videoInfo.pages.firstWhere(
          (p) => p.cid == song.cid,
          orElse: () => videoInfo.pages.first,
        );

        final songId = await _db.into(_db.songs).insert(
              SongsCompanion.insert(
                bvid: song.bvid,
                cid: song.cid,
                originTitle: page.partTitle.isNotEmpty
                    ? page.partTitle
                    : videoInfo.title,
                originArtist: videoInfo.owner,
                coverUrl: Value(videoInfo.coverUrl),
                duration: Value(page.duration),
                customTitle: Value(song.customTitle),
                customArtist: Value(song.customArtist),
              ),
            );

        semaphore.release();
        return _SongProcessResult(_SongStatus.imported, songId);
      } catch (e) {
        AppLogger.warning(
          '拉取元数据失败: ${song.bvid}, cid=${song.cid}',
          tag: 'ShareRepo',
        );
        semaphore.release();
        return _SongProcessResult(_SongStatus.failed, null);
      }
    } catch (e) {
      AppLogger.error(
        '处理歌曲失败: ${song.bvid}',
        tag: 'ShareRepo',
        error: e,
      );
      semaphore.release();
      return _SongProcessResult(_SongStatus.failed, null);
    }
  }
}

/// 歌曲处理状态
enum _SongStatus { imported, reused, failed }

/// 歌曲处理结果
class _SongProcessResult {
  final _SongStatus status;
  final int? songId;
  _SongProcessResult(this.status, this.songId);
}

/// 简单异步信号量，用于控制并发数量
class _Semaphore {
  final int _maxCount;
  int _currentCount = 0;
  final _waitQueue = <Completer<void>>[];

  _Semaphore(this._maxCount);

  Future<void> acquire() async {
    if (_currentCount < _maxCount) {
      _currentCount++;
      return;
    }
    final completer = Completer<void>();
    _waitQueue.add(completer);
    await completer.future;
    _currentCount++;
  }

  void release() {
    _currentCount--;
    if (_waitQueue.isNotEmpty) {
      final next = _waitQueue.removeAt(0);
      next.complete();
    }
  }
}
