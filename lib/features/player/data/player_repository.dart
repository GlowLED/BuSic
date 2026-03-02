import '../domain/models/audio_track.dart';

/// Abstract repository encapsulating the media playback engine.
///
/// Wraps `media_kit` player operations behind an interface for
/// testability and potential engine swapping.
abstract class PlayerRepository {
  /// Start playing the given [track].
  ///
  /// Resolves the audio source (local path preferred, stream URL fallback)
  /// and begins playback.
  Future<void> play(AudioTrack track);

  /// Pause the current playback.
  Future<void> pause();

  /// Resume playback from the current position.
  Future<void> resume();

  /// Stop playback and reset position to zero.
  Future<void> stop();

  /// Seek to the given [position] in the current track.
  Future<void> seek(Duration position);

  /// Set the playback volume (0.0 to 1.0).
  Future<void> setVolume(double volume);

  /// Stream of current playback position updates.
  Stream<Duration> get positionStream;

  /// Stream of current track duration updates.
  Stream<Duration> get durationStream;

  /// Stream of playing/paused state changes.
  Stream<bool> get playingStream;

  /// Stream emitting when the current track completes.
  Stream<void> get completedStream;

  /// Release all player resources.
  Future<void> dispose();
}
