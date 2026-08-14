import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/application/settings_notifier.dart';
import '../extensions/context_extensions.dart';

/// Shared glass-like panel surface used by media widgets and overlays.
class AppPanel extends ConsumerWidget {
  const AppPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.backgroundColors,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.blurSigma = 18,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final List<Color>? backgroundColors;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;
  final double blurSigma;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.appPalette;
    final depth = context.appDepth;
    final effectiveRadius = borderRadius ?? context.appRadii.largeRadius;
    final effectiveColors =
        backgroundColors ??
        [
          palette.surfaceElevated.withValues(
            alpha: 0.96 * palette.surfaceOpacity,
          ),
          palette.surfaceSecondary.withValues(
            alpha: 0.92 * palette.surfaceOpacity,
          ),
        ];

    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: effectiveRadius,
        gradient: backgroundColor == null
            ? LinearGradient(
                begin: gradientBegin,
                end: gradientEnd,
                colors: effectiveColors,
              )
            : null,
        border: Border.all(
          color: borderColor ?? palette.borderSubtle.withValues(alpha: 0.95),
          width: borderWidth ?? depth.outline,
        ),
      ),
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );

    // 「减少毛玻璃效果」开启时跳过 BackdropFilter，面板用自身渐变渲染，
    // 避免多层玻璃采样拖慢低端设备。
    final reduceTransparency = ref.watch(
      settingsNotifierProvider.select((s) => s.reduceTransparency),
    );
    final surface = reduceTransparency || blurSigma <= 0
        ? content
        : BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: content,
          );

    return Container(
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: boxShadow ?? depth.panelShadow,
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: surface,
      ),
    );
  }
}
