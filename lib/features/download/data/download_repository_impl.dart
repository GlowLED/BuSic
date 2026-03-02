import '../domain/models/download_task.dart';
import 'download_repository.dart';

/// Concrete implementation of [DownloadRepository] using Dio + Drift.
///
/// Downloads are performed via Dio with progress callbacks.
/// Task state is persisted in the Drift database.
/// On Android, may need foreground service for background downloads.
class DownloadRepositoryImpl implements DownloadRepository {
  // TODO: inject BiliDio, AppDatabase, and configure download directory

  @override
  Future<int> startDownload({
    required int songId,
    required String url,
    required String savePath,
  }) {
    // TODO: create task in DB, start Dio download with onReceiveProgress
    // Update song's localPath in Songs table on completion
    throw UnimplementedError();
  }

  @override
  Future<void> cancelDownload(int taskId) {
    // TODO: cancel Dio CancelToken, update task status to failed
    throw UnimplementedError();
  }

  @override
  Future<void> retryDownload(int taskId) {
    // TODO: reset task status to pending, restart download
    throw UnimplementedError();
  }

  @override
  Future<void> pauseDownload(int taskId) {
    // TODO: pause download if supported (range request resume)
    throw UnimplementedError();
  }

  @override
  Future<void> resumeDownload(int taskId) {
    // TODO: resume download with Range header
    throw UnimplementedError();
  }

  @override
  Stream<DownloadTask> watchTask(int taskId) {
    // TODO: watch Drift query for single task
    throw UnimplementedError();
  }

  @override
  Stream<List<DownloadTask>> watchAllTasks() {
    // TODO: watch Drift query for all tasks ordered by createdAt DESC
    throw UnimplementedError();
  }

  @override
  Future<List<DownloadTask>> getAllTasks() {
    // TODO: SELECT * FROM download_tasks ORDER BY created_at DESC
    throw UnimplementedError();
  }

  @override
  Future<List<DownloadTask>> getActiveTasks() {
    // TODO: SELECT * FROM download_tasks WHERE status IN (0, 1)
    throw UnimplementedError();
  }

  @override
  Future<void> clearCompletedTasks() {
    // TODO: DELETE FROM download_tasks WHERE status = 2
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask(int taskId, {bool deleteFile = false}) {
    // TODO: delete from DB, optionally delete local file
    throw UnimplementedError();
  }
}
