import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../player/domain/models/audio_track.dart';

/// 极简模式的歌曲信息面板。
///
/// 居中展示封面、歌名、歌手，切歌时通过 [AnimatedSwitcher] 自动渐变过渡。
class SongInfoPanel extends StatelessWidget {
  /// 当前播放的曲目，为 null 时显示占位。
  final AudioTrack? track;

  /// 是否正在加载中。
  final bool isLoading;

  const SongInfoPanel({
    super.key,
    required this.track,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const _LoadingPlaceholder(key: ValueKey('loading'));
    }

    final currentTrack = track;
    if (currentTrack == null) {
      return const _LoadingPlaceholder(key: ValueKey('empty'));
    }

    // 以 bvid+cid 作为 key，确保切歌时触发 AnimatedSwitcher 动画
    return Column(
      key: ValueKey('${currentTrack.bvid}_${currentTrack.cid}'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── 封面图 ──
        _CoverArt(coverUrl: currentTrack.coverUrl),
        const SizedBox(height: 32),

        // ── 歌曲名 ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            currentTrack.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.4,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // ── 歌手名 ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            currentTrack.artist,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

/// 封面图组件：圆角带阴影。
class _CoverArt extends StatelessWidget {
  final String? coverUrl;

  const _CoverArt({required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    const double size = 220;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    final url = coverUrl;
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholder(),
        errorWidget: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFF2A2A3E),
      child: const Center(
        child: Icon(
          Icons.music_note_rounded,
          color: Colors.white38,
          size: 64,
        ),
      ),
    );
  }
}

/// 加载状态占位。
class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            color: Colors.white38,
            strokeWidth: 2.5,
          ),
        ),
        SizedBox(height: 24),
        Text(
          '正在为你挑选音乐…',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 16,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
