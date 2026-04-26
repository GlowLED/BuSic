import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/core/database/app_database.dart';
import 'package:busic/core/services/audio_handler.dart';
import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/download/application/download_notifier.dart';
import 'package:busic/features/player/application/player_notifier.dart';
import 'package:busic/features/player/data/player_repository.dart';
import 'package:busic/features/player/domain/models/audio_track.dart';
import 'package:busic/features/player/domain/models/play_mode.dart';
import 'package:busic/features/search_and_parse/data/parse_repository.dart';
import 'package:busic/features/search_and_parse/domain/models/audio_stream_info.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_folder.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_item.dart';
import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/domain/models/video_tag.dart';
import 'package:busic/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late _FakePlayerRepository fakePlayerRepository;
  late _FakeParseRepository fakeParseRepository;
  late _FakeAudioHandler fakeAudioHandler;
  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    fakePlayerRepository = _FakePlayerRepository();
    fakeParseRepository = _FakeParseRepository();
    fakeAudioHandler = _FakeAudioHandler();
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        audioHandlerProvider.overrideWithValue(fakeAudioHandler),
        playerRepositoryProvider.overrideWithValue(fakePlayerRepository),
        playerParseRepositoryProvider.overrideWithValue(fakeParseRepository),
        playerResumeSeekDelayProvider.overrideWithValue(Duration.zero),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  group('PlayerNotifier 可测试性回归', () {
    test('恢复持久化状态后会同步音量到播放器仓储', () async {
      final track = _track(songId: 7, title: '恢复曲目');
      final queue = [
        track,
        _track(songId: 8, title: '队列第二首'),
      ];
      await _seedPlayerPreferences(
        track: track,
        queue: queue,
        currentIndex: 0,
        position: const Duration(seconds: 12),
        playMode: PlayMode.repeatAll,
        volume: 0.42,
        playlistId: 3,
        playlistName: '恢复歌单',
      );

      final state = container.read(playerNotifierProvider);
      expect(state.currentTrack, isNull);

      await _settle();

      final restored = container.read(playerNotifierProvider);
      expect(restored.currentTrack?.title, '恢复曲目');
      expect(restored.queue, hasLength(2));
      expect(restored.position, const Duration(seconds: 12));
      expect(restored.playMode, PlayMode.repeatAll);
      expect(restored.volume, 0.42);
      expect(fakePlayerRepository.volumeCalls, [0.42]);
    });

    test('resume 会先回填数据库 localPath，再按保存位置 seek', () async {
      final tempDir = await Directory.systemTemp.createTemp('player_resume_');
      final localFile = File('${tempDir.path}/cached_track.m4s');
      await localFile.writeAsString('cached');

      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BVresume01',
              cid: 456,
              originTitle: '缓存歌曲',
              originArtist: '作者',
              localPath: Value(localFile.path),
            ),
          );

      final track = _track(
        songId: songId,
        bvid: 'BVresume01',
        cid: 456,
        title: '待恢复歌曲',
      );
      await _seedPlayerPreferences(
        track: track,
        queue: [track],
        currentIndex: 0,
        position: const Duration(milliseconds: 2500),
        playMode: PlayMode.sequential,
        volume: 0.8,
      );

      container.read(playerNotifierProvider);
      await _settle();

      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.resume();
      await _settle();

      expect(fakeParseRepository.getAudioStreamCalls, 0);
      expect(fakePlayerRepository.playedTracks, hasLength(1));
      expect(
          fakePlayerRepository.playedTracks.single.localPath, localFile.path);
      expect(
          fakePlayerRepository.seekCalls, [const Duration(milliseconds: 2500)]);

      final state = container.read(playerNotifierProvider);
      expect(state.currentTrack?.localPath, localFile.path);

      await tempDir.delete(recursive: true);
    });

    test('下载完成信号会刷新队列中的最新 localPath', () async {
      final tempDir = await Directory.systemTemp.createTemp('player_refresh_');
      final localFile = File('${tempDir.path}/fresh_track.m4s');
      await localFile.writeAsString('fresh');

      final songId = await db.into(db.songs).insert(
            SongsCompanion.insert(
              bvid: 'BVrefresh01',
              cid: 5001,
              originTitle: '刷新歌曲',
              originArtist: '作者',
              localPath: Value(localFile.path),
            ),
          );

      final track = _track(
        songId: songId,
        bvid: 'BVrefresh01',
        cid: 5001,
        title: '下载前曲目',
      );

      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);

      container.read(downloadChangeSignalProvider.notifier).state++;
      await _settle();

      final state = container.read(playerNotifierProvider);
      expect(state.queue.single.localPath, localFile.path);
      expect(state.currentTrack?.localPath, localFile.path);

      await tempDir.delete(recursive: true);
    });

    test('顺序模式最后一首 next 会停止播放并重置到队列首项', () async {
      final first = _track(songId: 1, title: '第一首');
      final second = _track(songId: 2, title: '第二首');
      final notifier = container.read(playerNotifierProvider.notifier);

      await notifier.playTrack(second, queue: [first, second]);
      await notifier.next();
      await _settle();

      final state = container.read(playerNotifierProvider);
      expect(fakePlayerRepository.stopCallCount, 1);
      expect(state.currentIndex, 0);
      expect(state.currentTrack?.title, '第一首');
      expect(state.isPlaying, isFalse);
      expect(state.position, Duration.zero);
      expect(fakeAudioHandler.lastPlaying, isFalse);
      expect(fakeAudioHandler.lastPosition, Duration.zero);
      expect(fakeAudioHandler.lastTrack?.title, '第一首');
    });

    test('当前位置超过 3 秒时 previous 只 seek 到开头，不切歌', () async {
      final first = _track(songId: 1, title: '第一首');
      final second = _track(songId: 2, title: '第二首');
      final notifier = container.read(playerNotifierProvider.notifier);

      await notifier.playTrack(second, queue: [first, second]);
      fakePlayerRepository.emitPosition(const Duration(seconds: 4));
      await _settle();

      await notifier.previous();
      await _settle();

      final state = container.read(playerNotifierProvider);
      expect(fakePlayerRepository.seekCalls.last, Duration.zero);
      expect(fakePlayerRepository.playedTracks, hasLength(1));
      expect(state.currentIndex, 1);
      expect(state.currentTrack?.title, '第二首');
    });
  });
}

Future<void> _settle() async {
  await Future<void>.delayed(const Duration(milliseconds: 30));
}

Future<void> _seedPlayerPreferences({
  required AudioTrack track,
  required List<AudioTrack> queue,
  required int currentIndex,
  required Duration position,
  required PlayMode playMode,
  required double volume,
  int? playlistId,
  String? playlistName,
}) async {
  SharedPreferences.setMockInitialValues({
    'player_current_track': jsonEncode(track.toJson()),
    'player_queue': jsonEncode(queue.map((item) => item.toJson()).toList()),
    'player_current_index': currentIndex,
    'player_position_ms': position.inMilliseconds,
    'player_play_mode': playMode.index,
    'player_volume': volume,
    if (playlistId != null) 'player_playlist_id': playlistId,
    if (playlistName != null) 'player_playlist_name': playlistName,
  });
}

AudioTrack _track({
  required int songId,
  required String title,
  String bvid = 'BVplayer01',
  int cid = 1001,
  String artist = '测试歌手',
  String? localPath,
  String? streamUrl,
}) {
  return AudioTrack(
    songId: songId,
    bvid: bvid,
    cid: cid,
    title: title,
    artist: artist,
    duration: const Duration(minutes: 3),
    localPath: localPath,
    streamUrl: streamUrl,
  );
}

class _FakePlayerRepository implements PlayerRepository {
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _playingController = StreamController<bool>.broadcast();
  final _completedController = StreamController<void>.broadcast();

  final List<AudioTrack> playedTracks = [];
  final List<Duration> seekCalls = [];
  final List<double> volumeCalls = [];
  int stopCallCount = 0;

  void emitPosition(Duration position) {
    _positionController.add(position);
  }

  @override
  Stream<void> get completedStream => _completedController.stream;

  @override
  Future<void> dispose() async {
    await _positionController.close();
    await _durationController.close();
    await _playingController.close();
    await _completedController.close();
  }

  @override
  Stream<Duration> get durationStream => _durationController.stream;

  @override
  Future<void> pause() async {
    _playingController.add(false);
  }

  @override
  Future<void> play(AudioTrack track) async {
    playedTracks.add(track);
    _playingController.add(true);
    _durationController.add(track.duration);
  }

  @override
  Stream<bool> get playingStream => _playingController.stream;

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Future<void> resume() async {
    _playingController.add(true);
  }

  @override
  Future<void> seek(Duration position) async {
    seekCalls.add(position);
    _positionController.add(position);
  }

  @override
  Future<void> setVolume(double volume) async {
    volumeCalls.add(volume);
  }

  @override
  Future<void> stop() async {
    stopCallCount++;
    _playingController.add(false);
  }
}

class _FakeParseRepository implements ParseRepository {
  int getAudioStreamCalls = 0;
  AudioStreamInfo streamInfo = const AudioStreamInfo(
    url: 'https://example.com/audio.m4s',
    quality: 30280,
  );

  @override
  Future<({String imgKey, String subKey})> fetchWbiKeys() {
    throw UnimplementedError();
  }

  @override
  Future<List<AudioStreamInfo>> getAvailableQualities(
    String bvid,
    int cid,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<AudioStreamInfo> getAudioStream(
    String bvid,
    int cid, {
    int? quality,
  }) async {
    getAudioStreamCalls++;
    return streamInfo;
  }

  @override
  Future<List<VideoTag>> getVideoTags(String bvid) {
    throw UnimplementedError();
  }

  @override
  Future<List<BiliFavFolder>> getFavoriteFolders(int mid) {
    throw UnimplementedError();
  }

  @override
  Future<List<BiliFavItem>> getFavoriteFolderItems(
    int mediaId, {
    void Function(int fetched, int total)? onProgress,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BvidInfo> getVideoInfo(String bvid) {
    throw UnimplementedError();
  }

  @override
  Future<({List<BvidInfo> results, int numPages})> searchVideos(
    String keyword, {
    int page = 1,
    int pageSize = 20,
  }) {
    throw UnimplementedError();
  }
}

class _FakeAudioHandler extends BusicAudioHandler {
  AudioTrack? lastTrack;
  Duration? lastTrackDuration;
  bool? lastPlaying;
  Duration? lastPosition;

  @override
  void setCurrentTrack(AudioTrack? track, {Duration? duration}) {
    lastTrack = track;
    lastTrackDuration = duration ?? track?.duration;
  }

  @override
  void updatePlaybackState({
    required bool playing,
    required Duration position,
    Duration? bufferedPosition,
  }) {
    lastPlaying = playing;
    lastPosition = position;
  }
}
