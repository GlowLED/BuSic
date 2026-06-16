import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../comment/presentation/comment_section.dart';
import '../application/player_notifier.dart';
import '../domain/models/audio_track.dart';
import '../domain/models/play_mode.dart';
import '../domain/models/player_state.dart';
import 'widgets/cover_image.dart';
import 'widgets/draggable_progress_bar.dart';
import 'widgets/player_favorite_button.dart';
import 'widgets/play_queue_sheet.dart';
import 'widgets/volume_button.dart';

const _desktopPlayerBarHeight = 72.0;
const _mobilePlayerBarHeight = 52.0;
const _mobilePlayerButtonSize = 42.0;
const _recordRotationDuration = Duration(seconds: 18);

/// 底部播放控制栏，在所有主屏幕中显示。
///
/// 显示内容：
/// - Desktop: full controls and draggable progress.
/// - Mobile: compact capsule with circular cover, title line, play progress,
///   and queue entry.
class PlayerBar extends ConsumerWidget {
  const PlayerBar({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerNotifierProvider);
    final track = playerState.currentTrack;

    final progress = playerState.duration.inMilliseconds > 0
        ? (playerState.position.inMilliseconds /
                playerState.duration.inMilliseconds)
            .clamp(0.0, 1.0)
            .toDouble()
        : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobileLayout =
            PlatformUtils.isMobile || constraints.maxWidth < 480;

        if (isMobileLayout) {
          return _MobilePlayerBar(
            track: track,
            progress: progress,
            isPlaying: playerState.isPlaying,
            onPlayPause: () => _togglePlayback(ref, playerState.isPlaying),
            onShowQueue: track == null ? null : () => _showQueueSheet(context),
          );
        }

        return _DesktopPlayerBar(
          track: track,
          progress: progress,
          playerState: playerState,
          playModeIcon: _playModeIcon,
          playModeLabel: _playModeLabel,
          nextMode: _nextMode,
          qualityLabel: _qualityLabel,
          onPlayPause: () => _togglePlayback(ref, playerState.isPlaying),
          onShowComments: track == null
              ? null
              : () => _showCommentsSheet(context, track.bvid),
        );
      },
    );
  }

  void _togglePlayback(WidgetRef ref, bool isPlaying) {
    final notifier = ref.read(playerNotifierProvider.notifier);
    if (isPlaying) {
      notifier.pause();
    } else {
      notifier.resume();
    }
  }

  void _showQueueSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const PlayQueueSheet(),
    );
  }

  void _showCommentsSheet(BuildContext context, String bvid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, _) => CommentSection(bvid: bvid),
      ),
    );
  }
}

class _DesktopPlayerBar extends ConsumerWidget {
  const _DesktopPlayerBar({
    required this.track,
    required this.progress,
    required this.playerState,
    required this.playModeIcon,
    required this.playModeLabel,
    required this.nextMode,
    required this.qualityLabel,
    required this.onPlayPause,
    required this.onShowComments,
  });

  final AudioTrack? track;
  final double progress;
  final PlayerState playerState;
  final IconData Function(PlayMode mode) playModeIcon;
  final String Function(PlayMode mode) playModeLabel;
  final PlayMode Function(PlayMode mode) nextMode;
  final String Function(int quality) qualityLabel;
  final VoidCallback onPlayPause;
  final VoidCallback? onShowComments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrack = track;
    if (currentTrack == null) {
      return _PlayerBarSurface(
        height: _desktopPlayerBarHeight,
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

    return _PlayerBarSurface(
      height: _desktopPlayerBarHeight,
      child: Stack(
        children: [
          Row(
            children: [
              _CircularCover(
                size: _desktopPlayerBarHeight,
                coverUrl: currentTrack.coverUrl,
                isPlaying: playerState.isPlaying,
                onTap: () => context.push(AppRoutes.player),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14, right: 12),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.player),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentTrack.title,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                [
                                  currentTrack.artist,
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
                      if (currentTrack.quality > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: context.colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              qualityLabel(currentTrack.quality),
                              style: TextStyle(
                                fontSize: 10,
                                color: context.colorScheme.onTertiaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      if (context.isDesktop)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '${Formatters.formatDuration(playerState.position)} / ${Formatters.formatDuration(playerState.duration)}',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              fontFeatures: [
                                const FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                        ),
                      PlayerFavoriteButton(
                        track: currentTrack,
                        iconSize: 20,
                        inactiveColor: context.colorScheme.onSurfaceVariant,
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.comment_outlined,
                          size: 20,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        tooltip: context.l10n.commentSection,
                        visualDensity: VisualDensity.compact,
                        onPressed: onShowComments,
                      ),
                      IconButton(
                        icon: Icon(
                          playModeIcon(playerState.playMode),
                          size: 20,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        tooltip: playModeLabel(playerState.playMode),
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          final next = nextMode(playerState.playMode);
                          ref
                              .read(playerNotifierProvider.notifier)
                              .setMode(next);
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(playModeLabel(next)),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.only(
                                bottom: 80,
                                left: 16,
                                right: 16,
                              ),
                            ),
                          );
                        },
                      ),
                      if (context.isDesktop)
                        VolumeButton(
                          volume: playerState.volume,
                          onChanged: (v) {
                            ref
                                .read(playerNotifierProvider.notifier)
                                .setVolume(v);
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 24),
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          ref.read(playerNotifierProvider.notifier).previous();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          playerState.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 36,
                          color: context.colorScheme.primary,
                        ),
                        onPressed: onPlayPause,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 24),
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          ref.read(playerNotifierProvider.notifier).next();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: _desktopPlayerBarHeight,
            right: 0,
            height: 20,
            child: DraggableProgressBar(
              progress: progress,
              duration: playerState.duration,
              onSeek: (pos) {
                ref.read(playerNotifierProvider.notifier).seekTo(pos);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MobilePlayerBar extends StatelessWidget {
  const _MobilePlayerBar({
    required this.track,
    required this.progress,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onShowQueue,
  });

  final AudioTrack? track;
  final double progress;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback? onShowQueue;

  @override
  Widget build(BuildContext context) {
    final currentTrack = track;
    final hasTrack = currentTrack != null;

    return _PlayerBarSurface(
      height: _mobilePlayerBarHeight,
      child: Row(
        children: [
          _CircularCover(
            size: _mobilePlayerBarHeight,
            coverUrl: hasTrack ? currentTrack.coverUrl : null,
            isPlaying: isPlaying,
            onTap: hasTrack ? () => context.push(AppRoutes.player) : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: hasTrack
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.push(AppRoutes.player),
                    child: _MobileTrackLine(
                      title: currentTrack.title,
                      artist: currentTrack.artist,
                    ),
                  )
                : Text(
                    context.l10n.noPlayingMusic,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          _CircularProgressPlayButton(
            progress: hasTrack ? progress : 0,
            isPlaying: isPlaying,
            onPressed: hasTrack ? onPlayPause : null,
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 42,
            height: 42,
            child: IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.queue_music,
                color: hasTrack
                    ? context.colorScheme.onSurfaceVariant
                    : context.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.38),
              ),
              tooltip: context.l10n.queue,
              onPressed: onShowQueue,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}

class _PlayerBarSurface extends StatelessWidget {
  const _PlayerBarSurface({
    required this.height,
    required this.child,
  });

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: [
          BoxShadow(
            color: context.appDepth.shadowSoft,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(
              color: context.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _CircularCover extends StatefulWidget {
  const _CircularCover({
    required this.size,
    required this.coverUrl,
    required this.isPlaying,
    this.onTap,
  });

  final double size;
  final String? coverUrl;
  final bool isPlaying;
  final VoidCallback? onTap;

  @override
  State<_CircularCover> createState() => _CircularCoverState();
}

class _CircularCoverState extends State<_CircularCover>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: _recordRotationDuration,
    );
    _syncPlayback();
  }

  @override
  void didUpdateWidget(_CircularCover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coverUrl != widget.coverUrl) {
      _rotationController.value = 0;
    }
    _syncPlayback();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _syncPlayback() {
    if (widget.isPlaying) {
      if (!_rotationController.isAnimating) {
        _rotationController.repeat();
      }
    } else if (_rotationController.isAnimating) {
      _rotationController.stop(canceled: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cover = RepaintBoundary(
      child: AnimatedBuilder(
        animation: _rotationController,
        child: _RecordDisc(
          size: widget.size,
          coverUrl: widget.coverUrl,
        ),
        builder: (context, child) {
          return Transform.rotate(
            key: const ValueKey('player_bar_record_rotation'),
            angle: _rotationController.value * math.pi * 2,
            child: child,
          );
        },
      ),
    );

    if (widget.onTap == null) return cover;

    return GestureDetector(
      key: const ValueKey('player_bar_record_cover'),
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: cover,
    );
  }
}

class _RecordDisc extends StatelessWidget {
  const _RecordDisc({
    required this.size,
    required this.coverUrl,
  });

  final double size;
  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    final labelSize = size * 0.64;
    final hubSize = size * 0.14;
    final coverCacheSizePx = _recordCoverCacheSizePx(context, labelSize);

    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipOval(
              child: CustomPaint(
                painter: _RecordDiscPainter(
                  baseColor: const Color(0xFF17191D),
                  grooveColor: Colors.white.withValues(alpha: 0.075),
                  shadowColor: Colors.black.withValues(alpha: 0.44),
                  highlightColor: Colors.white.withValues(alpha: 0.16),
                ),
              ),
            ),
          ),
          ClipOval(
            child: SizedBox.square(
              dimension: labelSize,
              child: buildCoverImage(
                context,
                coverUrl,
                filterQuality: FilterQuality.high,
                cacheSizePx: coverCacheSizePx,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                useOldImageOnUrlChange: true,
              ),
            ),
          ),
          SizedBox.square(
            dimension: labelSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.42),
                  width: 1.2,
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF20242A).withValues(alpha: 0.94),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.28),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: SizedBox.square(dimension: hubSize),
          ),
        ],
      ),
    );
  }
}

int _recordCoverCacheSizePx(BuildContext context, double labelSize) {
  final pixelRatio = MediaQuery.devicePixelRatioOf(context);
  return (labelSize * pixelRatio * 3).ceil().clamp(160, 512).toInt();
}

class _RecordDiscPainter extends CustomPainter {
  const _RecordDiscPainter({
    required this.baseColor,
    required this.grooveColor,
    required this.shadowColor,
    required this.highlightColor,
  });

  final Color baseColor;
  final Color grooveColor;
  final Color shadowColor;
  final Color highlightColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final basePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          baseColor.withValues(alpha: 0.86),
          const Color(0xFF08090B),
          const Color(0xFF252930),
          const Color(0xFF050506),
        ],
        stops: const [0.0, 0.46, 0.76, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, basePaint);

    final groovePaint = Paint()
      ..color = grooveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.55;
    for (var ring = 0.58; ring <= 0.94; ring += 0.08) {
      canvas.drawCircle(center, radius * ring, groovePaint);
    }

    final innerShadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.1;
    canvas.drawCircle(center, radius * 0.72, innerShadowPaint);

    final highlightPaint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = math.max(1.4, radius * 0.04);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.82),
      -math.pi * 0.78,
      math.pi * 0.34,
      false,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(_RecordDiscPainter oldDelegate) {
    return baseColor != oldDelegate.baseColor ||
        grooveColor != oldDelegate.grooveColor ||
        shadowColor != oldDelegate.shadowColor ||
        highlightColor != oldDelegate.highlightColor;
  }
}

class _MobileTrackLine extends StatelessWidget {
  const _MobileTrackLine({
    required this.title,
    required this.artist,
  });

  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    final hasArtist = artist.trim().isNotEmpty;

    return Text.rich(
      key: const ValueKey('player_bar_mobile_track_text'),
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (hasArtist)
            TextSpan(
              text: ' - $artist',
              style: TextStyle(
                color: context.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodyMedium,
    );
  }
}

class _CircularProgressPlayButton extends StatelessWidget {
  const _CircularProgressPlayButton({
    required this.progress,
    required this.isPlaying,
    required this.onPressed,
  });

  final double progress;
  final bool isPlaying;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final iconColor = enabled ? Colors.black87 : Colors.black38;

    return SizedBox.square(
      dimension: _mobilePlayerButtonSize,
      child: CustomPaint(
        painter: _CircularProgressPainter(
          progress: progress,
          trackColor:
              context.colorScheme.outlineVariant.withValues(alpha: 0.56),
          progressColor: context.colorScheme.primary,
          strokeWidth: 3,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: iconColor,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  const _CircularProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = trackColor;

    canvas.drawCircle(center, radius, paint);

    final sweep = math.pi * 2 * progress.clamp(0.0, 1.0);
    if (sweep <= 0) return;

    paint.color = progressColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        trackColor != oldDelegate.trackColor ||
        progressColor != oldDelegate.progressColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
