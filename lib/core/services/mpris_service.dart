import 'dart:io';
import 'package:busic/features/player/domain/models/audio_track.dart';
import 'package:busic/features/player/domain/models/play_mode.dart';
import 'package:dbus/dbus.dart';
import 'package:flutter/foundation.dart';
import 'mpris_service_dbus.dart';

/// Service managing MPRIS (Media Player Remote Interfacing Specification) on Linux.
///
/// It registers Busic as a media player on the system D-Bus, enabling integration
/// with system-level media widgets, shell extensions, and hardware media keys.
class MprisService {
  DBusClient? _dbusClient;
  MprisServiceDbus? _mprisObject;

  // Callbacks hooked into PlayerNotifier to bridge system actions to the player core.
  VoidCallback? onPlay;
  VoidCallback? onPause;
  VoidCallback? onToggle;
  VoidCallback? onNext;
  VoidCallback? onPrevious;
  ValueSetter<Duration>? onSeek;
  ValueSetter<double>? setVolume;
  ValueSetter<PlayMode>? setMode;

  /// Initializes the MPRIS service and registers the D-Bus object on Linux.
  ///
  /// Binds the incoming control callbacks from [PlayerNotifier] and exposes
  /// the media controller interface under `/org/mpris/MediaPlayer2`.
  void init({
    required VoidCallback onPlay,
    required VoidCallback onPause,
    required VoidCallback onNext,
    required VoidCallback onPrevious,
    required ValueSetter<Duration> onSeek,
    required ValueSetter<double> setVolume,
    required ValueSetter<PlayMode> setMode,
  }) {
    if (!Platform.isLinux) return;

    this.onPlay = () {
      updatePlaybackStatus(true);
      onPlay();
    };
    this.onPause = () {
      updatePlaybackStatus(false);
      onPause();
    };
    onToggle = () {
      if (_mprisObject!.playbackState == 'Playing') {
        this.onPause?.call();
      } else if (_mprisObject!.playbackState == 'Paused') {
        this.onPlay?.call();
      }
    };
    this.onNext = onNext;
    this.onPrevious = onPrevious;
    this.onSeek = (duration) {
      updatePosition(duration);
      onSeek(duration);
    };
    this.setVolume = setVolume;
    this.setMode = setMode;
    try {
      // 1. Establish connection to the D-Bus Session Bus.
      _dbusClient = DBusClient.session();

      // 2. Instantiate the generated DBusObject on the standard MPRIS object path.
      _mprisObject = MprisServiceDbus(
          path: DBusObjectPath('/org/mpris/MediaPlayer2'));

      // 3. Expose the object to external clients on D-Bus.
      _dbusClient!.registerObject(_mprisObject!);

      // 4. Request the well-known name corresponding to this media player.
      _dbusClient!.requestName('org.mpris.MediaPlayer2.busic');
      _bindSystemCommands();
      _mprisObject!.init();
    } catch (e) {
      debugPrint('Failed to initialize MPRIS Service: $e');
    }
  }

  /// Binds player control actions from D-Bus commands to our local handlers.
  void _bindSystemCommands() {
    if (_mprisObject == null) return;
    _mprisObject!.onPlay = onPlay!;
    _mprisObject!.onNext = onNext!;
    _mprisObject!.onPause = onPause!;
    _mprisObject!.onSeek = onSeek!;
    _mprisObject!.onPrevious = onPrevious!;
    _mprisObject!.onToggle = onToggle!;
    _mprisObject!.setVolume = setVolume!;
    _mprisObject!.setMode = setMode!;
  }

  /// Maps and forwards current [AudioTrack] metadata updates to D-Bus properties.
  void updateCurrentTrack(AudioTrack? track, {Duration? duration}) {
    if (track == null) return;
    updateMetadata(
      title: track.title,
      artist: track.artist,
      artUrl: track.coverUrl,
      duration: duration ?? track.duration,
    );
  }

  /// Packs raw song metadata into the standard MPRIS Dict format (a{sv})
  /// and notifies the D-Bus daemon of property updates.
  Future<void> updateMetadata({
    required String title,
    required String artist,
    String? album,
    String? artUrl,
    Duration? duration,
  }) async {
    if (_mprisObject == null) return;

    // MPRIS specification expects metadata as a string-variant dictionary.
    _mprisObject!.metadata = {
      'mpris:trackid': DBusObjectPath('/'),
      'mpris:length': DBusInt64(duration?.inMicroseconds ?? 0), // MPRIS uses microseconds for duration.
      'xesam:title': DBusString(title),
      'xesam:artist': DBusArray.string([artist]),
      'xesam:album': DBusString(album ?? ''),
      'mpris:artUrl': DBusString(artUrl ?? ''),
    };

    await _mprisObject!.updatePlayerProperties({
      'Metadata': DBusDict.stringVariant(_mprisObject!.metadata)
    });
  }

  /// Updates the player's playback state (Playing / Paused / Stopped) on D-Bus.
  Future<void> updatePlaybackStatus(bool isPlaying) async {
    if (_mprisObject == null) return;
    String status = isPlaying ? 'Playing' : 'Paused';
    _mprisObject!.playbackState = status;
    await _mprisObject!.updatePlayerProperties({
      'PlaybackStatus': DBusString(status)
    });
  }

  /// Synchronizes the current playback position (in microseconds) with D-Bus.
  Future<void> updatePosition(Duration position) async {
    if (_mprisObject == null) return;
    _mprisObject!.position = position.inMicroseconds;
    // await _mprisObject!.updatePlayerProperties({
    //   'Position': DBusInt64(_mprisObject!.position)
    // });
  }

  /// Closes active D-Bus connections and frees resources when stopping.
  void dispose() {
    _dbusClient?.close();
    _dbusClient = null;
    _mprisObject = null;
  }
}
