import 'package:freezed_annotation/freezed_annotation.dart';

import 'audio_track.dart';
import 'play_mode.dart';

part 'player_state.freezed.dart';

/// Immutable state snapshot of the audio player.
///
/// Represents everything the UI needs to render the player controls,
/// progress bar, queue, and current track info.
@freezed
class PlayerState with _$PlayerState {
  const factory PlayerState({
    /// Currently playing track, or `null` if nothing is loaded.
    AudioTrack? currentTrack,

    /// The playback queue (ordered list of tracks).
    @Default([]) List<AudioTrack> queue,

    /// Current playback position.
    @Default(Duration.zero) Duration position,

    /// Total duration of the current track.
    @Default(Duration.zero) Duration duration,

    /// Whether audio is currently playing (not paused/stopped).
    @Default(false) bool isPlaying,

    /// Current playback mode.
    @Default(PlayMode.sequential) PlayMode playMode,

    /// Current volume level (0.0 to 1.0).
    @Default(1.0) double volume,

    /// Index of the current track in the queue.
    @Default(0) int currentIndex,
  }) = _PlayerState;
}
