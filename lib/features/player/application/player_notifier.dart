import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/audio_handler.dart';
import '../../../core/utils/logger.dart';
import '../../../main.dart';
import '../../auth/application/auth_notifier.dart';
import '../../download/application/download_notifier.dart';
import '../../playlist/domain/models/song_item.dart';
import '../../search_and_parse/data/parse_repository.dart';
import '../../search_and_parse/data/parse_repository_impl.dart';
import '../../settings/application/settings_notifier.dart';
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
/// Persists playback state (track, queue, position) for restore on next launch.
@riverpod
class PlayerNotifier extends _$PlayerNotifier {
  late PlayerRepository _repository;
  late ParseRepository _parseRepository;
  late BusicAudioHandler _audioHandler;
  late AppDatabase _db;
  final List<StreamSubscription> _subscriptions = [];
  DateTime _lastPersist = DateTime.fromMillisecondsSinceEpoch(0);

  /// Whether the media_kit player currently has loaded media.
  /// After app restart, the player state is restored from prefs but
  /// no media is loaded — this flag prevents spurious resume calls.
  bool _hasActiveMedia = false;

  static const _keyCurrentTrack = 'player_current_track';
  static const _keyQueue = 'player_queue';
  static const _keyCurrentIndex = 'player_current_index';
  static const _keyPosition = 'player_position_ms';
  static const _keyPlayMode = 'player_play_mode';
  static const _keyPlaylistName = 'player_playlist_name';
  static const _keyPlaylistId = 'player_playlist_id';
  static const _keyVolume = 'player_volume';

  int? get _preferredQuality {
    final quality = ref.read(settingsNotifierProvider).preferredQuality;
    return quality == 0 ? null : quality;
  }

  @override
  PlayerState build() {
    _repository = PlayerRepositoryImpl();
    _parseRepository = ParseRepositoryImpl(biliDio: BiliDio());
    _audioHandler = ref.read(audioHandlerProvider);
    _db = ref.read(databaseProvider);

    // Listen for download completions and refresh queue localPaths.
    ref.listen(downloadChangeSignalProvider, (_, __) {
      _refreshQueueLocalPaths();
    });

    // Connect media button callbacks (lock screen / notification controls)
    _audioHandler.onPlay = () => resume();
    _audioHandler.onPause = () => pause();
    _audioHandler.onSkipToNext = () => next();
    _audioHandler.onSkipToPrevious = () => previous();
    _audioHandler.onSeek = (pos) => seekTo(pos);
    _audioHandler.onStop = () => pause();

    // Listen to player streams
    _subscriptions.add(
      _repository.positionStream.listen((pos) {
        state = state.copyWith(position: pos);
        // Update media session position
        _audioHandler.updatePlaybackState(
          playing: state.isPlaying,
          position: pos,
        );
        // Throttle persist to once every 5 seconds
        final now = DateTime.now();
        if (now.difference(_lastPersist).inSeconds >= 5) {
          _lastPersist = now;
          _persistState();
        }
      }),
    );
    _subscriptions.add(
      _repository.durationStream.listen((dur) {
        state = state.copyWith(duration: dur);
        // Update media session with the correct duration
        _audioHandler.setCurrentTrack(state.currentTrack, duration: dur);
      }),
    );
    _subscriptions.add(
      _repository.playingStream.listen((playing) {
        state = state.copyWith(isPlaying: playing);
        _audioHandler.updatePlaybackState(
          playing: playing,
          position: state.position,
        );
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

    // Restore last session asynchronously
    _restoreState();

    return const PlayerState();
  }

  /// Query the database for the latest localPath of a song.
  /// Returns the path only if it exists on disk; otherwise returns null.
  Future<String?> _getFreshLocalPath(int songId) async {
    final song = await (_db.select(_db.songs)
          ..where((t) => t.id.equals(songId)))
        .getSingleOrNull();
    final path = song?.localPath;
    if (path == null) return null;
    try {
      if (await File(path).exists()) return path;
    } catch (_) {
      // Ignore file-system errors
    }
    return null;
  }

  /// Refresh localPath for all tracks in the current queue from the database.
  /// Called when downloads complete so offline playback uses cached files.
  Future<void> _refreshQueueLocalPaths() async {
    if (state.queue.isEmpty) return;
    var changed = false;
    final updatedQueue = List<AudioTrack>.from(state.queue);
    for (int i = 0; i < updatedQueue.length; i++) {
      final track = updatedQueue[i];
      if (track.localPath != null) continue; // already has local path
      final freshPath = await _getFreshLocalPath(track.songId);
      if (freshPath != null) {
        updatedQueue[i] = track.copyWith(localPath: freshPath);
        changed = true;
      }
    }
    if (changed) {
      final currentTrack = state.currentIndex < updatedQueue.length
          ? updatedQueue[state.currentIndex]
          : state.currentTrack;
      state = state.copyWith(queue: updatedQueue, currentTrack: currentTrack);
      AppLogger.info('Refreshed queue local paths after download', tag: 'Player');
    }
  }

  /// Persist current playback state to shared preferences.
  Future<void> _persistState() async {
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
      AppLogger.error('Failed to persist player state', tag: 'Player', error: e);
    }
  }

  /// Restore last session's playback state (paused).
  Future<void> _restoreState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final trackJson = prefs.getString(_keyCurrentTrack);
      if (trackJson == null) return;

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

      state = state.copyWith(
        currentTrack: track,
        queue: queue,
        currentIndex: currentIndex.clamp(0, queue.length - 1),
        position: Duration(milliseconds: positionMs),
        duration: track.duration,
        isPlaying: false,
        playMode: PlayMode.values[playModeIndex.clamp(0, PlayMode.values.length - 1)],
        volume: volume,
        playlistName: playlistName,
        playlistId: playlistId,
      );

      // Set volume on the player engine
      await _repository.setVolume(volume);

      AppLogger.info(
        'Restored last session: ${track.title}',
        tag: 'Player',
      );
    } catch (e) {
      AppLogger.error('Failed to restore player state', tag: 'Player', error: e);
    }
  }

  /// Update the platform media session (notification, lock screen controls).
  void _updateMediaSession(AudioTrack track) {
    _audioHandler.setCurrentTrack(track);
    _audioHandler.updatePlaybackState(
      playing: true,
      position: Duration.zero,
    );
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

    _updateMediaSession(track);
    await _repository.play(track);
    _hasActiveMedia = true;
  }

  /// Play a list of [AudioTrack]s starting from [index].
  ///
  /// The track at [index] is resolved for immediate playback;
  /// others will be resolved when they become current.
  Future<void> playTrackList(
    List<AudioTrack> tracks,
    int index, {
    String? playlistName,
  }) async {
    if (tracks.isEmpty) return;
    index = index.clamp(0, tracks.length - 1);

    var track = tracks[index];
    // Refresh localPath from DB and verify file exists
    if (track.localPath == null) {
      final freshPath = await _getFreshLocalPath(track.songId);
      if (freshPath != null) {
        track = track.copyWith(localPath: freshPath);
      }
    }
    // Resolve stream URL if not already available
    if (track.streamUrl == null && track.localPath == null) {
      final streamInfo = await _parseRepository.getAudioStream(
        track.bvid,
        track.cid,
        quality: _preferredQuality,
      );
      track = track.copyWith(
        streamUrl: streamInfo.url,
        quality: streamInfo.quality,
      );
    }

    final queue = List<AudioTrack>.from(tracks)..[index] = track;
    state = state.copyWith(
      currentTrack: track,
      queue: queue,
      currentIndex: index,
      position: Duration.zero,
      playlistId: null,
      playlistName: playlistName,
    );

    _updateMediaSession(track);
    await _repository.play(track);
    _hasActiveMedia = true;
  }

  /// Convert a [SongItem] to an [AudioTrack] by resolving the audio stream URL.
  ///
  /// Checks the database for the latest localPath (the song may have been
  /// downloaded since the [SongItem] was fetched) and verifies the file exists.
  Future<AudioTrack> _resolveAudioTrack(SongItem song) async {
    // Always check DB for the latest localPath and verify file exists.
    // This handles both freshly-downloaded songs and stale SongItem data.
    final effectiveLocalPath = await _getFreshLocalPath(song.id);

    String? streamUrl;
    int quality = song.audioQuality;

    if (effectiveLocalPath == null) {
      try {
        final streamInfo = await _parseRepository.getAudioStream(
          song.bvid,
          song.cid,
          quality: _preferredQuality,
        );
        streamUrl = streamInfo.url;
        quality = streamInfo.quality;
      } catch (e) {
        AppLogger.error('Failed to resolve stream for ${song.bvid}', tag: 'Player', error: e);
        rethrow;
      }
    }
    return AudioTrack(
      songId: song.id,
      bvid: song.bvid,
      cid: song.cid,
      title: song.displayTitle,
      artist: song.displayArtist,
      coverUrl: song.coverUrl,
      duration: Duration(seconds: song.duration),
      streamUrl: streamUrl,
      localPath: effectiveLocalPath,
      quality: quality,
    );
  }

  /// Play a song from a playlist, building the queue from the song list.
  Future<void> playSongFromPlaylist({
    required SongItem song,
    required List<SongItem> songs,
    required int playlistId,
    String? playlistName,
  }) async {
    final index = songs.indexWhere((s) => s.id == song.id);

    // Resolve current song first for immediate playback
    final track = await _resolveAudioTrack(song);

    // Build queue with placeholder tracks (will resolve on play)
    final queue = songs.map((s) => AudioTrack(
      songId: s.id,
      bvid: s.bvid,
      cid: s.cid,
      title: s.displayTitle,
      artist: s.displayArtist,
      coverUrl: s.coverUrl,
      duration: Duration(seconds: s.duration),
      streamUrl: s.id == song.id ? track.streamUrl : null,
      localPath: s.localPath,
      quality: s.audioQuality,
    )).toList();

    // Update the resolved track in queue
    if (index >= 0) {
      queue[index] = track;
    }

    state = state.copyWith(
      currentTrack: track,
      queue: queue,
      currentIndex: index >= 0 ? index : 0,
      position: Duration.zero,
      playlistId: playlistId,
      playlistName: playlistName,
    );

    _updateMediaSession(track);
    await _repository.play(track);
    _hasActiveMedia = true;
  }

  /// Pause the current playback.
  Future<void> pause() async {
    await _repository.pause();
  }

  /// Resume the current playback.
  ///
  /// If the player has no active media (e.g. restored from saved state),
  /// resolves the stream URL and starts playback from the saved position.
  /// Always checks the database for the latest localPath so that songs
  /// downloaded after the queue was built can be played offline.
  Future<void> resume() async {
    final track = state.currentTrack;
    if (track == null) return;

    // Check if the player needs to load the media first (restored state)
    if (!_hasActiveMedia) {
      var playableTrack = track;

      // Refresh localPath from DB — the song may have been downloaded
      // after the queue was built or after the state was persisted.
      if (playableTrack.localPath == null) {
        final freshPath = await _getFreshLocalPath(playableTrack.songId);
        if (freshPath != null) {
          playableTrack = playableTrack.copyWith(localPath: freshPath);
        }
      }

      if (playableTrack.streamUrl == null && playableTrack.localPath == null) {
        try {
          final streamInfo = await _parseRepository.getAudioStream(
            playableTrack.bvid,
            playableTrack.cid,
            quality: _preferredQuality,
          );
          playableTrack = playableTrack.copyWith(
            streamUrl: streamInfo.url,
            quality: streamInfo.quality,
          );
        } catch (e) {
          AppLogger.error('Failed to resolve stream for resume',
              tag: 'Player', error: e);
          return;
        }
      }

      // Update in queue & state
      final updatedQueue = List<AudioTrack>.from(state.queue);
      if (state.currentIndex < updatedQueue.length) {
        updatedQueue[state.currentIndex] = playableTrack;
      }
      state = state.copyWith(
        currentTrack: playableTrack,
        queue: updatedQueue,
      );

      final savedPosition = state.position;
      await _repository.play(playableTrack);
      _hasActiveMedia = true;
      // Seek to saved position after a short delay for media to load
      if (savedPosition > Duration.zero) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _repository.seek(savedPosition);
        });
      }
      return;
    }

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

    var track = state.queue[nextIndex];

    // Refresh localPath from DB in case the song was downloaded after
    // the queue was built.
    if (track.localPath == null) {
      final freshPath = await _getFreshLocalPath(track.songId);
      if (freshPath != null) {
        track = track.copyWith(localPath: freshPath);
      }
    }

    // Resolve stream URL if no local file available
    if (track.streamUrl == null && track.localPath == null) {
      try {
        final streamInfo = await _parseRepository.getAudioStream(
          track.bvid,
          track.cid,
          quality: _preferredQuality,
        );
        track = track.copyWith(
          streamUrl: streamInfo.url,
          quality: streamInfo.quality,
        );
      } catch (e) {
        AppLogger.error('Failed to resolve next track', tag: 'Player', error: e);
        return;
      }
    }
    final updatedQueue = List<AudioTrack>.from(state.queue);
    updatedQueue[nextIndex] = track;
    state = state.copyWith(
      queue: updatedQueue,
      currentTrack: track,
      currentIndex: nextIndex,
      position: Duration.zero,
    );
    _updateMediaSession(track);
    await _repository.play(track);
    _hasActiveMedia = true;
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

    var track = state.queue[prevIndex];

    // Refresh localPath from DB in case the song was downloaded after
    // the queue was built.
    if (track.localPath == null) {
      final freshPath = await _getFreshLocalPath(track.songId);
      if (freshPath != null) {
        track = track.copyWith(localPath: freshPath);
      }
    }

    // Resolve stream URL if no local file available
    if (track.streamUrl == null && track.localPath == null) {
      try {
        final streamInfo = await _parseRepository.getAudioStream(
          track.bvid,
          track.cid,
          quality: _preferredQuality,
        );
        track = track.copyWith(
          streamUrl: streamInfo.url,
          quality: streamInfo.quality,
        );
      } catch (e) {
        AppLogger.error('Failed to resolve prev track', tag: 'Player', error: e);
        return;
      }
    }
    final updatedQueue = List<AudioTrack>.from(state.queue);
    updatedQueue[prevIndex] = track;
    state = state.copyWith(
      queue: updatedQueue,
      currentTrack: track,
      currentIndex: prevIndex,
      position: Duration.zero,
    );
    _updateMediaSession(track);
    await _repository.play(track);
    _hasActiveMedia = true;
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
