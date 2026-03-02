import 'package:flutter/material.dart';

/// Application theme configuration.
///
/// Provides both light and dark [ThemeData] instances with consistent
/// color scheme, typography, and component styling.
class AppTheme {
  AppTheme._();

  // ── Brand Colors ──────────────────────────────────────────────────────
  static const Color _primaryColor = Color(0xFF00A1D6); // Bilibili blue
  static const Color _secondaryColor = Color(0xFFFB7299); // Bilibili pink
  static const Color _errorColor = Color(0xFFE53935);

  // ── Light Theme ───────────────────────────────────────────────────────
  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      secondary: _secondaryColor,
      error: _errorColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      cardTheme: const CardTheme(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
      ),
    );
  }

  // ── Dark Theme ────────────────────────────────────────────────────────
  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      secondary: _secondaryColor,
      error: _errorColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      cardTheme: const CardTheme(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
      ),
    );
  }

  // ── Responsive Breakpoints ────────────────────────────────────────────

  /// Width threshold for switching between mobile and desktop layouts.
  static const double desktopBreakpoint = 840.0;

  /// Width threshold for compact mobile layout.
  static const double compactBreakpoint = 600.0;
}
