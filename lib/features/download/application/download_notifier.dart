import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/bili_dio.dart';
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

/// State notifier managing the download task queue and status.
@riverpod
class DownloadNotifier extends _$DownloadNotifier {
  late DownloadRepository _repository;
  late ParseRepository _parseRepository;
  StreamSubscription? _watchSubscription;

  @override
  Future<List<DownloadTask>> build() async {
    _repository = ref.read(downloadRepositoryProvider);
    _parseRepository = ParseRepositoryImpl(biliDio: BiliDio());

    // Watch for updates
    _watchSubscription = _repository.watchAllTasks().listen((tasks) {
      state = AsyncData(tasks);
    });

    ref.onDispose(() {
      _watchSubscription?.cancel();
    });

    return _repository.getAllTasks();
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
  /// and starts the download.
  Future<void> downloadSongWithQuality({
    required int songId,
    required String bvid,
    required int cid,
    required int quality,
    required String title,
  }) async {
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
  Future<void> retryDownload(int taskId) async {
    await _repository.retryDownload(taskId);
    ref.invalidateSelf();
  }

  /// Remove completed tasks from the list.
  Future<void> clearCompleted() async {
    await _repository.clearCompletedTasks();
    ref.invalidateSelf();
  }

  /// Delete a task (and optionally its downloaded file).
  ///
  /// When [deleteFile] is true, also clears the song's cached status
  /// and invalidates playlist providers so the UI reflects the change.
  Future<void> deleteTask(int taskId, {bool deleteFile = false}) async {
    await _repository.deleteTask(taskId, deleteFile: deleteFile);
    ref.invalidateSelf();
    if (deleteFile) {
      // Refresh playlist views to update cache status
      ref.invalidate(playlistListNotifierProvider);
    }
  }
}
