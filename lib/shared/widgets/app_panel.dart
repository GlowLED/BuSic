import 'dart:ui';

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Shared glass-like panel surface used by media widgets and overlays.
class AppPanel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final depth = context.appDepth;
    final effectiveRadius = borderRadius ?? context.appRadii.largeRadius;
    final effectiveColors = backgroundColors ??
        [
          palette.surfaceElevated.withValues(alpha: 0.96),
          palette.surfaceSecondary.withValues(alpha: 0.92),
        ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: boxShadow ?? depth.panelShadow,
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: DecoratedBox(
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
                color:
                    borderColor ?? palette.borderSubtle.withValues(alpha: 0.95),
                width: borderWidth ?? depth.outline,
              ),
            ),
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
