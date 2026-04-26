// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_rights.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoRights _$VideoRightsFromJson(Map<String, dynamic> json) {
  return _VideoRights.fromJson(json);
}

/// @nodoc
mixin _$VideoRights {
  /// Whether reposting is forbidden without creator authorization.
  bool get noReprint => throw _privateConstructorUsedError;

  /// Serializes this VideoRights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoRights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoRightsCopyWith<VideoRights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoRightsCopyWith<$Res> {
  factory $VideoRightsCopyWith(
          VideoRights value, $Res Function(VideoRights) then) =
      _$VideoRightsCopyWithImpl<$Res, VideoRights>;
  @useResult
  $Res call({bool noReprint});
}

/// @nodoc
class _$VideoRightsCopyWithImpl<$Res, $Val extends VideoRights>
    implements $VideoRightsCopyWith<$Res> {
  _$VideoRightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoRights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noReprint = null,
  }) {
    return _then(_value.copyWith(
      noReprint: null == noReprint
          ? _value.noReprint
          : noReprint // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoRightsImplCopyWith<$Res>
    implements $VideoRightsCopyWith<$Res> {
  factory _$$VideoRightsImplCopyWith(
          _$VideoRightsImpl value, $Res Function(_$VideoRightsImpl) then) =
      __$$VideoRightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool noReprint});
}

/// @nodoc
class __$$VideoRightsImplCopyWithImpl<$Res>
    extends _$VideoRightsCopyWithImpl<$Res, _$VideoRightsImpl>
    implements _$$VideoRightsImplCopyWith<$Res> {
  __$$VideoRightsImplCopyWithImpl(
      _$VideoRightsImpl _value, $Res Function(_$VideoRightsImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoRights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noReprint = null,
  }) {
    return _then(_$VideoRightsImpl(
      noReprint: null == noReprint
          ? _value.noReprint
          : noReprint // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoRightsImpl implements _VideoRights {
  const _$VideoRightsImpl({this.noReprint = false});

  factory _$VideoRightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoRightsImplFromJson(json);

  /// Whether reposting is forbidden without creator authorization.
  @override
  @JsonKey()
  final bool noReprint;

  @override
  String toString() {
    return 'VideoRights(noReprint: $noReprint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoRightsImpl &&
            (identical(other.noReprint, noReprint) ||
                other.noReprint == noReprint));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, noReprint);

  /// Create a copy of VideoRights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoRightsImplCopyWith<_$VideoRightsImpl> get copyWith =>
      __$$VideoRightsImplCopyWithImpl<_$VideoRightsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoRightsImplToJson(
      this,
    );
  }
}

abstract class _VideoRights implements VideoRights {
  const factory _VideoRights({final bool noReprint}) = _$VideoRightsImpl;

  factory _VideoRights.fromJson(Map<String, dynamic> json) =
      _$VideoRightsImpl.fromJson;

  /// Whether reposting is forbidden without creator authorization.
  @override
  bool get noReprint;

  /// Create a copy of VideoRights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoRightsImplCopyWith<_$VideoRightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
