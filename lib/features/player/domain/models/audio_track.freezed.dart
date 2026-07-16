// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioTrack {

/// Database song ID.
 int get songId;/// Bilibili BV number.
 String get bvid;/// Bilibili CID (page identifier).
 int get cid;/// Display title (custom or origin).
 String get title;/// Display artist (custom or origin).
 String get artist;/// Cover image URL.
 String? get coverUrl;/// Track duration.
 Duration get duration;/// Resolved audio stream URL (for network playback).
 String? get streamUrl;/// Local file path (for cached/downloaded playback).
 String? get localPath;/// Audio quality identifier.
 int get quality;
/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioTrackCopyWith<AudioTrack> get copyWith => _$AudioTrackCopyWithImpl<AudioTrack>(this as AudioTrack, _$identity);

  /// Serializes this AudioTrack to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioTrack&&(identical(other.songId, songId) || other.songId == songId)&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl)&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,songId,bvid,cid,title,artist,coverUrl,duration,streamUrl,localPath,quality);

@override
String toString() {
  return 'AudioTrack(songId: $songId, bvid: $bvid, cid: $cid, title: $title, artist: $artist, coverUrl: $coverUrl, duration: $duration, streamUrl: $streamUrl, localPath: $localPath, quality: $quality)';
}


}

/// @nodoc
abstract mixin class $AudioTrackCopyWith<$Res>  {
  factory $AudioTrackCopyWith(AudioTrack value, $Res Function(AudioTrack) _then) = _$AudioTrackCopyWithImpl;
@useResult
$Res call({
 int songId, String bvid, int cid, String title, String artist, String? coverUrl, Duration duration, String? streamUrl, String? localPath, int quality
});




}
/// @nodoc
class _$AudioTrackCopyWithImpl<$Res>
    implements $AudioTrackCopyWith<$Res> {
  _$AudioTrackCopyWithImpl(this._self, this._then);

  final AudioTrack _self;
  final $Res Function(AudioTrack) _then;

/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? songId = null,Object? bvid = null,Object? cid = null,Object? title = null,Object? artist = null,Object? coverUrl = freezed,Object? duration = null,Object? streamUrl = freezed,Object? localPath = freezed,Object? quality = null,}) {
  return _then(_self.copyWith(
songId: null == songId ? _self.songId : songId // ignore: cast_nullable_to_non_nullable
as int,bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,streamUrl: freezed == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String?,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioTrack].
extension AudioTrackPatterns on AudioTrack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioTrack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioTrack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioTrack value)  $default,){
final _that = this;
switch (_that) {
case _AudioTrack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioTrack value)?  $default,){
final _that = this;
switch (_that) {
case _AudioTrack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int songId,  String bvid,  int cid,  String title,  String artist,  String? coverUrl,  Duration duration,  String? streamUrl,  String? localPath,  int quality)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioTrack() when $default != null:
return $default(_that.songId,_that.bvid,_that.cid,_that.title,_that.artist,_that.coverUrl,_that.duration,_that.streamUrl,_that.localPath,_that.quality);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int songId,  String bvid,  int cid,  String title,  String artist,  String? coverUrl,  Duration duration,  String? streamUrl,  String? localPath,  int quality)  $default,) {final _that = this;
switch (_that) {
case _AudioTrack():
return $default(_that.songId,_that.bvid,_that.cid,_that.title,_that.artist,_that.coverUrl,_that.duration,_that.streamUrl,_that.localPath,_that.quality);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int songId,  String bvid,  int cid,  String title,  String artist,  String? coverUrl,  Duration duration,  String? streamUrl,  String? localPath,  int quality)?  $default,) {final _that = this;
switch (_that) {
case _AudioTrack() when $default != null:
return $default(_that.songId,_that.bvid,_that.cid,_that.title,_that.artist,_that.coverUrl,_that.duration,_that.streamUrl,_that.localPath,_that.quality);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AudioTrack implements AudioTrack {
  const _AudioTrack({required this.songId, required this.bvid, required this.cid, required this.title, required this.artist, this.coverUrl, required this.duration, this.streamUrl, this.localPath, this.quality = 0});
  factory _AudioTrack.fromJson(Map<String, dynamic> json) => _$AudioTrackFromJson(json);

/// Database song ID.
@override final  int songId;
/// Bilibili BV number.
@override final  String bvid;
/// Bilibili CID (page identifier).
@override final  int cid;
/// Display title (custom or origin).
@override final  String title;
/// Display artist (custom or origin).
@override final  String artist;
/// Cover image URL.
@override final  String? coverUrl;
/// Track duration.
@override final  Duration duration;
/// Resolved audio stream URL (for network playback).
@override final  String? streamUrl;
/// Local file path (for cached/downloaded playback).
@override final  String? localPath;
/// Audio quality identifier.
@override@JsonKey() final  int quality;

/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioTrackCopyWith<_AudioTrack> get copyWith => __$AudioTrackCopyWithImpl<_AudioTrack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudioTrackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioTrack&&(identical(other.songId, songId) || other.songId == songId)&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl)&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,songId,bvid,cid,title,artist,coverUrl,duration,streamUrl,localPath,quality);

@override
String toString() {
  return 'AudioTrack(songId: $songId, bvid: $bvid, cid: $cid, title: $title, artist: $artist, coverUrl: $coverUrl, duration: $duration, streamUrl: $streamUrl, localPath: $localPath, quality: $quality)';
}


}

/// @nodoc
abstract mixin class _$AudioTrackCopyWith<$Res> implements $AudioTrackCopyWith<$Res> {
  factory _$AudioTrackCopyWith(_AudioTrack value, $Res Function(_AudioTrack) _then) = __$AudioTrackCopyWithImpl;
@override @useResult
$Res call({
 int songId, String bvid, int cid, String title, String artist, String? coverUrl, Duration duration, String? streamUrl, String? localPath, int quality
});




}
/// @nodoc
class __$AudioTrackCopyWithImpl<$Res>
    implements _$AudioTrackCopyWith<$Res> {
  __$AudioTrackCopyWithImpl(this._self, this._then);

  final _AudioTrack _self;
  final $Res Function(_AudioTrack) _then;

/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? songId = null,Object? bvid = null,Object? cid = null,Object? title = null,Object? artist = null,Object? coverUrl = freezed,Object? duration = null,Object? streamUrl = freezed,Object? localPath = freezed,Object? quality = null,}) {
  return _then(_AudioTrack(
songId: null == songId ? _self.songId : songId // ignore: cast_nullable_to_non_nullable
as int,bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,streamUrl: freezed == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String?,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
