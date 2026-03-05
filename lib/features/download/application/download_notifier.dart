import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/utils/logger.dart';
import '../../auth/application/auth_notifier.dart';
import '../../playlist/application/playlist_notifier.dart';
import '../../search_and_parse/data/parse_repository.dart';
import '../../search_and_parse/data/parse_repository_impl.dart';
import '../../search_and_parse/domain/models/audio_stream_info.dart';
import '../../settings/application/settings_notifier.dart';
import '../data/download_repository.dart';
import '../data/download_repository_impl.dart';
import '../domain/models/download_task.dart';

part 'download_notifier.g.dart';

/// Keep-alive provider for the download repository singleton.
/// This ensures the repository instance (and its stream controller)
/// persists across notifier rebuilds, so progress updates are never lost.
final downloadRepositoryProvider = Provider<DownloadRepository>((ref) {
  return DownloadRepositoryImpl(
    dio: BiliDio(),
    db: ref.read(databaseProvider),
  );
});

/// A simple signal provider that gets incremented whenever download status
/// changes (download completed, file deleted, etc.). Playlist detail providers
/// watch this to know when to refresh cache/quality display.
final downloadChangeSignalProvider = StateProvider<int>((ref) => 0);

/// State notifier managing the download task queue and status.
///
/// Keep-alive so the [watchAllTasks] listener stays active even when the
/// download screen is not visible. This ensures [downloadChangeSignalProvider]
/// fires when downloads complete in the background, allowing playlist views
/// to refresh their download status indicators.
@Riverpod(keepAlive: true)
class DownloadNotifier extends _$DownloadNotifier {
  late DownloadRepository _repository;
  late ParseRepository _parseRepository;
  StreamSubscription? _watchSubscription;
  Set<int> _previousCompletedIds = {};
  bool _listenerInitialized = false;

  @override
  Future<List<DownloadTask>> build() async {
    _repository = ref.read(downloadRepositoryProvider);
    _parseRepository = ParseRepositoryImpl(biliDio: BiliDio());

    _listenerInitialized = false;

    // Watch for updates
    _watchSubscription = _repository.watchAllTasks().listen((tasks) {
      state = AsyncData(tasks);
      // Detect newly completed downloads and signal playlist views to refresh
      final completedIds = tasks
          .where((t) => t.status == DownloadStatus.completed)
          .map((t) => t.id)
          .toSet();
      if (_listenerInitialized) {
        final newlyCompleted =
            completedIds.difference(_previousCompletedIds);
        if (newlyCompleted.isNotEmpty) {
          _notifyDownloadChanged();
        }
      }
      _previousCompletedIds = completedIds;
      _listenerInitialized = true;
    });

    ref.onDispose(() {
      _watchSubscription?.cancel();
    });

    return _repository.getAllTasks();
  }

  /// Notify all playlist views that download status changed.
  void _notifyDownloadChanged() {
    ref.read(downloadChangeSignalProvider.notifier).state++;
    ref.invalidate(playlistListNotifierProvider);
  }

  /// Get available audio qualities for a song.
  Future<List<AudioStreamInfo>> getAvailableQualities({
    required String bvid,
    required int cid,
  }) async {
    return _parseRepository.getAvailableQualities(bvid, cid);
  }

  /// Download a song with selected quality.
  ///
  /// Resolves the audio stream URL for [quality], determines the save path,
  /// and starts the download. If the song already has a download with equal
  /// or higher quality, the download is skipped. If it has a lower quality
  /// download, the old file is replaced.
  ///
  /// Returns `true` if the download was started, `false` if skipped.
  Future<bool> downloadSongWithQuality({
    required int songId,
    required String bvid,
    required int cid,
    required int quality,
    required String title,
  }) async {
    // ── Dedup check: skip if same or higher quality already exists ──
    final tasks = state.valueOrNull ?? [];

    // Check for active download of same song
    final hasActive = tasks.any((t) =>
        t.songId == songId &&
        (t.status == DownloadStatus.pending ||
            t.status == DownloadStatus.downloading));
    if (hasActive) {
      AppLogger.info('Song $songId already downloading, skipping',
          tag: 'Download');
      return false;
    }

    // Check existing completed download quality via repository
    final existingQuality =
        await (_repository as DownloadRepositoryImpl).getSongAudioQuality(songId);
    if (existingQuality >= quality && existingQuality > 0) {
      AppLogger.info(
          'Song $songId already has quality $existingQuality >= $quality, skipping',
          tag: 'Download');
      return false;
    }

    // Remove old lower-quality download if exists
    if (existingQuality > 0) {
      final oldTask = tasks.firstWhere(
        (t) => t.songId == songId && t.status == DownloadStatus.completed,
        orElse: () => tasks.first, // fallback, won't match
      );
      if (oldTask.songId == songId &&
          oldTask.status == DownloadStatus.completed) {
        AppLogger.info(
            'Replacing quality $existingQuality → $quality for song $songId',
            tag: 'Download');
        await _repository.deleteTask(oldTask.id, deleteFile: true);
      }
    }

    // Resolve stream URL for selected quality
    final streamInfo = await _parseRepository.getAudioStream(
      bvid,
      cid,
      quality: quality,
    );

    // Determine save path — use settings cache path or default
    final settingsCachePath = ref.read(settingsNotifierProvider).cachePath;
    String downloadDirPath;
    if (settingsCachePath != null && settingsCachePath.isNotEmpty) {
      downloadDirPath = settingsCachePath;
    } else {
      final dir = await getApplicationDocumentsDirectory();
      downloadDirPath = path.join(dir.path, 'busic', 'downloads');
    }
    final downloadDir = Directory(downloadDirPath);
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    final safeTitle = title.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
    final savePath = path.join(
      downloadDir.path,
      '${safeTitle}_${bvid}_$quality.m4s',
    );

    await _repository.startDownload(
      songId: songId,
      url: streamInfo.url,
      savePath: savePath,
      quality: quality,
    );
    ref.invalidateSelf();
    return true;
  }

  /// Start downloading a song by creating a download task.
  Future<void> downloadSong({
    required int songId,
    required String url,
    required String savePath,
  }) async {
    await _repository.startDownload(
      songId: songId,
      url: url,
      savePath: savePath,
    );
    ref.invalidateSelf();
  }

  /// Cancel an active download.
  Future<void> cancelDownload(int taskId) async {
    await _repository.cancelDownload(taskId);
    ref.invalidateSelf();
  }

  /// Retry a failed download.
  ///
  /// Re-resolves the audio stream URL (since B站 URLs expire) and restarts
  /// the download using the existing task row.
  Future<void> retryDownload(int taskId) async {
    // Find the task to get songId and filePath
    final tasks = state.valueOrNull ?? await _repository.getAllTasks();
    final task = tasks.where((t) => t.id == taskId).firstOrNull;
    if (task == null) return;

    // Look up song's bvid and cid for stream URL resolution
    final songInfo = await _repository.getSongBvidCid(task.songId);
    if (songInfo == null) {
      AppLogger.error('Cannot retry: song ${task.songId} not found',
          tag: 'Download');
      return;
    }

    // Determine quality — use stored quality from the task, fallback to settings
    var quality = await _repository.getTaskQuality(taskId);
    if (quality == 0) {
      quality = ref.read(settingsNotifierProvider).preferredQuality;
    }

    try {
      // Re-resolve stream URL
      final streamInfo = await _parseRepository.getAudioStream(
        songInfo.bvid,
        songInfo.cid,
        quality: quality,
      );

      // Use existing save path or generate a new one
      String savePath;
      if (task.filePath != null && task.filePath!.isNotEmpty) {
        savePath = task.filePath!;
      } else {
        final settingsCachePath = ref.read(settingsNotifierProvider).cachePath;
        String downloadDirPath;
        if (settingsCachePath != null && settingsCachePath.isNotEmpty) {
          downloadDirPath = settingsCachePath;
        } else {
          final dir = await getApplicationDocumentsDirectory();
          downloadDirPath = path.join(dir.path, 'busic', 'downloads');
        }
        final downloadDir = Directory(downloadDirPath);
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        final safeTitle =
            (task.songTitle ?? 'song').replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
        savePath = path.join(
          downloadDir.path,
          '${safeTitle}_${songInfo.bvid}_$quality.m4s',
        );
      }

      await _repository.restartDownload(taskId, streamInfo.url, savePath, quality);
      ref.invalidateSelf();
    } catch (e) {
      AppLogger.error('Retry download failed: $e', tag: 'Download');
    }
  }

  /// Remove completed tasks from the list.
  Future<void> clearCompleted() async {
    await _repository.clearCompletedTasks();
    ref.invalidateSelf();
  }

  /// Delete a task (and optionally its downloaded file).
  ///
  /// For non-completed tasks, partial files are always cleaned up.
  /// When [deleteFile] is true, also clears the song's cached status
  /// and invalidates playlist providers so the UI reflects the change.
  Future<void> deleteTask(int taskId, {bool deleteFile = false}) async {
    await _repository.deleteTask(taskId, deleteFile: deleteFile);
    ref.invalidateSelf();
    // Always notify since partial files are now cleaned up for non-completed
    _notifyDownloadChanged();
  }

  /// Pause an active download.
  ///
  /// Cancels the download and sets status back to pending so it can be
  /// retried later with a fresh stream URL.
  Future<void> pauseDownload(int taskId) async {
    await _repository.pauseDownload(taskId);
    ref.invalidateSelf();
  }

  /// Download all uncached songs from a playlist in batch.
  ///
  /// Filters [songs] for those that are not yet cached, then downloads
  /// each with the given [quality]. Returns the count of songs that
  /// were successfully queued for download.
  Future<int> downloadAllUncached({
    required List<({int id, String bvid, int cid, String title, bool isCached})>
        songs,
    required int quality,
  }) async {
    final uncached = songs.where((s) => !s.isCached).toList();
    if (uncached.isEmpty) return 0;

    int started = 0;
    for (final song in uncached) {
      try {
        final didStart = await downloadSongWithQuality(
          songId: song.id,
          bvid: song.bvid,
          cid: song.cid,
          quality: quality,
          title: song.title,
        );
        if (didStart) started++;
      } catch (e) {
        AppLogger.error(
          'Batch download failed for song ${song.id}: $e',
          tag: 'Download',
        );
      }
    }
    return started;
  }
}
