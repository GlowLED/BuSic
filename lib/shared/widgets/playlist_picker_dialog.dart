import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/playlist/application/playlist_notifier.dart';
import '../../l10n/generated/app_localizations.dart';
import 'common_dialogs.dart';

/// Reusable dialog for selecting a target playlist.
///
/// Returns the selected playlist ID via [Navigator.pop], or `null` if
/// the user cancelled.
///
/// If [excludePlaylistId] is provided, that playlist will be hidden
/// from the list (useful when moving songs between playlists).
class PlaylistPickerDialog extends ConsumerWidget {
  /// Optional playlist ID to exclude from the list.
  final int? excludePlaylistId;

  const PlaylistPickerDialog({super.key, this.excludePlaylistId});

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
          data: (playlists) {
            final filtered = excludePlaylistId != null
                ? playlists
                    .where((p) => p.id != excludePlaylistId)
                    .toList()
                : playlists;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.add_circle_outline,
                      color: colorScheme.primary),
                  title: Text(l10n.createPlaylist),
                  onTap: () => _createAndSelect(context, ref, l10n),
                ),
                const Divider(),
                if (filtered.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.noPlaylists,
                        style:
                            TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final playlist = filtered[index];
                        return ListTile(
                          leading: Icon(playlist.isFavorite
                              ? Icons.favorite
                              : Icons.library_music),
                          title: Text(playlist.isFavorite
                              ? l10n.myFavorites
                              : playlist.name),
                          subtitle: Text('${playlist.songCount} 首歌曲'),
                          onTap: () =>
                              Navigator.of(context).pop(playlist.id),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
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
    final name = await CommonDialogs.showInputDialog(
      context,
      title: l10n.createPlaylist,
      hint: l10n.title,
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
