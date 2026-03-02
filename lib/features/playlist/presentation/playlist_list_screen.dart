import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // TODO: implement playlist list UI
    // - Watch playlistListNotifierProvider
    // - Handle loading/error/data states
    // - Display playlists as cards/tiles
    return const Scaffold(
      body: Center(
        child: Text('TODO: PlaylistListScreen'),
      ),
    );
  }
}
