import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/logger.dart';
import '../../auth/application/auth_notifier.dart';
import '../../player/application/player_notifier.dart';
import '../../player/domain/models/audio_track.dart';
import '../../playlist/data/playlist_repository_impl.dart';
import '../../search_and_parse/data/parse_repository.dart';
import '../../search_and_parse/data/parse_repository_impl.dart';
import '../../settings/application/settings_notifier.dart';

/// 极简模式页面（内部代号：给我一首歌）。
///
/// 全黑背景，自动随机抽歌并播放。
/// 双击屏幕退出极简模式，回到原版主页。
/// 退到后台时自动停止播放。
class MinimalScreen extends ConsumerStatefulWidget {
  const MinimalScreen({super.key});

  @override
  ConsumerState<MinimalScreen> createState() => _MinimalScreenState();
}

class _MinimalScreenState extends ConsumerState<MinimalScreen>
    with WidgetsBindingObserver {
  String _statusText = '🎵 正在为你播放...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 监听 App 生命周期，用于即完即走
    WidgetsBinding.instance.addObserver(this);
    // 进入页面后触发异步抽歌
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickAndPlay();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 监听生命周期：退到后台或划掉应用时停止播放
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _stopPlayback();
    }
  }

  /// 停止播放
  void _stopPlayback() {
    try {
      ref.read(playerNotifierProvider.notifier).pause();
    } catch (e) {
      AppLogger.error('停止播放失败', tag: 'Minimal', error: e);
    }
  }

  /// 核心逻辑：抽歌并播放
  Future<void> _pickAndPlay() async {
    final parseRepo = ParseRepositoryImpl(biliDio: BiliDio());

    try {
      final track = await _resolveRandomTrack(parseRepo);
      if (!mounted) return;

      // 获取音频流 URL
      final streamInfo = await parseRepo.getAudioStream(
        track.bvid,
        track.cid,
        quality: _preferredQuality,
      );
      if (!mounted) return;

      final playableTrack = track.copyWith(
        streamUrl: streamInfo.url,
        quality: streamInfo.quality,
      );

      // 调用全局播放器播放
      await ref.read(playerNotifierProvider.notifier).playTrack(playableTrack);
      if (!mounted) return;

      setState(() {
        _statusText = '🎵 ${playableTrack.title}\n${playableTrack.artist}';
        _isLoading = false;
      });
    } catch (e, st) {
      AppLogger.error('极简模式抽歌失败', tag: 'Minimal', error: e, stackTrace: st);
      if (!mounted) return;
      setState(() {
        _statusText = '😢 加载失败，双击退出';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('网络请求失败，请检查网络后重试')),
      );
    }
  }

  /// 获取用户偏好音质
  int? get _preferredQuality {
    final q = ref.read(settingsNotifierProvider).preferredQuality;
    return q == 0 ? null : q;
  }

  /// 根据优先级获取随机曲目的 AudioTrack（不含 streamUrl）
  ///
  /// 优先级：本地歌单 > 搜索音乐热门
  Future<AudioTrack> _resolveRandomTrack(ParseRepository parseRepo) async {
    final random = Random();

    // ── 优先级 1：从设置中指定的本地歌单随机抽歌 ──
    final minimalPlaylistId = await ref
        .read(settingsNotifierProvider.notifier)
        .getMinimalPlaylistId();
    if (minimalPlaylistId != null && minimalPlaylistId > 0) {
      try {
        final db = ref.read(databaseProvider);
        final playlistRepo = PlaylistRepositoryImpl(db: db);
        final songs = await playlistRepo.getSongsInPlaylist(minimalPlaylistId);
        if (songs.isNotEmpty) {
          final song = songs[random.nextInt(songs.length)];
          return AudioTrack(
            songId: song.id,
            bvid: song.bvid,
            cid: song.cid,
            title: song.displayTitle,
            artist: song.displayArtist,
            coverUrl: song.coverUrl,
            localPath: song.localPath,
            duration: Duration(seconds: song.duration),
            quality: song.audioQuality,
          );
        }
      } catch (e) {
        AppLogger.warning('从本地歌单获取歌曲失败，回退到搜索', tag: 'Minimal');
      }
    }

    // ── 优先级 2：搜索 B站 音乐区热门视频 ──
    final searchResult = await parseRepo.searchVideos('音乐');
    final videos = searchResult.results;
    if (videos.isEmpty) {
      throw Exception('未找到任何音乐视频');
    }

    // 随机选一个视频
    final video = videos[random.nextInt(videos.length)];

    // 需要通过 getVideoInfo 获取 cid（搜索结果不包含 pages/cid）
    final videoInfo = await parseRepo.getVideoInfo(video.bvid);
    if (videoInfo.pages.isEmpty) {
      throw Exception('视频 ${video.bvid} 没有可用分P');
    }
    final page = videoInfo.pages.first;

    return AudioTrack(
      songId: 0,
      bvid: videoInfo.bvid,
      cid: page.cid,
      title: videoInfo.title,
      artist: videoInfo.owner,
      coverUrl: videoInfo.coverUrl,
      duration: Duration(seconds: page.duration),
    );
  }

  /// 双击退出极简模式，回到原版主页
  void _exitMinimalMode() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: _exitMinimalMode,
        behavior: HitTestBehavior.opaque,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.white54),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _statusText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              if (!_isLoading)
                const Text(
                  '双击屏幕退出极简模式',
                  style: TextStyle(color: Colors.white24, fontSize: 13),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
