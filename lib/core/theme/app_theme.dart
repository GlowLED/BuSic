import 'package:flutter/material.dart';

import 'app_theme_tokens.dart';

/// Application theme configuration.
///
/// Provides both light and dark [ThemeData] instances with a shared
/// design-token system for palette, spacing, radius, and depth.
class AppTheme {
  AppTheme._();

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

  static const Map<String, Color> seedPresets = {
    'green': greenSeed,
    'blue': blueSeed,
    'teal': tealSeed,
    'pink': pinkSeed,
    'purple': purpleSeed,
    'indigo': indigoSeed,
    'yellow': yellowSeed,
    'orange': orangeSeed,
    'red': redSeed,
    'cyan': cyanSeed,
  };

  static const AppThemeSpacing _spacing = AppThemeSpacing(
    xxs: 4,
    xs: 8,
    sm: 12,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 40,
    xxxl: 56,
  );

  static const AppThemeRadii _radii = AppThemeRadii(
    small: 12,
    medium: 18,
    large: 24,
    xLarge: 32,
    pill: 999,
  );

  static const Color _darkBase = Color(0xFF090C12);
  static const Color _darkSurface = Color(0xFF161D27);
  static const Color _darkSurfaceRaised = Color(0xFF202A37);
  static const Color _lightBase = Color(0xFFF5F0E8);
  static const Color _lightSurface = Color(0xFFFFFBF7);
  static const Color _lightSurfaceRaised = Color(0xFFFFFFFF);

  static ThemeData lightTheme({required Color seedColor}) {
    return _buildTheme(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
  }

  static ThemeData darkTheme({required Color seedColor}) {
    return _buildTheme(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
  }

  static ThemeData _buildTheme({
    required Color seedColor,
    required Brightness brightness,
  }) {
    final bundle = _buildBundle(
      seedColor: seedColor,
      brightness: brightness,
    );
    final typography = brightness == Brightness.dark
        ? Typography.material2021().white
        : Typography.material2021().black;
    final textTheme = _buildTextTheme(typography, bundle.palette);

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: bundle.colorScheme,
      scaffoldBackgroundColor: bundle.palette.backgroundPrimary,
      canvasColor: bundle.palette.backgroundSecondary,
      dividerColor: bundle.palette.borderSubtle,
      splashColor: bundle.palette.overlaySoft,
      highlightColor: Colors.transparent,
      hoverColor: bundle.palette.overlaySoft,
      shadowColor: bundle.depth.shadow,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[
        bundle.palette,
        _spacing,
        _radii,
        bundle.depth,
      ],
    );

    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: bundle.palette.textPrimary),
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: bundle.palette.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: bundle.palette.surfacePrimary,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shadowColor: bundle.depth.shadowSoft,
        shape: RoundedRectangleBorder(
          borderRadius: _radii.largeRadius,
          side: BorderSide(
            color: bundle.palette.borderSubtle,
            width: bundle.depth.outline,
          ),
        ),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        backgroundColor: bundle.palette.surfaceSecondary,
        selectedColor: bundle.palette.accentSoft,
        secondarySelectedColor: bundle.palette.accentSoft,
        shadowColor: Colors.transparent,
        side: BorderSide(
          color: bundle.palette.borderSubtle,
          width: bundle.depth.outline,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: _spacing.sm,
          vertical: _spacing.xxs,
        ),
        shape: RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: bundle.palette.textSecondary,
        ),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: bundle.palette.textPrimary,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: bundle.palette.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shadowColor: bundle.depth.shadow,
        shape: RoundedRectangleBorder(borderRadius: _radii.xLargeRadius),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: bundle.palette.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: bundle.palette.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_radii.xLarge),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: bundle.palette.borderStrong,
      ),
      dividerTheme: DividerThemeData(
        color: bundle.palette.borderSubtle,
        thickness: bundle.depth.hairline,
        space: _spacing.lg,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: _spacing.md,
              vertical: _spacing.sm,
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return bundle.palette.accentMuted;
            }
            return bundle.palette.accentStrong;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return bundle.palette.textMuted;
            }
            return bundle.colorScheme.onPrimary;
          }),
          overlayColor: WidgetStatePropertyAll(bundle.palette.overlayMedium),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: bundle.palette.accentStrong,
        foregroundColor: bundle.colorScheme.onPrimary,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: _radii.largeRadius),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          padding: WidgetStatePropertyAll(EdgeInsets.all(_spacing.xs)),
          foregroundColor: WidgetStatePropertyAll(bundle.palette.textSecondary),
          overlayColor: WidgetStatePropertyAll(bundle.palette.overlayMedium),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bundle.palette.surfaceSecondary,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: bundle.palette.textMuted,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: bundle.palette.textSecondary,
        ),
        helperStyle: textTheme.bodySmall?.copyWith(
          color: bundle.palette.textMuted,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: bundle.palette.danger,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: _spacing.md,
          vertical: _spacing.sm,
        ),
        border: _inputBorder(
          color: bundle.palette.borderSubtle,
          width: bundle.depth.outline,
        ),
        enabledBorder: _inputBorder(
          color: bundle.palette.borderSubtle,
          width: bundle.depth.outline,
        ),
        focusedBorder: _inputBorder(
          color: bundle.palette.accentStrong,
          width: bundle.depth.outlineStrong,
        ),
        errorBorder: _inputBorder(
          color: bundle.palette.danger,
          width: bundle.depth.outlineStrong,
        ),
        focusedErrorBorder: _inputBorder(
          color: bundle.palette.danger,
          width: bundle.depth.outlineStrong,
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
        contentPadding: EdgeInsets.symmetric(
          horizontal: _spacing.md,
          vertical: _spacing.xxs,
        ),
        iconColor: bundle.palette.textSecondary,
        textColor: bundle.palette.textPrimary,
        titleTextStyle: textTheme.titleSmall,
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          color: bundle.palette.textSecondary,
        ),
        selectedTileColor: bundle.palette.accentSoft,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: bundle.palette.surfaceSecondary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: bundle.palette.accentSoft,
        shadowColor: bundle.depth.shadowSoft,
        height: 74,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            color: isSelected
                ? bundle.palette.textPrimary
                : bundle.palette.textMuted,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected
                ? bundle.palette.textPrimary
                : bundle.palette.textMuted,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: bundle.palette.surfaceSecondary,
        indicatorColor: bundle.palette.accentSoft,
        elevation: 0,
        selectedIconTheme: IconThemeData(color: bundle.palette.textPrimary),
        unselectedIconTheme: IconThemeData(color: bundle.palette.textMuted),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: bundle.palette.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: bundle.palette.textMuted,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: _spacing.md,
              vertical: _spacing.sm,
            ),
          ),
          foregroundColor: WidgetStatePropertyAll(bundle.palette.textPrimary),
          overlayColor: WidgetStatePropertyAll(bundle.palette.overlaySoft),
          side: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return BorderSide(
              color: isSelected
                  ? bundle.palette.accentStrong
                  : bundle.palette.borderStrong,
              width: isSelected
                  ? bundle.depth.outlineStrong
                  : bundle.depth.outline,
            );
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: bundle.palette.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: _radii.largeRadius),
        elevation: 0,
        textStyle: textTheme.bodyMedium,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: bundle.palette.accentStrong,
        linearTrackColor: bundle.palette.accentMuted,
        circularTrackColor: bundle.palette.accentMuted,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: _spacing.md,
              vertical: _spacing.xs,
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return bundle.palette.accentSoft;
            }
            return bundle.palette.surfaceSecondary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return bundle.palette.textPrimary;
            }
            return bundle.palette.textSecondary;
          }),
          overlayColor: WidgetStatePropertyAll(bundle.palette.overlaySoft),
          side: WidgetStatePropertyAll(
            BorderSide(
              color: bundle.palette.borderStrong,
              width: bundle.depth.outline,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
      ),
      sliderTheme: baseTheme.sliderTheme.copyWith(
        activeTrackColor: bundle.palette.accentStrong,
        inactiveTrackColor: bundle.palette.accentMuted,
        secondaryActiveTrackColor: bundle.palette.accentSoft,
        thumbColor: bundle.palette.accentStrong,
        overlayColor: bundle.palette.accentStrong.withValues(alpha: 0.18),
        trackHeight: 4,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bundle.palette.surfaceElevated,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: bundle.palette.textPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
        actionTextColor: bundle.palette.accentStrong,
        disabledActionTextColor: bundle.palette.textMuted,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return bundle.palette.accentStrong.withValues(alpha: 0.4);
          }
          return bundle.palette.accentMuted;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return bundle.palette.accentStrong;
          }
          return bundle.palette.textMuted;
        }),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(bundle.palette.accentStrong),
          overlayColor: WidgetStatePropertyAll(bundle.palette.overlaySoft),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: _spacing.sm,
              vertical: _spacing.xs,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: bundle.palette.accentStrong,
        selectionColor: bundle.palette.accentSoft,
        selectionHandleColor: bundle.palette.accentStrong,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: bundle.palette.surfaceElevated,
          borderRadius: _radii.mediumRadius,
          border: Border.all(
            color: bundle.palette.borderSubtle,
            width: bundle.depth.outline,
          ),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: bundle.palette.textPrimary,
        ),
      ),
    );
  }

  static _AppThemeBundle _buildBundle({
    required Color seedColor,
    required Brightness brightness,
  }) {
    final accentStrong = _normalizeSeed(seedColor, brightness);
    final baseScheme = ColorScheme.fromSeed(
      seedColor: accentStrong,
      brightness: brightness,
      error: brightness == Brightness.dark
          ? const Color(0xFFFF8E88)
          : const Color(0xFFD73F3A),
    );

    final isDark = brightness == Brightness.dark;
    final backgroundPrimary = isDark
        ? _tintSurface(accentStrong, _darkBase, 0.10)
        : _tintSurface(accentStrong, _lightBase, 0.05);
    final backgroundSecondary = isDark
        ? _tintSurface(accentStrong, const Color(0xFF111722), 0.16)
        : _tintSurface(accentStrong, const Color(0xFFEDE4D8), 0.08);
    final surfacePrimary = isDark
        ? _tintSurface(accentStrong, _darkSurface, 0.18)
        : _tintSurface(accentStrong, _lightSurface, 0.10);
    final surfaceSecondary = isDark
        ? _tintSurface(accentStrong, const Color(0xFF1B2430), 0.24)
        : _tintSurface(accentStrong, const Color(0xFFFBF5ED), 0.16);
    final surfaceElevated = isDark
        ? _tintSurface(accentStrong, _darkSurfaceRaised, 0.30)
        : _tintSurface(accentStrong, _lightSurfaceRaised, 0.22);

    final textPrimary =
        isDark ? const Color(0xFFF4F7FB) : const Color(0xFF171C22);
    final textSecondary =
        isDark ? const Color(0xFFBEC7D3) : const Color(0xFF56606D);
    final textMuted =
        isDark ? const Color(0xFF909BA8) : const Color(0xFF7A8591);
    final borderSubtle = isDark
        ? _tintSurface(accentStrong, const Color(0xFF293241), 0.18)
        : _tintSurface(accentStrong, const Color(0xFFD9D0C5), 0.12);
    final borderStrong = isDark
        ? _tintSurface(accentStrong, const Color(0xFF3A4558), 0.34)
        : _tintSurface(accentStrong, const Color(0xFFC7BCB0), 0.20);
    final accentSoft = isDark
        ? _tintSurface(accentStrong, const Color(0xFF172432), 0.34)
        : _tintSurface(accentStrong, _lightSurfaceRaised, 0.16);
    final accentMuted = isDark
        ? _tintSurface(accentStrong, const Color(0xFF121822), 0.20)
        : _tintSurface(accentStrong, const Color(0xFFF5EEE5), 0.08);

    final palette = AppThemePalette(
      backgroundPrimary: backgroundPrimary,
      backgroundSecondary: backgroundSecondary,
      surfacePrimary: surfacePrimary,
      surfaceSecondary: surfaceSecondary,
      surfaceElevated: surfaceElevated,
      accentStrong: accentStrong,
      accentSoft: accentSoft,
      accentMuted: accentMuted,
      borderSubtle: borderSubtle,
      borderStrong: borderStrong,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      textMuted: textMuted,
      success: isDark ? const Color(0xFF56D39A) : const Color(0xFF11875B),
      successSoft: isDark ? const Color(0xFF173528) : const Color(0xFFD8F4E6),
      warning: isDark ? const Color(0xFFFFC766) : const Color(0xFFB86C00),
      warningSoft: isDark ? const Color(0xFF3D2D0F) : const Color(0xFFFCE8C6),
      danger: baseScheme.error,
      dangerSoft: isDark ? const Color(0xFF45211F) : const Color(0xFFFAD9D7),
      overlaySoft: isDark
          ? Colors.white.withValues(alpha: 0.04)
          : const Color(0xFF0D1117).withValues(alpha: 0.04),
      overlayMedium: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : const Color(0xFF0D1117).withValues(alpha: 0.08),
      overlayStrong: isDark
          ? Colors.white.withValues(alpha: 0.14)
          : const Color(0xFF0D1117).withValues(alpha: 0.16),
      coverGlow: accentStrong.withValues(alpha: isDark ? 0.38 : 0.20),
    );

    final secondary =
        _blend(baseScheme.secondary, accentStrong, isDark ? 0.24 : 0.16);
    final tertiary =
        _blend(baseScheme.tertiary, accentStrong, isDark ? 0.18 : 0.12);
    final secondaryContainer = _tintSurface(
      secondary,
      surfaceSecondary,
      isDark ? 0.30 : 0.18,
    );
    final tertiaryContainer = _tintSurface(
      tertiary,
      surfaceSecondary,
      isDark ? 0.34 : 0.20,
    );

    final colorScheme = baseScheme.copyWith(
      primary: accentStrong,
      onPrimary: _foregroundFor(accentStrong),
      primaryContainer: accentSoft,
      onPrimaryContainer: textPrimary,
      secondary: secondary,
      onSecondary: _foregroundFor(secondary),
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: textPrimary,
      tertiary: tertiary,
      onTertiary: _foregroundFor(tertiary),
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: textPrimary,
      surface: surfacePrimary,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      surfaceContainerLow: surfacePrimary,
      surfaceContainer: surfaceSecondary,
      surfaceContainerHigh: surfaceSecondary,
      surfaceContainerHighest: surfaceElevated,
      surfaceBright: surfaceElevated,
      surfaceDim: backgroundSecondary,
      outline: borderStrong,
      outlineVariant: borderSubtle,
      error: palette.danger,
      onError: _foregroundFor(palette.danger),
      errorContainer: palette.dangerSoft,
      onErrorContainer: textPrimary,
      scrim: Colors.black.withValues(alpha: isDark ? 0.72 : 0.56),
      surfaceTint: Colors.transparent,
    );

    final depth = AppThemeDepth(
      hairline: 1,
      outline: 1,
      outlineStrong: 1.4,
      shadowSoft: isDark
          ? Colors.black.withValues(alpha: 0.36)
          : Colors.black.withValues(alpha: 0.10),
      shadow: isDark
          ? Colors.black.withValues(alpha: 0.20)
          : Colors.black.withValues(alpha: 0.06),
      glow: palette.coverGlow,
      panelBlur: isDark ? 28 : 20,
      panelOffset: Offset(0, isDark ? 18 : 14),
      floatingBlur: isDark ? 36 : 28,
      floatingOffset: Offset(0, isDark ? 24 : 18),
      glowBlur: isDark ? 44 : 34,
      glowSpread: isDark ? 6 : 2,
    );

    return _AppThemeBundle(
      colorScheme: colorScheme,
      palette: palette,
      depth: depth,
    );
  }

  static TextTheme _buildTextTheme(
    TextTheme base,
    AppThemePalette palette,
  ) {
    TextStyle tune(
      TextStyle? style, {
      double? size,
      FontWeight? weight,
      double? height,
      double? letterSpacing,
      Color? color,
    }) {
      return (style ?? const TextStyle()).copyWith(
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color ?? palette.textPrimary,
      );
    }

    return base.copyWith(
      displayLarge: tune(
        base.displayLarge,
        size: 62,
        weight: FontWeight.w700,
        height: 0.94,
        letterSpacing: -1.8,
      ),
      displayMedium: tune(
        base.displayMedium,
        size: 48,
        weight: FontWeight.w700,
        height: 0.98,
        letterSpacing: -1.2,
      ),
      displaySmall: tune(
        base.displaySmall,
        size: 40,
        weight: FontWeight.w700,
        height: 1,
        letterSpacing: -0.9,
      ),
      headlineLarge: tune(
        base.headlineLarge,
        size: 34,
        weight: FontWeight.w700,
        height: 1.05,
        letterSpacing: -0.7,
      ),
      headlineMedium: tune(
        base.headlineMedium,
        size: 28,
        weight: FontWeight.w700,
        height: 1.08,
        letterSpacing: -0.5,
      ),
      headlineSmall: tune(
        base.headlineSmall,
        size: 24,
        weight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -0.3,
      ),
      titleLarge: tune(
        base.titleLarge,
        size: 21,
        weight: FontWeight.w700,
        height: 1.16,
        letterSpacing: -0.2,
      ),
      titleMedium: tune(
        base.titleMedium,
        size: 17,
        weight: FontWeight.w700,
        height: 1.18,
      ),
      titleSmall: tune(
        base.titleSmall,
        size: 15,
        weight: FontWeight.w600,
        height: 1.2,
      ),
      bodyLarge: tune(
        base.bodyLarge,
        size: 16,
        weight: FontWeight.w500,
        height: 1.42,
      ),
      bodyMedium: tune(
        base.bodyMedium,
        size: 14,
        weight: FontWeight.w500,
        height: 1.45,
      ),
      bodySmall: tune(
        base.bodySmall,
        size: 12,
        weight: FontWeight.w500,
        height: 1.45,
        color: palette.textSecondary,
      ),
      labelLarge: tune(
        base.labelLarge,
        size: 13,
        weight: FontWeight.w700,
        height: 1.15,
        letterSpacing: 0.2,
      ),
      labelMedium: tune(
        base.labelMedium,
        size: 12,
        weight: FontWeight.w700,
        height: 1.15,
        letterSpacing: 0.2,
        color: palette.textSecondary,
      ),
      labelSmall: tune(
        base.labelSmall,
        size: 11,
        weight: FontWeight.w700,
        height: 1.1,
        letterSpacing: 0.3,
        color: palette.textMuted,
      ),
    );
  }

  static OutlineInputBorder _inputBorder({
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: _radii.mediumRadius,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static Color _normalizeSeed(Color seedColor, Brightness brightness) {
    final hsl = HSLColor.fromColor(seedColor);
    final saturation =
        (hsl.saturation * (brightness == Brightness.dark ? 1.08 : 0.94))
            .clamp(0.38, 0.82)
            .toDouble();
    final lightness = brightness == Brightness.dark
        ? hsl.lightness.clamp(0.62, 0.74).toDouble()
        : hsl.lightness.clamp(0.42, 0.56).toDouble();

    return hsl.withSaturation(saturation).withLightness(lightness).toColor();
  }

  static Color _tintSurface(Color accent, Color base, double alpha) {
    return Color.alphaBlend(accent.withValues(alpha: alpha), base);
  }

  static Color _blend(Color a, Color b, double amount) {
    return Color.lerp(a, b, amount)!;
  }

  static Color _foregroundFor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
        ? Colors.white
        : const Color(0xFF11161C);
  }

  /// Width threshold for switching between mobile and desktop layouts.
  static const double desktopBreakpoint = 840.0;

  /// Width threshold for compact mobile layout.
  static const double compactBreakpoint = 600.0;
}

class _AppThemeBundle {
  const _AppThemeBundle({
    required this.colorScheme,
    required this.palette,
    required this.depth,
  });

  final ColorScheme colorScheme;
  final AppThemePalette palette;
  final AppThemeDepth depth;
}
