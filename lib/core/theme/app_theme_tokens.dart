import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class AppThemePalette extends ThemeExtension<AppThemePalette> {
  const AppThemePalette({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceElevated,
    required this.accentStrong,
    required this.accentSoft,
    required this.accentMuted,
    required this.borderSubtle,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.overlaySoft,
    required this.overlayMedium,
    required this.overlayStrong,
    required this.coverGlow,
  });

  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color surfaceElevated;
  final Color accentStrong;
  final Color accentSoft;
  final Color accentMuted;
  final Color borderSubtle;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color overlaySoft;
  final Color overlayMedium;
  final Color overlayStrong;
  final Color coverGlow;

  @override
  AppThemePalette copyWith({
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? surfacePrimary,
    Color? surfaceSecondary,
    Color? surfaceElevated,
    Color? accentStrong,
    Color? accentSoft,
    Color? accentMuted,
    Color? borderSubtle,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? overlaySoft,
    Color? overlayMedium,
    Color? overlayStrong,
    Color? coverGlow,
  }) {
    return AppThemePalette(
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      accentStrong: accentStrong ?? this.accentStrong,
      accentSoft: accentSoft ?? this.accentSoft,
      accentMuted: accentMuted ?? this.accentMuted,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      overlaySoft: overlaySoft ?? this.overlaySoft,
      overlayMedium: overlayMedium ?? this.overlayMedium,
      overlayStrong: overlayStrong ?? this.overlayStrong,
      coverGlow: coverGlow ?? this.coverGlow,
    );
  }

  @override
  AppThemePalette lerp(
    covariant ThemeExtension<AppThemePalette>? other,
    double t,
  ) {
    if (other is! AppThemePalette) {
      return this;
    }

    return AppThemePalette(
      backgroundPrimary:
          Color.lerp(backgroundPrimary, other.backgroundPrimary, t)!,
      backgroundSecondary:
          Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      surfacePrimary: Color.lerp(surfacePrimary, other.surfacePrimary, t)!,
      surfaceSecondary:
          Color.lerp(surfaceSecondary, other.surfaceSecondary, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      accentStrong: Color.lerp(accentStrong, other.accentStrong, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      overlaySoft: Color.lerp(overlaySoft, other.overlaySoft, t)!,
      overlayMedium: Color.lerp(overlayMedium, other.overlayMedium, t)!,
      overlayStrong: Color.lerp(overlayStrong, other.overlayStrong, t)!,
      coverGlow: Color.lerp(coverGlow, other.coverGlow, t)!,
    );
  }
}

@immutable
class AppThemeSpacing extends ThemeExtension<AppThemeSpacing> {
  const AppThemeSpacing({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;

  @override
  AppThemeSpacing copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
  }) {
    return AppThemeSpacing(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
    );
  }

  @override
  AppThemeSpacing lerp(
    covariant ThemeExtension<AppThemeSpacing>? other,
    double t,
  ) {
    if (other is! AppThemeSpacing) {
      return this;
    }

    return AppThemeSpacing(
      xxs: lerpDouble(xxs, other.xxs, t)!,
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      xxxl: lerpDouble(xxxl, other.xxxl, t)!,
    );
  }
}

@immutable
class AppThemeRadii extends ThemeExtension<AppThemeRadii> {
  const AppThemeRadii({
    required this.small,
    required this.medium,
    required this.large,
    required this.xLarge,
    required this.pill,
  });

  final double small;
  final double medium;
  final double large;
  final double xLarge;
  final double pill;

  BorderRadius get smallRadius => BorderRadius.circular(small);
  BorderRadius get mediumRadius => BorderRadius.circular(medium);
  BorderRadius get largeRadius => BorderRadius.circular(large);
  BorderRadius get xLargeRadius => BorderRadius.circular(xLarge);
  BorderRadius get pillRadius => BorderRadius.circular(pill);

  @override
  AppThemeRadii copyWith({
    double? small,
    double? medium,
    double? large,
    double? xLarge,
    double? pill,
  }) {
    return AppThemeRadii(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      xLarge: xLarge ?? this.xLarge,
      pill: pill ?? this.pill,
    );
  }

  @override
  AppThemeRadii lerp(
    covariant ThemeExtension<AppThemeRadii>? other,
    double t,
  ) {
    if (other is! AppThemeRadii) {
      return this;
    }

    return AppThemeRadii(
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      xLarge: lerpDouble(xLarge, other.xLarge, t)!,
      pill: lerpDouble(pill, other.pill, t)!,
    );
  }
}

@immutable
class AppThemeDepth extends ThemeExtension<AppThemeDepth> {
  const AppThemeDepth({
    required this.hairline,
    required this.outline,
    required this.outlineStrong,
    required this.shadowSoft,
    required this.shadow,
    required this.glow,
    required this.panelBlur,
    required this.panelOffset,
    required this.floatingBlur,
    required this.floatingOffset,
    required this.glowBlur,
    required this.glowSpread,
  });

  final double hairline;
  final double outline;
  final double outlineStrong;
  final Color shadowSoft;
  final Color shadow;
  final Color glow;
  final double panelBlur;
  final Offset panelOffset;
  final double floatingBlur;
  final Offset floatingOffset;
  final double glowBlur;
  final double glowSpread;

  List<BoxShadow> get panelShadow => [
        BoxShadow(
          color: shadowSoft,
          blurRadius: panelBlur,
          offset: panelOffset,
        ),
        BoxShadow(
          color: shadow,
          blurRadius: panelBlur * 0.55,
          offset: Offset(panelOffset.dx, panelOffset.dy * 0.5),
        ),
      ];

  List<BoxShadow> get floatingShadow => [
        BoxShadow(
          color: shadowSoft,
          blurRadius: floatingBlur,
          offset: floatingOffset,
        ),
        BoxShadow(
          color: shadow,
          blurRadius: floatingBlur * 0.6,
          offset: Offset(floatingOffset.dx, floatingOffset.dy * 0.45),
        ),
      ];

  List<BoxShadow> get coverGlowShadow => [
        BoxShadow(
          color: glow,
          blurRadius: glowBlur,
          spreadRadius: glowSpread,
        ),
      ];

  @override
  AppThemeDepth copyWith({
    double? hairline,
    double? outline,
    double? outlineStrong,
    Color? shadowSoft,
    Color? shadow,
    Color? glow,
    double? panelBlur,
    Offset? panelOffset,
    double? floatingBlur,
    Offset? floatingOffset,
    double? glowBlur,
    double? glowSpread,
  }) {
    return AppThemeDepth(
      hairline: hairline ?? this.hairline,
      outline: outline ?? this.outline,
      outlineStrong: outlineStrong ?? this.outlineStrong,
      shadowSoft: shadowSoft ?? this.shadowSoft,
      shadow: shadow ?? this.shadow,
      glow: glow ?? this.glow,
      panelBlur: panelBlur ?? this.panelBlur,
      panelOffset: panelOffset ?? this.panelOffset,
      floatingBlur: floatingBlur ?? this.floatingBlur,
      floatingOffset: floatingOffset ?? this.floatingOffset,
      glowBlur: glowBlur ?? this.glowBlur,
      glowSpread: glowSpread ?? this.glowSpread,
    );
  }

  @override
  AppThemeDepth lerp(
    covariant ThemeExtension<AppThemeDepth>? other,
    double t,
  ) {
    if (other is! AppThemeDepth) {
      return this;
    }

    return AppThemeDepth(
      hairline: lerpDouble(hairline, other.hairline, t)!,
      outline: lerpDouble(outline, other.outline, t)!,
      outlineStrong: lerpDouble(outlineStrong, other.outlineStrong, t)!,
      shadowSoft: Color.lerp(shadowSoft, other.shadowSoft, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
      panelBlur: lerpDouble(panelBlur, other.panelBlur, t)!,
      panelOffset: Offset.lerp(panelOffset, other.panelOffset, t)!,
      floatingBlur: lerpDouble(floatingBlur, other.floatingBlur, t)!,
      floatingOffset: Offset.lerp(floatingOffset, other.floatingOffset, t)!,
      glowBlur: lerpDouble(glowBlur, other.glowBlur, t)!,
      glowSpread: lerpDouble(glowSpread, other.glowSpread, t)!,
    );
  }
}
