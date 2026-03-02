import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/database/app_database.dart';
import '../domain/models/download_task.dart' as domain;
import 'download_repository.dart';

/// Concrete implementation of [DownloadRepository] using Dio + Drift.
class DownloadRepositoryImpl implements DownloadRepository {
  final BiliDio _dio;
  final AppDatabase _db;
  final Map<int, CancelToken> _cancelTokens = {};
  final StreamController<domain.DownloadTask> _taskUpdateController =
      StreamController.broadcast();

  DownloadRepositoryImpl({required BiliDio dio, required AppDatabase db})
      : _dio = dio,
        _db = db;

  domain.DownloadTask _mapTask(DownloadTask row) {
    return domain.DownloadTask(
      id: row.id,
      songId: row.songId,
      status: domain.DownloadStatus.values[row.status.clamp(0, 3)],
      progress: row.progress / 100.0,
      filePath: row.filePath,
      createdAt: row.createdAt,
    );
  }

  @override
  Future<int> startDownload({
    required int songId,
    required String url,
    required String savePath,
  }) async {
    // Create task in DB
    final taskId = await _db.into(_db.downloadTasks).insert(
          DownloadTasksCompanion.insert(
            songId: songId,
            filePath: Value(savePath),
          ),
        );

    // Start async download
    _downloadFile(taskId, songId, url, savePath);

    return taskId;
  }

  Future<void> _downloadFile(
    int taskId,
    int songId,
    String url,
    String savePath,
  ) async {
    final cancelToken = CancelToken();
    _cancelTokens[taskId] = cancelToken;

    try {
      // Update status to downloading
      await _updateTaskStatus(taskId, 1);

      await _dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = ((received / total) * 100).round();
            _updateTaskProgress(taskId, progress);
          }
        },
      );

      // Mark completed
      await _updateTaskStatus(taskId, 2, progress: 100);

      // Update song's local path
      await (_db.update(_db.songs)..where((t) => t.id.equals(songId)))
          .write(SongsCompanion(localPath: Value(savePath)));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      await _updateTaskStatus(taskId, 3);
    } catch (_) {
      await _updateTaskStatus(taskId, 3);
    } finally {
      _cancelTokens.remove(taskId);
    }
  }

  Future<void> _updateTaskStatus(int taskId, int status,
      {int? progress}) async {
    final companion = DownloadTasksCompanion(
      status: Value(status),
      progress: progress != null ? Value(progress) : const Value.absent(),
    );
    await (_db.update(_db.downloadTasks)..where((t) => t.id.equals(taskId)))
        .write(companion);

    // Emit update
    final row = await (_db.select(_db.downloadTasks)
          ..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();
    if (row != null) {
      _taskUpdateController.add(_mapTask(row));
    }
  }

  Future<void> _updateTaskProgress(int taskId, int progress) async {
    await (_db.update(_db.downloadTasks)..where((t) => t.id.equals(taskId)))
        .write(DownloadTasksCompanion(progress: Value(progress)));
  }

  @override
  Future<void> cancelDownload(int taskId) async {
    _cancelTokens[taskId]?.cancel();
    _cancelTokens.remove(taskId);
    await _updateTaskStatus(taskId, 3);
  }

  @override
  Future<void> retryDownload(int taskId) async {
    final row = await (_db.select(_db.downloadTasks)
          ..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();
    if (row == null || row.filePath == null) return;

    // Get song info for URL
    final song = await (_db.select(_db.songs)
          ..where((t) => t.id.equals(row.songId)))
        .getSingleOrNull();
    if (song == null) return;

    // Reset status
    await _updateTaskStatus(taskId, 0, progress: 0);

    // Note: stream URL needs to be re-resolved; for now just mark as pending
    // The download notifier should handle resolving the URL
  }

  @override
  Future<void> pauseDownload(int taskId) async {
    _cancelTokens[taskId]?.cancel();
    _cancelTokens.remove(taskId);
    // Keep status as downloading but stop the transfer
  }

  @override
  Future<void> resumeDownload(int taskId) async {
    // Re-resolve and restart - simplified approach
    await retryDownload(taskId);
  }

  @override
  Stream<domain.DownloadTask> watchTask(int taskId) {
    return _taskUpdateController.stream
        .where((task) => task.id == taskId);
  }

  @override
  Stream<List<domain.DownloadTask>> watchAllTasks() async* {
    yield await getAllTasks();
    await for (final _ in _taskUpdateController.stream) {
      yield await getAllTasks();
    }
  }

  @override
  Future<List<domain.DownloadTask>> getAllTasks() async {
    final rows = await (_db.select(_db.downloadTasks)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_mapTask).toList();
  }

  @override
  Future<List<domain.DownloadTask>> getActiveTasks() async {
    final rows = await (_db.select(_db.downloadTasks)
          ..where((t) => t.status.isIn([0, 1]))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_mapTask).toList();
  }

  @override
  Future<void> clearCompletedTasks() async {
    await (_db.delete(_db.downloadTasks)..where((t) => t.status.equals(2)))
        .go();
  }

  @override
  Future<void> deleteTask(int taskId, {bool deleteFile = false}) async {
    if (deleteFile) {
      final row = await (_db.select(_db.downloadTasks)
            ..where((t) => t.id.equals(taskId)))
          .getSingleOrNull();
      if (row?.filePath != null) {
        try {
          await File(row!.filePath!).delete();
        } catch (_) {
          // Ignore file deletion errors
        }
      }
    }

    _cancelTokens[taskId]?.cancel();
    _cancelTokens.remove(taskId);

    await (_db.delete(_db.downloadTasks)..where((t) => t.id.equals(taskId)))
        .go();
  }
}
