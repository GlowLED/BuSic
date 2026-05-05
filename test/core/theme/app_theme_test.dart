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

    test('text selection uses a stronger global accent overlay', () {
      for (final seedColor in AppTheme.seedPresets.values) {
        for (final theme in [
          AppTheme.lightTheme(seedColor: seedColor),
          AppTheme.darkTheme(seedColor: seedColor),
        ]) {
          final palette = theme.extension<AppThemePalette>()!;
          final selectionTheme = theme.textSelectionTheme;
          final selectionColor = selectionTheme.selectionColor;

          expect(selectionTheme.cursorColor, palette.accentStrong);
          expect(selectionTheme.selectionHandleColor, palette.accentStrong);
          expect(selectionColor, isNotNull);
          expect(selectionColor, isNot(equals(palette.accentSoft)));
          expect(
            selectionColor!.a,
            closeTo(
              theme.colorScheme.brightness == Brightness.dark ? 0.50 : 0.42,
              0.001,
            ),
          );

          final selectedSurface = Color.alphaBlend(
            selectionColor,
            palette.surfacePrimary,
          );
          final previousSelectedSurface = Color.alphaBlend(
            palette.accentSoft,
            palette.surfacePrimary,
          );

          expect(
            _contrastRatio(selectedSurface, palette.surfacePrimary),
            greaterThan(
              _contrastRatio(
                previousSelectedSurface,
                palette.surfacePrimary,
              ),
            ),
          );
        }
      }
    });
  });
}

double _contrastRatio(Color a, Color b) {
  final first = a.computeLuminance();
  final second = b.computeLuminance();
  final lighter = first > second ? first : second;
  final darker = first > second ? second : first;

  return (lighter + 0.05) / (darker + 0.05);
}
