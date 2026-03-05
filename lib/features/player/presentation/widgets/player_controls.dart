import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/player_notifier.dart';
import '../../domain/models/play_mode.dart';
import 'volume_sheet.dart';

/// Playback control buttons: play-mode, previous, play/pause, next, volume.
///
/// Adapts to narrow screens by splitting into two rows.
class PlayerControls extends ConsumerWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerNotifierProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 400;

        final modeBtn = IconButton(
          icon: Icon(
            _modeIcon(playerState.playMode),
            color: Colors.white70,
          ),
          onPressed: () {
            const modes = PlayMode.values;
            final next = (playerState.playMode.index + 1) % modes.length;
            ref.read(playerNotifierProvider.notifier).setMode(modes[next]);
          },
        );

        final prevBtn = IconButton(
          icon: const Icon(Icons.skip_previous,
              color: Colors.white, size: 36),
          onPressed: () {
            ref.read(playerNotifierProvider.notifier).previous();
          },
        );

        final playPauseBtn = Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            iconSize: 40,
            icon: Icon(
              playerState.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black87,
            ),
            onPressed: () {
              final notifier = ref.read(playerNotifierProvider.notifier);
              if (playerState.isPlaying) {
                notifier.pause();
              } else {
                notifier.resume();
              }
            },
          ),
        );

        final nextBtn = IconButton(
          icon:
              const Icon(Icons.skip_next, color: Colors.white, size: 36),
          onPressed: () {
            ref.read(playerNotifierProvider.notifier).next();
          },
        );

        final volumeBtn = IconButton(
          icon: const Icon(Icons.volume_up, color: Colors.white70),
          onPressed: () => showVolumeSheet(context, ref),
        );

        if (isNarrow) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [prevBtn, playPauseBtn, nextBtn],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [modeBtn, volumeBtn],
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [modeBtn, prevBtn, playPauseBtn, nextBtn, volumeBtn],
          ),
        );
      },
    );
  }

  IconData _modeIcon(PlayMode mode) {
    switch (mode) {
      case PlayMode.sequential:
        return Icons.arrow_forward;
      case PlayMode.repeatAll:
        return Icons.repeat;
      case PlayMode.repeatOne:
        return Icons.repeat_one;
      case PlayMode.shuffle:
        return Icons.shuffle;
    }
  }
}
