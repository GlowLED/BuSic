import 'package:flutter/material.dart';

/// A reusable song list tile widget.
///
/// Displays cover art, title, artist, and duration in a consistent format.
/// Used across playlist detail, search results, and queue views.
class SongTile extends StatelessWidget {
  /// Song cover image URL.
  final String? coverUrl;

  /// Song title to display.
  final String title;

  /// Song artist to display.
  final String artist;

  /// Formatted duration string (e.g., "3:42").
  final String? duration;

  /// Whether this song is currently playing.
  final bool isPlaying;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  /// Callback when the more/options button is tapped.
  final VoidCallback? onMorePressed;

  const SongTile({
    super.key,
    this.coverUrl,
    required this.title,
    required this.artist,
    this.duration,
    this.isPlaying = false,
    this.onTap,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement song tile UI
    // Leading: 48x48 cover image (cached_network_image) or placeholder
    // Title + subtitle rows
    // Trailing: duration text + more button
    return const ListTile(
      title: Text('TODO: SongTile'),
    );
  }
}
