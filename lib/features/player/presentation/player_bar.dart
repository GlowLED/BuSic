import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // TODO: implement bottom player bar
    // - Watch playerNotifierProvider
    // - If no track loaded, return SizedBox.shrink()
    // - Show mini player with GestureDetector → navigate to /player
    return const SizedBox.shrink();
  }
}
