import 'package:media_kit/media_kit.dart';

import '../domain/models/audio_track.dart' as domain;
import 'player_repository.dart';

/// Concrete implementation of [PlayerRepository] using media_kit.
///
/// Manages a `media_kit` [Player] instance and translates its events
/// into Dart streams.
class PlayerRepositoryImpl implements PlayerRepository {
  final Player _player;

  PlayerRepositoryImpl() : _player = Player() {
    // Configure mpv properties for better audio output:
    // 1. Allow volume amplification up to 200% for headroom.
    // 2. Enable loudness normalization (loudnorm) targeting -10 LUFS
    //    (louder than EBU R128's -14) to match perceived loudness of
    //    B站 native player and other music apps.
    final nativePlayer = _player.platform as NativePlayer;
    nativePlayer.setProperty('volume-max', '200');
    nativePlayer.setProperty('af', 'loudnorm=I=-10:TP=-1:LRA=7');
  }

  @override
  Future<void> play(domain.AudioTrack track) async {
    final source = track.localPath ?? track.streamUrl;
    if (source == null) return;

    final media = Media(source, httpHeaders: {
      'Referer': 'https://www.bilibili.com',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    });

    await _player.open(media);
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> resume() async {
    await _player.play();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume * 100.0);
  }

  @override
  Stream<Duration> get positionStream => _player.stream.position;

  @override
  Stream<Duration> get durationStream => _player.stream.duration;

  @override
  Stream<bool> get playingStream => _player.stream.playing;

  @override
  Stream<void> get completedStream =>
      _player.stream.completed.where((c) => c).cast<void>();

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }
}
