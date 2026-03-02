import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/song_tile.dart';
import '../application/playlist_notifier.dart';
import '../domain/models/song_item.dart';
import 'widgets/metadata_edit_dialog.dart';

/// Screen displaying songs within a specific playlist.
///
/// Features:
/// - Playlist header with name, cover, song count
/// - Scrollable list of songs (using SongTile)
/// - Drag to reorder
/// - "Play all" / "Shuffle" buttons
/// - Context menu per song: edit metadata, remove, add to queue
class PlaylistDetailScreen extends ConsumerWidget {
  /// The playlist database ID.
  final int playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(playlistDetailNotifierProvider(playlistId));
    final playlistAsync = ref.watch(playlistListNotifierProvider);
    final l10n = context.l10n;

    // Find playlist info from the list
    final playlistName = playlistAsync.whenOrNull(
      data: (playlists) {
        final match = playlists.where((p) => p.id == playlistId);
        return match.isNotEmpty ? match.first.name : null;
      },
    );

    return Scaffold(
      body: songsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (songs) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 160,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/playlists'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    playlistName ?? 'Playlist',
                    style: context.textTheme.titleMedium,
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.colorScheme.primaryContainer,
                          context.colorScheme.surface,
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  if (songs.isNotEmpty) ...[
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      tooltip: l10n.play,
                      onPressed: () {
                        // TODO: Play all songs via PlayerNotifier
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.shuffle),
                      tooltip: l10n.shuffle,
                      onPressed: () {
                        // TODO: Shuffle play via PlayerNotifier
                      },
                    ),
                  ],
                ],
              ),
              if (songs.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      l10n.noSongs,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                SliverReorderableList(
                  itemCount: songs.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    ref
                        .read(playlistDetailNotifierProvider(playlistId)
                            .notifier)
                        .reorderSongs(oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ReorderableDragStartListener(
                      key: ValueKey(song.id),
                      index: index,
                      child: SongTile(
                        title: song.displayTitle,
                        artist: song.displayArtist,
                        coverUrl: song.coverUrl,
                        duration: Formatters.formatDuration(Duration(seconds: song.duration)),
                        isPlaying: false, // TODO: compare with current player track
                        onTap: () {
                          // TODO: play this song via PlayerNotifier
                        },
                        onMorePressed: () {
                          _showSongMenu(context, ref, song);
                        },
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  void _showSongMenu(
    BuildContext context,
    WidgetRef ref,
    SongItem song,
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
              title: Text(l10n.editMetadata),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder: (_) => MetadataEditDialog(
                    song: song,
                    playlistId: playlistId,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: Text(l10n.removeFromPlaylist),
              onTap: () {
                Navigator.pop(ctx);
                ref
                    .read(playlistDetailNotifierProvider(playlistId).notifier)
                    .removeSong(song.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.queue_music),
              title: Text(l10n.addToPlaylist),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: add to play queue
              },
            ),
          ],
        ),
      ),
    );
  }
}
