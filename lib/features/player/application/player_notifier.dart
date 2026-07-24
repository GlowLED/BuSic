import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:busic/core/services/mpris_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
import 'playback_fade_controller.dart';
import 'player_state_persistence.dart';

part 'player_notifier.g.dart';

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  return PlayerRepositoryImpl();
});

final playerParseRepositoryProvider = Provider<ParseRepository>((ref) {
  return ParseRepositoryImpl(biliDio: BiliDio());
});

final playerMprisServiceProvider = Provider<MprisService?>((ref) {
  return Platform.isLinux ? MprisService() : null;
});

final playerResumeSeekDelayProvider = Provider<Duration>((ref) {
  return const Duration(milliseconds: 300);
});

final playerFadeTickIntervalProvider = Provider<Duration>((ref) {
  return const Duration(milliseconds: 50);
});

final playerFadeDelayProvider = Provider<PlaybackFadeDelay>((ref) {
  return (duration) => Future<void>.delayed(duration);
});

/// State notifier managing the audio player lifecycle.
///
/// Controls playback, queue management, and mode switching.
/// Listens to the [PlayerRepository] streams and updates [PlayerState] accordingly.
/// Persists playback state (track, queue, position) for restore on next launch.
@Riverpod(name: 'playerNotifierProvider', keepAlive: true)
class PlayerNotifier extends _$PlayerNotifier with PlayerStatePersistence {
  late PlayerRepository _repository;
  late ParseRepository _parseRepository;
  late BusicAudioHandler _audioHandler;
  late PlaybackFadeController _fadeController;
  MprisService? _mprisService;
  late AppDatabase _db;
  final List<StreamSubscription> _subscriptions = [];
  DateTime _lastPersist = DateTime.fromMillisecondsSinceEpoch(0);
  int _playbackCommandGeneration = 0;
  Future<void> _transportTail = Future<void>.value();
  bool _engineIsPlaying = false;
  bool _naturalFadeActive = false;
  String? _naturalFadeTrackKey;
  Duration? _naturalFadeWindow;

  /// Whether the media_kit player currently has loaded media.
  /// After app restart, the player state is restored from prefs but
  /// no media is loaded — this flag prevents spurious resume calls.
  bool _hasActiveMedia = false;

  int? get _preferredQuality {
    final quality = ref.read(settingsNotifierProvider).preferredQuality;
    return quality == 0 ? null : quality;
  }

  @override
  PlayerState build() {
    _repository = ref.read(playerRepositoryProvider);
    _parseRepository = ref.read(playerParseRepositoryProvider);
    _audioHandler = ref.read(audioHandlerProvider);
    _fadeController = PlaybackFadeController(
      setVolume: _repository.setVolume,
      tickInterval: ref.read(playerFadeTickIntervalProvider),
      delay: ref.read(playerFadeDelayProvider),
    );
    _mprisService = ref.read(playerMprisServiceProvider);
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
    _audioHandler.onStop = () => stop();

    ref.listen(
      settingsNotifierProvider.select(
        (settings) => settings.playbackFadeEnabled,
      ),
      (_, enabled) {
        if (!enabled) {
          _naturalFadeActive = false;
          _naturalFadeTrackKey = null;
          _naturalFadeWindow = null;
          unawaited(_fadeController.setImmediate(state.volume));
        }
      },
    );

    _mprisService?.init(
      onPlay: () => resume(),
      onPause: () => pause(),
      onNext: () => next(),
      onPrevious: () => previous(),
      onSeek: (pos) => seekTo(pos),
      setVolume: (volume) => setVolume(volume),
      setMode: (mode) => setMode(mode),
    );
    // Listen to player streams
    _subscriptions.add(
      _repository.positionStream.listen((pos) {
        state = state.copyWith(position: pos);
        _updateNaturalFade(pos);
        // Update media session position
        _audioHandler.updatePlaybackState(
          playing: state.isPlaying,
          position: pos,
        );
        _mprisService?.updatePlaybackStatus(state.isPlaying);
        _mprisService?.updatePosition(pos);
        // Throttle persist to once every 5 seconds
        final now = DateTime.now();
        if (now.difference(_lastPersist).inSeconds >= 5) {
          _lastPersist = now;
          persistState();
        }
      }),
    );
    _subscriptions.add(
      _repository.durationStream.listen((dur) {
        state = state.copyWith(duration: dur);
        // Update media session with the correct duration
        _audioHandler.setCurrentTrack(state.currentTrack, duration: dur);
        _mprisService?.updateCurrentTrack(state.currentTrack, duration: dur);
      }),
    );
    _subscriptions.add(
      _repository.playingStream.listen((playing) {
        // Engine events can arrive after a newer user command. Keep the
        // physical state for transport reconciliation, but never let a stale
        // event overwrite the UI-facing playback intent.
        _engineIsPlaying = playing;
      }),
    );
    _subscriptions.add(
      _repository.completedStream.listen((_) {
        unawaited(_onTrackCompleted());
      }),
    );

    ref.onDispose(() {
      for (final sub in _subscriptions) {
        sub.cancel();
      }
      _repository.dispose();
      _fadeController.dispose();
      _mprisService?.dispose();
    });

    // Restore last session asynchronously
    _initRestore();

    return const PlayerState();
  }

  /// Kick off the asynchronous restore of last session's state.
  Future<void> _initRestore() async {
    final restoreCommand = _playbackCommandGeneration;
    final restored = await restoreState();
    if (restored != null &&
        ref.mounted &&
        restoreCommand == _playbackCommandGeneration) {
      state = restored;
      await _fadeController.setImmediate(restored.volume);
      AppLogger.info(
        'Restored last session: ${restored.currentTrack?.title}',
        tag: 'Player',
      );
    }
  }

  /// Query the database for the latest localPath of a song.
  /// Returns the path only if it exists on disk; otherwise returns null.
  Future<String?> _getFreshLocalPath(int songId) async {
    final song = await (_db.select(
      _db.songs,
    )..where((t) => t.id.equals(songId))).getSingleOrNull();
    final path = song?.localPath;
    if (path == null) return null;
    if (await _localFileExists(path)) return path;
    return null;
  }

  Future<bool> _localFileExists(String path) async {
    try {
      return await File(path).exists();
    } catch (_) {
      // Ignore file-system errors
    }
    return false;
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
      AppLogger.info(
        'Refreshed queue local paths after download',
        tag: 'Player',
      );
    }
  }

  /// Ensure a track is playable by refreshing its local path from DB
  /// and resolving the stream URL if no local file is available.
  ///
  /// This consolidates the repeated "check localPath → resolve stream"
  /// pattern used in [resume], [next], [previous], and [playTrackList].
  Future<AudioTrack> _ensurePlayable(AudioTrack track) async {
    // Refresh localPath from DB — the song may have been downloaded
    // after the queue was built or after state was persisted.
    final freshPath = await _getFreshLocalPath(track.songId);
    if (freshPath != null) {
      track = track.copyWith(localPath: freshPath, streamUrl: null);
    } else if (track.localPath != null &&
        !await _localFileExists(track.localPath!)) {
      track = track.copyWith(localPath: null);
    }

    // Resolve stream URL if no local file is available. Restored player state
    // deliberately does not trust persisted Bilibili stream URLs because they
    // can expire across app launches.
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

    return track;
  }

  /// Update the platform media session (notification, lock screen controls).
  void _updateMediaSession(AudioTrack track) {
    _audioHandler.setCurrentTrack(track);
    _audioHandler.updatePlaybackState(
      playing: state.isPlaying,
      position: state.position,
    );
    _mprisService?.updateCurrentTrack(track, duration: state.duration);
    _mprisService?.updatePlaybackStatus(state.isPlaying);
    _mprisService?.updatePosition(state.position);
  }

  bool get _playbackFadeEnabled {
    return ref.read(settingsNotifierProvider).playbackFadeEnabled;
  }

  Duration get _playbackFadeDuration {
    final durationMs = ref
        .read(settingsNotifierProvider)
        .playbackFadeDurationMs;
    return Duration(milliseconds: max(0, durationMs));
  }

  int _beginPlaybackCommand() {
    _playbackCommandGeneration++;
    _naturalFadeActive = false;
    _naturalFadeTrackKey = null;
    _naturalFadeWindow = null;
    _fadeController.cancel();
    return _playbackCommandGeneration;
  }

  bool _isCurrentPlaybackCommand(int command) {
    return command == _playbackCommandGeneration;
  }

  void _setPlaybackIntent(bool playing, {Duration? position}) {
    final nextPosition = position ?? state.position;
    state = state.copyWith(isPlaying: playing, position: nextPosition);
    _audioHandler.updatePlaybackState(playing: playing, position: nextPosition);
    _mprisService?.updatePlaybackStatus(playing);
    _mprisService?.updatePosition(nextPosition);
  }

  Future<bool> _runTransportCommand(
    int command,
    Future<void> Function() operation, {
    bool? resultingPlaying,
    bool skipIfEngineStateMatches = false,
  }) {
    final result = Completer<bool>();
    final previousCommand = _transportTail;

    _transportTail = () async {
      await previousCommand;
      if (!_isCurrentPlaybackCommand(command)) {
        result.complete(false);
        return;
      }
      if (skipIfEngineStateMatches &&
          resultingPlaying != null &&
          _engineIsPlaying == resultingPlaying) {
        result.complete(true);
        return;
      }

      try {
        await operation();
        if (resultingPlaying != null) {
          _engineIsPlaying = resultingPlaying;
        }
        result.complete(_isCurrentPlaybackCommand(command));
      } catch (error, stackTrace) {
        result.completeError(error, stackTrace);
      }
    }();

    return result.future;
  }

  Duration _fadeDurationTo(double target) {
    final configuredMicros = _playbackFadeDuration.inMicroseconds;
    final referenceVolume = state.volume.clamp(0, 1).toDouble();
    if (configuredMicros <= 0 || referenceVolume <= 0.0001) {
      return Duration.zero;
    }

    final distance = (target - _fadeController.effectiveVolume).abs();
    final ratio = (distance / referenceVolume).clamp(0.0, 1.0);
    return Duration(microseconds: (configuredMicros * ratio).round());
  }

  Future<bool> _fadeOutForCommand(int command, {bool shouldFade = true}) async {
    if (!_isCurrentPlaybackCommand(command)) return false;
    if (!_playbackFadeEnabled ||
        !_hasActiveMedia ||
        !shouldFade ||
        _fadeController.effectiveVolume <= 0.0001) {
      return true;
    }

    final completed = await _fadeController.fadeTo(
      target: 0,
      duration: _fadeDurationTo(0),
      phase: PlaybackFadePhase.fadeOut,
    );
    if (!completed &&
        _isCurrentPlaybackCommand(command) &&
        !_playbackFadeEnabled) {
      return true;
    }
    return completed && _isCurrentPlaybackCommand(command);
  }

  Future<bool> _fadeInForCommand(int command) async {
    if (!_isCurrentPlaybackCommand(command)) return false;
    if (!_playbackFadeEnabled) {
      return true;
    }

    final completed = await _fadeController.fadeTo(
      target: state.volume,
      duration: _fadeDurationTo(state.volume),
      phase: PlaybackFadePhase.fadeIn,
      targetProvider: () => state.volume,
    );
    return completed && _isCurrentPlaybackCommand(command);
  }

  Future<bool> _transitionToTrack({
    required AudioTrack track,
    required PlayerState nextState,
    required int command,
    bool fadeOutCurrent = true,
  }) async {
    final previousState = state;
    final previousHasActiveMedia = _hasActiveMedia;
    final previousEffectiveVolume = _fadeController.effectiveVolume;
    final shouldFadeCurrent = _engineIsPlaying || previousState.isPlaying;
    _setPlaybackIntent(true);

    try {
      if (fadeOutCurrent &&
          !await _fadeOutForCommand(command, shouldFade: shouldFadeCurrent)) {
        return false;
      }
      if (!_isCurrentPlaybackCommand(command)) return false;

      state = nextState.copyWith(
        currentTrack: track,
        position: Duration.zero,
        duration: track.duration,
        isPlaying: true,
      );
      _updateMediaSession(track);

      await _fadeController.setImmediate(
        _playbackFadeEnabled ? 0 : state.volume,
      );
      if (!_isCurrentPlaybackCommand(command)) return false;

      final opened = await _runTransportCommand(command, () async {
        await _repository.play(track);
        _hasActiveMedia = true;
      }, resultingPlaying: true);
      if (!opened) return false;

      _naturalFadeActive = false;
      _naturalFadeTrackKey = null;
      _naturalFadeWindow = null;
      await _fadeInForCommand(command);
      return _isCurrentPlaybackCommand(command);
    } catch (error) {
      if (_isCurrentPlaybackCommand(command)) {
        state = previousState;
        _hasActiveMedia = previousHasActiveMedia;
        _audioHandler.setCurrentTrack(
          previousState.currentTrack,
          duration: previousState.duration,
        );
        _setPlaybackIntent(
          previousState.isPlaying,
          position: previousState.position,
        );
        await _fadeController.setImmediate(previousEffectiveVolume);
      }
      AppLogger.error(
        'Failed to open playback track',
        tag: 'Player',
        error: error,
      );
      rethrow;
    }
  }

  /// Play a specific track, optionally replacing the queue.
  Future<void> playTrack(AudioTrack track, {List<AudioTrack>? queue}) async {
    final command = _beginPlaybackCommand();
    final newQueue = queue ?? [track];
    final index = newQueue.indexOf(track);

    await _transitionToTrack(
      track: track,
      command: command,
      nextState: state.copyWith(
        queue: newQueue,
        currentIndex: index >= 0 ? index : 0,
      ),
    );
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
    final command = _beginPlaybackCommand();
    index = index.clamp(0, tracks.length - 1);

    var track = await _ensurePlayable(tracks[index]);
    if (!_isCurrentPlaybackCommand(command)) return;

    final queue = List<AudioTrack>.from(tracks)..[index] = track;
    await _transitionToTrack(
      track: track,
      command: command,
      nextState: state.copyWith(
        queue: queue,
        currentIndex: index,
        playlistId: null,
        playlistName: playlistName,
      ),
    );
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
        AppLogger.error(
          'Failed to resolve stream for ${song.bvid}',
          tag: 'Player',
          error: e,
        );
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
    final command = _beginPlaybackCommand();
    final index = songs.indexWhere((s) => s.id == song.id);

    // Resolve current song first for immediate playback
    final track = await _resolveAudioTrack(song);
    if (!_isCurrentPlaybackCommand(command)) return;

    // Build queue with placeholder tracks (will resolve on play)
    final queue = songs
        .map(
          (s) => AudioTrack(
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
          ),
        )
        .toList();

    // Update the resolved track in queue
    if (index >= 0) {
      queue[index] = track;
    }

    await _transitionToTrack(
      track: track,
      command: command,
      nextState: state.copyWith(
        queue: queue,
        currentIndex: index >= 0 ? index : 0,
        playlistId: playlistId,
        playlistName: playlistName,
      ),
    );
  }

  /// Toggle the latest playback intent.
  ///
  /// The decision lives in the notifier so repeated taps before the next
  /// widget rebuild always observe the newest intent instead of a stale UI
  /// snapshot.
  Future<void> togglePlayback() {
    return state.isPlaying ? pause() : resume();
  }

  /// Pause the current playback.
  Future<void> pause() async {
    if (!state.isPlaying) return;

    final shouldFade = _engineIsPlaying || state.isPlaying;
    final command = _beginPlaybackCommand();
    _setPlaybackIntent(false);

    try {
      if (!await _fadeOutForCommand(command, shouldFade: shouldFade)) return;
      if (!_isCurrentPlaybackCommand(command)) return;
      await _runTransportCommand(
        command,
        _repository.pause,
        resultingPlaying: false,
        skipIfEngineStateMatches: true,
      );
    } catch (error) {
      if (_isCurrentPlaybackCommand(command)) {
        _setPlaybackIntent(true);
        try {
          await _runTransportCommand(
            command,
            _repository.resume,
            resultingPlaying: true,
          );
          await _fadeInForCommand(command);
        } catch (_) {
          // Preserve the original pause error after best-effort recovery.
        }
      }
      rethrow;
    }
  }

  /// Stop playback and reset the current position.
  Future<void> stop() async {
    final wasPlaying = state.isPlaying;
    final shouldFade = _engineIsPlaying || wasPlaying;
    final command = _beginPlaybackCommand();
    _setPlaybackIntent(false);

    try {
      if (!await _fadeOutForCommand(command, shouldFade: shouldFade)) return;
      if (!_isCurrentPlaybackCommand(command)) return;

      final stopped = await _runTransportCommand(
        command,
        _repository.stop,
        resultingPlaying: false,
      );
      if (!stopped) return;

      _hasActiveMedia = false;
      _setPlaybackIntent(false, position: Duration.zero);
      await persistState();
    } catch (error) {
      if (_isCurrentPlaybackCommand(command)) {
        _setPlaybackIntent(wasPlaying);
        if (wasPlaying) {
          try {
            await _runTransportCommand(
              command,
              _repository.resume,
              resultingPlaying: true,
            );
            await _fadeInForCommand(command);
          } catch (_) {
            // Preserve the original stop error after best-effort recovery.
          }
        }
      }
      rethrow;
    }
  }

  /// Resume the current playback.
  ///
  /// If the player has no active media (e.g. restored from saved state),
  /// resolves the stream URL and starts playback from the saved position.
  /// Always checks the database for the latest localPath so that songs
  /// downloaded after the queue was built can be played offline.
  Future<void> resume() async {
    final track = state.currentTrack;
    if (track == null || state.isPlaying) return;
    final command = _beginPlaybackCommand();
    _setPlaybackIntent(true);

    // Check if the player needs to load the media first (restored state)
    if (!_hasActiveMedia) {
      AudioTrack playableTrack;
      try {
        playableTrack = await _ensurePlayable(track);
      } catch (e) {
        if (_isCurrentPlaybackCommand(command)) {
          _setPlaybackIntent(false);
        }
        AppLogger.error(
          'Failed to resolve stream for resume',
          tag: 'Player',
          error: e,
        );
        return;
      }
      if (!_isCurrentPlaybackCommand(command)) return;

      // Update in queue & state
      final updatedQueue = List<AudioTrack>.from(state.queue);
      if (state.currentIndex < updatedQueue.length) {
        updatedQueue[state.currentIndex] = playableTrack;
      }
      final savedPosition = state.position;
      state = state.copyWith(currentTrack: playableTrack, queue: updatedQueue);
      _updateMediaSession(playableTrack);

      try {
        await _fadeController.setImmediate(
          _playbackFadeEnabled ? 0 : state.volume,
        );
        if (!_isCurrentPlaybackCommand(command)) return;

        final opened = await _runTransportCommand(command, () async {
          await _repository.play(playableTrack);
          _hasActiveMedia = true;
        }, resultingPlaying: true);
        if (!opened) return;

        // Keep restored playback silent until its saved position is applied.
        if (savedPosition > Duration.zero) {
          final seekDelay = ref.read(playerResumeSeekDelayProvider);
          await Future<void>.delayed(seekDelay);
          if (!_isCurrentPlaybackCommand(command)) return;
          await _repository.seek(savedPosition);
        }
        await _fadeInForCommand(command);
      } catch (error) {
        if (_isCurrentPlaybackCommand(command)) {
          _setPlaybackIntent(false);
          await _fadeController.setImmediate(state.volume);
        }
        rethrow;
      }
      return;
    }

    try {
      final resumed = await _runTransportCommand(
        command,
        _repository.resume,
        resultingPlaying: true,
        skipIfEngineStateMatches: true,
      );
      if (!resumed) return;
      await _fadeInForCommand(command);
    } catch (error) {
      if (_isCurrentPlaybackCommand(command)) {
        _setPlaybackIntent(false);
        try {
          await _runTransportCommand(
            command,
            _repository.pause,
            resultingPlaying: false,
          );
        } catch (_) {
          // Preserve the original resume error after best-effort recovery.
        }
        await _fadeController.setImmediate(
          _playbackFadeEnabled ? 0 : state.volume,
        );
      }
      rethrow;
    }
  }

  /// Skip to the next track in the queue.
  Future<void> next() async {
    final command = _beginPlaybackCommand();
    await _next(command, fadeOutCurrent: true);
  }

  Future<void> _next(int command, {required bool fadeOutCurrent}) async {
    if (state.queue.isEmpty || !_isCurrentPlaybackCommand(command)) return;

    final nextIndex = _getNextIndex();
    if (nextIndex == null) {
      // Sequential mode, last track finished: stop and reset to first track.
      _setPlaybackIntent(false);
      if (fadeOutCurrent &&
          !await _fadeOutForCommand(
            command,
            shouldFade: _engineIsPlaying || state.isPlaying,
          )) {
        return;
      }
      if (!_isCurrentPlaybackCommand(command)) return;
      final stopped = await _runTransportCommand(
        command,
        _repository.stop,
        resultingPlaying: false,
      );
      if (!stopped) return;
      _hasActiveMedia = false;
      final firstTrack = state.queue.isNotEmpty ? state.queue.first : null;
      state = state.copyWith(
        isPlaying: false,
        currentIndex: 0,
        currentTrack: firstTrack,
        position: Duration.zero,
        duration: firstTrack?.duration ?? Duration.zero,
      );
      _setPlaybackIntent(false, position: Duration.zero);
      if (firstTrack != null) {
        _audioHandler.setCurrentTrack(
          firstTrack,
          duration: firstTrack.duration,
        );
      }
      await persistState();
      return;
    }

    var track = state.queue[nextIndex];

    try {
      track = await _ensurePlayable(track);
    } catch (e) {
      AppLogger.error('Failed to resolve next track', tag: 'Player', error: e);
      return;
    }
    if (!_isCurrentPlaybackCommand(command)) return;

    final updatedQueue = List<AudioTrack>.from(state.queue);
    updatedQueue[nextIndex] = track;
    await _transitionToTrack(
      track: track,
      command: command,
      fadeOutCurrent: fadeOutCurrent,
      nextState: state.copyWith(queue: updatedQueue, currentIndex: nextIndex),
    );
  }

  /// Skip to the previous track in the queue.
  Future<void> previous() async {
    if (state.queue.isEmpty) return;
    final command = _beginPlaybackCommand();

    // If past 3 seconds, restart current track
    if (state.position.inSeconds > 3) {
      final wasPlaying = state.isPlaying;
      if (wasPlaying && !await _fadeOutForCommand(command, shouldFade: true)) {
        return;
      }
      if (!_isCurrentPlaybackCommand(command)) return;
      await _repository.seek(Duration.zero);
      if (wasPlaying && _isCurrentPlaybackCommand(command)) {
        await _fadeInForCommand(command);
      }
      return;
    }

    final prevIndex = state.currentIndex > 0
        ? state.currentIndex - 1
        : state.queue.length - 1;

    var track = state.queue[prevIndex];

    try {
      track = await _ensurePlayable(track);
    } catch (e) {
      AppLogger.error('Failed to resolve prev track', tag: 'Player', error: e);
      return;
    }
    if (!_isCurrentPlaybackCommand(command)) return;

    final updatedQueue = List<AudioTrack>.from(state.queue);
    updatedQueue[prevIndex] = track;
    await _transitionToTrack(
      track: track,
      command: command,
      nextState: state.copyWith(queue: updatedQueue, currentIndex: prevIndex),
    );
  }

  /// Seek to a specific position in the current track.
  Future<void> seekTo(Duration position) async {
    if (state.currentTrack == null) return;

    final durationMs = state.duration.inMilliseconds;
    final targetMs =
        (durationMs > 0
                ? position.inMilliseconds.clamp(0, durationMs)
                : max(0, position.inMilliseconds))
            .toInt();
    final target = Duration(milliseconds: targetMs);

    state = state.copyWith(position: target);
    _audioHandler.updatePlaybackState(
      playing: state.isPlaying,
      position: target,
    );
    await persistState();

    if (!_hasActiveMedia) return;
    await _repository.seek(target);
    _updateNaturalFade(target, positionWasSeek: true);
  }

  /// Set the playback mode (sequential, repeat, shuffle).
  void setMode(PlayMode mode) {
    state = state.copyWith(playMode: mode);
    _mprisService?.updateLoopStatus(mode);
  }

  /// Set the volume level (0.0 to 1.0).
  Future<void> setVolume(double volume) async {
    final normalized = volume.clamp(0, 1).toDouble();
    state = state.copyWith(volume: normalized);
    _mprisService?.updateVolume(normalized);

    if (!_playbackFadeEnabled) {
      await _fadeController.setImmediate(normalized);
      return;
    }

    // Fade-in reads the latest target on every step. Fade-out keeps heading
    // to silence while this value becomes the target for the next playback.
    if (_naturalFadeActive ||
        _fadeController.phase == PlaybackFadePhase.fadeIn ||
        _fadeController.phase == PlaybackFadePhase.fadeOut) {
      return;
    }

    await _fadeController.setImmediate(normalized);
  }

  /// Update the songId of the current track and its queue entry.
  ///
  /// Called after a track with `songId == 0` is persisted to the database.
  void updateCurrentTrackSongId(int newSongId) {
    final track = state.currentTrack;
    if (track == null) return;
    final updated = track.copyWith(songId: newSongId);
    final newQueue = List<AudioTrack>.from(state.queue);
    if (state.currentIndex < newQueue.length) {
      newQueue[state.currentIndex] = updated;
    }
    state = state.copyWith(queue: newQueue, currentTrack: updated);
    persistState();
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

  void _updateNaturalFade(Duration position, {bool positionWasSeek = false}) {
    final track = state.currentTrack;
    final duration = state.duration;
    if (!_playbackFadeEnabled ||
        !_hasActiveMedia ||
        !state.isPlaying ||
        track == null ||
        duration <= Duration.zero) {
      return;
    }

    final remaining = duration - position;
    final fadeDuration = _playbackFadeDuration;
    final trackKey = '${track.bvid}:${track.cid}:${state.currentIndex}';

    if (_naturalFadeActive) {
      final activeWindow = _naturalFadeWindow ?? fadeDuration;
      final movedOutsideFadeWindow = remaining > activeWindow;
      final trackChanged = _naturalFadeTrackKey != trackKey;
      if (movedOutsideFadeWindow || trackChanged) {
        _naturalFadeActive = false;
        _naturalFadeTrackKey = null;
        _naturalFadeWindow = null;
        unawaited(_fadeController.setImmediate(state.volume));
      } else if (positionWasSeek) {
        _naturalFadeActive = false;
        _naturalFadeTrackKey = null;
        _naturalFadeWindow = null;
        _fadeController.cancel();
        _startNaturalFade(trackKey, remaining, fadeDuration);
      }
      return;
    }

    if (remaining <= Duration.zero || remaining > fadeDuration) return;

    _startNaturalFade(trackKey, remaining, fadeDuration);
  }

  void _startNaturalFade(
    String trackKey,
    Duration remaining,
    Duration fadeWindow,
  ) {
    _naturalFadeActive = true;
    _naturalFadeTrackKey = trackKey;
    _naturalFadeWindow = fadeWindow;
    unawaited(
      _fadeController
          .fadeTo(
            target: 0,
            duration: remaining,
            phase: PlaybackFadePhase.fadeOut,
          )
          .then((_) {})
          .catchError((Object error, StackTrace stackTrace) {
            if (_naturalFadeTrackKey == trackKey) {
              _naturalFadeActive = false;
              _naturalFadeTrackKey = null;
              _naturalFadeWindow = null;
              unawaited(_fadeController.setImmediate(state.volume));
            }
            AppLogger.error(
              'Natural playback fade failed',
              tag: 'Player',
              error: error,
            );
          }),
    );
  }

  Future<void> _onTrackCompleted() async {
    final command = _beginPlaybackCommand();
    await _next(command, fadeOutCurrent: false);
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
