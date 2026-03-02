import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/player_repository.dart';
import '../data/player_repository_impl.dart';
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
  final List<StreamSubscription> _subscriptions = [];

  @override
  PlayerState build() {
    _repository = PlayerRepositoryImpl();

    // Listen to player streams
    _subscriptions.add(
      _repository.positionStream.listen((pos) {
        state = state.copyWith(position: pos);
      }),
    );
    _subscriptions.add(
      _repository.durationStream.listen((dur) {
        state = state.copyWith(duration: dur);
      }),
    );
    _subscriptions.add(
      _repository.playingStream.listen((playing) {
        state = state.copyWith(isPlaying: playing);
      }),
    );
    _subscriptions.add(
      _repository.completedStream.listen((_) {
        _onTrackCompleted();
      }),
    );

    ref.onDispose(() {
      for (final sub in _subscriptions) {
        sub.cancel();
      }
      _repository.dispose();
    });

    return const PlayerState();
  }

  /// Play a specific track, optionally replacing the queue.
  Future<void> playTrack(AudioTrack track, {List<AudioTrack>? queue}) async {
    final newQueue = queue ?? [track];
    final index = newQueue.indexOf(track);

    state = state.copyWith(
      currentTrack: track,
      queue: newQueue,
      currentIndex: index >= 0 ? index : 0,
      position: Duration.zero,
    );

    await _repository.play(track);
  }

  /// Pause the current playback.
  Future<void> pause() async {
    await _repository.pause();
  }

  /// Resume the current playback.
  Future<void> resume() async {
    await _repository.resume();
  }

  /// Skip to the next track in the queue.
  Future<void> next() async {
    if (state.queue.isEmpty) return;

    final nextIndex = _getNextIndex();
    if (nextIndex == null) {
      await _repository.stop();
      state = state.copyWith(isPlaying: false);
      return;
    }

    final track = state.queue[nextIndex];
    state = state.copyWith(
      currentTrack: track,
      currentIndex: nextIndex,
      position: Duration.zero,
    );
    await _repository.play(track);
  }

  /// Skip to the previous track in the queue.
  Future<void> previous() async {
    if (state.queue.isEmpty) return;

    // If past 3 seconds, restart current track
    if (state.position.inSeconds > 3) {
      await _repository.seek(Duration.zero);
      return;
    }

    final prevIndex = state.currentIndex > 0
        ? state.currentIndex - 1
        : state.queue.length - 1;

    final track = state.queue[prevIndex];
    state = state.copyWith(
      currentTrack: track,
      currentIndex: prevIndex,
      position: Duration.zero,
    );
    await _repository.play(track);
  }

  /// Seek to a specific position in the current track.
  Future<void> seekTo(Duration position) async {
    await _repository.seek(position);
  }

  /// Set the playback mode (sequential, repeat, shuffle).
  void setMode(PlayMode mode) {
    state = state.copyWith(playMode: mode);
  }

  /// Set the volume level (0.0 to 1.0).
  Future<void> setVolume(double volume) async {
    await _repository.setVolume(volume);
    state = state.copyWith(volume: volume);
  }

  /// Add a track to the end of the queue.
  void addToQueue(AudioTrack track) {
    state = state.copyWith(queue: [...state.queue, track]);
  }

  /// Remove a track from the queue by index.
  void removeFromQueue(int index) {
    if (index < 0 || index >= state.queue.length) return;
    final newQueue = List<AudioTrack>.from(state.queue)..removeAt(index);
    var newIndex = state.currentIndex;
    if (index < state.currentIndex) {
      newIndex--;
    } else if (index == state.currentIndex && newQueue.isNotEmpty) {
      newIndex = newIndex.clamp(0, newQueue.length - 1);
    }
    state = state.copyWith(queue: newQueue, currentIndex: newIndex);
  }

  /// Reorder a track in the queue.
  void reorderQueue(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final newQueue = List<AudioTrack>.from(state.queue);
    final item = newQueue.removeAt(oldIndex);
    newQueue.insert(newIndex, item);

    // Adjust current index
    var newCurrentIndex = state.currentIndex;
    if (oldIndex == state.currentIndex) {
      newCurrentIndex = newIndex;
    } else {
      if (oldIndex < state.currentIndex) newCurrentIndex--;
      if (newIndex <= newCurrentIndex) newCurrentIndex++;
    }

    state = state.copyWith(queue: newQueue, currentIndex: newCurrentIndex);
  }

  void _onTrackCompleted() {
    switch (state.playMode) {
      case PlayMode.repeatOne:
        if (state.currentTrack != null) {
          _repository.play(state.currentTrack!);
        }
      case PlayMode.sequential:
      case PlayMode.repeatAll:
      case PlayMode.shuffle:
        next();
    }
  }

  int? _getNextIndex() {
    if (state.queue.isEmpty) return null;

    switch (state.playMode) {
      case PlayMode.sequential:
        final next = state.currentIndex + 1;
        return next < state.queue.length ? next : null;
      case PlayMode.repeatAll:
        return (state.currentIndex + 1) % state.queue.length;
      case PlayMode.repeatOne:
        return state.currentIndex;
      case PlayMode.shuffle:
        if (state.queue.length == 1) return 0;
        int next;
        do {
          next = Random().nextInt(state.queue.length);
        } while (next == state.currentIndex);
        return next;
    }
  }
}
