// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    _UserPreferences(
      themeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      locale: json['locale'] as String?,
      cachePath: json['cachePath'] as String?,
      preferredQuality: (json['preferredQuality'] as num?)?.toInt() ?? 0,
      themeSeedColor: (json['themeSeedColor'] as num?)?.toInt() ?? 0xFF4CAF50,
    );

Map<String, dynamic> _$UserPreferencesToJson(_UserPreferences instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'locale': instance.locale,
      'cachePath': instance.cachePath,
      'preferredQuality': instance.preferredQuality,
      'themeSeedColor': instance.themeSeedColor,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
