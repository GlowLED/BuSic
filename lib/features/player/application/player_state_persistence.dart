import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/logger.dart';
import '../domain/models/audio_track.dart';
import '../domain/models/play_mode.dart';
import '../domain/models/player_state.dart';

/// Mixin handling persist/restore of [PlayerState] to [SharedPreferences].
///
/// Mixed into the PlayerNotifier so persistence logic is separated
/// from playback control logic.
mixin PlayerStatePersistence {
  static const _keyCurrentTrack = 'player_current_track';
  static const _keyQueue = 'player_queue';
  static const _keyCurrentIndex = 'player_current_index';
  static const _keyPosition = 'player_position_ms';
  static const _keyPlayMode = 'player_play_mode';
  static const _keyPlaylistName = 'player_playlist_name';
  static const _keyPlaylistId = 'player_playlist_id';
  static const _keyVolume = 'player_volume';

  /// Subclass must provide the current [PlayerState].
  PlayerState get state;

  /// Persist current playback state to shared preferences.
  Future<void> persistState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final track = state.currentTrack;
      if (track != null) {
        await prefs.setString(_keyCurrentTrack, jsonEncode(track.toJson()));
        await prefs.setString(
          _keyQueue,
          jsonEncode(state.queue.map((t) => t.toJson()).toList()),
        );
        await prefs.setInt(_keyCurrentIndex, state.currentIndex);
        await prefs.setInt(_keyPosition, state.position.inMilliseconds);
        await prefs.setInt(_keyPlayMode, state.playMode.index);
        await prefs.setDouble(_keyVolume, state.volume);
        if (state.playlistName != null) {
          await prefs.setString(_keyPlaylistName, state.playlistName!);
        }
        if (state.playlistId != null) {
          await prefs.setInt(_keyPlaylistId, state.playlistId!);
        }
      }
    } catch (e) {
      AppLogger.error('Failed to persist player state',
          tag: 'Player', error: e);
    }
  }

  /// Restore playback state from shared preferences.
  ///
  /// Returns the restored [PlayerState] or `null` if nothing was saved.
  Future<PlayerState?> restoreState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final trackJson = prefs.getString(_keyCurrentTrack);
      if (trackJson == null) return null;

      final track = AudioTrack.fromJson(
        jsonDecode(trackJson) as Map<String, dynamic>,
      );

      final queueJson = prefs.getString(_keyQueue);
      List<AudioTrack> queue = [track];
      if (queueJson != null) {
        final queueList = jsonDecode(queueJson) as List;
        queue = queueList
            .map((e) => AudioTrack.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      final currentIndex = prefs.getInt(_keyCurrentIndex) ?? 0;
      final positionMs = prefs.getInt(_keyPosition) ?? 0;
      final playModeIndex = prefs.getInt(_keyPlayMode) ?? 0;
      final volume = prefs.getDouble(_keyVolume) ?? 1.0;
      final playlistName = prefs.getString(_keyPlaylistName);
      final playlistId = prefs.getInt(_keyPlaylistId);

      return PlayerState(
        currentTrack: track,
        queue: queue,
        currentIndex: currentIndex.clamp(0, queue.length - 1),
        position: Duration(milliseconds: positionMs),
        duration: track.duration,
        isPlaying: false,
        playMode: PlayMode
            .values[playModeIndex.clamp(0, PlayMode.values.length - 1)],
        volume: volume,
        playlistName: playlistName,
        playlistId: playlistId,
      );
    } catch (e) {
      AppLogger.error('Failed to restore player state',
          tag: 'Player', error: e);
      return null;
    }
  }
}
