import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/player_repository.dart';
import '../domain/models/audio_track.dart';
import '../domain/models/play_mode.dart';
import '../domain/models/player_state.dart';

part 'player_notifier.g.dart';

/// State notifier managing the audio player lifecycle.
///
/// Controls playback, queue management, and mode switching.
/// Listens to the [PlayerRepository] streams and updates [PlayerState] accordingly.
@riverpod
class PlayerNotifier extends _$PlayerNotifier {
  late final PlayerRepository _repository;

  @override
  PlayerState build() {
    // TODO: inject repository, set up stream listeners
    return const PlayerState();
  }

  /// Play a specific track, optionally replacing the queue.
  Future<void> playTrack(AudioTrack track, {List<AudioTrack>? queue}) async {
    // TODO: update queue state, call repository.play()
    throw UnimplementedError();
  }

  /// Pause the current playback.
  Future<void> pause() async {
    // TODO: call repository.pause(), update isPlaying
    throw UnimplementedError();
  }

  /// Resume the current playback.
  Future<void> resume() async {
    // TODO: call repository.resume(), update isPlaying
    throw UnimplementedError();
  }

  /// Skip to the next track in the queue.
  Future<void> next() async {
    // TODO: determine next track based on playMode, call playTrack
    throw UnimplementedError();
  }

  /// Skip to the previous track in the queue.
  Future<void> previous() async {
    // TODO: determine previous track or restart current
    throw UnimplementedError();
  }

  /// Seek to a specific position in the current track.
  Future<void> seekTo(Duration position) async {
    // TODO: call repository.seek()
    throw UnimplementedError();
  }

  /// Set the playback mode (sequential, repeat, shuffle).
  void setMode(PlayMode mode) {
    // TODO: update state.playMode
    throw UnimplementedError();
  }

  /// Set the volume level (0.0 to 1.0).
  Future<void> setVolume(double volume) async {
    // TODO: call repository.setVolume(), update state
    throw UnimplementedError();
  }

  /// Add a track to the end of the queue.
  void addToQueue(AudioTrack track) {
    // TODO: append to state.queue
    throw UnimplementedError();
  }

  /// Remove a track from the queue by index.
  void removeFromQueue(int index) {
    // TODO: remove from state.queue, adjust currentIndex if needed
    throw UnimplementedError();
  }

  /// Reorder a track in the queue.
  void reorderQueue(int oldIndex, int newIndex) {
    // TODO: reorder state.queue list
    throw UnimplementedError();
  }
}
