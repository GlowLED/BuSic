import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/context_extensions.dart';
import '../application/download_notifier.dart';
import '../domain/models/download_task.dart';
import 'widgets/download_task_tile.dart';

/// Download management screen showing all download tasks.
class DownloadScreen extends ConsumerWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(downloadNotifierProvider);
    final l10n = context.l10n;

    return Scaffold(
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.download_outlined,
                    size: 64,
                    color: context.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noSongs,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          final hasCompleted =
              tasks.any((t) => t.status == DownloadStatus.completed);

          return Column(
            children: [
              if (hasCompleted)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.clear_all),
                        label: Text(l10n.clearCompleted),
                        onPressed: () {
                          ref
                              .read(downloadNotifierProvider.notifier)
                              .clearCompleted();
                        },
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return DownloadTaskTile(
                      task: task,
                      songTitle: 'Song #${task.songId}',
                      onCancel: task.status == DownloadStatus.downloading
                          ? () => ref
                              .read(downloadNotifierProvider.notifier)
                              .cancelDownload(task.id)
                          : null,
                      onRetry: task.status == DownloadStatus.failed
                          ? () => ref
                              .read(downloadNotifierProvider.notifier)
                              .retryDownload(task.id)
                          : null,
                      onDelete: () => ref
                          .read(downloadNotifierProvider.notifier)
                          .deleteTask(task.id, deleteFile: true),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
