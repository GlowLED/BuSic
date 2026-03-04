import 'package:flutter/material.dart';
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

  /// Localized strings via [AppLocalizations].
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Screen width from [MediaQuery].
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Screen height from [MediaQuery].
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Whether the current layout is considered desktop width (>= 840).
  bool get isDesktop => screenWidth >= 840;

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
