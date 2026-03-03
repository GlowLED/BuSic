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

    /// Song title (populated from songs table for display).
    String? songTitle,

    /// Song artist (populated from songs table for display).
    String? songArtist,

    /// Cover image URL (populated from songs table for display).
    String? coverUrl,

    /// Total bytes of the download (runtime only, not persisted).
    @Default(0) int totalBytes,

    /// Bytes received so far (runtime only).
    @Default(0) int receivedBytes,

    /// Current download speed in bytes/s (runtime only).
    @Default(0.0) double speed,

    /// File size on disk in bytes (for completed downloads).
    @Default(0) int fileSize,
  }) = _DownloadTask;

  factory DownloadTask.fromJson(Map<String, dynamic> json) =>
      _$DownloadTaskFromJson(json);
}
