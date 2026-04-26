// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_interaction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VideoInteractionState {
  /// Whether the current user has liked the video.
  bool get isLiked => throw _privateConstructorUsedError;

  /// Whether the current user has added the video to a favorite folder.
  bool get isFavorited => throw _privateConstructorUsedError;

  /// Number of coins the current user has given to the video.
  int get coinsGiven => throw _privateConstructorUsedError;

  /// Whether an interaction request is in progress.
  bool get isBusy => throw _privateConstructorUsedError;

  /// Last interaction error for presentation feedback.
  String? get lastError => throw _privateConstructorUsedError;

  /// Create a copy of VideoInteractionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoInteractionStateCopyWith<VideoInteractionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoInteractionStateCopyWith<$Res> {
  factory $VideoInteractionStateCopyWith(VideoInteractionState value,
          $Res Function(VideoInteractionState) then) =
      _$VideoInteractionStateCopyWithImpl<$Res, VideoInteractionState>;
  @useResult
  $Res call(
      {bool isLiked,
      bool isFavorited,
      int coinsGiven,
      bool isBusy,
      String? lastError});
}

/// @nodoc
class _$VideoInteractionStateCopyWithImpl<$Res,
        $Val extends VideoInteractionState>
    implements $VideoInteractionStateCopyWith<$Res> {
  _$VideoInteractionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoInteractionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLiked = null,
    Object? isFavorited = null,
    Object? coinsGiven = null,
    Object? isBusy = null,
    Object? lastError = freezed,
  }) {
    return _then(_value.copyWith(
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorited: null == isFavorited
          ? _value.isFavorited
          : isFavorited // ignore: cast_nullable_to_non_nullable
              as bool,
      coinsGiven: null == coinsGiven
          ? _value.coinsGiven
          : coinsGiven // ignore: cast_nullable_to_non_nullable
              as int,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoInteractionStateImplCopyWith<$Res>
    implements $VideoInteractionStateCopyWith<$Res> {
  factory _$$VideoInteractionStateImplCopyWith(
          _$VideoInteractionStateImpl value,
          $Res Function(_$VideoInteractionStateImpl) then) =
      __$$VideoInteractionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLiked,
      bool isFavorited,
      int coinsGiven,
      bool isBusy,
      String? lastError});
}

/// @nodoc
class __$$VideoInteractionStateImplCopyWithImpl<$Res>
    extends _$VideoInteractionStateCopyWithImpl<$Res,
        _$VideoInteractionStateImpl>
    implements _$$VideoInteractionStateImplCopyWith<$Res> {
  __$$VideoInteractionStateImplCopyWithImpl(_$VideoInteractionStateImpl _value,
      $Res Function(_$VideoInteractionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoInteractionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLiked = null,
    Object? isFavorited = null,
    Object? coinsGiven = null,
    Object? isBusy = null,
    Object? lastError = freezed,
  }) {
    return _then(_$VideoInteractionStateImpl(
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorited: null == isFavorited
          ? _value.isFavorited
          : isFavorited // ignore: cast_nullable_to_non_nullable
              as bool,
      coinsGiven: null == coinsGiven
          ? _value.coinsGiven
          : coinsGiven // ignore: cast_nullable_to_non_nullable
              as int,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$VideoInteractionStateImpl implements _VideoInteractionState {
  const _$VideoInteractionStateImpl(
      {this.isLiked = false,
      this.isFavorited = false,
      this.coinsGiven = 0,
      this.isBusy = false,
      this.lastError});

  /// Whether the current user has liked the video.
  @override
  @JsonKey()
  final bool isLiked;

  /// Whether the current user has added the video to a favorite folder.
  @override
  @JsonKey()
  final bool isFavorited;

  /// Number of coins the current user has given to the video.
  @override
  @JsonKey()
  final int coinsGiven;

  /// Whether an interaction request is in progress.
  @override
  @JsonKey()
  final bool isBusy;

  /// Last interaction error for presentation feedback.
  @override
  final String? lastError;

  @override
  String toString() {
    return 'VideoInteractionState(isLiked: $isLiked, isFavorited: $isFavorited, coinsGiven: $coinsGiven, isBusy: $isBusy, lastError: $lastError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoInteractionStateImpl &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.isFavorited, isFavorited) ||
                other.isFavorited == isFavorited) &&
            (identical(other.coinsGiven, coinsGiven) ||
                other.coinsGiven == coinsGiven) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isLiked, isFavorited, coinsGiven, isBusy, lastError);

  /// Create a copy of VideoInteractionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoInteractionStateImplCopyWith<_$VideoInteractionStateImpl>
      get copyWith => __$$VideoInteractionStateImplCopyWithImpl<
          _$VideoInteractionStateImpl>(this, _$identity);
}

abstract class _VideoInteractionState implements VideoInteractionState {
  const factory _VideoInteractionState(
      {final bool isLiked,
      final bool isFavorited,
      final int coinsGiven,
      final bool isBusy,
      final String? lastError}) = _$VideoInteractionStateImpl;

  /// Whether the current user has liked the video.
  @override
  bool get isLiked;

  /// Whether the current user has added the video to a favorite folder.
  @override
  bool get isFavorited;

  /// Number of coins the current user has given to the video.
  @override
  int get coinsGiven;

  /// Whether an interaction request is in progress.
  @override
  bool get isBusy;

  /// Last interaction error for presentation feedback.
  @override
  String? get lastError;

  /// Create a copy of VideoInteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoInteractionStateImplCopyWith<_$VideoInteractionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
