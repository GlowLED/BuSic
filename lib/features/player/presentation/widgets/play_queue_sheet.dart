import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // TODO: implement play queue sheet
    // - ReorderableListView of queue tracks
    // - Highlight current track
    // - Swipe to dismiss for removal
    return const SizedBox.shrink();
  }
}
