import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // TODO: implement playlist detail UI
    // - Watch playlistDetailNotifierProvider(playlistId)
    // - Handle loading/error/data states
    return Scaffold(
      body: Center(
        child: Text('TODO: PlaylistDetailScreen (ID: $playlistId)'),
      ),
    );
  }
}
