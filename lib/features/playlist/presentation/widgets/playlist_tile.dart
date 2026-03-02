import 'package:flutter/material.dart';

import '../../domain/models/playlist.dart';

/// A card/tile widget representing a single playlist in the list view.
///
/// Shows cover art, playlist name, and song count.
class PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PlaylistTile({
    super.key,
    required this.playlist,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement playlist tile UI
    // - Cover image or default gradient placeholder
    // - Name text
    // - Song count badge
    return const ListTile(
      title: Text('TODO: PlaylistTile'),
    );
  }
}
