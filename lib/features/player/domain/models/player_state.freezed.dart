// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerState {

/// Currently playing track, or `null` if nothing is loaded.
 AudioTrack? get currentTrack;/// The playback queue (ordered list of tracks).
 List<AudioTrack> get queue;/// Current playback position.
 Duration get position;/// Total duration of the current track.
 Duration get duration;/// Whether audio is currently playing (not paused/stopped).
 bool get isPlaying;/// Current playback mode.
 PlayMode get playMode;/// Current volume level (0.0 to 1.0).
 double get volume;/// Index of the current track in the queue.
 int get currentIndex;/// Currently playing playlist name (for display).
 String? get playlistName;/// Currently playing playlist ID.
 int? get playlistId;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.currentTrack, currentTrack) || other.currentTrack == currentTrack)&&const DeepCollectionEquality().equals(other.queue, queue)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.playMode, playMode) || other.playMode == playMode)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.playlistName, playlistName) || other.playlistName == playlistName)&&(identical(other.playlistId, playlistId) || other.playlistId == playlistId));
}


@override
int get hashCode => Object.hash(runtimeType,currentTrack,const DeepCollectionEquality().hash(queue),position,duration,isPlaying,playMode,volume,currentIndex,playlistName,playlistId);

@override
String toString() {
  return 'PlayerState(currentTrack: $currentTrack, queue: $queue, position: $position, duration: $duration, isPlaying: $isPlaying, playMode: $playMode, volume: $volume, currentIndex: $currentIndex, playlistName: $playlistName, playlistId: $playlistId)';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 AudioTrack? currentTrack, List<AudioTrack> queue, Duration position, Duration duration, bool isPlaying, PlayMode playMode, double volume, int currentIndex, String? playlistName, int? playlistId
});


$AudioTrackCopyWith<$Res>? get currentTrack;

}
/// @nodoc
class _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._self, this._then);

  final PlayerState _self;
  final $Res Function(PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentTrack = freezed,Object? queue = null,Object? position = null,Object? duration = null,Object? isPlaying = null,Object? playMode = null,Object? volume = null,Object? currentIndex = null,Object? playlistName = freezed,Object? playlistId = freezed,}) {
  return _then(_self.copyWith(
currentTrack: freezed == currentTrack ? _self.currentTrack : currentTrack // ignore: cast_nullable_to_non_nullable
as AudioTrack?,queue: null == queue ? _self.queue : queue // ignore: cast_nullable_to_non_nullable
as List<AudioTrack>,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,playMode: null == playMode ? _self.playMode : playMode // ignore: cast_nullable_to_non_nullable
as PlayMode,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,playlistName: freezed == playlistName ? _self.playlistName : playlistName // ignore: cast_nullable_to_non_nullable
as String?,playlistId: freezed == playlistId ? _self.playlistId : playlistId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioTrackCopyWith<$Res>? get currentTrack {
    if (_self.currentTrack == null) {
    return null;
  }

  return $AudioTrackCopyWith<$Res>(_self.currentTrack!, (value) {
    return _then(_self.copyWith(currentTrack: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayerState].
extension PlayerStatePatterns on PlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AudioTrack? currentTrack,  List<AudioTrack> queue,  Duration position,  Duration duration,  bool isPlaying,  PlayMode playMode,  double volume,  int currentIndex,  String? playlistName,  int? playlistId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.currentTrack,_that.queue,_that.position,_that.duration,_that.isPlaying,_that.playMode,_that.volume,_that.currentIndex,_that.playlistName,_that.playlistId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AudioTrack? currentTrack,  List<AudioTrack> queue,  Duration position,  Duration duration,  bool isPlaying,  PlayMode playMode,  double volume,  int currentIndex,  String? playlistName,  int? playlistId)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.currentTrack,_that.queue,_that.position,_that.duration,_that.isPlaying,_that.playMode,_that.volume,_that.currentIndex,_that.playlistName,_that.playlistId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AudioTrack? currentTrack,  List<AudioTrack> queue,  Duration position,  Duration duration,  bool isPlaying,  PlayMode playMode,  double volume,  int currentIndex,  String? playlistName,  int? playlistId)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.currentTrack,_that.queue,_that.position,_that.duration,_that.isPlaying,_that.playMode,_that.volume,_that.currentIndex,_that.playlistName,_that.playlistId);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerState implements PlayerState {
  const _PlayerState({this.currentTrack, final  List<AudioTrack> queue = const [], this.position = Duration.zero, this.duration = Duration.zero, this.isPlaying = false, this.playMode = PlayMode.sequential, this.volume = 1.0, this.currentIndex = 0, this.playlistName, this.playlistId}): _queue = queue;
  

/// Currently playing track, or `null` if nothing is loaded.
@override final  AudioTrack? currentTrack;
/// The playback queue (ordered list of tracks).
 final  List<AudioTrack> _queue;
/// The playback queue (ordered list of tracks).
@override@JsonKey() List<AudioTrack> get queue {
  if (_queue is EqualUnmodifiableListView) return _queue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queue);
}

/// Current playback position.
@override@JsonKey() final  Duration position;
/// Total duration of the current track.
@override@JsonKey() final  Duration duration;
/// Whether audio is currently playing (not paused/stopped).
@override@JsonKey() final  bool isPlaying;
/// Current playback mode.
@override@JsonKey() final  PlayMode playMode;
/// Current volume level (0.0 to 1.0).
@override@JsonKey() final  double volume;
/// Index of the current track in the queue.
@override@JsonKey() final  int currentIndex;
/// Currently playing playlist name (for display).
@override final  String? playlistName;
/// Currently playing playlist ID.
@override final  int? playlistId;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateCopyWith<_PlayerState> get copyWith => __$PlayerStateCopyWithImpl<_PlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.currentTrack, currentTrack) || other.currentTrack == currentTrack)&&const DeepCollectionEquality().equals(other._queue, _queue)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.playMode, playMode) || other.playMode == playMode)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.playlistName, playlistName) || other.playlistName == playlistName)&&(identical(other.playlistId, playlistId) || other.playlistId == playlistId));
}


@override
int get hashCode => Object.hash(runtimeType,currentTrack,const DeepCollectionEquality().hash(_queue),position,duration,isPlaying,playMode,volume,currentIndex,playlistName,playlistId);

@override
String toString() {
  return 'PlayerState(currentTrack: $currentTrack, queue: $queue, position: $position, duration: $duration, isPlaying: $isPlaying, playMode: $playMode, volume: $volume, currentIndex: $currentIndex, playlistName: $playlistName, playlistId: $playlistId)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 AudioTrack? currentTrack, List<AudioTrack> queue, Duration position, Duration duration, bool isPlaying, PlayMode playMode, double volume, int currentIndex, String? playlistName, int? playlistId
});


@override $AudioTrackCopyWith<$Res>? get currentTrack;

}
/// @nodoc
class __$PlayerStateCopyWithImpl<$Res>
    implements _$PlayerStateCopyWith<$Res> {
  __$PlayerStateCopyWithImpl(this._self, this._then);

  final _PlayerState _self;
  final $Res Function(_PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentTrack = freezed,Object? queue = null,Object? position = null,Object? duration = null,Object? isPlaying = null,Object? playMode = null,Object? volume = null,Object? currentIndex = null,Object? playlistName = freezed,Object? playlistId = freezed,}) {
  return _then(_PlayerState(
currentTrack: freezed == currentTrack ? _self.currentTrack : currentTrack // ignore: cast_nullable_to_non_nullable
as AudioTrack?,queue: null == queue ? _self._queue : queue // ignore: cast_nullable_to_non_nullable
as List<AudioTrack>,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,playMode: null == playMode ? _self.playMode : playMode // ignore: cast_nullable_to_non_nullable
as PlayMode,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,playlistName: freezed == playlistName ? _self.playlistName : playlistName // ignore: cast_nullable_to_non_nullable
as String?,playlistId: freezed == playlistId ? _self.playlistId : playlistId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioTrackCopyWith<$Res>? get currentTrack {
    if (_self.currentTrack == null) {
    return null;
  }

  return $AudioTrackCopyWith<$Res>(_self.currentTrack!, (value) {
    return _then(_self.copyWith(currentTrack: value));
  });
}
}

// dart format on
