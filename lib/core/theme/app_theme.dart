import 'package:flutter/material.dart';

/// Application theme configuration.
///
/// Provides both light and dark [ThemeData] instances with consistent
/// color scheme, typography, and component styling.
class AppTheme {
  AppTheme._();

  // ── Theme Seed Presets ────────────────────────────────────────────────
  static const Color greenSeed = Color(0xFF4CAF50);
  static const Color pinkSeed = Color(0xFFE91E63);
  static const Color purpleSeed = Color(0xFF9C27B0);
  static const Color yellowSeed = Color(0xFFFBC02D);
  static const Color blueSeed = Color(0xFF2196F3);
  static const Color tealSeed = Color(0xFF009688);
  static const Color orangeSeed = Color(0xFFFF9800);
  static const Color redSeed = Color(0xFFF44336);
  static const Color indigoSeed = Color(0xFF3F51B5);
  static const Color cyanSeed = Color(0xFF00BCD4);

  static const Color _errorColor = Color(0xFFE53935);

  // ── Light Theme ───────────────────────────────────────────────────────
  static ThemeData lightTheme({required Color seedColor}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      error: _errorColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      cardTheme: const CardThemeData(
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
  static ThemeData darkTheme({required Color seedColor}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      error: _errorColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      cardTheme: const CardThemeData(
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
