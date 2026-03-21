import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/logger.dart';
import '../../../main.dart';
import '../../auth/application/auth_notifier.dart';
import '../../player/application/player_notifier.dart';
import '../../player/domain/models/audio_track.dart';
import '../../player/domain/models/play_mode.dart';
import '../../playlist/data/playlist_repository_impl.dart';
import '../../search_and_parse/data/parse_repository_impl.dart';
import '../../settings/application/settings_notifier.dart';
import 'widgets/minimal_background.dart';
import 'widgets/song_info_panel.dart';

/// 极简模式页面（内部代号：给我一首歌）。
///
/// 毛玻璃封面背景 + 呼吸动效，自动将歌单塞入播放队列并以 Shuffle 模式连播。
/// 双击屏幕退出极简模式，回到原版主页。
///
/// 生命周期策略（解决 Flutter 无法区分锁屏 vs 切后台的痛点）：
/// - 锁屏 / 切后台 / 回到前台 → **完全不干预播放**
///   （audio_service 前台服务维持后台音频会话，锁屏继续播放）
/// - 划掉应用 (`detached`) → 完整停止播放 + 销毁 AudioService 前台服务
///
/// 为什么不在 paused/resumed 中做任何事：
/// Flutter 的 AppLifecycleState.paused 在锁屏和切后台时**都**会触发，
/// 无法可靠区分。若在 paused 中暂停，锁屏听歌会中断；
/// 若在 resumed 中切歌，解锁后会误切歌。两者都严重影响体验。
/// 因此采用"完全不干预"策略，优先保证锁屏连续播放。
class MinimalScreen extends ConsumerStatefulWidget {
  const MinimalScreen({super.key});

  @override
  ConsumerState<MinimalScreen> createState() => _MinimalScreenState();
}

class _MinimalScreenState extends ConsumerState<MinimalScreen>
    with WidgetsBindingObserver {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initQueue();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 生命周期监听：仅处理 `detached`（应用被划掉）。
  ///
  /// paused / hidden / resumed 全部不做任何播放干预，原因：
  /// - Flutter 的 `paused` 在锁屏和切后台时都会触发，无法区分
  /// - 若在 `paused` 中暂停 → 锁屏时音乐中断（Bug #2）
  /// - 若在 `resumed` 中切歌 → 解锁时误切歌（Bug #2）
  /// - audio_service 前台服务天然维持后台/锁屏音频会话
  ///
  /// detached 时完整停止：先暂停 media_kit 播放器，再销毁 AudioService
  /// 前台服务（移除通知 + 释放 WakeLock），确保无进程残留。
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.detached) return;

    // ── 应用被划掉：完整停止播放 + 销毁前台服务 ──
    try {
      ref.read(playerNotifierProvider.notifier).pause();
      // 通过 audioHandlerProvider 调用 stop()，销毁前台服务（移除通知栏、释放 WakeLock）
      // 配合 AndroidManifest 的 stopWithTask="true" 双保险
      ref.read(audioHandlerProvider).stop();
      AppLogger.info('App detached: 已停止播放并销毁音频服务', tag: 'Minimal');
    } catch (e) {
      AppLogger.error('detached 清理失败', tag: 'Minimal', error: e);
    }
  }

  /// 核心初始化：加载歌单 → 塞入完整队列 → 开启 Shuffle 模式 → 播放。
  ///
  /// 优先级：本地歌单 → B站搜索兜底。
  /// 所有播放均委托给 [PlayerNotifier] 原生管线
  /// （自动查本地缓存、WBI 签名 API、Referer Header）。
  Future<void> _initQueue() async {
    try {
      final random = Random();
      final playerNotifier = ref.read(playerNotifierProvider.notifier);

      // ── 强制开启 Shuffle 模式，确保连播时随机 ──
      playerNotifier.setMode(PlayMode.shuffle);

      // ── 优先级 1：本地歌单 → playSongFromPlaylist（整队列） ──
      final playlistId = await ref
          .read(settingsNotifierProvider.notifier)
          .getMinimalPlaylistId();
      if (playlistId != null && playlistId > 0) {
        final db = ref.read(databaseProvider);
        final playlistRepo = PlaylistRepositoryImpl(db: db);
        final songs = await playlistRepo.getSongsInPlaylist(playlistId);
        if (songs.isNotEmpty) {
          // 随机选一首作为起点，整个歌单作为队列
          final startSong = songs[random.nextInt(songs.length)];
          await playerNotifier.playSongFromPlaylist(
            song: startSong,
            songs: songs,
            playlistId: playlistId,
          );
          if (!mounted) return;
          setState(() => _isLoading = false);
          return;
        }
      }

      // ── 优先级 2：B站搜索兜底 → playTrackList（整列表） ──
      final parseRepo = ParseRepositoryImpl(biliDio: BiliDio());
      final searchResult = await parseRepo.searchVideos('音乐');
      if (searchResult.results.isEmpty) {
        throw Exception('未找到任何音乐视频');
      }

      // 将搜索结果全部转为 AudioTrack 队列（streamUrl 留空，由 next 时按需解析）
      final tracks = <AudioTrack>[];
      for (final video in searchResult.results) {
        try {
          final info = await parseRepo.getVideoInfo(video.bvid);
          if (info.pages.isEmpty) continue;
          final page = info.pages.first;
          tracks.add(AudioTrack(
            songId: 0,
            bvid: info.bvid,
            cid: page.cid,
            title: info.title,
            artist: info.owner,
            coverUrl: info.coverUrl,
            duration: Duration(seconds: page.duration),
          ));
        } catch (e) {
          // 单个视频解析失败不阻塞整体
          AppLogger.warning('跳过视频 ${video.bvid}', tag: 'Minimal');
        }
      }

      if (tracks.isEmpty) throw Exception('未找到可播放的音乐视频');

      // 随机起点
      final startIndex = random.nextInt(tracks.length);
      await playerNotifier.playTrackList(tracks, startIndex);
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e, st) {
      AppLogger.error('极简模式初始化失败', tag: 'Minimal', error: e, stackTrace: st);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = '加载失败，双击退出重试';
      });
    }
  }

  /// 双击退出极简模式
  void _exitMinimalMode() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    // ★ watch playerState：1) 保持 provider 存活  2) 自动刷新 UI（切歌/封面）
    final playerState = ref.watch(playerNotifierProvider);
    final currentTrack = playerState.currentTrack;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: _exitMinimalMode,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── 毛玻璃呼吸背景 ──
            MinimalBackground(coverUrl: currentTrack?.coverUrl),

            // ── 前景内容 ──
            SafeArea(
              child: Column(
                children: [
                  // ── 顶部操作栏（隐蔽的退出按钮） ──
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: IconButton(
                        onPressed: _exitMinimalMode,
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withValues(alpha: 0.3),
                          size: 24,
                        ),
                        tooltip: '退出极简模式',
                      ),
                    ),
                  ),

                  // ── 居中歌曲信息面板 ──
                  Expanded(
                    child: Center(
                      child: _errorMessage != null
                          ? Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            )
                          : SongInfoPanel(
                              track: currentTrack,
                              isLoading: _isLoading,
                            ),
                    ),
                  ),

                  // ── 底部提示 ──
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Text(
                      '双击屏幕退出',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.2),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
