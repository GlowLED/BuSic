import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../domain/models/download_task.dart';

/// Format bytes to human-readable string.
String formatBytes(int bytes) {
  if (bytes <= 0) return '0 B';
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}

/// Format speed (bytes/s) to human-readable string.
String _formatSpeed(double bytesPerSec) {
  return '${formatBytes(bytesPerSec.round())}/s';
}

/// Format duration in seconds to human readable.
String _formatEta(double seconds) {
  if (seconds.isInfinite || seconds.isNaN || seconds <= 0) return '--:--';
  final s = seconds.round();
  if (s < 60) return '${s}s';
  if (s < 3600) return '${s ~/ 60}m${s % 60}s';
  return '${s ~/ 3600}h${(s % 3600) ~/ 60}m';
}

/// Widget displaying a single download task with cover art, title, artist, and progress.
class DownloadTaskTile extends StatelessWidget {
  final DownloadTask task;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;
  final VoidCallback? onAddToPlaylist;

  const DownloadTaskTile({
    super.key,
    required this.task,
    this.onCancel,
    this.onRetry,
    this.onDelete,
    this.onAddToPlaylist,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeading(context),
      title: Text(
        task.songTitle ?? 'Song #${task.songId}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: _buildSubtitle(context),
      trailing: _buildTrailing(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildLeading(BuildContext context) {
    final colorScheme = context.colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          children: [
            // Cover art
            task.coverUrl != null && task.coverUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: task.coverUrl!,
                    fit: BoxFit.cover,
                    width: 48,
                    height: 48,
                    placeholder: (_, __) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.music_note,
                          color: colorScheme.onSurfaceVariant),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.music_note,
                          color: colorScheme.onSurfaceVariant),
                    ),
                  )
                : Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.music_note,
                        color: colorScheme.onSurfaceVariant),
                  ),
            // Status overlay for downloading
            if (task.status == DownloadStatus.downloading)
              Positioned.fill(
                child: Container(
                  color: Colors.black38,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        value: task.progress > 0 ? task.progress : null,
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            // Status overlay for pending
            if (task.status == DownloadStatus.pending)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(Icons.hourglass_empty,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
            // Status overlay for failed
            if (task.status == DownloadStatus.failed)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.redAccent, size: 20),
                  ),
                ),
              ),
            // Completed check
            if (task.status == DownloadStatus.completed)
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.check, color: Colors.white, size: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final l10n = context.l10n;
    switch (task.status) {
      case DownloadStatus.pending:
        return Text(
          [task.songArtist, l10n.pending].where((s) => s != null && s.isNotEmpty).join(' · '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      case DownloadStatus.downloading:
        final eta = task.speed > 0 && task.totalBytes > 0
            ? (task.totalBytes - task.receivedBytes) / task.speed
            : double.infinity;
        final parts = <String>[
          if (task.songArtist != null && task.songArtist!.isNotEmpty)
            task.songArtist!,
          '${(task.progress * 100).toInt()}%',
          if (task.totalBytes > 0)
            '${formatBytes(task.receivedBytes)}/${formatBytes(task.totalBytes)}',
          if (task.speed > 0) _formatSpeed(task.speed),
          if (eta.isFinite) _formatEta(eta),
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: task.progress > 0 ? task.progress : null,
            ),
            const SizedBox(height: 4),
            Text(
              parts.join('  ·  '),
              style: context.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      case DownloadStatus.completed:
        final parts = <String>[
          if (task.songArtist != null && task.songArtist!.isNotEmpty)
            task.songArtist!,
          l10n.downloaded,
          if (task.fileSize > 0) formatBytes(task.fileSize),
        ];
        return Text(
          parts.join(' · '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      case DownloadStatus.failed:
        return Text(
          task.errorMessage ?? l10n.downloadFailed,
          style: TextStyle(color: context.colorScheme.error),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
    }
  }

  Widget _buildTrailing(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (task.status == DownloadStatus.downloading && onCancel != null)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onCancel,
            tooltip: '取消',
          ),
        if (task.status == DownloadStatus.failed && onRetry != null)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRetry,
            tooltip: '重试',
          ),
        if (task.status == DownloadStatus.completed && onAddToPlaylist != null)
          IconButton(
            icon: const Icon(Icons.playlist_add, size: 22),
            onPressed: onAddToPlaylist,
            tooltip: '添加到歌单',
          ),
        if ((task.status == DownloadStatus.completed ||
                task.status == DownloadStatus.pending) &&
            onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
            tooltip: '删除',
          ),
      ],
    );
  }
}
