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

  /// Whether to automatically cache audio when playing.
  bool get autoCache => throw _privateConstructorUsedError;

  /// Preferred audio quality identifier.
  /// 0 = auto (best available), or specific quality code.
  int get preferredQuality => throw _privateConstructorUsedError;

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
      bool autoCache,
      int preferredQuality});
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
    Object? autoCache = null,
    Object? preferredQuality = null,
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
      autoCache: null == autoCache
          ? _value.autoCache
          : autoCache // ignore: cast_nullable_to_non_nullable
              as bool,
      preferredQuality: null == preferredQuality
          ? _value.preferredQuality
          : preferredQuality // ignore: cast_nullable_to_non_nullable
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
      bool autoCache,
      int preferredQuality});
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
    Object? autoCache = null,
    Object? preferredQuality = null,
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
      autoCache: null == autoCache
          ? _value.autoCache
          : autoCache // ignore: cast_nullable_to_non_nullable
              as bool,
      preferredQuality: null == preferredQuality
          ? _value.preferredQuality
          : preferredQuality // ignore: cast_nullable_to_non_nullable
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
      this.autoCache = false,
      this.preferredQuality = 0});

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

  /// Whether to automatically cache audio when playing.
  @override
  @JsonKey()
  final bool autoCache;

  /// Preferred audio quality identifier.
  /// 0 = auto (best available), or specific quality code.
  @override
  @JsonKey()
  final int preferredQuality;

  @override
  String toString() {
    return 'UserPreferences(themeMode: $themeMode, locale: $locale, cachePath: $cachePath, autoCache: $autoCache, preferredQuality: $preferredQuality)';
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
            (identical(other.autoCache, autoCache) ||
                other.autoCache == autoCache) &&
            (identical(other.preferredQuality, preferredQuality) ||
                other.preferredQuality == preferredQuality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, themeMode, locale, cachePath, autoCache, preferredQuality);

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
      final bool autoCache,
      final int preferredQuality}) = _$UserPreferencesImpl;

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

  /// Whether to automatically cache audio when playing.
  @override
  bool get autoCache;

  /// Preferred audio quality identifier.
  /// 0 = auto (best available), or specific quality code.
  @override
  int get preferredQuality;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
