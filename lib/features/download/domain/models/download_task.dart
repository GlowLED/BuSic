import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_task.freezed.dart';
part 'download_task.g.dart';

/// Status of a download task.
enum DownloadStatus {
  /// Queued, waiting to start.
  pending,

  /// Currently downloading.
  downloading,

  /// Successfully downloaded and saved to disk.
  completed,

  /// Download failed (network error, disk error, etc.).
  failed,
}

/// Domain model representing a media download task.
@freezed
class DownloadTask with _$DownloadTask {
  const factory DownloadTask({
    /// Database primary key.
    required int id,

    /// Associated song database ID.
    required int songId,

    /// Current download status.
    required DownloadStatus status,

    /// Download progress from 0.0 to 1.0.
    @Default(0.0) double progress,

    /// Target local file path.
    String? filePath,

    /// Error message if status is [DownloadStatus.failed].
    String? errorMessage,

    /// Timestamp when the task was created.
    required DateTime createdAt,
  }) = _DownloadTask;

  factory DownloadTask.fromJson(Map<String, dynamic> json) =>
      _$DownloadTaskFromJson(json);
}
