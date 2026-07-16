// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_rights.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoRights {

/// Whether reposting is forbidden without creator authorization.
 bool get noReprint;
/// Create a copy of VideoRights
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoRightsCopyWith<VideoRights> get copyWith => _$VideoRightsCopyWithImpl<VideoRights>(this as VideoRights, _$identity);

  /// Serializes this VideoRights to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoRights&&(identical(other.noReprint, noReprint) || other.noReprint == noReprint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,noReprint);

@override
String toString() {
  return 'VideoRights(noReprint: $noReprint)';
}


}

/// @nodoc
abstract mixin class $VideoRightsCopyWith<$Res>  {
  factory $VideoRightsCopyWith(VideoRights value, $Res Function(VideoRights) _then) = _$VideoRightsCopyWithImpl;
@useResult
$Res call({
 bool noReprint
});




}
/// @nodoc
class _$VideoRightsCopyWithImpl<$Res>
    implements $VideoRightsCopyWith<$Res> {
  _$VideoRightsCopyWithImpl(this._self, this._then);

  final VideoRights _self;
  final $Res Function(VideoRights) _then;

/// Create a copy of VideoRights
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noReprint = null,}) {
  return _then(_self.copyWith(
noReprint: null == noReprint ? _self.noReprint : noReprint // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoRights].
extension VideoRightsPatterns on VideoRights {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoRights value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoRights() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoRights value)  $default,){
final _that = this;
switch (_that) {
case _VideoRights():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoRights value)?  $default,){
final _that = this;
switch (_that) {
case _VideoRights() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool noReprint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoRights() when $default != null:
return $default(_that.noReprint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool noReprint)  $default,) {final _that = this;
switch (_that) {
case _VideoRights():
return $default(_that.noReprint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool noReprint)?  $default,) {final _that = this;
switch (_that) {
case _VideoRights() when $default != null:
return $default(_that.noReprint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoRights implements VideoRights {
  const _VideoRights({this.noReprint = false});
  factory _VideoRights.fromJson(Map<String, dynamic> json) => _$VideoRightsFromJson(json);

/// Whether reposting is forbidden without creator authorization.
@override@JsonKey() final  bool noReprint;

/// Create a copy of VideoRights
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoRightsCopyWith<_VideoRights> get copyWith => __$VideoRightsCopyWithImpl<_VideoRights>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoRightsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoRights&&(identical(other.noReprint, noReprint) || other.noReprint == noReprint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,noReprint);

@override
String toString() {
  return 'VideoRights(noReprint: $noReprint)';
}


}

/// @nodoc
abstract mixin class _$VideoRightsCopyWith<$Res> implements $VideoRightsCopyWith<$Res> {
  factory _$VideoRightsCopyWith(_VideoRights value, $Res Function(_VideoRights) _then) = __$VideoRightsCopyWithImpl;
@override @useResult
$Res call({
 bool noReprint
});




}
/// @nodoc
class __$VideoRightsCopyWithImpl<$Res>
    implements _$VideoRightsCopyWith<$Res> {
  __$VideoRightsCopyWithImpl(this._self, this._then);

  final _VideoRights _self;
  final $Res Function(_VideoRights) _then;

/// Create a copy of VideoRights
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noReprint = null,}) {
  return _then(_VideoRights(
noReprint: null == noReprint ? _self.noReprint : noReprint // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
