// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  /// Bilibili user ID (DedeUserID).
  String get userId => throw _privateConstructorUsedError;

  /// Display nickname.
  String get nickname => throw _privateConstructorUsedError;

  /// Avatar image URL.
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// SESSDATA cookie value for authenticated requests.
  String get sessdata => throw _privateConstructorUsedError;

  /// bili_jct CSRF token cookie value.
  String get biliJct => throw _privateConstructorUsedError;

  /// Whether the user session is valid / not expired.
  bool get isLoggedIn => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String userId,
      String nickname,
      String? avatarUrl,
      String sessdata,
      String biliJct,
      bool isLoggedIn});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? avatarUrl = freezed,
    Object? sessdata = null,
    Object? biliJct = null,
    Object? isLoggedIn = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sessdata: null == sessdata
          ? _value.sessdata
          : sessdata // ignore: cast_nullable_to_non_nullable
              as String,
      biliJct: null == biliJct
          ? _value.biliJct
          : biliJct // ignore: cast_nullable_to_non_nullable
              as String,
      isLoggedIn: null == isLoggedIn
          ? _value.isLoggedIn
          : isLoggedIn // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String nickname,
      String? avatarUrl,
      String sessdata,
      String biliJct,
      bool isLoggedIn});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? avatarUrl = freezed,
    Object? sessdata = null,
    Object? biliJct = null,
    Object? isLoggedIn = null,
  }) {
    return _then(_$UserImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sessdata: null == sessdata
          ? _value.sessdata
          : sessdata // ignore: cast_nullable_to_non_nullable
              as String,
      biliJct: null == biliJct
          ? _value.biliJct
          : biliJct // ignore: cast_nullable_to_non_nullable
              as String,
      isLoggedIn: null == isLoggedIn
          ? _value.isLoggedIn
          : isLoggedIn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.userId,
      required this.nickname,
      this.avatarUrl,
      required this.sessdata,
      required this.biliJct,
      this.isLoggedIn = false});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  /// Bilibili user ID (DedeUserID).
  @override
  final String userId;

  /// Display nickname.
  @override
  final String nickname;

  /// Avatar image URL.
  @override
  final String? avatarUrl;

  /// SESSDATA cookie value for authenticated requests.
  @override
  final String sessdata;

  /// bili_jct CSRF token cookie value.
  @override
  final String biliJct;

  /// Whether the user session is valid / not expired.
  @override
  @JsonKey()
  final bool isLoggedIn;

  @override
  String toString() {
    return 'User(userId: $userId, nickname: $nickname, avatarUrl: $avatarUrl, sessdata: $sessdata, biliJct: $biliJct, isLoggedIn: $isLoggedIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.sessdata, sessdata) ||
                other.sessdata == sessdata) &&
            (identical(other.biliJct, biliJct) || other.biliJct == biliJct) &&
            (identical(other.isLoggedIn, isLoggedIn) ||
                other.isLoggedIn == isLoggedIn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, nickname, avatarUrl, sessdata, biliJct, isLoggedIn);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String userId,
      required final String nickname,
      final String? avatarUrl,
      required final String sessdata,
      required final String biliJct,
      final bool isLoggedIn}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  /// Bilibili user ID (DedeUserID).
  @override
  String get userId;

  /// Display nickname.
  @override
  String get nickname;

  /// Avatar image URL.
  @override
  String? get avatarUrl;

  /// SESSDATA cookie value for authenticated requests.
  @override
  String get sessdata;

  /// bili_jct CSRF token cookie value.
  @override
  String get biliJct;

  /// Whether the user session is valid / not expired.
  @override
  bool get isLoggedIn;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
