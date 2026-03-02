import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../application/player_notifier.dart';

/// Bottom playback control bar displayed across all main screens.
///
/// Shows:
/// - Mini cover art + track title/artist
/// - Play/pause button
/// - Progress indicator
/// - Tap to expand to full player screen
class PlayerBar extends ConsumerWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerNotifierProvider);
    final track = playerState.currentTrack;

    if (track == null) return const SizedBox.shrink();

    final progress = playerState.duration.inMilliseconds > 0
        ? playerState.position.inMilliseconds /
            playerState.duration.inMilliseconds
        : 0.0;

    return GestureDetector(
      onTap: () => context.push('/player'),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          border: Border(
            top: BorderSide(
              color: context.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 2,
              backgroundColor: Colors.transparent,
              color: context.colorScheme.primary,
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    // Cover
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: track.coverUrl != null
                            ? CachedNetworkImage(
                                imageUrl: track.coverUrl!,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(
                                  color: context.colorScheme.primaryContainer,
                                  child: const Icon(Icons.music_note, size: 24),
                                ),
                              )
                            : Container(
                                color: context.colorScheme.primaryContainer,
                                child: const Icon(Icons.music_note, size: 24),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title & artist
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            style: context.textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${track.artist} · ${Formatters.formatDuration(playerState.position)}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Play/pause button
                    IconButton(
                      icon: Icon(
                        playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () {
                        final notifier =
                            ref.read(playerNotifierProvider.notifier);
                        if (playerState.isPlaying) {
                          notifier.pause();
                        } else {
                          notifier.resume();
                        }
                      },
                    ),
                    // Next button
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        ref.read(playerNotifierProvider.notifier).next();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
