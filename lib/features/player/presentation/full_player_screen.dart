import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../application/player_notifier.dart';
import '../domain/models/play_mode.dart';
import 'widgets/play_queue_sheet.dart';

/// Full-screen player view with large cover art, lyrics, and controls.
class FullPlayerScreen extends ConsumerStatefulWidget {
  const FullPlayerScreen({super.key});

  @override
  ConsumerState<FullPlayerScreen> createState() => _FullPlayerScreenState();
}

class _FullPlayerScreenState extends ConsumerState<FullPlayerScreen> {
  /// Non-null while the user is dragging the seek bar.
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerNotifierProvider);
    final track = playerState.currentTrack;
    final l10n = context.l10n;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred background
          if (track?.coverUrl != null)
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: _buildBackgroundCover(track!.coverUrl!),
            ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      IconButton(
                        icon:
                            const Icon(Icons.queue_music, color: Colors.white),
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
                ),

                const Spacer(),

                // Cover art
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: track?.coverUrl != null
                          ? _buildMainCover(track!.coverUrl!)
                          : Container(
                              color: context.colorScheme.primaryContainer,
                              child: const Icon(Icons.music_note,
                                  size: 80, color: Colors.white70),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Title & artist
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        track?.title ?? l10n.unknownTitle,
                        style: context.textTheme.headlineSmall
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        track?.artist ?? l10n.unknownArtist,
                        style: context.textTheme.bodyLarge
                            ?.copyWith(color: Colors.white70),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Seek bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14),
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          value: _dragValue ??
                              (playerState.duration.inMilliseconds > 0
                              ? playerState.position.inMilliseconds
                                  .toDouble()
                                  .clamp(
                                      0,
                                      playerState.duration.inMilliseconds
                                          .toDouble())
                              : 0),
                          max: playerState.duration.inMilliseconds > 0
                              ? playerState.duration.inMilliseconds.toDouble()
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
                                      : playerState.position),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              Formatters.formatDuration(
                                  playerState.duration),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Play mode
                      IconButton(
                        icon: Icon(
                          _modeIcon(playerState.playMode),
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          const modes = PlayMode.values;
                          final next =
                              (playerState.playMode.index + 1) % modes.length;
                          ref
                              .read(playerNotifierProvider.notifier)
                              .setMode(modes[next]);
                        },
                      ),
                      // Previous
                      IconButton(
                        icon: const Icon(Icons.skip_previous,
                            color: Colors.white, size: 36),
                        onPressed: () {
                          ref.read(playerNotifierProvider.notifier).previous();
                        },
                      ),
                      // Play/Pause
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 40,
                          icon: Icon(
                            playerState.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.black87,
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
                      ),
                      // Next
                      IconButton(
                        icon: const Icon(Icons.skip_next,
                            color: Colors.white, size: 36),
                        onPressed: () {
                          ref.read(playerNotifierProvider.notifier).next();
                        },
                      ),
                      // Volume
                      IconButton(
                        icon: const Icon(Icons.volume_up,
                            color: Colors.white70),
                        onPressed: () => _showVolumeSheet(context, ref),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
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

  void _showVolumeSheet(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.volume, style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, _) {
                final volume = ref.watch(
                    playerNotifierProvider.select((s) => s.volume));
                return Slider(
                  value: volume,
                  onChanged: (v) {
                    ref.read(playerNotifierProvider.notifier).setVolume(v);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBackgroundCover(String coverUrl) {
  final isLocal = coverUrl.startsWith('/') || coverUrl.startsWith('file://');
  if (isLocal) {
    final path = coverUrl.startsWith('file://')
        ? Uri.parse(coverUrl).toFilePath()
        : coverUrl;
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      color: Colors.black54,
      colorBlendMode: BlendMode.darken,
      errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black54),
    );
  }

  return CachedNetworkImage(
    imageUrl: coverUrl,
    fit: BoxFit.cover,
    color: Colors.black54,
    colorBlendMode: BlendMode.darken,
  );
}

Widget _buildMainCover(String coverUrl) {
  final isLocal = coverUrl.startsWith('/') || coverUrl.startsWith('file://');
  if (isLocal) {
    final path = coverUrl.startsWith('file://')
        ? Uri.parse(coverUrl).toFilePath()
        : coverUrl;
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black12),
    );
  }

  return CachedNetworkImage(
    imageUrl: coverUrl,
    fit: BoxFit.cover,
  );
}
