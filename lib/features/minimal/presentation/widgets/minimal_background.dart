import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const _minimalBackgroundCacheOversample = 1.5;
const _minimalBackgroundMinCacheDimension = 256.0;
const _minimalBackgroundMaxCacheDimension = 1024.0;
const _minimalBackgroundBlurSigma = 60.0;

/// 极简模式的毛玻璃呼吸背景。
///
/// 取当前播放歌曲的封面图进行高斯模糊，并叠加一层缓慢脉动的
/// 缩放 + 透明度呼吸动画，营造沉浸式氛围。
///
/// 性能策略：模糊只作用于静态封面图（仅封面变化时重算一次），
/// 呼吸动画只对已模糊图层做 scale/opacity，避免每帧全屏重采样。
class MinimalBackground extends StatefulWidget {
  /// 封面图 URL，为 null 时显示纯渐变色背景。
  final String? coverUrl;

  const MinimalBackground({super.key, this.coverUrl});

  @override
  State<MinimalBackground> createState() => _MinimalBackgroundState();
}

class _MinimalBackgroundState extends State<MinimalBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // 呼吸周期 6 秒，永久循环
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    // 缩放幅度 1.0 → 1.12，平滑的正弦曲线
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // 透明度微弱呼吸 0.6 → 0.85
    _opacityAnimation = Tween<double>(begin: 0.6, end: 0.85).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 模糊后的封面是静态图层，仅在封面变化时重建一次；呼吸动画把它
    // 作为 child 复用，每帧只做一次便宜的 Transform + Opacity。
    final blurredCover = RepaintBoundary(
      child: _buildBlurredCover(),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── 底层：模糊封面（AnimatedBuilder child 提升，呼吸动画不重建它）──
        AnimatedBuilder(
          animation: _breathController,
          child: blurredCover,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                filterQuality: FilterQuality.high,
                child: child,
              ),
            );
          },
        ),

        // ── 暗色叠加层，保证前景文字可读 ──
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.4),
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 对封面图应用一次高斯模糊；无封面时退化为渐变色背景。
  Widget _buildBlurredCover() {
    final url = widget.coverUrl;
    if (url == null || url.isEmpty) {
      return _gradientFallback();
    }

    return ClipRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: _minimalBackgroundBlurSigma,
          sigmaY: _minimalBackgroundBlurSigma,
        ),
        child: _buildBackground(url),
      ),
    );
  }

  /// 根据封面 URL 构建原始背景图层。
  Widget _buildBackground(String url) {
    final cacheSize = _backgroundCacheSize();
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      memCacheWidth: cacheSize?.width,
      memCacheHeight: cacheSize?.height,
      // 加载中和失败时回退到渐变色
      placeholder: (_, __) => _gradientFallback(),
      errorWidget: (_, __, ___) => _gradientFallback(),
    );
  }

  /// 无封面时的默认渐变背景。
  Widget _gradientFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
    );
  }

  ({int width, int height})? _backgroundCacheSize() {
    final screenSize = MediaQuery.sizeOf(context);
    if (screenSize.width <= 0 || screenSize.height <= 0) return null;

    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final rawWidth =
        screenSize.width * pixelRatio * _minimalBackgroundCacheOversample;
    final rawHeight =
        screenSize.height * pixelRatio * _minimalBackgroundCacheOversample;
    final rawMax = math.max(rawWidth, rawHeight);
    if (!rawMax.isFinite || rawMax <= 0) return null;

    final scale = rawMax < _minimalBackgroundMinCacheDimension
        ? _minimalBackgroundMinCacheDimension / rawMax
        : rawMax > _minimalBackgroundMaxCacheDimension
        ? _minimalBackgroundMaxCacheDimension / rawMax
        : 1.0;

    return (
      width: math.max(1, (rawWidth * scale).ceil()),
      height: math.max(1, (rawHeight * scale).ceil()),
    );
  }
}
