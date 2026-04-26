// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoStats _$VideoStatsFromJson(Map<String, dynamic> json) {
  return _VideoStats.fromJson(json);
}

/// @nodoc
mixin _$VideoStats {
  /// View count.
  int get view => throw _privateConstructorUsedError;

  /// Danmaku count.
  int get danmaku => throw _privateConstructorUsedError;

  /// Reply/comment count.
  int get reply => throw _privateConstructorUsedError;

  /// Favorite count.
  int get favorite => throw _privateConstructorUsedError;

  /// Coin count.
  int get coin => throw _privateConstructorUsedError;

  /// Share count.
  int get share => throw _privateConstructorUsedError;

  /// Like count.
  int get like => throw _privateConstructorUsedError;

  /// Serializes this VideoStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoStatsCopyWith<VideoStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoStatsCopyWith<$Res> {
  factory $VideoStatsCopyWith(
          VideoStats value, $Res Function(VideoStats) then) =
      _$VideoStatsCopyWithImpl<$Res, VideoStats>;
  @useResult
  $Res call(
      {int view,
      int danmaku,
      int reply,
      int favorite,
      int coin,
      int share,
      int like});
}

/// @nodoc
class _$VideoStatsCopyWithImpl<$Res, $Val extends VideoStats>
    implements $VideoStatsCopyWith<$Res> {
  _$VideoStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? view = null,
    Object? danmaku = null,
    Object? reply = null,
    Object? favorite = null,
    Object? coin = null,
    Object? share = null,
    Object? like = null,
  }) {
    return _then(_value.copyWith(
      view: null == view
          ? _value.view
          : view // ignore: cast_nullable_to_non_nullable
              as int,
      danmaku: null == danmaku
          ? _value.danmaku
          : danmaku // ignore: cast_nullable_to_non_nullable
              as int,
      reply: null == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as int,
      favorite: null == favorite
          ? _value.favorite
          : favorite // ignore: cast_nullable_to_non_nullable
              as int,
      coin: null == coin
          ? _value.coin
          : coin // ignore: cast_nullable_to_non_nullable
              as int,
      share: null == share
          ? _value.share
          : share // ignore: cast_nullable_to_non_nullable
              as int,
      like: null == like
          ? _value.like
          : like // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoStatsImplCopyWith<$Res>
    implements $VideoStatsCopyWith<$Res> {
  factory _$$VideoStatsImplCopyWith(
          _$VideoStatsImpl value, $Res Function(_$VideoStatsImpl) then) =
      __$$VideoStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int view,
      int danmaku,
      int reply,
      int favorite,
      int coin,
      int share,
      int like});
}

/// @nodoc
class __$$VideoStatsImplCopyWithImpl<$Res>
    extends _$VideoStatsCopyWithImpl<$Res, _$VideoStatsImpl>
    implements _$$VideoStatsImplCopyWith<$Res> {
  __$$VideoStatsImplCopyWithImpl(
      _$VideoStatsImpl _value, $Res Function(_$VideoStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? view = null,
    Object? danmaku = null,
    Object? reply = null,
    Object? favorite = null,
    Object? coin = null,
    Object? share = null,
    Object? like = null,
  }) {
    return _then(_$VideoStatsImpl(
      view: null == view
          ? _value.view
          : view // ignore: cast_nullable_to_non_nullable
              as int,
      danmaku: null == danmaku
          ? _value.danmaku
          : danmaku // ignore: cast_nullable_to_non_nullable
              as int,
      reply: null == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as int,
      favorite: null == favorite
          ? _value.favorite
          : favorite // ignore: cast_nullable_to_non_nullable
              as int,
      coin: null == coin
          ? _value.coin
          : coin // ignore: cast_nullable_to_non_nullable
              as int,
      share: null == share
          ? _value.share
          : share // ignore: cast_nullable_to_non_nullable
              as int,
      like: null == like
          ? _value.like
          : like // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoStatsImpl implements _VideoStats {
  const _$VideoStatsImpl(
      {this.view = 0,
      this.danmaku = 0,
      this.reply = 0,
      this.favorite = 0,
      this.coin = 0,
      this.share = 0,
      this.like = 0});

  factory _$VideoStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoStatsImplFromJson(json);

  /// View count.
  @override
  @JsonKey()
  final int view;

  /// Danmaku count.
  @override
  @JsonKey()
  final int danmaku;

  /// Reply/comment count.
  @override
  @JsonKey()
  final int reply;

  /// Favorite count.
  @override
  @JsonKey()
  final int favorite;

  /// Coin count.
  @override
  @JsonKey()
  final int coin;

  /// Share count.
  @override
  @JsonKey()
  final int share;

  /// Like count.
  @override
  @JsonKey()
  final int like;

  @override
  String toString() {
    return 'VideoStats(view: $view, danmaku: $danmaku, reply: $reply, favorite: $favorite, coin: $coin, share: $share, like: $like)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoStatsImpl &&
            (identical(other.view, view) || other.view == view) &&
            (identical(other.danmaku, danmaku) || other.danmaku == danmaku) &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.favorite, favorite) ||
                other.favorite == favorite) &&
            (identical(other.coin, coin) || other.coin == coin) &&
            (identical(other.share, share) || other.share == share) &&
            (identical(other.like, like) || other.like == like));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, view, danmaku, reply, favorite, coin, share, like);

  /// Create a copy of VideoStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoStatsImplCopyWith<_$VideoStatsImpl> get copyWith =>
      __$$VideoStatsImplCopyWithImpl<_$VideoStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoStatsImplToJson(
      this,
    );
  }
}

abstract class _VideoStats implements VideoStats {
  const factory _VideoStats(
      {final int view,
      final int danmaku,
      final int reply,
      final int favorite,
      final int coin,
      final int share,
      final int like}) = _$VideoStatsImpl;

  factory _VideoStats.fromJson(Map<String, dynamic> json) =
      _$VideoStatsImpl.fromJson;

  /// View count.
  @override
  int get view;

  /// Danmaku count.
  @override
  int get danmaku;

  /// Reply/comment count.
  @override
  int get reply;

  /// Favorite count.
  @override
  int get favorite;

  /// Coin count.
  @override
  int get coin;

  /// Share count.
  @override
  int get share;

  /// Like count.
  @override
  int get like;

  /// Create a copy of VideoStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoStatsImplCopyWith<_$VideoStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
