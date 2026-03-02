import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../domain/models/download_task.dart';

/// Widget displaying a single download task with progress.
class DownloadTaskTile extends StatelessWidget {
  final DownloadTask task;
  final String songTitle;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;

  const DownloadTaskTile({
    super.key,
    required this.task,
    required this.songTitle,
    this.onCancel,
    this.onRetry,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      leading: _buildStatusIcon(context),
      title: Text(
        songTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: _buildSubtitle(context, l10n),
      trailing: _buildAction(context),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    switch (task.status) {
      case DownloadStatus.pending:
        return Icon(Icons.hourglass_empty,
            color: context.colorScheme.onSurfaceVariant);
      case DownloadStatus.downloading:
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: task.progress > 0 ? task.progress : null,
            strokeWidth: 2.5,
          ),
        );
      case DownloadStatus.completed:
        return Icon(Icons.check_circle, color: context.colorScheme.primary);
      case DownloadStatus.failed:
        return Icon(Icons.error, color: context.colorScheme.error);
    }
  }

  Widget _buildSubtitle(BuildContext context, dynamic l10n) {
    switch (task.status) {
      case DownloadStatus.pending:
        return Text(l10n.pending);
      case DownloadStatus.downloading:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: task.progress > 0 ? task.progress : null,
            ),
            const SizedBox(height: 4),
            Text('${(task.progress * 100).toInt()}%'),
          ],
        );
      case DownloadStatus.completed:
        return Text(l10n.downloaded);
      case DownloadStatus.failed:
        return Text(
          task.errorMessage ?? l10n.downloadFailed,
          style: TextStyle(color: context.colorScheme.error),
        );
    }
  }

  Widget? _buildAction(BuildContext context) {
    switch (task.status) {
      case DownloadStatus.downloading:
        return IconButton(
          icon: const Icon(Icons.close),
          onPressed: onCancel,
        );
      case DownloadStatus.failed:
        return IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRetry,
        );
      case DownloadStatus.completed:
      case DownloadStatus.pending:
        return IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        );
    }
  }
}
