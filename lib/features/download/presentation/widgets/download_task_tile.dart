import 'package:flutter/material.dart';

import '../../domain/models/download_task.dart';

/// Widget displaying a single download task with progress.
///
/// Shows:
/// - Song title
/// - Progress bar (for downloading status)
/// - Status icon/text
/// - Action button: cancel (downloading), retry (failed), delete (completed)
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
    // TODO: implement download task tile UI
    // - Leading: status icon
    // - Title: song name
    // - Subtitle: progress bar or status text
    // - Trailing: action button based on status
    return const ListTile(
      title: Text('TODO: DownloadTaskTile'),
    );
  }
}
