import 'dart:async';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';

import '../../features/player/domain/models/audio_track.dart';

/// Audio handler that bridges `audio_service` (platform media session)
/// with the existing media_kit-based player.
///
/// This provides:
/// - Android foreground service for background playback
/// - Lock screen / notification media controls
/// - Media session metadata (title, artist, cover, progress)
///
/// The actual playback is still handled by `PlayerRepositoryImpl` (media_kit).
/// This handler only forwards media button events to callbacks defined by
/// `PlayerNotifier` and receives metadata/state updates from it.
class BusicAudioHandler extends BaseAudioHandler with SeekHandler {
  /// Callbacks set by PlayerNotifier to handle media button events.
  VoidCallback? onPlay;
  VoidCallback? onPause;
  VoidCallback? onSkipToNext;
  VoidCallback? onSkipToPrevious;
  void Function(Duration position)? onSeek;
  VoidCallback? onStop;

  BusicAudioHandler();

  @override
  Future<void> play() async {
    onPlay?.call();
  }

  @override
  Future<void> pause() async {
    onPause?.call();
  }

  @override
  Future<void> skipToNext() async {
    onSkipToNext?.call();
  }

  @override
  Future<void> skipToPrevious() async {
    onSkipToPrevious?.call();
  }

  @override
  Future<void> seek(Duration position) async {
    onSeek?.call(position);
  }

  @override
  Future<void> stop() async {
    onStop?.call();
  }

  /// Update the media session metadata from the current track.
  void setCurrentTrack(AudioTrack? track, {Duration? duration}) {
    if (track == null) {
      mediaItem.add(null);
      return;
    }

    mediaItem.add(MediaItem(
      id: '${track.bvid}_${track.cid}',
      title: track.title,
      artist: track.artist,
      artUri: track.coverUrl != null ? Uri.tryParse(track.coverUrl!) : null,
      duration: duration ?? track.duration,
    ));
  }

  /// Update the playback state shown in the media session.
  void updatePlaybackState({
    required bool playing,
    required Duration position,
    Duration? bufferedPosition,
  }) {
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: AudioProcessingState.ready,
      playing: playing,
      updatePosition: position,
      bufferedPosition: bufferedPosition ?? Duration.zero,
    ));
  }
}
