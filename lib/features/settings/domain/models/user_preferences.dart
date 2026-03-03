import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

/// User preferences / settings model.
///
/// Persisted locally (could use shared_preferences or a dedicated DB table).
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    /// Theme mode: system, light, or dark.
    @Default(ThemeMode.system) ThemeMode themeMode,

    /// App locale: 'en', 'zh', or null for system default.
    String? locale,

    /// Custom cache directory path (null = default platform path).
    String? cachePath,

    /// Preferred audio quality identifier.
    /// 0 = auto (best available), or specific quality code.
    @Default(0) int preferredQuality,

    /// Theme seed color value.
    @Default(0xFF4CAF50) int themeSeedColor,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
