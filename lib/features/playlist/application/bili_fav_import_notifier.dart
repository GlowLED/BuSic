import 'dart:async';

import 'package:drift/drift.dart' hide JsonKey;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/logger.dart';
import '../../auth/application/auth_notifier.dart';
import '../../search_and_parse/data/parse_repository.dart';
import '../../search_and_parse/data/parse_repository_impl.dart';
import '../../search_and_parse/domain/models/bili_fav_folder.dart';
import '../../search_and_parse/domain/models/bili_fav_item.dart';
import 'playlist_notifier.dart';

part 'bili_fav_import_notifier.freezed.dart';
part 'bili_fav_import_notifier.g.dart';

// ── State ────────────────────────────────────────────────────────────────

@freezed
class BiliFavImportState with _$BiliFavImportState {
  /// 初始/空闲状态
  const factory BiliFavImportState.idle() = _Idle;

  /// 正在加载收藏夹列表
  const factory BiliFavImportState.loadingFolders() = _LoadingFolders;

  /// 已加载收藏夹列表，等待用户选择
  const factory BiliFavImportState.foldersLoaded(
    List<BiliFavFolder> folders,
  ) = _FoldersLoaded;

  /// 正在拉取收藏夹内容
  const factory BiliFavImportState.loadingItems({
    required String folderName,
    required int fetched,
    required int total,
  }) = _LoadingItems;

  /// 已加载收藏夹内容，等待用户确认导入
  const factory BiliFavImportState.itemsLoaded({
    required String folderName,
    required List<BiliFavItem> items,
  }) = _ItemsLoaded;

  /// 正在导入歌曲到本地歌单
  const factory BiliFavImportState.importing({
    required int current,
    required int total,
  }) = _Importing;

  /// 导入完成
  const factory BiliFavImportState.completed({
    required int playlistId,
    required int imported,
    required int reused,
    required int failed,
    required List<String> failedBvids,
  }) = _Completed;

  /// 出错
  const factory BiliFavImportState.error(String message) = _Error;
}

// ── Notifier ─────────────────────────────────────────────────────────────

@riverpod
class BiliFavImportNotifier extends _$BiliFavImportNotifier {
  late final ParseRepository _parseRepo;
  late final AppDatabase _db;

  /// 并发拉取控制（避免触发 B 站频率限制）
  static const _maxConcurrency = 3;

  @override
  BiliFavImportState build() {
    _parseRepo = ParseRepositoryImpl(biliDio: BiliDio());
    _db = ref.read(databaseProvider);
    return const BiliFavImportState.idle();
  }

  /// 加载用户的 B 站收藏夹列表
  Future<void> loadFolders() async {
    ref.keepAlive();
    state = const BiliFavImportState.loadingFolders();
    try {
      final user = await ref.read(authNotifierProvider.future);
      if (user == null) {
        state = const BiliFavImportState.error('pleaseLoginFirst');
        return;
      }
      final mid = int.tryParse(user.userId);
      if (mid == null) {
        state = const BiliFavImportState.error('pleaseLoginFirst');
        return;
      }
      final folders = await _parseRepo.getFavoriteFolders(mid);
      state = BiliFavImportState.foldersLoaded(folders);
    } catch (e) {
      AppLogger.error('加载收藏夹列表失败', tag: 'BiliFavImport', error: e);
      state = BiliFavImportState.error(e.toString());
    }
  }

  /// 加载指定收藏夹的全部内容
  Future<List<BiliFavItem>?> loadFolderItems(BiliFavFolder folder) async {
    ref.keepAlive();
    state = BiliFavImportState.loadingItems(
      folderName: folder.title,
      fetched: 0,
      total: folder.mediaCount,
    );
    try {
      final items = await _parseRepo.getFavoriteFolderItems(
        folder.id,
        onProgress: (fetched, total) {
          state = BiliFavImportState.loadingItems(
            folderName: folder.title,
            fetched: fetched,
            total: total,
          );
        },
      );
      state = BiliFavImportState.itemsLoaded(
        folderName: folder.title,
        items: items,
      );
      return items;
    } catch (e) {
      AppLogger.error('加载收藏夹内容失败', tag: 'BiliFavImport', error: e);
      state = BiliFavImportState.error(e.toString());
      return null;
    }
  }

  /// 执行导入：创建歌单并逐首处理歌曲
  ///
  /// 与 [ShareRepositoryImpl.importPlaylist] 采用相同的并发模式。
  Future<void> importToPlaylist({
    required String playlistName,
    required List<BiliFavItem> items,
  }) async {
    final link = ref.keepAlive();
    state = BiliFavImportState.importing(current: 0, total: items.length);

    var imported = 0;
    var reused = 0;
    var failed = 0;
    final failedBvids = <String>[];
    final songIds = <int>[];

    try {
      // 1. 创建歌单
      final playlistId = await _db.into(_db.playlists).insert(
            PlaylistsCompanion.insert(name: playlistName),
          );

      // 2. 并发处理每首歌曲（信号量控制）
      final semaphore = _Semaphore(_maxConcurrency);
      final futures = <Future<_SongResult>>[];

      for (final item in items) {
        futures.add(_processFavItem(item, semaphore));
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
            failedBvids.add(items[i].bvid);
        }
        state = BiliFavImportState.importing(
          current: i + 1,
          total: items.length,
        );
      }

      // 3. 批量关联到歌单
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

      // 4. 刷新歌单列表
      ref.invalidate(playlistListNotifierProvider);

      state = BiliFavImportState.completed(
        playlistId: playlistId,
        imported: imported,
        reused: reused,
        failed: failed,
        failedBvids: failedBvids,
      );
    } catch (e) {
      AppLogger.error('导入收藏夹失败', tag: 'BiliFavImport', error: e);
      state = BiliFavImportState.error(e.toString());
    } finally {
      link.close();
    }
  }

  /// 处理单首收藏夹视频：检查本地是否已有，否则通过 API 拉取元数据
  Future<_SongResult> _processFavItem(
    BiliFavItem item,
    _Semaphore semaphore,
  ) async {
    try {
      await semaphore.acquire();

      // 检查本地是否已有该歌曲 (bvid + firstCid)
      final existing = await (_db.select(_db.songs)
            ..where(
                (t) => t.bvid.equals(item.bvid) & t.cid.equals(item.firstCid)))
          .getSingleOrNull();

      if (existing != null) {
        semaphore.release();
        return _SongResult(_SongStatus.reused, existing.id);
      }

      // 本地不存在，通过 B 站 API 拉取完整元数据
      try {
        final videoInfo = await _parseRepo.getVideoInfo(item.bvid);
        final page = videoInfo.pages.firstWhere(
          (p) => p.cid == item.firstCid,
          orElse: () => videoInfo.pages.isNotEmpty
              ? videoInfo.pages.first
              : throw StateError('No pages found for ${item.bvid}'),
        );

        final songId = await _db.into(_db.songs).insert(
              SongsCompanion.insert(
                bvid: item.bvid,
                cid: page.cid,
                originTitle: page.partTitle.isNotEmpty
                    ? page.partTitle
                    : videoInfo.title,
                originArtist: videoInfo.owner,
                coverUrl: Value(videoInfo.coverUrl),
                duration: Value(page.duration),
              ),
            );

        semaphore.release();
        return _SongResult(_SongStatus.imported, songId);
      } catch (e) {
        AppLogger.warning(
          '拉取元数据失败: ${item.bvid}',
          tag: 'BiliFavImport',
        );
        semaphore.release();
        return _SongResult(_SongStatus.failed, null);
      }
    } catch (e) {
      AppLogger.error(
        '处理歌曲失败: ${item.bvid}',
        tag: 'BiliFavImport',
        error: e,
      );
      semaphore.release();
      return _SongResult(_SongStatus.failed, null);
    }
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────

enum _SongStatus { imported, reused, failed }

class _SongResult {
  final _SongStatus status;
  final int? songId;
  _SongResult(this.status, this.songId);
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
