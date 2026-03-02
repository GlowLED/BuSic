import 'package:cached_network_image/cached_network_image.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cover area
            Expanded(
              child: playlist.coverUrl != null
                  ? CachedNetworkImage(
                      imageUrl: playlist.coverUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _buildPlaceholder(colorScheme),
                      errorWidget: (_, __, ___) =>
                          _buildPlaceholder(colorScheme),
                    )
                  : _buildPlaceholder(colorScheme),
            ),
            // Info area
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name,
                    style: textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${playlist.songCount} songs',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Icon(
        Icons.library_music,
        size: 48,
        color: colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
      ),
    );
  }
}
