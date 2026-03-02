import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/bili_dio.dart';
import '../../auth/application/auth_notifier.dart';
import '../data/download_repository.dart';
import '../data/download_repository_impl.dart';
import '../domain/models/download_task.dart';

part 'download_notifier.g.dart';

/// State notifier managing the download task queue and status.
@riverpod
class DownloadNotifier extends _$DownloadNotifier {
  late final DownloadRepository _repository;
  StreamSubscription? _watchSubscription;

  @override
  Future<List<DownloadTask>> build() async {
    _repository = DownloadRepositoryImpl(
      dio: BiliDio(),
      db: ref.read(databaseProvider),
    );

    // Watch for updates
    _watchSubscription = _repository.watchAllTasks().listen((tasks) {
      state = AsyncData(tasks);
    });

    ref.onDispose(() {
      _watchSubscription?.cancel();
    });

    return _repository.getAllTasks();
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
  Future<void> deleteTask(int taskId, {bool deleteFile = false}) async {
    await _repository.deleteTask(taskId, deleteFile: deleteFile);
    ref.invalidateSelf();
  }
}
