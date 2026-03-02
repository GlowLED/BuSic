import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Full-screen player view with large cover art, lyrics, and controls.
///
/// Features:
/// - Blurred background from cover art
/// - Large cover art display
/// - Track title and artist
/// - Seek bar with position/duration labels
/// - Play/pause, next, previous buttons
/// - Volume slider
/// - Play mode toggle
/// - Lyrics display (future)
/// - Audio spectrum visualization (future)
class FullPlayerScreen extends ConsumerWidget {
  const FullPlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement full player screen
    return const Scaffold(
      body: Center(
        child: Text('TODO: FullPlayerScreen'),
      ),
    );
  }
}
