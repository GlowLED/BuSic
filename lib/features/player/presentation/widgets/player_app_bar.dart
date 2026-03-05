import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/player_notifier.dart';
import '../../domain/models/audio_track.dart';
import '../../../playlist/application/favorite_notifier.dart';
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
            icon: const Icon(Icons.keyboard_arrow_down,
                color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          // ❤️ Favourite button
          if (track != null) _FavoriteButton(track: track!),
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

class _FavoriteButton extends ConsumerWidget {
  final AudioTrack track;
  const _FavoriteButton({required this.track});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final favState = ref.watch(favoriteNotifierProvider);
    final isFav = favState.value?.contains(track.songId) ?? false;

    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.redAccent : Colors.white,
      ),
      tooltip: isFav ? l10n.removeFromFavorites : l10n.addToFavorites,
      onPressed: () async {
        if (track.songId > 0) {
          ref.read(favoriteNotifierProvider.notifier).toggleFavorite(
              track.songId);
        } else {
          final newId = await ref
              .read(favoriteNotifierProvider.notifier)
              .favoriteFromTrack(track);
          ref
              .read(playerNotifierProvider.notifier)
              .updateCurrentTrackSongId(newId);
        }
      },
    );
  }
}
