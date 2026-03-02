import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/player_notifier.dart';

/// Bottom sheet displaying the current playback queue.
///
/// Shows:
/// - Ordered list of tracks in the queue
/// - Highlight on the currently playing track
/// - Drag handle for reordering
/// - Swipe to remove
class PlayQueueSheet extends ConsumerWidget {
  const PlayQueueSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerNotifierProvider);
    final l10n = context.l10n;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    l10n.queue,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${playerState.queue.length})',
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Queue list
            Expanded(
              child: playerState.queue.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noSongs,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ReorderableListView.builder(
                      scrollController: scrollController,
                      itemCount: playerState.queue.length,
                      onReorder: (oldIndex, newIndex) {
                        ref
                            .read(playerNotifierProvider.notifier)
                            .reorderQueue(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final track = playerState.queue[index];
                        final isCurrent = index == playerState.currentIndex;

                        return Dismissible(
                          key: ValueKey('queue_${track.songId}_$index'),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            ref
                                .read(playerNotifierProvider.notifier)
                                .removeFromQueue(index);
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            color: context.colorScheme.error,
                            child: Icon(Icons.delete,
                                color: context.colorScheme.onError),
                          ),
                          child: ListTile(
                            leading: isCurrent
                                ? Icon(Icons.equalizer,
                                    color: context.colorScheme.primary)
                                : Text(
                                    '${index + 1}',
                                    style: context.textTheme.bodySmall,
                                  ),
                            title: Text(
                              track.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: isCurrent
                                  ? TextStyle(
                                      color: context.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : null,
                            ),
                            subtitle: Text(
                              track.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodySmall,
                            ),
                            onTap: () {
                              ref
                                  .read(playerNotifierProvider.notifier)
                                  .playTrack(
                                    track,
                                    queue: playerState.queue,
                                  );
                            },
                            trailing: ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
