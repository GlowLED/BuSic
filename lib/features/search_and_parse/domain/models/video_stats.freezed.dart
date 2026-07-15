// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoStats {

/// View count.
 int get view;/// Danmaku count.
 int get danmaku;/// Reply/comment count.
 int get reply;/// Favorite count.
 int get favorite;/// Coin count.
 int get coin;/// Share count.
 int get share;/// Like count.
 int get like;
/// Create a copy of VideoStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoStatsCopyWith<VideoStats> get copyWith => _$VideoStatsCopyWithImpl<VideoStats>(this as VideoStats, _$identity);

  /// Serializes this VideoStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoStats&&(identical(other.view, view) || other.view == view)&&(identical(other.danmaku, danmaku) || other.danmaku == danmaku)&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.coin, coin) || other.coin == coin)&&(identical(other.share, share) || other.share == share)&&(identical(other.like, like) || other.like == like));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,view,danmaku,reply,favorite,coin,share,like);

@override
String toString() {
  return 'VideoStats(view: $view, danmaku: $danmaku, reply: $reply, favorite: $favorite, coin: $coin, share: $share, like: $like)';
}


}

/// @nodoc
abstract mixin class $VideoStatsCopyWith<$Res>  {
  factory $VideoStatsCopyWith(VideoStats value, $Res Function(VideoStats) _then) = _$VideoStatsCopyWithImpl;
@useResult
$Res call({
 int view, int danmaku, int reply, int favorite, int coin, int share, int like
});




}
/// @nodoc
class _$VideoStatsCopyWithImpl<$Res>
    implements $VideoStatsCopyWith<$Res> {
  _$VideoStatsCopyWithImpl(this._self, this._then);

  final VideoStats _self;
  final $Res Function(VideoStats) _then;

/// Create a copy of VideoStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? view = null,Object? danmaku = null,Object? reply = null,Object? favorite = null,Object? coin = null,Object? share = null,Object? like = null,}) {
  return _then(_self.copyWith(
view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as int,danmaku: null == danmaku ? _self.danmaku : danmaku // ignore: cast_nullable_to_non_nullable
as int,reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as int,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as int,coin: null == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as int,share: null == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as int,like: null == like ? _self.like : like // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoStats].
extension VideoStatsPatterns on VideoStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoStats value)  $default,){
final _that = this;
switch (_that) {
case _VideoStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoStats value)?  $default,){
final _that = this;
switch (_that) {
case _VideoStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int view,  int danmaku,  int reply,  int favorite,  int coin,  int share,  int like)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoStats() when $default != null:
return $default(_that.view,_that.danmaku,_that.reply,_that.favorite,_that.coin,_that.share,_that.like);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int view,  int danmaku,  int reply,  int favorite,  int coin,  int share,  int like)  $default,) {final _that = this;
switch (_that) {
case _VideoStats():
return $default(_that.view,_that.danmaku,_that.reply,_that.favorite,_that.coin,_that.share,_that.like);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int view,  int danmaku,  int reply,  int favorite,  int coin,  int share,  int like)?  $default,) {final _that = this;
switch (_that) {
case _VideoStats() when $default != null:
return $default(_that.view,_that.danmaku,_that.reply,_that.favorite,_that.coin,_that.share,_that.like);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoStats implements VideoStats {
  const _VideoStats({this.view = 0, this.danmaku = 0, this.reply = 0, this.favorite = 0, this.coin = 0, this.share = 0, this.like = 0});
  factory _VideoStats.fromJson(Map<String, dynamic> json) => _$VideoStatsFromJson(json);

/// View count.
@override@JsonKey() final  int view;
/// Danmaku count.
@override@JsonKey() final  int danmaku;
/// Reply/comment count.
@override@JsonKey() final  int reply;
/// Favorite count.
@override@JsonKey() final  int favorite;
/// Coin count.
@override@JsonKey() final  int coin;
/// Share count.
@override@JsonKey() final  int share;
/// Like count.
@override@JsonKey() final  int like;

/// Create a copy of VideoStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoStatsCopyWith<_VideoStats> get copyWith => __$VideoStatsCopyWithImpl<_VideoStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoStats&&(identical(other.view, view) || other.view == view)&&(identical(other.danmaku, danmaku) || other.danmaku == danmaku)&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.coin, coin) || other.coin == coin)&&(identical(other.share, share) || other.share == share)&&(identical(other.like, like) || other.like == like));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,view,danmaku,reply,favorite,coin,share,like);

@override
String toString() {
  return 'VideoStats(view: $view, danmaku: $danmaku, reply: $reply, favorite: $favorite, coin: $coin, share: $share, like: $like)';
}


}

/// @nodoc
abstract mixin class _$VideoStatsCopyWith<$Res> implements $VideoStatsCopyWith<$Res> {
  factory _$VideoStatsCopyWith(_VideoStats value, $Res Function(_VideoStats) _then) = __$VideoStatsCopyWithImpl;
@override @useResult
$Res call({
 int view, int danmaku, int reply, int favorite, int coin, int share, int like
});




}
/// @nodoc
class __$VideoStatsCopyWithImpl<$Res>
    implements _$VideoStatsCopyWith<$Res> {
  __$VideoStatsCopyWithImpl(this._self, this._then);

  final _VideoStats _self;
  final $Res Function(_VideoStats) _then;

/// Create a copy of VideoStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? view = null,Object? danmaku = null,Object? reply = null,Object? favorite = null,Object? coin = null,Object? share = null,Object? like = null,}) {
  return _then(_VideoStats(
view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as int,danmaku: null == danmaku ? _self.danmaku : danmaku // ignore: cast_nullable_to_non_nullable
as int,reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as int,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as int,coin: null == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as int,share: null == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as int,like: null == like ? _self.like : like // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
