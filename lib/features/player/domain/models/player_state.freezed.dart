// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlayerState {
  /// Currently playing track, or `null` if nothing is loaded.
  AudioTrack? get currentTrack => throw _privateConstructorUsedError;

  /// The playback queue (ordered list of tracks).
  List<AudioTrack> get queue => throw _privateConstructorUsedError;

  /// Current playback position.
  Duration get position => throw _privateConstructorUsedError;

  /// Total duration of the current track.
  Duration get duration => throw _privateConstructorUsedError;

  /// Whether audio is currently playing (not paused/stopped).
  bool get isPlaying => throw _privateConstructorUsedError;

  /// Current playback mode.
  PlayMode get playMode => throw _privateConstructorUsedError;

  /// Current volume level (0.0 to 1.0).
  double get volume => throw _privateConstructorUsedError;

  /// Index of the current track in the queue.
  int get currentIndex => throw _privateConstructorUsedError;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerStateCopyWith<PlayerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStateCopyWith<$Res> {
  factory $PlayerStateCopyWith(
          PlayerState value, $Res Function(PlayerState) then) =
      _$PlayerStateCopyWithImpl<$Res, PlayerState>;
  @useResult
  $Res call(
      {AudioTrack? currentTrack,
      List<AudioTrack> queue,
      Duration position,
      Duration duration,
      bool isPlaying,
      PlayMode playMode,
      double volume,
      int currentIndex});

  $AudioTrackCopyWith<$Res>? get currentTrack;
}

/// @nodoc
class _$PlayerStateCopyWithImpl<$Res, $Val extends PlayerState>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTrack = freezed,
    Object? queue = null,
    Object? position = null,
    Object? duration = null,
    Object? isPlaying = null,
    Object? playMode = null,
    Object? volume = null,
    Object? currentIndex = null,
  }) {
    return _then(_value.copyWith(
      currentTrack: freezed == currentTrack
          ? _value.currentTrack
          : currentTrack // ignore: cast_nullable_to_non_nullable
              as AudioTrack?,
      queue: null == queue
          ? _value.queue
          : queue // ignore: cast_nullable_to_non_nullable
              as List<AudioTrack>,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Duration,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      playMode: null == playMode
          ? _value.playMode
          : playMode // ignore: cast_nullable_to_non_nullable
              as PlayMode,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AudioTrackCopyWith<$Res>? get currentTrack {
    if (_value.currentTrack == null) {
      return null;
    }

    return $AudioTrackCopyWith<$Res>(_value.currentTrack!, (value) {
      return _then(_value.copyWith(currentTrack: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerStateImplCopyWith<$Res>
    implements $PlayerStateCopyWith<$Res> {
  factory _$$PlayerStateImplCopyWith(
          _$PlayerStateImpl value, $Res Function(_$PlayerStateImpl) then) =
      __$$PlayerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AudioTrack? currentTrack,
      List<AudioTrack> queue,
      Duration position,
      Duration duration,
      bool isPlaying,
      PlayMode playMode,
      double volume,
      int currentIndex});

  @override
  $AudioTrackCopyWith<$Res>? get currentTrack;
}

/// @nodoc
class __$$PlayerStateImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerStateImpl>
    implements _$$PlayerStateImplCopyWith<$Res> {
  __$$PlayerStateImplCopyWithImpl(
      _$PlayerStateImpl _value, $Res Function(_$PlayerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTrack = freezed,
    Object? queue = null,
    Object? position = null,
    Object? duration = null,
    Object? isPlaying = null,
    Object? playMode = null,
    Object? volume = null,
    Object? currentIndex = null,
  }) {
    return _then(_$PlayerStateImpl(
      currentTrack: freezed == currentTrack
          ? _value.currentTrack
          : currentTrack // ignore: cast_nullable_to_non_nullable
              as AudioTrack?,
      queue: null == queue
          ? _value._queue
          : queue // ignore: cast_nullable_to_non_nullable
              as List<AudioTrack>,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Duration,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      playMode: null == playMode
          ? _value.playMode
          : playMode // ignore: cast_nullable_to_non_nullable
              as PlayMode,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PlayerStateImpl implements _PlayerState {
  const _$PlayerStateImpl(
      {this.currentTrack,
      final List<AudioTrack> queue = const [],
      this.position = Duration.zero,
      this.duration = Duration.zero,
      this.isPlaying = false,
      this.playMode = PlayMode.sequential,
      this.volume = 1.0,
      this.currentIndex = 0})
      : _queue = queue;

  /// Currently playing track, or `null` if nothing is loaded.
  @override
  final AudioTrack? currentTrack;

  /// The playback queue (ordered list of tracks).
  final List<AudioTrack> _queue;

  /// The playback queue (ordered list of tracks).
  @override
  @JsonKey()
  List<AudioTrack> get queue {
    if (_queue is EqualUnmodifiableListView) return _queue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_queue);
  }

  /// Current playback position.
  @override
  @JsonKey()
  final Duration position;

  /// Total duration of the current track.
  @override
  @JsonKey()
  final Duration duration;

  /// Whether audio is currently playing (not paused/stopped).
  @override
  @JsonKey()
  final bool isPlaying;

  /// Current playback mode.
  @override
  @JsonKey()
  final PlayMode playMode;

  /// Current volume level (0.0 to 1.0).
  @override
  @JsonKey()
  final double volume;

  /// Index of the current track in the queue.
  @override
  @JsonKey()
  final int currentIndex;

  @override
  String toString() {
    return 'PlayerState(currentTrack: $currentTrack, queue: $queue, position: $position, duration: $duration, isPlaying: $isPlaying, playMode: $playMode, volume: $volume, currentIndex: $currentIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStateImpl &&
            (identical(other.currentTrack, currentTrack) ||
                other.currentTrack == currentTrack) &&
            const DeepCollectionEquality().equals(other._queue, _queue) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.playMode, playMode) ||
                other.playMode == playMode) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentTrack,
      const DeepCollectionEquality().hash(_queue),
      position,
      duration,
      isPlaying,
      playMode,
      volume,
      currentIndex);

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStateImplCopyWith<_$PlayerStateImpl> get copyWith =>
      __$$PlayerStateImplCopyWithImpl<_$PlayerStateImpl>(this, _$identity);
}

abstract class _PlayerState implements PlayerState {
  const factory _PlayerState(
      {final AudioTrack? currentTrack,
      final List<AudioTrack> queue,
      final Duration position,
      final Duration duration,
      final bool isPlaying,
      final PlayMode playMode,
      final double volume,
      final int currentIndex}) = _$PlayerStateImpl;

  /// Currently playing track, or `null` if nothing is loaded.
  @override
  AudioTrack? get currentTrack;

  /// The playback queue (ordered list of tracks).
  @override
  List<AudioTrack> get queue;

  /// Current playback position.
  @override
  Duration get position;

  /// Total duration of the current track.
  @override
  Duration get duration;

  /// Whether audio is currently playing (not paused/stopped).
  @override
  bool get isPlaying;

  /// Current playback mode.
  @override
  PlayMode get playMode;

  /// Current volume level (0.0 to 1.0).
  @override
  double get volume;

  /// Index of the current track in the queue.
  @override
  int get currentIndex;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerStateImplCopyWith<_$PlayerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
