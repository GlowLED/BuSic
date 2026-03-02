import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/common_dialogs.dart';
import '../application/playlist_notifier.dart';
import 'widgets/playlist_tile.dart';

/// Screen displaying all user playlists.
///
/// Features:
/// - Grid or list view of playlists with cover art
/// - "Create playlist" floating action button
/// - Long press for rename/delete context menu
class PlaylistListScreen extends ConsumerWidget {
  const PlaylistListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistListNotifierProvider);
    final l10n = context.l10n;

    return Scaffold(
      body: playlistsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
        data: (playlists) {
          if (playlists.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.library_music_outlined,
                    size: 64,
                    color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noPlaylists,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900
                  ? 4
                  : constraints.maxWidth > 600
                      ? 3
                      : 2;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return PlaylistTile(
                    playlist: playlist,
                    onTap: () {
                      context.go('/playlists/${playlist.id}');
                    },
                    onLongPress: () {
                      _showPlaylistMenu(context, ref, playlist.id, playlist.name);
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createPlaylist(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _createPlaylist(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final name = await CommonDialogs.showInputDialog(
      context,
      title: l10n.createPlaylist,
      hint: l10n.title,
    );
    if (name != null && name.trim().isNotEmpty) {
      await ref
          .read(playlistListNotifierProvider.notifier)
          .createPlaylist(name.trim());
    }
  }

  void _showPlaylistMenu(
    BuildContext context,
    WidgetRef ref,
    int id,
    String currentName,
  ) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.renamePlaylist),
              onTap: () async {
                Navigator.pop(ctx);
                final newName = await CommonDialogs.showInputDialog(
                  context,
                  title: l10n.renamePlaylist,
                  hint: l10n.title,
                  initialValue: currentName,
                );
                if (newName != null && newName.trim().isNotEmpty) {
                  await ref
                      .read(playlistListNotifierProvider.notifier)
                      .renamePlaylist(id, newName.trim());
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: context.colorScheme.error),
              title: Text(
                l10n.deletePlaylist,
                style: TextStyle(color: context.colorScheme.error),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await CommonDialogs.showConfirmDialog(
                  context,
                  title: l10n.deletePlaylist,
                  message: '${l10n.deletePlaylist}?',
                );
                if (confirmed == true) {
                  await ref
                      .read(playlistListNotifierProvider.notifier)
                      .deletePlaylist(id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
