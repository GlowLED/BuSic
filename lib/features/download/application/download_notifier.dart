import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/download_repository.dart';
import '../domain/models/download_task.dart';

part 'download_notifier.g.dart';

/// State notifier managing the download task queue and status.
@riverpod
class DownloadNotifier extends _$DownloadNotifier {
  late final DownloadRepository _repository;

  @override
  Future<List<DownloadTask>> build() async {
    // TODO: inject repository, load all tasks, set up watchers
    throw UnimplementedError();
  }

  /// Start downloading a song.
  ///
  /// Resolves the audio stream URL, determines the save path,
  /// and creates a download task.
  Future<void> downloadSong(int songId) async {
    // TODO: resolve stream URL via ParseRepository, start download
    throw UnimplementedError();
  }

  /// Cancel an active download.
  Future<void> cancelDownload(int taskId) async {
    // TODO: call repository.cancelDownload, refresh state
    throw UnimplementedError();
  }

  /// Retry a failed download.
  Future<void> retryDownload(int taskId) async {
    // TODO: call repository.retryDownload, refresh state
    throw UnimplementedError();
  }

  /// Remove completed tasks from the list.
  Future<void> clearCompleted() async {
    // TODO: call repository.clearCompletedTasks, refresh state
    throw UnimplementedError();
  }

  /// Delete a task (and optionally its downloaded file).
  Future<void> deleteTask(int taskId, {bool deleteFile = false}) async {
    // TODO: call repository.deleteTask, refresh state
    throw UnimplementedError();
  }
}
