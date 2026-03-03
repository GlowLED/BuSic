// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  /// Theme mode: system, light, or dark.
  ThemeMode get themeMode => throw _privateConstructorUsedError;

  /// App locale: 'en', 'zh', or null for system default.
  String? get locale => throw _privateConstructorUsedError;

  /// Custom cache directory path (null = default platform path).
  String? get cachePath => throw _privateConstructorUsedError;

  /// Preferred audio quality identifier.
  /// 0 = auto (best available), or specific quality code.
  int get preferredQuality => throw _privateConstructorUsedError;

  /// Theme seed color value.
  int get themeSeedColor => throw _privateConstructorUsedError;

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
          UserPreferences value, $Res Function(UserPreferences) then) =
      _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call(
      {ThemeMode themeMode,
      String? locale,
      String? cachePath,
      int preferredQuality,
      int themeSeedColor});
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? locale = freezed,
    Object? cachePath = freezed,
    Object? preferredQuality = null,
    Object? themeSeedColor = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
      cachePath: freezed == cachePath
          ? _value.cachePath
          : cachePath // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredQuality: null == preferredQuality
          ? _value.preferredQuality
          : preferredQuality // ignore: cast_nullable_to_non_nullable
              as int,
      themeSeedColor: null == themeSeedColor
          ? _value.themeSeedColor
          : themeSeedColor // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(_$UserPreferencesImpl value,
          $Res Function(_$UserPreferencesImpl) then) =
      __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ThemeMode themeMode,
      String? locale,
      String? cachePath,
      int preferredQuality,
      int themeSeedColor});
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
      _$UserPreferencesImpl _value, $Res Function(_$UserPreferencesImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? locale = freezed,
    Object? cachePath = freezed,
    Object? preferredQuality = null,
    Object? themeSeedColor = null,
  }) {
    return _then(_$UserPreferencesImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
      cachePath: freezed == cachePath
          ? _value.cachePath
          : cachePath // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredQuality: null == preferredQuality
          ? _value.preferredQuality
          : preferredQuality // ignore: cast_nullable_to_non_nullable
              as int,
      themeSeedColor: null == themeSeedColor
          ? _value.themeSeedColor
          : themeSeedColor // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl implements _UserPreferences {
  const _$UserPreferencesImpl(
      {this.themeMode = ThemeMode.system,
      this.locale,
      this.cachePath,
      this.preferredQuality = 0,
      this.themeSeedColor = 0xFF4CAF50});

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  /// Theme mode: system, light, or dark.
  @override
  @JsonKey()
  final ThemeMode themeMode;

  /// App locale: 'en', 'zh', or null for system default.
  @override
  final String? locale;

  /// Custom cache directory path (null = default platform path).
  @override
  final String? cachePath;

  /// Preferred audio quality identifier.
  /// 0 = auto (best available), or specific quality code.
  @override
  @JsonKey()
  final int preferredQuality;

  /// Theme seed color value.
  @override
  @JsonKey()
  final int themeSeedColor;

  @override
  String toString() {
    return 'UserPreferences(themeMode: $themeMode, locale: $locale, cachePath: $cachePath, preferredQuality: $preferredQuality, themeSeedColor: $themeSeedColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.cachePath, cachePath) ||
                other.cachePath == cachePath) &&
            (identical(other.preferredQuality, preferredQuality) ||
                other.preferredQuality == preferredQuality) &&
            (identical(other.themeSeedColor, themeSeedColor) ||
                other.themeSeedColor == themeSeedColor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, themeMode, locale, cachePath,
      preferredQuality, themeSeedColor);

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(
      this,
    );
  }
}

abstract class _UserPreferences implements UserPreferences {
  const factory _UserPreferences(
      {final ThemeMode themeMode,
      final String? locale,
      final String? cachePath,
      final int preferredQuality,
      final int themeSeedColor}) = _$UserPreferencesImpl;

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  /// Theme mode: system, light, or dark.
  @override
  ThemeMode get themeMode;

  /// App locale: 'en', 'zh', or null for system default.
  @override
  String? get locale;

  /// Custom cache directory path (null = default platform path).
  @override
  String? get cachePath;

  /// Preferred audio quality identifier.
  /// 0 = auto (best available), or specific quality code.
  @override
  int get preferredQuality;

  /// Theme seed color value.
  @override
  int get themeSeedColor;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
