import 'package:flutter/material.dart';

import '../../../shared/extensions/context_extensions.dart';

enum CommentSectionAppearance { standard, playerOverlay }

ThemeData commentSectionTheme(
  BuildContext context,
  CommentSectionAppearance appearance,
) {
  final baseTheme = Theme.of(context);
  if (appearance == CommentSectionAppearance.standard) {
    return baseTheme;
  }

  final palette = context.appPalette;
  final colorScheme = baseTheme.colorScheme.copyWith(
    brightness: Brightness.dark,
    primary: palette.accentStrong,
    onPrimary: baseTheme.colorScheme.onPrimary,
    primaryContainer: Colors.white.withValues(alpha: 0.92),
    onPrimaryContainer: Colors.black.withValues(alpha: 0.88),
    surface: Colors.transparent,
    onSurface: Colors.white.withValues(alpha: 0.92),
    onSurfaceVariant: Colors.white.withValues(alpha: 0.62),
    surfaceContainerLow: Colors.black.withValues(alpha: 0.12),
    surfaceContainer: Colors.black.withValues(alpha: 0.18),
    surfaceContainerHigh: Colors.black.withValues(alpha: 0.24),
    surfaceContainerHighest: Colors.white.withValues(alpha: 0.09),
    outline: Colors.white.withValues(alpha: 0.20),
    outlineVariant: Colors.white.withValues(alpha: 0.12),
  );
  final textTheme = baseTheme.textTheme.apply(
    bodyColor: Colors.white.withValues(alpha: 0.90),
    displayColor: Colors.white.withValues(alpha: 0.94),
  );

  return baseTheme.copyWith(
    colorScheme: colorScheme,
    textTheme: textTheme,
    dividerTheme: DividerThemeData(
      color: Colors.white.withValues(alpha: 0.12),
      thickness: context.appDepth.hairline,
      space: 1,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: baseTheme.iconButtonTheme.style?.copyWith(
        foregroundColor: WidgetStatePropertyAll(
          Colors.white.withValues(alpha: 0.72),
        ),
        overlayColor: WidgetStatePropertyAll(
          Colors.white.withValues(alpha: 0.08),
        ),
      ),
    ),
    inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
      fillColor: Colors.white.withValues(alpha: 0.09),
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: Colors.white.withValues(alpha: 0.44),
      ),
    ),
    progressIndicatorTheme: baseTheme.progressIndicatorTheme.copyWith(
      color: palette.accentStrong,
      circularTrackColor: Colors.white.withValues(alpha: 0.10),
    ),
  );
}
