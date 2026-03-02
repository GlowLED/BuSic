import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/user_preferences.dart';

part 'settings_notifier.g.dart';

/// State notifier managing user preferences / settings.
///
/// Persists preferences to local storage and provides reactive
/// access for theme, locale, and other app-wide settings.
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  static const _keyThemeMode = 'theme_mode';
  static const _keyLocale = 'locale';
  static const _keyCachePath = 'cache_path';
  static const _keyAutoCache = 'auto_cache';
  static const _keyPreferredQuality = 'preferred_quality';

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
    final autoCache = prefs.getBool(_keyAutoCache) ?? false;
    final preferredQuality = prefs.getInt(_keyPreferredQuality) ?? 0;

    state = UserPreferences(
      themeMode: themeModeIndex != null
          ? ThemeMode.values[themeModeIndex.clamp(0, 2)]
          : ThemeMode.system,
      locale: locale,
      cachePath: cachePath,
      autoCache: autoCache,
      preferredQuality: preferredQuality,
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

  /// Toggle automatic caching on/off.
  Future<void> setAutoCache(bool enabled) async {
    state = state.copyWith(autoCache: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoCache, enabled);
  }

  /// Set the preferred audio quality.
  Future<void> setPreferredQuality(int quality) async {
    state = state.copyWith(preferredQuality: quality);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPreferredQuality, quality);
  }

  /// Reset all settings to defaults.
  Future<void> resetToDefaults() async {
    state = const UserPreferences();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyThemeMode);
    await prefs.remove(_keyLocale);
    await prefs.remove(_keyCachePath);
    await prefs.remove(_keyAutoCache);
    await prefs.remove(_keyPreferredQuality);
  }
}
