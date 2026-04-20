import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/theme/app_theme.dart';
import 'package:busic/core/theme/app_theme_tokens.dart';

void main() {
  group('AppTheme design tokens', () {
    test('light theme exposes the full token set', () {
      final theme = AppTheme.lightTheme(seedColor: AppTheme.greenSeed);

      final palette = theme.extension<AppThemePalette>();
      final spacing = theme.extension<AppThemeSpacing>();
      final radii = theme.extension<AppThemeRadii>();
      final depth = theme.extension<AppThemeDepth>();

      expect(theme.colorScheme.brightness, Brightness.light);
      expect(palette, isNotNull);
      expect(spacing, isNotNull);
      expect(radii, isNotNull);
      expect(depth, isNotNull);
      expect(theme.scaffoldBackgroundColor, palette!.backgroundPrimary);
      expect(
          theme.colorScheme.surfaceContainerHighest, palette.surfaceElevated);
      expect(theme.colorScheme.error, palette.danger);
      expect(spacing!.xl, greaterThan(spacing.md));
      expect(radii!.pill, greaterThan(radii.large));
      expect(depth!.panelShadow, isNotEmpty);
    });

    test('dark theme keeps dark semantics and emphasis layers', () {
      final theme = AppTheme.darkTheme(seedColor: AppTheme.pinkSeed);
      final palette = theme.extension<AppThemePalette>()!;
      final depth = theme.extension<AppThemeDepth>()!;

      expect(theme.colorScheme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, palette.accentStrong);
      expect(theme.colorScheme.primaryContainer, palette.accentSoft);
      expect(
          theme.navigationBarTheme.backgroundColor, palette.surfaceSecondary);
      expect(theme.navigationRailTheme.indicatorColor, palette.accentSoft);
      expect(depth.coverGlowShadow, isNotEmpty);
    });
  });
}
