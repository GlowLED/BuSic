// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserPreferences {

/// Theme mode: system, light, or dark.
 ThemeMode get themeMode;/// App locale: 'en', 'zh', or null for system default.
 String? get locale;/// Custom cache directory path (null = default platform path).
 String? get cachePath;/// Preferred audio quality identifier.
/// 0 = auto (best available), or specific quality code.
 int get preferredQuality;/// Theme seed color value.
 int get themeSeedColor;
/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<UserPreferences> get copyWith => _$UserPreferencesCopyWithImpl<UserPreferences>(this as UserPreferences, _$identity);

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPreferences&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.cachePath, cachePath) || other.cachePath == cachePath)&&(identical(other.preferredQuality, preferredQuality) || other.preferredQuality == preferredQuality)&&(identical(other.themeSeedColor, themeSeedColor) || other.themeSeedColor == themeSeedColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,locale,cachePath,preferredQuality,themeSeedColor);

@override
String toString() {
  return 'UserPreferences(themeMode: $themeMode, locale: $locale, cachePath: $cachePath, preferredQuality: $preferredQuality, themeSeedColor: $themeSeedColor)';
}


}

/// @nodoc
abstract mixin class $UserPreferencesCopyWith<$Res>  {
  factory $UserPreferencesCopyWith(UserPreferences value, $Res Function(UserPreferences) _then) = _$UserPreferencesCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode, String? locale, String? cachePath, int preferredQuality, int themeSeedColor
});




}
/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._self, this._then);

  final UserPreferences _self;
  final $Res Function(UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? locale = freezed,Object? cachePath = freezed,Object? preferredQuality = null,Object? themeSeedColor = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,cachePath: freezed == cachePath ? _self.cachePath : cachePath // ignore: cast_nullable_to_non_nullable
as String?,preferredQuality: null == preferredQuality ? _self.preferredQuality : preferredQuality // ignore: cast_nullable_to_non_nullable
as int,themeSeedColor: null == themeSeedColor ? _self.themeSeedColor : themeSeedColor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPreferences].
extension UserPreferencesPatterns on UserPreferences {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPreferences value)  $default,){
final _that = this;
switch (_that) {
case _UserPreferences():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeMode themeMode,  String? locale,  String? cachePath,  int preferredQuality,  int themeSeedColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.themeMode,_that.locale,_that.cachePath,_that.preferredQuality,_that.themeSeedColor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeMode themeMode,  String? locale,  String? cachePath,  int preferredQuality,  int themeSeedColor)  $default,) {final _that = this;
switch (_that) {
case _UserPreferences():
return $default(_that.themeMode,_that.locale,_that.cachePath,_that.preferredQuality,_that.themeSeedColor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeMode themeMode,  String? locale,  String? cachePath,  int preferredQuality,  int themeSeedColor)?  $default,) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.themeMode,_that.locale,_that.cachePath,_that.preferredQuality,_that.themeSeedColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserPreferences implements UserPreferences {
  const _UserPreferences({this.themeMode = ThemeMode.system, this.locale, this.cachePath, this.preferredQuality = 0, this.themeSeedColor = 0xFF4CAF50});
  factory _UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);

/// Theme mode: system, light, or dark.
@override@JsonKey() final  ThemeMode themeMode;
/// App locale: 'en', 'zh', or null for system default.
@override final  String? locale;
/// Custom cache directory path (null = default platform path).
@override final  String? cachePath;
/// Preferred audio quality identifier.
/// 0 = auto (best available), or specific quality code.
@override@JsonKey() final  int preferredQuality;
/// Theme seed color value.
@override@JsonKey() final  int themeSeedColor;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPreferencesCopyWith<_UserPreferences> get copyWith => __$UserPreferencesCopyWithImpl<_UserPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPreferences&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.cachePath, cachePath) || other.cachePath == cachePath)&&(identical(other.preferredQuality, preferredQuality) || other.preferredQuality == preferredQuality)&&(identical(other.themeSeedColor, themeSeedColor) || other.themeSeedColor == themeSeedColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,locale,cachePath,preferredQuality,themeSeedColor);

@override
String toString() {
  return 'UserPreferences(themeMode: $themeMode, locale: $locale, cachePath: $cachePath, preferredQuality: $preferredQuality, themeSeedColor: $themeSeedColor)';
}


}

/// @nodoc
abstract mixin class _$UserPreferencesCopyWith<$Res> implements $UserPreferencesCopyWith<$Res> {
  factory _$UserPreferencesCopyWith(_UserPreferences value, $Res Function(_UserPreferences) _then) = __$UserPreferencesCopyWithImpl;
@override @useResult
$Res call({
 ThemeMode themeMode, String? locale, String? cachePath, int preferredQuality, int themeSeedColor
});




}
/// @nodoc
class __$UserPreferencesCopyWithImpl<$Res>
    implements _$UserPreferencesCopyWith<$Res> {
  __$UserPreferencesCopyWithImpl(this._self, this._then);

  final _UserPreferences _self;
  final $Res Function(_UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? locale = freezed,Object? cachePath = freezed,Object? preferredQuality = null,Object? themeSeedColor = null,}) {
  return _then(_UserPreferences(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,cachePath: freezed == cachePath ? _self.cachePath : cachePath // ignore: cast_nullable_to_non_nullable
as String?,preferredQuality: null == preferredQuality ? _self.preferredQuality : preferredQuality // ignore: cast_nullable_to_non_nullable
as int,themeSeedColor: null == themeSeedColor ? _self.themeSeedColor : themeSeedColor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
