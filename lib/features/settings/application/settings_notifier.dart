import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/user_preferences.dart';

part 'settings_notifier.g.dart';

/// State notifier managing user preferences / settings.
///
/// Persists preferences to local storage and provides reactive
/// access for theme, locale, and other app-wide settings.
@Riverpod(name: 'settingsNotifierProvider')
class SettingsNotifier extends _$SettingsNotifier {
  static const supportedPlaybackFadeDurations = [500, 1000, 2000];
  static const supportedUiScales = [0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5];
  static const defaultUiScale = 1.0;

  static const _keyThemeMode = 'theme_mode';
  static const _keyLocale = 'locale';
  static const _keyCachePath = 'cache_path';
  static const _keyPreferredQuality = 'preferred_quality';
  static const _keyThemeSeedColor = 'theme_seed_color';
  static const _keyUiScale = 'ui_scale';
  static const _keyPlaybackFadeEnabled = 'playback_fade_enabled';
  static const _keyPlaybackFadeDurationMs = 'playback_fade_duration_ms';
  static const _keyBackgroundImagePath = 'background_image_path';
  static const _keyBackgroundImageOpacity = 'background_image_opacity';
  static const _keyBackgroundImageBlur = 'background_image_blur';
  static const _keyMinimalPlaylistId = 'minimal_playlist_id';

  @override
  UserPreferences build() {
    _loadPreferences();
    return const UserPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final themeModeIndex = prefs.getInt(_keyThemeMode);
    final locale = prefs.getString(_keyLocale);
    final cachePath = prefs.getString(_keyCachePath);
    final preferredQuality = prefs.getInt(_keyPreferredQuality) ?? 0;
    final themeSeedColor = prefs.getInt(_keyThemeSeedColor) ?? 0xFF4CAF50;
    final uiScale = normalizeUiScale(prefs.getDouble(_keyUiScale));
    final playbackFadeEnabled = prefs.getBool(_keyPlaybackFadeEnabled) ?? true;
    final storedPlaybackFadeDurationMs =
        prefs.getInt(_keyPlaybackFadeDurationMs) ?? 1000;
    final playbackFadeDurationMs =
        supportedPlaybackFadeDurations.contains(storedPlaybackFadeDurationMs)
        ? storedPlaybackFadeDurationMs
        : 1000;
    final backgroundImagePath = prefs.getString(_keyBackgroundImagePath);
    final storedOpacity = prefs.getDouble(_keyBackgroundImageOpacity);
    final storedBlur = prefs.getDouble(_keyBackgroundImageBlur);

    state = UserPreferences(
      themeMode: themeModeIndex != null
          ? ThemeMode.values[themeModeIndex.clamp(0, 2)]
          : ThemeMode.system,
      locale: locale,
      cachePath: cachePath,
      preferredQuality: preferredQuality,
      themeSeedColor: themeSeedColor,
      uiScale: uiScale,
      playbackFadeEnabled: playbackFadeEnabled,
      playbackFadeDurationMs: playbackFadeDurationMs,
      backgroundImagePath: backgroundImagePath,
      backgroundImageOpacity: (storedOpacity ?? 0.5).clamp(0.0, 1.0).toDouble(),
      backgroundImageBlur: (storedBlur ?? 0).clamp(0.0, 60.0).toDouble(),
    );
  }

  /// Update the theme mode (system, light, dark).
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
  }

  /// Update the app locale.
  Future<void> setLocale(String? locale) async {
    state = state.copyWith(locale: locale);
    final prefs = await SharedPreferences.getInstance();
    if (locale != null) {
      await prefs.setString(_keyLocale, locale);
    } else {
      await prefs.remove(_keyLocale);
    }
  }

  /// Update the cache directory path.
  Future<void> setCachePath(String? path) async {
    state = state.copyWith(cachePath: path);
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString(_keyCachePath, path);
    } else {
      await prefs.remove(_keyCachePath);
    }
  }

  /// Set the preferred audio quality.
  Future<void> setPreferredQuality(int quality) async {
    state = state.copyWith(preferredQuality: quality);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPreferredQuality, quality);
  }

  /// Set the seed color used for the app color scheme.
  Future<void> setThemeSeedColor(int colorValue) async {
    state = state.copyWith(themeSeedColor: colorValue);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeSeedColor, colorValue);
  }

  /// Normalize a stored or requested desktop interface scale.
  static double normalizeUiScale(double? scale) {
    if (scale == null || !scale.isFinite) return defaultUiScale;
    if (scale < supportedUiScales.first || scale > supportedUiScales.last) {
      return defaultUiScale;
    }

    var closest = supportedUiScales.first;
    var closestDistance = (scale - closest).abs();
    for (final candidate in supportedUiScales.skip(1)) {
      final distance = (scale - candidate).abs();
      if (distance < closestDistance) {
        closest = candidate;
        closestDistance = distance;
      }
    }
    return closest;
  }

  /// Set the desktop interface scale and persist it locally.
  Future<void> setUiScale(double scale) async {
    final normalized = normalizeUiScale(scale);
    state = state.copyWith(uiScale: normalized);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyUiScale, normalized);
  }

  /// Increase the desktop interface scale by one supported step.
  Future<void> increaseUiScale() {
    final currentIndex = supportedUiScales.indexOf(
      normalizeUiScale(state.uiScale),
    );
    final nextIndex = (currentIndex + 1).clamp(0, supportedUiScales.length - 1);
    return setUiScale(supportedUiScales[nextIndex]);
  }

  /// Decrease the desktop interface scale by one supported step.
  Future<void> decreaseUiScale() {
    final currentIndex = supportedUiScales.indexOf(
      normalizeUiScale(state.uiScale),
    );
    final nextIndex = (currentIndex - 1).clamp(0, supportedUiScales.length - 1);
    return setUiScale(supportedUiScales[nextIndex]);
  }

  /// Reset only the desktop interface scale to 100%.
  Future<void> resetUiScale() => setUiScale(defaultUiScale);

  /// Enable or disable playback fade transitions.
  Future<void> setPlaybackFadeEnabled(bool enabled) async {
    state = state.copyWith(playbackFadeEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPlaybackFadeEnabled, enabled);
  }

  /// Set the duration of a single playback fade transition.
  Future<void> setPlaybackFadeDurationMs(int durationMs) async {
    final normalized = supportedPlaybackFadeDurations.contains(durationMs)
        ? durationMs
        : 1000;
    state = state.copyWith(playbackFadeDurationMs: normalized);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPlaybackFadeDurationMs, normalized);
  }

  /// Update the app-wide background image path (null = no background).
  Future<void> setBackgroundImagePath(String? path) async {
    state = state.copyWith(backgroundImagePath: path);
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString(_keyBackgroundImagePath, path);
    } else {
      await prefs.remove(_keyBackgroundImagePath);
    }
  }

  /// Set the opacity of the background image (0.0 to 1.0).
  Future<void> setBackgroundImageOpacity(double opacity) async {
    final normalized = opacity.clamp(0.0, 1.0).toDouble();
    state = state.copyWith(backgroundImageOpacity: normalized);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyBackgroundImageOpacity, normalized);
  }

  /// Set the Gaussian blur sigma of the background image (0 to 60).
  Future<void> setBackgroundImageBlur(double blur) async {
    final normalized = blur.clamp(0.0, 60.0).toDouble();
    state = state.copyWith(backgroundImageBlur: normalized);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyBackgroundImageBlur, normalized);
  }

  /// Reset all settings to defaults.
  Future<void> resetToDefaults() async {
    state = const UserPreferences();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyThemeMode);
    await prefs.remove(_keyLocale);
    await prefs.remove(_keyCachePath);
    await prefs.remove(_keyPreferredQuality);
    await prefs.remove(_keyThemeSeedColor);
    await prefs.remove(_keyUiScale);
    await prefs.remove(_keyPlaybackFadeEnabled);
    await prefs.remove(_keyPlaybackFadeDurationMs);
    await prefs.remove(_keyBackgroundImagePath);
    await prefs.remove(_keyBackgroundImageOpacity);
    await prefs.remove(_keyBackgroundImageBlur);

    // Cleanup startup recommendation keys left by older builds.
    await prefs.remove('is_minimal_mode');
    await prefs.remove('minimal_playlist_id');
  }

  /// Read the playlist id used by the minimal screen, if one still exists.
  Future<int?> getMinimalPlaylistId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMinimalPlaylistId);
  }
}
