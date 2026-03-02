import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 48,
          height: 48,
          child: coverUrl != null && coverUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: coverUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.music_note, color: colorScheme.onSurfaceVariant),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.music_note, color: colorScheme.onSurfaceVariant),
                  ),
                )
              : Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.music_note, color: colorScheme.onSurfaceVariant),
                ),
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodyLarge?.copyWith(
          color: isPlaying ? colorScheme.primary : null,
          fontWeight: isPlaying ? FontWeight.bold : null,
        ),
      ),
      subtitle: Text(
        artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodySmall?.copyWith(
          color: isPlaying ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (duration != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                duration!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          if (onMorePressed != null)
            IconButton(
              icon: const Icon(Icons.more_vert, size: 20),
              onPressed: onMorePressed,
            ),
        ],
      ),
      onTap: onTap,
      selected: isPlaying,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
