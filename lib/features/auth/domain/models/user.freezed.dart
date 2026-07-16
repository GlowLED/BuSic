// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

/// Bilibili user ID (DedeUserID).
 String get userId;/// Display nickname.
 String get nickname;/// Avatar image URL.
 String? get avatarUrl;/// SESSDATA cookie value for authenticated requests.
 String get sessdata;/// bili_jct CSRF token cookie value.
 String get biliJct;/// Whether the user session is valid / not expired.
 bool get isLoggedIn;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.sessdata, sessdata) || other.sessdata == sessdata)&&(identical(other.biliJct, biliJct) || other.biliJct == biliJct)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,nickname,avatarUrl,sessdata,biliJct,isLoggedIn);

@override
String toString() {
  return 'User(userId: $userId, nickname: $nickname, avatarUrl: $avatarUrl, sessdata: $sessdata, biliJct: $biliJct, isLoggedIn: $isLoggedIn)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String userId, String nickname, String? avatarUrl, String sessdata, String biliJct, bool isLoggedIn
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? nickname = null,Object? avatarUrl = freezed,Object? sessdata = null,Object? biliJct = null,Object? isLoggedIn = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,sessdata: null == sessdata ? _self.sessdata : sessdata // ignore: cast_nullable_to_non_nullable
as String,biliJct: null == biliJct ? _self.biliJct : biliJct // ignore: cast_nullable_to_non_nullable
as String,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String nickname,  String? avatarUrl,  String sessdata,  String biliJct,  bool isLoggedIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.userId,_that.nickname,_that.avatarUrl,_that.sessdata,_that.biliJct,_that.isLoggedIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String nickname,  String? avatarUrl,  String sessdata,  String biliJct,  bool isLoggedIn)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.userId,_that.nickname,_that.avatarUrl,_that.sessdata,_that.biliJct,_that.isLoggedIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String nickname,  String? avatarUrl,  String sessdata,  String biliJct,  bool isLoggedIn)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.userId,_that.nickname,_that.avatarUrl,_that.sessdata,_that.biliJct,_that.isLoggedIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.userId, required this.nickname, this.avatarUrl, required this.sessdata, required this.biliJct, this.isLoggedIn = false});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

/// Bilibili user ID (DedeUserID).
@override final  String userId;
/// Display nickname.
@override final  String nickname;
/// Avatar image URL.
@override final  String? avatarUrl;
/// SESSDATA cookie value for authenticated requests.
@override final  String sessdata;
/// bili_jct CSRF token cookie value.
@override final  String biliJct;
/// Whether the user session is valid / not expired.
@override@JsonKey() final  bool isLoggedIn;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.sessdata, sessdata) || other.sessdata == sessdata)&&(identical(other.biliJct, biliJct) || other.biliJct == biliJct)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,nickname,avatarUrl,sessdata,biliJct,isLoggedIn);

@override
String toString() {
  return 'User(userId: $userId, nickname: $nickname, avatarUrl: $avatarUrl, sessdata: $sessdata, biliJct: $biliJct, isLoggedIn: $isLoggedIn)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String userId, String nickname, String? avatarUrl, String sessdata, String biliJct, bool isLoggedIn
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? nickname = null,Object? avatarUrl = freezed,Object? sessdata = null,Object? biliJct = null,Object? isLoggedIn = null,}) {
  return _then(_User(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,sessdata: null == sessdata ? _self.sessdata : sessdata // ignore: cast_nullable_to_non_nullable
as String,biliJct: null == biliJct ? _self.biliJct : biliJct // ignore: cast_nullable_to_non_nullable
as String,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
