import '../domain/models/audio_track.dart';
import 'player_repository.dart';

/// Concrete implementation of [PlayerRepository] using media_kit.
///
/// Manages a `media_kit` [Player] instance and translates its events
/// into Dart streams.
class PlayerRepositoryImpl implements PlayerRepository {
  // TODO: inject media_kit Player instance

  @override
  Future<void> play(AudioTrack track) {
    // TODO: create Media from track.localPath ?? track.streamUrl
    // Set HTTP headers (Referer, User-Agent) for Bilibili stream
    throw UnimplementedError();
  }

  @override
  Future<void> pause() {
    // TODO: call player.pause()
    throw UnimplementedError();
  }

  @override
  Future<void> resume() {
    // TODO: call player.play()
    throw UnimplementedError();
  }

  @override
  Future<void> stop() {
    // TODO: call player.stop()
    throw UnimplementedError();
  }

  @override
  Future<void> seek(Duration position) {
    // TODO: call player.seek(position)
    throw UnimplementedError();
  }

  @override
  Future<void> setVolume(double volume) {
    // TODO: call player.setVolume(volume * 100)
    throw UnimplementedError();
  }

  @override
  Stream<Duration> get positionStream {
    // TODO: map player.stream.position
    throw UnimplementedError();
  }

  @override
  Stream<Duration> get durationStream {
    // TODO: map player.stream.duration
    throw UnimplementedError();
  }

  @override
  Stream<bool> get playingStream {
    // TODO: map player.stream.playing
    throw UnimplementedError();
  }

  @override
  Stream<void> get completedStream {
    // TODO: map player.stream.completed
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() {
    // TODO: call player.dispose()
    throw UnimplementedError();
  }
}
