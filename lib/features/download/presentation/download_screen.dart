import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/context_extensions.dart';
import '../../playlist/application/playlist_notifier.dart';
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

          final downloadingTasks = tasks
              .where((t) => t.status == DownloadStatus.downloading)
              .toList();
          final pendingTasks = tasks
              .where((t) => t.status == DownloadStatus.pending)
              .toList();
          final completedTasks = tasks
              .where((t) => t.status == DownloadStatus.completed)
              .toList();
          final failedTasks = tasks
              .where((t) => t.status == DownloadStatus.failed)
              .toList();
          final totalCacheSize = completedTasks.fold<int>(
              0, (sum, t) => sum + t.fileSize);

          return CustomScrollView(
            slivers: [
              // Downloading section
              if (downloadingTasks.isNotEmpty) ...[
                _SectionHeader(title: l10n.downloadingQueue),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = downloadingTasks[index];
                      return DownloadTaskTile(
                        task: task,
                        onPause: () => ref
                            .read(downloadNotifierProvider.notifier)
                            .pauseDownload(task.id),
                        onCancel: () => ref
                            .read(downloadNotifierProvider.notifier)
                            .cancelDownload(task.id),
                        onDelete: () => ref
                            .read(downloadNotifierProvider.notifier)
                            .deleteTask(task.id),
                      );
                    },
                    childCount: downloadingTasks.length,
                  ),
                ),
              ],

              // Pending queue section
              if (pendingTasks.isNotEmpty) ...[
                _SectionHeader(title: l10n.pendingQueue),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = pendingTasks[index];
                      return DownloadTaskTile(
                        task: task,
                        onRetry: () => ref
                            .read(downloadNotifierProvider.notifier)
                            .retryDownload(task.id),
                        onDelete: () => ref
                            .read(downloadNotifierProvider.notifier)
                            .deleteTask(task.id),
                      );
                    },
                    childCount: pendingTasks.length,
                  ),
                ),
              ],

              // Failed downloads section
              if (failedTasks.isNotEmpty) ...[
                _SectionHeader(
                  title: l10n.downloadFailed,
                  trailing: TextButton(
                    onPressed: () {
                      for (final task in failedTasks) {
                        ref
                            .read(downloadNotifierProvider.notifier)
                            .retryDownload(task.id);
                      }
                    },
                    child: Text(l10n.retryAll),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = failedTasks[index];
                      return DownloadTaskTile(
                        task: task,
                        onRetry: () => ref
                            .read(downloadNotifierProvider.notifier)
                            .retryDownload(task.id),
                        onDelete: () => ref
                            .read(downloadNotifierProvider.notifier)
                            .deleteTask(task.id, deleteFile: true),
                      );
                    },
                    childCount: failedTasks.length,
                  ),
                ),
              ],

              // Completed downloads section
              if (completedTasks.isNotEmpty) ...[
                _SectionHeader(
                  title: totalCacheSize > 0
                      ? '${l10n.completedDownloads} (${formatBytes(totalCacheSize)})'
                      : l10n.completedDownloads,
                  trailing: TextButton.icon(
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: Text(l10n.clearCompleted),
                    onPressed: () {
                      ref
                          .read(downloadNotifierProvider.notifier)
                          .clearCompleted();
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = completedTasks[index];
                      return DownloadTaskTile(
                        task: task,
                        onDelete: () => ref
                            .read(downloadNotifierProvider.notifier)
                            .deleteTask(task.id, deleteFile: true),
                        onAddToPlaylist: () =>
                            _showPlaylistPicker(context, ref, task),
                      );
                    },
                    childCount: completedTasks.length,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  /// Show playlist picker dialog and add the song to selected playlist.
  Future<void> _showPlaylistPicker(
    BuildContext context,
    WidgetRef ref,
    DownloadTask task,
  ) async {
    final selectedPlaylistId = await showDialog<int>(
      context: context,
      builder: (_) => const _PlaylistPickerDialog(),
    );
    if (selectedPlaylistId == null || !context.mounted) return;

    try {
      await ref
          .read(playlistDetailNotifierProvider(selectedPlaylistId).notifier)
          .addSong(task.songId);
      ref.invalidate(playlistListNotifierProvider);
      if (context.mounted) {
        context.showSnackBar('已添加到歌单');
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar('添加失败: $e');
      }
    }
  }
}

/// Playlist picker dialog for adding a downloaded song to a playlist.
class _PlaylistPickerDialog extends ConsumerWidget {
  const _PlaylistPickerDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistListNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(l10n.addToPlaylist),
      content: SizedBox(
        width: 320,
        height: 400,
        child: playlistsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (playlists) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    Icon(Icons.add_circle_outline, color: colorScheme.primary),
                title: Text(l10n.createPlaylist),
                onTap: () => _createAndSelect(context, ref, l10n),
              ),
              const Divider(),
              if (playlists.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(l10n.noPlaylists,
                        style:
                            TextStyle(color: colorScheme.onSurfaceVariant)),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlists[index];
                      return ListTile(
                        leading: const Icon(Icons.library_music),
                        title: Text(playlist.name),
                        subtitle: Text('${playlist.songCount} 首歌曲'),
                        onTap: () =>
                            Navigator.of(context).pop(playlist.id),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  Future<void> _createAndSelect(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.createPlaylist),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.title),
          onSubmitted: (v) => Navigator.of(ctx).pop(v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (name != null && name.trim().isNotEmpty && context.mounted) {
      final playlist = await ref
          .read(playlistListNotifierProvider.notifier)
          .createPlaylist(name.trim());
      if (context.mounted) {
        Navigator.of(context).pop(playlist.id);
      }
    }
  }
}

/// Section header for the download list.
class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
