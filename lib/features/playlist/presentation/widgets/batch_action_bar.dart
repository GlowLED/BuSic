import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/playlist_picker_dialog.dart';
import '../../application/playlist_notifier.dart';

/// Action bar displayed during batch selection mode.
///
/// Provides "add to playlist" and "delete" actions for selected songs.
class BatchActionBar extends ConsumerWidget {
  final int playlistId;
  final Set<int> selectedSongIds;
  final VoidCallback onExitEditMode;

  const BatchActionBar({
    super.key,
    required this.playlistId,
    required this.selectedSongIds,
    required this.onExitEditMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Text(
            '已选 ${selectedSongIds.length} 首',
            style: context.textTheme.bodyMedium,
          ),
          const Spacer(),
          TextButton.icon(
            icon: const Icon(Icons.playlist_add, size: 18),
            label: const Text('加入歌单'),
            onPressed: () => _addToPlaylist(context, ref),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            icon: Icon(
              Icons.delete_outline,
              size: 18,
              color: colorScheme.error,
            ),
            label: Text('删除', style: TextStyle(color: colorScheme.error)),
            onPressed: () => _deleteSongs(context, ref, colorScheme),
          ),
        ],
      ),
    );
  }

  Future<void> _addToPlaylist(BuildContext context, WidgetRef ref) async {
    final targetPlaylistId = await showDialog<int>(
      context: context,
      builder: (_) => PlaylistPickerDialog(excludePlaylistId: playlistId),
    );
    if (targetPlaylistId == null || !context.mounted) return;
    final ids = selectedSongIds.toList();
    final notifier = ref.read(
      playlistDetailNotifierProvider(targetPlaylistId).notifier,
    );
    for (final songId in ids) {
      await notifier.addSong(songId);
    }
    if (context.mounted) {
      context.showSnackBar('已添加 ${ids.length} 首歌曲到歌单');
    }
    onExitEditMode();
  }

  Future<void> _deleteSongs(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) async {
    final count = selectedSongIds.length;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定从歌单中移除 $count 首歌曲？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('删除', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      for (final songId in selectedSongIds.toList()) {
        await ref
            .read(playlistDetailNotifierProvider(playlistId).notifier)
            .removeSong(songId);
      }
      if (context.mounted) {
        context.showSnackBar('已移除 $count 首歌曲');
      }
      onExitEditMode();
    }
  }
}
