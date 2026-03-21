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
  static const _keyPreferredQuality = 'preferred_quality';
  static const _keyThemeSeedColor = 'theme_seed_color';
  static const _keyMinimalMode = 'is_minimal_mode';
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

    state = UserPreferences(
      themeMode: themeModeIndex != null
          ? ThemeMode.values[themeModeIndex.clamp(0, 2)]
          : ThemeMode.system,
      locale: locale,
      cachePath: cachePath,
      preferredQuality: preferredQuality,
      themeSeedColor: themeSeedColor,
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

  /// Reset all settings to defaults.
  Future<void> resetToDefaults() async {
    state = const UserPreferences();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyThemeMode);
    await prefs.remove(_keyLocale);
    await prefs.remove(_keyCachePath);
    await prefs.remove(_keyPreferredQuality);
    await prefs.remove(_keyThemeSeedColor);
    await prefs.remove(_keyMinimalMode);
    await prefs.remove(_keyMinimalPlaylistId);
  }

  // ── 极简模式设置（不修改 UserPreferences 模型，直接读写 SharedPreferences） ──

  /// 读取极简模式开关状态（默认 false）。
  Future<bool> getMinimalMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyMinimalMode) ?? false;
  }

  /// 设置极简模式开关。
  Future<void> setMinimalMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMinimalMode, enabled);
  }

  /// 读取极简模式指定的本地歌单 ID。
  Future<int?> getMinimalPlaylistId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMinimalPlaylistId);
  }

  /// 设置极简模式指定的本地歌单 ID。
  Future<void> setMinimalPlaylistId(int? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id != null) {
      await prefs.setInt(_keyMinimalPlaylistId, id);
    } else {
      await prefs.remove(_keyMinimalPlaylistId);
    }
  }
}
