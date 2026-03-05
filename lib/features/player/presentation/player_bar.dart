import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../comment/presentation/comment_section.dart';
import '../../playlist/application/favorite_notifier.dart';
import '../application/player_notifier.dart';
import '../domain/models/play_mode.dart';
import 'widgets/cover_image.dart';
import 'widgets/draggable_progress_bar.dart';
import 'widgets/volume_button.dart';

/// 底部播放控制栏，在所有主屏幕中显示。
///
/// 显示内容：
/// - 可拖动进度条（点击跳转 / 拖动预览 / 上滑取消）
/// - 迷你封面 + 曲名/作者 + 歌单名
/// - 上一首 / 播放|暂停 / 下一首
/// - 播放模式切换
/// - 时间显示（仅桌面端）
/// - 音量控制（仅桌面端）
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

    // 无曲目时显示占位栏
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

    // 收藏状态
    final favState = ref.watch(favoriteNotifierProvider);
    final isFavorited =
        track.songId > 0 && (favState.value?.contains(track.songId) ?? false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 480;

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
          child: Stack(
            children: [
              // 可拖动进度条（覆盖顶部，扩大触控区域至 20px）
              Positioned(
                top: 0,
                left: 0,
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
              // 内容区域
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      // 封面
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.player),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: buildCoverImage(context, track.coverUrl),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 标题、作者、歌单
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.player),
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
                      // ── 宽屏独有：音质标签、时间 ──
                      if (!isCompact) ...[
                        // 音质标签
                        if (track.quality > 0)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
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
                                  color:
                                      context.colorScheme.onTertiaryContainer,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        // 时间显示（仅桌面端）
                        if (context.isDesktop)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
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
                      ],
                      // ❤️ 收藏按钮
                      IconButton(
                        icon: Icon(
                          isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 20,
                          color: isFavorited
                              ? Colors.redAccent
                              : context.colorScheme.onSurfaceVariant,
                        ),
                        tooltip: isFavorited
                            ? context.l10n.removeFromFavorites
                            : context.l10n.addToFavorites,
                        visualDensity: VisualDensity.compact,
                        onPressed: () async {
                          if (track.songId > 0) {
                            ref
                                .read(
                                    favoriteNotifierProvider.notifier)
                                .toggleFavorite(track.songId);
                          } else {
                            final newId = await ref
                                .read(
                                    favoriteNotifierProvider.notifier)
                                .favoriteFromTrack(track);
                            ref
                                .read(
                                    playerNotifierProvider.notifier)
                                .updateCurrentTrackSongId(newId);
                          }
                        },
                      ),
                      // 💬 评论按钮
                      IconButton(
                        icon: Icon(
                          Icons.comment_outlined,
                          size: 20,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        tooltip: context.l10n.commentSection,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => DraggableScrollableSheet(
                              initialChildSize: 0.75,
                              minChildSize: 0.4,
                              maxChildSize: 0.95,
                              expand: false,
                              builder: (context, _) =>
                                  CommentSection(bvid: track.bvid),
                            ),
                          );
                        },
                      ),
                      // ── 宽屏独有：播放模式、音量 ──
                      if (!isCompact) ...[
                        // 播放模式按钮
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
                            ref
                                .read(playerNotifierProvider.notifier)
                                .setMode(next);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_playModeLabel(next)),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.only(
                                    bottom: 80, left: 16, right: 16),
                              ),
                            );
                          },
                        ),
                        // 音量按钮（仅桌面端）
                        if (context.isDesktop)
                          VolumeButton(
                            volume: playerState.volume,
                            onChanged: (v) {
                              ref
                                  .read(playerNotifierProvider.notifier)
                                  .setVolume(v);
                            },
                          ),
                      ],
                      // 上一首
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 24),
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          ref
                              .read(playerNotifierProvider.notifier)
                              .previous();
                        },
                      ),
                      // 播放/暂停
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
                      // 下一首
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
        );
      },
    );
  }
}
