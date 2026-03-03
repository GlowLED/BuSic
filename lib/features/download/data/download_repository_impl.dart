import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/database/app_database.dart';
import '../domain/models/download_task.dart' as domain;
import 'download_repository.dart';

/// Tracks download speed and bytes for a single task.
class _DownloadMetrics {
  int totalBytes = 0;
  int receivedBytes = 0;
  double speed = 0.0;
  int _prevReceived = 0;
  int _prevTime = 0;

  void update(int received, int total) {
    totalBytes = total;
    receivedBytes = received;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_prevTime == 0) {
      _prevTime = now;
      _prevReceived = received;
      return;
    }
    final elapsed = now - _prevTime;
    if (elapsed >= 500) {
      final instantSpeed = (received - _prevReceived) * 1000.0 / elapsed;
      speed = speed == 0 ? instantSpeed : 0.3 * instantSpeed + 0.7 * speed;
      _prevReceived = received;
      _prevTime = now;
    }
  }
}

/// Concrete implementation of [DownloadRepository] using Dio + Drift.
class DownloadRepositoryImpl implements DownloadRepository {
  final BiliDio _dio;
  final AppDatabase _db;
  final Map<int, CancelToken> _cancelTokens = {};
  final Map<int, int> _lastDbProgress = {};
  final Map<int, int> _lastEmitTime = {};
  final Map<int, _DownloadMetrics> _metricsMap = {};
  final Map<int, domain.DownloadTask> _activeTaskCache = {};
  final StreamController<domain.DownloadTask?> _taskUpdateController =
      StreamController.broadcast();

  DownloadRepositoryImpl({required BiliDio dio, required AppDatabase db})
      : _dio = dio,
        _db = db;

  domain.DownloadTask _mapTask(DownloadTask row,
      {String? songTitle, String? songArtist, String? coverUrl}) {
    return domain.DownloadTask(
      id: row.id,
      songId: row.songId,
      status: domain.DownloadStatus.values[row.status.clamp(0, 3)],
      progress: row.progress / 100.0,
      filePath: row.filePath,
      createdAt: row.createdAt,
      songTitle: songTitle,
      songArtist: songArtist,
      coverUrl: coverUrl,
    );
  }

  @override
  Future<int> startDownload({
    required int songId,
    required String url,
    required String savePath,
    int quality = 0,
  }) async {
    final taskId = await _db.into(_db.downloadTasks).insert(
          DownloadTasksCompanion.insert(
            songId: songId,
            filePath: Value(savePath),
          ),
        );

    // Cache task info for quick progress emissions
    final song = await (_db.select(_db.songs)
          ..where((t) => t.id.equals(songId)))
        .getSingleOrNull();
    _activeTaskCache[taskId] = domain.DownloadTask(
      id: taskId,
      songId: songId,
      status: domain.DownloadStatus.pending,
      createdAt: DateTime.now(),
      songTitle: song?.customTitle ?? song?.originTitle,
      songArtist: song?.customArtist ?? song?.originArtist,
      coverUrl: song?.coverUrl,
      filePath: savePath,
    );

    _downloadFile(taskId, songId, url, savePath, quality);
    _taskUpdateController.add(null); // structural change
    return taskId;
  }

  Future<void> _downloadFile(
    int taskId,
    int songId,
    String url,
    String savePath,
    int quality,
  ) async {
    final cancelToken = CancelToken();
    _cancelTokens[taskId] = cancelToken;
    final metrics = _DownloadMetrics();
    _metricsMap[taskId] = metrics;

    try {
      await _updateTaskStatus(taskId, 1);
      final cached = _activeTaskCache[taskId];
      if (cached != null) {
        _activeTaskCache[taskId] =
            cached.copyWith(status: domain.DownloadStatus.downloading);
      }

      await _dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        headers: {
          'Referer': 'https://www.bilibili.com',
        },
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = ((received / total) * 100).round();
            metrics.update(received, total);

            // Persist to DB every 5%
            final lastDb = _lastDbProgress[taskId] ?? 0;
            if (progress - lastDb >= 5) {
              _lastDbProgress[taskId] = progress;
              (_db.update(_db.downloadTasks)
                    ..where((t) => t.id.equals(taskId)))
                  .write(DownloadTasksCompanion(progress: Value(progress)));
            }

            // Emit to stream every ~300ms for real-time UI
            final now = DateTime.now().millisecondsSinceEpoch;
            final lastEmit = _lastEmitTime[taskId] ?? 0;
            if (now - lastEmit >= 300 || progress >= 100) {
              _lastEmitTime[taskId] = now;
              final c = _activeTaskCache[taskId];
              if (c != null) {
                _taskUpdateController.add(c.copyWith(
                  status: domain.DownloadStatus.downloading,
                  progress: progress / 100.0,
                  totalBytes: total,
                  receivedBytes: received,
                  speed: metrics.speed,
                ));
              }
            }
          }
        },
      );

      // Mark completed
      await (_db.update(_db.downloadTasks)
            ..where((t) => t.id.equals(taskId)))
          .write(const DownloadTasksCompanion(
        status: Value(2),
        progress: Value(100),
      ));
      await (_db.update(_db.songs)..where((t) => t.id.equals(songId)))
          .write(SongsCompanion(
        localPath: Value(savePath),
        audioQuality: Value(quality),
      ));
      _taskUpdateController.add(null); // structural change
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      await _updateTaskStatus(taskId, 3);
    } catch (_) {
      await _updateTaskStatus(taskId, 3);
    } finally {
      _cancelTokens.remove(taskId);
      _lastDbProgress.remove(taskId);
      _lastEmitTime.remove(taskId);
      _metricsMap.remove(taskId);
      _activeTaskCache.remove(taskId);
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
    _taskUpdateController.add(null); // structural change
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

    final song = await (_db.select(_db.songs)
          ..where((t) => t.id.equals(row.songId)))
        .getSingleOrNull();
    if (song == null) return;

    await _updateTaskStatus(taskId, 0, progress: 0);
  }

  @override
  Future<void> pauseDownload(int taskId) async {
    _cancelTokens[taskId]?.cancel();
    _cancelTokens.remove(taskId);
  }

  @override
  Future<void> resumeDownload(int taskId) async {
    await retryDownload(taskId);
  }

  @override
  Stream<domain.DownloadTask> watchTask(int taskId) {
    return _taskUpdateController.stream
        .where((task) => task != null && task.id == taskId)
        .map((task) => task!);
  }

  @override
  Stream<List<domain.DownloadTask>> watchAllTasks() async* {
    var cached = await _getAllTasksWithFileSize();
    yield cached;
    await for (final update in _taskUpdateController.stream) {
      if (update != null) {
        // Progress update — merge into cache
        final idx = cached.indexWhere((t) => t.id == update.id);
        if (idx >= 0) {
          cached = List.from(cached)
            ..[idx] = update.copyWith(
              songTitle: cached[idx].songTitle,
              songArtist: cached[idx].songArtist,
              coverUrl: cached[idx].coverUrl,
            );
        } else {
          cached = await _getAllTasksWithFileSize();
        }
      } else {
        // Structural change — full refresh
        cached = await _getAllTasksWithFileSize();
      }
      yield List.from(cached);
    }
  }

  /// Fetches all tasks from DB and reads file sizes for completed ones.
  Future<List<domain.DownloadTask>> _getAllTasksWithFileSize() async {
    final tasks = await getAllTasks();
    final results = <domain.DownloadTask>[];
    for (final task in tasks) {
      if (task.status == domain.DownloadStatus.completed &&
          task.filePath != null) {
        try {
          final file = File(task.filePath!);
          if (await file.exists()) {
            final size = await file.length();
            results.add(task.copyWith(fileSize: size));
          } else {
            results.add(task);
          }
        } catch (_) {
          results.add(task);
        }
      } else {
        results.add(task);
      }
    }
    return results;
  }

  @override
  Future<List<domain.DownloadTask>> getAllTasks() async {
    final query = _db.select(_db.downloadTasks).join([
      leftOuterJoin(
        _db.songs,
        _db.songs.id.equalsExp(_db.downloadTasks.songId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(_db.downloadTasks.createdAt)]);

    final rows = await query.get();
    return rows.map((row) {
      final task = row.readTable(_db.downloadTasks);
      final song = row.readTableOrNull(_db.songs);
      return _mapTask(
        task,
        songTitle: song?.customTitle ?? song?.originTitle,
        songArtist: song?.customArtist ?? song?.originArtist,
        coverUrl: song?.coverUrl,
      );
    }).toList();
  }

  @override
  Future<List<domain.DownloadTask>> getActiveTasks() async {
    final query = _db.select(_db.downloadTasks).join([
      leftOuterJoin(
        _db.songs,
        _db.songs.id.equalsExp(_db.downloadTasks.songId),
      ),
    ])
      ..where(_db.downloadTasks.status.isIn([0, 1]))
      ..orderBy([OrderingTerm.desc(_db.downloadTasks.createdAt)]);

    final rows = await query.get();
    return rows.map((row) {
      final task = row.readTable(_db.downloadTasks);
      final song = row.readTableOrNull(_db.songs);
      return _mapTask(
        task,
        songTitle: song?.customTitle ?? song?.originTitle,
        songArtist: song?.customArtist ?? song?.originArtist,
        coverUrl: song?.coverUrl,
      );
    }).toList();
  }

  @override
  Future<void> clearCompletedTasks() async {
    await (_db.delete(_db.downloadTasks)..where((t) => t.status.equals(2)))
        .go();
    _taskUpdateController.add(null);
  }

  @override
  Future<void> deleteTask(int taskId, {bool deleteFile = false}) async {
    final row = await (_db.select(_db.downloadTasks)
          ..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();

    if (deleteFile && row?.filePath != null) {
      try {
        await File(row!.filePath!).delete();
      } catch (_) {
        // Ignore file deletion errors
      }
      // Clear song's local cache reference
      if (row != null) {
        await (_db.update(_db.songs)..where((t) => t.id.equals(row.songId)))
            .write(const SongsCompanion(
              localPath: Value(null),
              audioQuality: Value(0),
            ));
      }
    }

    _cancelTokens[taskId]?.cancel();
    _cancelTokens.remove(taskId);

    await (_db.delete(_db.downloadTasks)..where((t) => t.id.equals(taskId)))
        .go();
    _taskUpdateController.add(null);
  }
}
