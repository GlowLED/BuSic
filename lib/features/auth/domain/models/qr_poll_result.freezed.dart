// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_poll_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QrPollResult {

/// Status code:
/// - 0: success
/// - 86038: QR code expired
/// - 86090: scanned, waiting for confirmation
/// - 86101: not yet scanned
 int get code;/// Human-readable status message.
 String get message;/// Redirect URL on success (contains cookie params).
 String? get url;
/// Create a copy of QrPollResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrPollResultCopyWith<QrPollResult> get copyWith => _$QrPollResultCopyWithImpl<QrPollResult>(this as QrPollResult, _$identity);

  /// Serializes this QrPollResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrPollResult&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,url);

@override
String toString() {
  return 'QrPollResult(code: $code, message: $message, url: $url)';
}


}

/// @nodoc
abstract mixin class $QrPollResultCopyWith<$Res>  {
  factory $QrPollResultCopyWith(QrPollResult value, $Res Function(QrPollResult) _then) = _$QrPollResultCopyWithImpl;
@useResult
$Res call({
 int code, String message, String? url
});




}
/// @nodoc
class _$QrPollResultCopyWithImpl<$Res>
    implements $QrPollResultCopyWith<$Res> {
  _$QrPollResultCopyWithImpl(this._self, this._then);

  final QrPollResult _self;
  final $Res Function(QrPollResult) _then;

/// Create a copy of QrPollResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? url = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QrPollResult].
extension QrPollResultPatterns on QrPollResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrPollResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrPollResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrPollResult value)  $default,){
final _that = this;
switch (_that) {
case _QrPollResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrPollResult value)?  $default,){
final _that = this;
switch (_that) {
case _QrPollResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  String message,  String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrPollResult() when $default != null:
return $default(_that.code,_that.message,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  String message,  String? url)  $default,) {final _that = this;
switch (_that) {
case _QrPollResult():
return $default(_that.code,_that.message,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  String message,  String? url)?  $default,) {final _that = this;
switch (_that) {
case _QrPollResult() when $default != null:
return $default(_that.code,_that.message,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QrPollResult implements QrPollResult {
  const _QrPollResult({required this.code, required this.message, this.url});
  factory _QrPollResult.fromJson(Map<String, dynamic> json) => _$QrPollResultFromJson(json);

/// Status code:
/// - 0: success
/// - 86038: QR code expired
/// - 86090: scanned, waiting for confirmation
/// - 86101: not yet scanned
@override final  int code;
/// Human-readable status message.
@override final  String message;
/// Redirect URL on success (contains cookie params).
@override final  String? url;

/// Create a copy of QrPollResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrPollResultCopyWith<_QrPollResult> get copyWith => __$QrPollResultCopyWithImpl<_QrPollResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QrPollResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrPollResult&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,url);

@override
String toString() {
  return 'QrPollResult(code: $code, message: $message, url: $url)';
}


}

/// @nodoc
abstract mixin class _$QrPollResultCopyWith<$Res> implements $QrPollResultCopyWith<$Res> {
  factory _$QrPollResultCopyWith(_QrPollResult value, $Res Function(_QrPollResult) _then) = __$QrPollResultCopyWithImpl;
@override @useResult
$Res call({
 int code, String message, String? url
});




}
/// @nodoc
class __$QrPollResultCopyWithImpl<$Res>
    implements _$QrPollResultCopyWith<$Res> {
  __$QrPollResultCopyWithImpl(this._self, this._then);

  final _QrPollResult _self;
  final $Res Function(_QrPollResult) _then;

/// Create a copy of QrPollResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? url = freezed,}) {
  return _then(_QrPollResult(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
