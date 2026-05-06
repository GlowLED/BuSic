import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../domain/models/audio_track.dart';
import 'player_favorite_button.dart';
import 'play_queue_sheet.dart';

/// Top app bar for the full player screen.
///
/// Contains back (chevron-down), favourite toggle, and queue button.
class PlayerAppBar extends ConsumerWidget {
  /// The currently playing track (nullable when nothing is playing).
  final AudioTrack? track;

  const PlayerAppBar({super.key, this.track});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          // ❤️ Favourite button
          if (track != null)
            PlayerFavoriteButton(
              track: track!,
              inactiveColor: Colors.white,
            ),
          IconButton(
            icon: const Icon(Icons.queue_music, color: Colors.white),
            tooltip: l10n.queue,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const PlayQueueSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}
