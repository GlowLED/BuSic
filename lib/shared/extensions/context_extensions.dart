import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tokens.dart';
import '../../l10n/generated/app_localizations.dart';

/// Convenience extensions on [BuildContext] for quick access to
/// frequently used theme, localization, and navigation properties.
extension ContextExtensions on BuildContext {
  /// Current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Current [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Current [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// App-level palette tokens for surfaces, text, states, and overlays.
  AppThemePalette get appPalette =>
      Theme.of(this).extension<AppThemePalette>()!;

  /// App-level spacing tokens.
  AppThemeSpacing get appSpacing =>
      Theme.of(this).extension<AppThemeSpacing>()!;

  /// App-level corner radius tokens.
  AppThemeRadii get appRadii => Theme.of(this).extension<AppThemeRadii>()!;

  /// App-level shadow, border, and glow tokens.
  AppThemeDepth get appDepth => Theme.of(this).extension<AppThemeDepth>()!;

  /// Localized strings via [AppLocalizations].
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Screen width from [MediaQuery].
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Screen height from [MediaQuery].
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Whether the current layout is considered desktop width (>= 840).
  bool get isDesktop => screenWidth >= AppTheme.desktopBreakpoint;

  /// Show a [SnackBar] with the given [message], floating above the player bar.
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
      ),
    );
  }
}
