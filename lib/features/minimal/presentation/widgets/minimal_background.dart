import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 极简模式的毛玻璃呼吸背景。
///
/// 取当前播放歌曲的封面图进行高斯模糊，并叠加一层缓慢脉动的
/// 缩放 + 透明度呼吸动画，营造沉浸式氛围。
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
    return AnimatedBuilder(
      animation: _breathController,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // ── 底层：封面图或渐变色 ──
            Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: _buildBackground(),
              ),
            ),

            // ── 高斯模糊层 ──
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: const SizedBox.expand(),
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
      },
    );
  }

  /// 根据是否有封面 URL 构建背景图层。
  Widget _buildBackground() {
    final url = widget.coverUrl;
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        // 加载中和失败时回退到渐变色
        placeholder: (_, __) => _gradientFallback(),
        errorWidget: (_, __, ___) => _gradientFallback(),
      );
    }
    return _gradientFallback();
  }

  /// 无封面时的默认渐变背景。
  Widget _gradientFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
      ),
    );
  }
}
