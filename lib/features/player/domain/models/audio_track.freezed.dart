// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AudioTrack _$AudioTrackFromJson(Map<String, dynamic> json) {
  return _AudioTrack.fromJson(json);
}

/// @nodoc
mixin _$AudioTrack {
  /// Database song ID.
  int get songId => throw _privateConstructorUsedError;

  /// Bilibili BV number.
  String get bvid => throw _privateConstructorUsedError;

  /// Bilibili CID (page identifier).
  int get cid => throw _privateConstructorUsedError;

  /// Display title (custom or origin).
  String get title => throw _privateConstructorUsedError;

  /// Display artist (custom or origin).
  String get artist => throw _privateConstructorUsedError;

  /// Cover image URL.
  String? get coverUrl => throw _privateConstructorUsedError;

  /// Track duration.
  Duration get duration => throw _privateConstructorUsedError;

  /// Resolved audio stream URL (for network playback).
  String? get streamUrl => throw _privateConstructorUsedError;

  /// Local file path (for cached/downloaded playback).
  String? get localPath => throw _privateConstructorUsedError;

  /// Audio quality identifier.
  int get quality => throw _privateConstructorUsedError;

  /// Serializes this AudioTrack to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AudioTrack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioTrackCopyWith<AudioTrack> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioTrackCopyWith<$Res> {
  factory $AudioTrackCopyWith(
          AudioTrack value, $Res Function(AudioTrack) then) =
      _$AudioTrackCopyWithImpl<$Res, AudioTrack>;
  @useResult
  $Res call(
      {int songId,
      String bvid,
      int cid,
      String title,
      String artist,
      String? coverUrl,
      Duration duration,
      String? streamUrl,
      String? localPath,
      int quality});
}

/// @nodoc
class _$AudioTrackCopyWithImpl<$Res, $Val extends AudioTrack>
    implements $AudioTrackCopyWith<$Res> {
  _$AudioTrackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioTrack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songId = null,
    Object? bvid = null,
    Object? cid = null,
    Object? title = null,
    Object? artist = null,
    Object? coverUrl = freezed,
    Object? duration = null,
    Object? streamUrl = freezed,
    Object? localPath = freezed,
    Object? quality = null,
  }) {
    return _then(_value.copyWith(
      songId: null == songId
          ? _value.songId
          : songId // ignore: cast_nullable_to_non_nullable
              as int,
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      cid: null == cid
          ? _value.cid
          : cid // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      streamUrl: freezed == streamUrl
          ? _value.streamUrl
          : streamUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      localPath: freezed == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String?,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AudioTrackImplCopyWith<$Res>
    implements $AudioTrackCopyWith<$Res> {
  factory _$$AudioTrackImplCopyWith(
          _$AudioTrackImpl value, $Res Function(_$AudioTrackImpl) then) =
      __$$AudioTrackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int songId,
      String bvid,
      int cid,
      String title,
      String artist,
      String? coverUrl,
      Duration duration,
      String? streamUrl,
      String? localPath,
      int quality});
}

/// @nodoc
class __$$AudioTrackImplCopyWithImpl<$Res>
    extends _$AudioTrackCopyWithImpl<$Res, _$AudioTrackImpl>
    implements _$$AudioTrackImplCopyWith<$Res> {
  __$$AudioTrackImplCopyWithImpl(
      _$AudioTrackImpl _value, $Res Function(_$AudioTrackImpl) _then)
      : super(_value, _then);

  /// Create a copy of AudioTrack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songId = null,
    Object? bvid = null,
    Object? cid = null,
    Object? title = null,
    Object? artist = null,
    Object? coverUrl = freezed,
    Object? duration = null,
    Object? streamUrl = freezed,
    Object? localPath = freezed,
    Object? quality = null,
  }) {
    return _then(_$AudioTrackImpl(
      songId: null == songId
          ? _value.songId
          : songId // ignore: cast_nullable_to_non_nullable
              as int,
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      cid: null == cid
          ? _value.cid
          : cid // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      streamUrl: freezed == streamUrl
          ? _value.streamUrl
          : streamUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      localPath: freezed == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String?,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioTrackImpl implements _AudioTrack {
  const _$AudioTrackImpl(
      {required this.songId,
      required this.bvid,
      required this.cid,
      required this.title,
      required this.artist,
      this.coverUrl,
      required this.duration,
      this.streamUrl,
      this.localPath,
      this.quality = 0});

  factory _$AudioTrackImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioTrackImplFromJson(json);

  /// Database song ID.
  @override
  final int songId;

  /// Bilibili BV number.
  @override
  final String bvid;

  /// Bilibili CID (page identifier).
  @override
  final int cid;

  /// Display title (custom or origin).
  @override
  final String title;

  /// Display artist (custom or origin).
  @override
  final String artist;

  /// Cover image URL.
  @override
  final String? coverUrl;

  /// Track duration.
  @override
  final Duration duration;

  /// Resolved audio stream URL (for network playback).
  @override
  final String? streamUrl;

  /// Local file path (for cached/downloaded playback).
  @override
  final String? localPath;

  /// Audio quality identifier.
  @override
  @JsonKey()
  final int quality;

  @override
  String toString() {
    return 'AudioTrack(songId: $songId, bvid: $bvid, cid: $cid, title: $title, artist: $artist, coverUrl: $coverUrl, duration: $duration, streamUrl: $streamUrl, localPath: $localPath, quality: $quality)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioTrackImpl &&
            (identical(other.songId, songId) || other.songId == songId) &&
            (identical(other.bvid, bvid) || other.bvid == bvid) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.streamUrl, streamUrl) ||
                other.streamUrl == streamUrl) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.quality, quality) || other.quality == quality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, songId, bvid, cid, title, artist,
      coverUrl, duration, streamUrl, localPath, quality);

  /// Create a copy of AudioTrack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioTrackImplCopyWith<_$AudioTrackImpl> get copyWith =>
      __$$AudioTrackImplCopyWithImpl<_$AudioTrackImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioTrackImplToJson(
      this,
    );
  }
}

abstract class _AudioTrack implements AudioTrack {
  const factory _AudioTrack(
      {required final int songId,
      required final String bvid,
      required final int cid,
      required final String title,
      required final String artist,
      final String? coverUrl,
      required final Duration duration,
      final String? streamUrl,
      final String? localPath,
      final int quality}) = _$AudioTrackImpl;

  factory _AudioTrack.fromJson(Map<String, dynamic> json) =
      _$AudioTrackImpl.fromJson;

  /// Database song ID.
  @override
  int get songId;

  /// Bilibili BV number.
  @override
  String get bvid;

  /// Bilibili CID (page identifier).
  @override
  int get cid;

  /// Display title (custom or origin).
  @override
  String get title;

  /// Display artist (custom or origin).
  @override
  String get artist;

  /// Cover image URL.
  @override
  String? get coverUrl;

  /// Track duration.
  @override
  Duration get duration;

  /// Resolved audio stream URL (for network playback).
  @override
  String? get streamUrl;

  /// Local file path (for cached/downloaded playback).
  @override
  String? get localPath;

  /// Audio quality identifier.
  @override
  int get quality;

  /// Create a copy of AudioTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioTrackImplCopyWith<_$AudioTrackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
