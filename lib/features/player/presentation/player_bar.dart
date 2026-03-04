import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../application/player_notifier.dart';
import '../domain/models/play_mode.dart';

/// Bottom playback control bar displayed across all main screens.
///
/// Shows:
/// - Progress slider (draggable, seeks on release)
/// - Mini cover art + track title/artist + playlist name
/// - Previous / Play|Pause / Next buttons
/// - Play mode toggle
/// - Time display
class PlayerBar extends ConsumerStatefulWidget {
  const PlayerBar({super.key});

  @override
  ConsumerState<PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends ConsumerState<PlayerBar> {
  /// Non-null while the user is dragging the progress bar.
  double? _dragProgress;

  IconData _playModeIcon(PlayMode mode) {
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

  String _playModeLabel(PlayMode mode) {
    switch (mode) {
      case PlayMode.sequential:
        return '顺序播放';
      case PlayMode.repeatAll:
        return '列表循环';
      case PlayMode.repeatOne:
        return '单曲循环';
      case PlayMode.shuffle:
        return '随机播放';
    }
  }

  PlayMode _nextMode(PlayMode current) {
    const modes = PlayMode.values;
    return modes[(modes.indexOf(current) + 1) % modes.length];
  }

  String _qualityLabel(int quality) {
    switch (quality) {
      case 30216:
        return '64kbps';
      case 30232:
        return '132kbps';
      case 30280:
        return '192kbps';
      case 30250:
        return 'Dolby';
      case 30251:
        return 'Hi-Res';
      default:
        return '$quality';
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerNotifierProvider);
    final track = playerState.currentTrack;

    // Show placeholder bar when no track is loaded
    if (track == null) {
      return Container(
        height: 72,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          border: Border(
            top: BorderSide(
              color: context.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
        ),
        child: Center(
          child: Text(
            context.l10n.noPlayingMusic,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final progress = playerState.duration.inMilliseconds > 0
        ? playerState.position.inMilliseconds /
            playerState.duration.inMilliseconds
        : 0.0;

    return Container(
        height: 72,
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
            // Draggable progress bar
            SizedBox(
              height: 4,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                  activeTrackColor: context.colorScheme.primary,
                  inactiveTrackColor: context.colorScheme.primary.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: (_dragProgress ?? progress).clamp(0.0, 1.0),
                  onChangeStart: (value) {
                    setState(() => _dragProgress = value);
                  },
                  onChanged: (value) {
                    setState(() => _dragProgress = value);
                  },
                  onChangeEnd: (value) {
                    if (playerState.duration.inMilliseconds > 0) {
                      final position = Duration(
                        milliseconds: (value * playerState.duration.inMilliseconds).toInt(),
                      );
                      ref.read(playerNotifierProvider.notifier).seekTo(position);
                    }
                    setState(() => _dragProgress = null);
                  },
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // On narrow screens (< 500), hide quality badge, play mode, volume
                    final isCompact = constraints.maxWidth < 500;
                    return Row(
                      children: [
                        // Cover + Title — tappable to open full player
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.player),
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Cover
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: _buildCover(context, track.coverUrl),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                        // Title, artist & playlist — also tappable
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.push(AppRoutes.player),
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track.title,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  [
                                    track.artist,
                                    if (playerState.playlistName != null)
                                      playerState.playlistName!,
                                  ].join(' · '),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                    // Quality badge (desktop only)
                    if (!isCompact && track.quality > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _qualityLabel(track.quality),
                            style: TextStyle(
                              fontSize: 10,
                              color: context.colorScheme.onTertiaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    // Time display — use compact format on mobile
                    if (!isCompact)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '${Formatters.formatDuration(playerState.position)} / ${Formatters.formatDuration(playerState.duration)}',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    // Play mode button (desktop only)
                    if (!isCompact)
                      IconButton(
                        icon: Icon(
                          _playModeIcon(playerState.playMode),
                          size: 20,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        tooltip: _playModeLabel(playerState.playMode),
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          final next = _nextMode(playerState.playMode);
                          ref.read(playerNotifierProvider.notifier).setMode(next);
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_playModeLabel(next)),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
                            ),
                          );
                        },
                      ),
                    // Volume button (desktop only)
                    if (!isCompact)
                      _VolumeButton(
                        volume: playerState.volume,
                        onChanged: (v) {
                          ref.read(playerNotifierProvider.notifier).setVolume(v);
                        },
                      ),
                    // Previous button
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 24),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        ref.read(playerNotifierProvider.notifier).previous();
                      },
                    ),
                    // Play/pause button
                    IconButton(
                      icon: Icon(
                        playerState.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        size: 36,
                        color: context.colorScheme.primary,
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
                      icon: const Icon(Icons.skip_next, size: 24),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        ref.read(playerNotifierProvider.notifier).next();
                      },
                    ),
                  ],
                );
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }
}

Widget _buildCover(BuildContext context, String? coverUrl) {
  if (coverUrl == null || coverUrl.isEmpty) {
    return Container(
      color: context.colorScheme.primaryContainer,
      child: const Icon(Icons.music_note, size: 24),
    );
  }

  final isLocal = coverUrl.startsWith('/') || coverUrl.startsWith('file://');
  if (isLocal) {
    final path = coverUrl.startsWith('file://')
        ? Uri.parse(coverUrl).toFilePath()
        : coverUrl;
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: context.colorScheme.primaryContainer,
        child: const Icon(Icons.music_note, size: 24),
      ),
    );
  }

  return CachedNetworkImage(
    imageUrl: coverUrl,
    fit: BoxFit.cover,
    errorWidget: (_, __, ___) => Container(
      color: context.colorScheme.primaryContainer,
      child: const Icon(Icons.music_note, size: 24),
    ),
  );
}

/// Volume button with popup slider.
class _VolumeButton extends StatefulWidget {
  final double volume;
  final ValueChanged<double> onChanged;

  const _VolumeButton({required this.volume, required this.onChanged});

  @override
  State<_VolumeButton> createState() => _VolumeButtonState();
}

class _VolumeButtonState extends State<_VolumeButton> {
  final _overlayController = OverlayPortalController();
  final _link = LayerLink();

  IconData _volumeIcon(double vol) {
    if (vol <= 0) return Icons.volume_off;
    if (vol < 0.5) return Icons.volume_down;
    return Icons.volume_up;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (ctx) {
          return Stack(
            children: [
              // Dismiss area
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _overlayController.hide(),
                ),
              ),
              // Slider popup
              CompositedTransformFollower(
                link: _link,
                targetAnchor: Alignment.topCenter,
                followerAnchor: Alignment.bottomCenter,
                offset: const Offset(0, -8),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: SizedBox(
                      height: 120,
                      width: 36,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                            activeTrackColor: colorScheme.primary,
                            inactiveTrackColor: colorScheme.primary.withValues(alpha: 0.2),
                            thumbColor: colorScheme.primary,
                          ),
                          child: Slider(
                            value: widget.volume,
                            min: 0,
                            max: 1,
                            onChanged: widget.onChanged,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: IconButton(
          icon: Icon(
            _volumeIcon(widget.volume),
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          tooltip: '音量 ${(widget.volume * 100).round()}%',
          visualDensity: VisualDensity.compact,
          onPressed: () {
            if (_overlayController.isShowing) {
              _overlayController.hide();
            } else {
              _overlayController.show();
            }
          },
        ),
      ),
    );
  }
}
