import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/models/user_preferences.dart';

part 'settings_notifier.g.dart';

/// State notifier managing user preferences / settings.
///
/// Persists preferences to local storage and provides reactive
/// access for theme, locale, and other app-wide settings.
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  UserPreferences build() {
    // TODO: load persisted preferences from shared_preferences / DB
    return const UserPreferences();
  }

  /// Update the theme mode (system, light, dark).
  Future<void> setThemeMode(ThemeMode mode) async {
    // TODO: persist and update state
    throw UnimplementedError();
  }

  /// Update the app locale.
  ///
  /// Pass `null` to follow system locale.
  Future<void> setLocale(String? locale) async {
    // TODO: persist and update state
    throw UnimplementedError();
  }

  /// Update the cache directory path.
  Future<void> setCachePath(String? path) async {
    // TODO: persist and update state
    throw UnimplementedError();
  }

  /// Toggle automatic caching on/off.
  Future<void> setAutoCache(bool enabled) async {
    // TODO: persist and update state
    throw UnimplementedError();
  }

  /// Set the preferred audio quality.
  Future<void> setPreferredQuality(int quality) async {
    // TODO: persist and update state
    throw UnimplementedError();
  }

  /// Reset all settings to defaults.
  Future<void> resetToDefaults() async {
    // TODO: clear persisted preferences, reset state
    throw UnimplementedError();
  }
}
