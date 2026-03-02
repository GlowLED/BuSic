import '../domain/models/download_task.dart';

/// Abstract repository for managing media download tasks.
///
/// Handles download queue, progress tracking, and file I/O.
abstract class DownloadRepository {
  /// Start downloading audio for [songId] from [url] to [savePath].
  ///
  /// Creates a new download task and begins the download.
  /// Returns the created task's database ID.
  Future<int> startDownload({
    required int songId,
    required String url,
    required String savePath,
  });

  /// Cancel an active download by [taskId].
  Future<void> cancelDownload(int taskId);

  /// Retry a failed download by [taskId].
  Future<void> retryDownload(int taskId);

  /// Pause an active download (if supported by the implementation).
  Future<void> pauseDownload(int taskId);

  /// Resume a paused download.
  Future<void> resumeDownload(int taskId);

  /// Watch a single download task for progress updates.
  ///
  /// Emits updates whenever the task's status or progress changes.
  Stream<DownloadTask> watchTask(int taskId);

  /// Watch all download tasks for changes.
  Stream<List<DownloadTask>> watchAllTasks();

  /// Get all download tasks from the database.
  Future<List<DownloadTask>> getAllTasks();

  /// Get only active (pending + downloading) tasks.
  Future<List<DownloadTask>> getActiveTasks();

  /// Remove completed tasks from the database.
  Future<void> clearCompletedTasks();

  /// Remove a single task from the database.
  ///
  /// Optionally [deleteFile] to also remove the downloaded file from disk.
  Future<void> deleteTask(int taskId, {bool deleteFile = false});
}
