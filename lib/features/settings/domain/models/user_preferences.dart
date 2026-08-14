import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

/// User preferences / settings model.
///
/// Persisted locally (could use shared_preferences or a dedicated DB table).
@freezed
abstract class UserPreferences with _$UserPreferences {
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

    /// Desktop interface scale. Mobile platforms always render at 100%.
    @Default(1.0) double uiScale,

    /// Whether playback boundaries use volume fade transitions.
    @Default(true) bool playbackFadeEnabled,

    /// Duration of a single fade-in or fade-out transition.
    @Default(1000) int playbackFadeDurationMs,

    /// Path to the app-wide background image (null = no background).
    String? backgroundImagePath,

    /// Opacity of the background image, 0.0 to 1.0.
    @Default(0.5) double backgroundImageOpacity,

    /// Gaussian blur sigma of the background image, 0 to 60.
    @Default(0) double backgroundImageBlur,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
