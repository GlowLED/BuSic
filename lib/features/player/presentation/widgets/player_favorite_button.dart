import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../playlist/application/favorite_notifier.dart';
import '../../application/player_notifier.dart';
import '../../domain/models/audio_track.dart';

/// Favorite toggle for the currently playing track.
///
/// Player surfaces can appear before any playlist page has loaded favorite
/// status, especially after cold-start restore, so this widget loads the
/// current track's status itself.
class PlayerFavoriteButton extends ConsumerStatefulWidget {
  const PlayerFavoriteButton({
    super.key,
    required this.track,
    this.iconSize,
    this.activeColor = Colors.redAccent,
    this.inactiveColor,
    this.visualDensity,
  });

  final AudioTrack track;
  final double? iconSize;
  final Color activeColor;
  final Color? inactiveColor;
  final VisualDensity? visualDensity;

  @override
  ConsumerState<PlayerFavoriteButton> createState() =>
      _PlayerFavoriteButtonState();
}

class _PlayerFavoriteButtonState extends ConsumerState<PlayerFavoriteButton> {
  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  @override
  void didUpdateWidget(PlayerFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.track.songId != widget.track.songId) {
      _loadFavoriteStatus();
    }
  }

  void _loadFavoriteStatus() {
    final songId = widget.track.songId;
    if (songId <= 0) return;
    unawaited(
      ref.read(favoriteNotifierProvider.notifier).loadFavoriteStatus([songId]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final favState = ref.watch(favoriteNotifierProvider);
    final isFavorited = widget.track.songId > 0 &&
        (favState.value?.contains(widget.track.songId) ?? false);

    return IconButton(
      icon: Icon(
        isFavorited ? Icons.favorite : Icons.favorite_border,
        size: widget.iconSize,
        color: isFavorited
            ? widget.activeColor
            : widget.inactiveColor ?? IconTheme.of(context).color,
      ),
      tooltip: isFavorited ? l10n.removeFromFavorites : l10n.addToFavorites,
      visualDensity: widget.visualDensity,
      onPressed: () async {
        if (widget.track.songId > 0) {
          await ref
              .read(favoriteNotifierProvider.notifier)
              .toggleFavorite(widget.track.songId);
        } else {
          final newId = await ref
              .read(favoriteNotifierProvider.notifier)
              .favoriteFromTrack(widget.track);
          ref.read(playerNotifierProvider.notifier).updateCurrentTrackSongId(
                newId,
              );
        }
      },
    );
  }
}
