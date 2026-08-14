import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../application/player_notifier.dart';

/// Seek bar with position/duration labels for the full player screen.
///
/// Handles drag state internally so that the slider thumb follows
/// the user's finger while dragging and snaps back to the actual
/// position on release.
class PlayerSeekBar extends ConsumerStatefulWidget {
  const PlayerSeekBar({super.key});

  @override
  ConsumerState<PlayerSeekBar> createState() => _PlayerSeekBarState();
}

class _PlayerSeekBarState extends ConsumerState<PlayerSeekBar> {
  /// Non-null while the user is dragging the seek bar.
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    // Watch only position/duration so 60Hz ticks don't rebuild parent screens.
    final position = ref.watch(
      playerNotifierProvider.select((s) => s.position),
    );
    final duration = ref.watch(
      playerNotifierProvider.select((s) => s.duration),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.white,
            ),
            child: Slider(
              value:
                  _dragValue ??
                  (duration.inMilliseconds > 0
                      ? position.inMilliseconds.toDouble().clamp(
                          0,
                          duration.inMilliseconds.toDouble(),
                        )
                      : 0),
              max: duration.inMilliseconds > 0
                  ? duration.inMilliseconds.toDouble()
                  : 1,
              onChangeStart: (value) {
                setState(() => _dragValue = value);
              },
              onChanged: (value) {
                setState(() => _dragValue = value);
              },
              onChangeEnd: (value) {
                ref
                    .read(playerNotifierProvider.notifier)
                    .seekTo(Duration(milliseconds: value.toInt()));
                setState(() => _dragValue = null);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Formatters.formatDuration(
                    _dragValue != null
                        ? Duration(milliseconds: _dragValue!.toInt())
                        : position,
                  ),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  Formatters.formatDuration(duration),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
