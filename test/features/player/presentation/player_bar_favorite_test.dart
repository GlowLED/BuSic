import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/core/database/app_database.dart';
import 'package:busic/core/services/audio_handler.dart';
import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/player/application/player_notifier.dart';
import 'package:busic/features/player/data/player_repository.dart';
import 'package:busic/features/player/domain/models/audio_track.dart';
import 'package:busic/features/player/domain/models/play_mode.dart';
import 'package:busic/features/player/presentation/player_bar.dart';
import 'package:busic/features/player/presentation/widgets/draggable_progress_bar.dart';
import 'package:busic/features/search_and_parse/data/parse_repository.dart';
import 'package:busic/features/search_and_parse/domain/models/audio_stream_info.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_folder.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_item.dart';
import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/domain/models/video_tag.dart';
import 'package:busic/main.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late _FakePlayerRepository fakePlayerRepository;
  late _FakeAudioHandler fakeAudioHandler;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    fakePlayerRepository = _FakePlayerRepository();
    fakeAudioHandler = _FakeAudioHandler();
  });

  tearDown(() async {
    await db.close();
  });

  group('PlayerBar 收藏状态', () {
    testWidgets('冷启动恢复已收藏歌曲时显示红心', (tester) async {
      final songId = await _seedSong(
        db,
        bvid: 'BVfavcold01',
        cid: 1001,
        title: '冷启动收藏曲目',
      );
      await _seedFavorite(db, songId);
      await _seedPlayerPreferences(
        track: _track(
          songId: songId,
          bvid: 'BVfavcold01',
          cid: 1001,
          title: '冷启动收藏曲目',
        ),
      );

      await tester.pumpWidget(
        _buildSubject(
          db: db,
          fakeAudioHandler: fakeAudioHandler,
          fakePlayerRepository: fakePlayerRepository,
        ),
      );
      await _settle(tester);

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);

      final icon = tester.widget<Icon>(find.byIcon(Icons.favorite));
      expect(icon.color, Colors.redAccent);
    });

    testWidgets('冷启动恢复未收藏歌曲时仍显示空心爱心', (tester) async {
      final songId = await _seedSong(
        db,
        bvid: 'BVplaincold01',
        cid: 1002,
        title: '冷启动普通曲目',
      );
      await _seedPlayerPreferences(
        track: _track(
          songId: songId,
          bvid: 'BVplaincold01',
          cid: 1002,
          title: '冷启动普通曲目',
        ),
      );

      await tester.pumpWidget(
        _buildSubject(
          db: db,
          fakeAudioHandler: fakeAudioHandler,
          fakePlayerRepository: fakePlayerRepository,
        ),
      );
      await _settle(tester);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });
  });

  group('PlayerBar 移动端布局', () {
    testWidgets('使用紧凑控制并移除可拖动进度条', (tester) async {
      final songId = await _seedSong(
        db,
        bvid: 'BVmobilebar01',
        cid: 2001,
        title: '移动端标题',
      );
      await _seedPlayerPreferences(
        track: _track(
          songId: songId,
          bvid: 'BVmobilebar01',
          cid: 2001,
          title: '移动端标题',
          artist: '移动端作者',
        ),
      );

      await tester.pumpWidget(
        _buildSubject(
          db: db,
          fakeAudioHandler: fakeAudioHandler,
          fakePlayerRepository: fakePlayerRepository,
          width: 390,
        ),
      );
      await _settle(tester);

      expect(find.byType(DraggableProgressBar), findsNothing);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.queue_music), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
      expect(find.byIcon(Icons.comment_outlined), findsNothing);
      expect(find.byIcon(Icons.skip_previous), findsNothing);
      expect(find.byIcon(Icons.skip_next), findsNothing);
      expect(find.byIcon(Icons.arrow_forward), findsNothing);
      expect(find.byIcon(Icons.repeat), findsNothing);
      expect(find.byIcon(Icons.repeat_one), findsNothing);
      expect(find.byIcon(Icons.shuffle), findsNothing);

      final trackText = tester.widget<Text>(
        find.byKey(const ValueKey('player_bar_mobile_track_text')),
      );
      expect(trackText.textSpan?.toPlainText(), '移动端标题 - 移动端作者');
      expect(trackText.maxLines, 1);
      expect(trackText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('队列按钮打开播放队列', (tester) async {
      final songId = await _seedSong(
        db,
        bvid: 'BVmobilebar02',
        cid: 2002,
        title: '队列测试曲目',
      );
      await _seedPlayerPreferences(
        track: _track(
          songId: songId,
          bvid: 'BVmobilebar02',
          cid: 2002,
          title: '队列测试曲目',
        ),
      );

      await tester.pumpWidget(
        _buildSubject(
          db: db,
          fakeAudioHandler: fakeAudioHandler,
          fakePlayerRepository: fakePlayerRepository,
          width: 390,
        ),
      );
      await _settle(tester);

      await tester.tap(find.byIcon(Icons.queue_music));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Queue'), findsOneWidget);
      expect(find.text('(1)'), findsOneWidget);
    });

    testWidgets('record cover rotates only while playing', (tester) async {
      final songId = await _seedSong(
        db,
        bvid: 'BVmobilebar03',
        cid: 2003,
        title: 'Record rotation',
      );
      await _seedPlayerPreferences(
        track: _track(
          songId: songId,
          bvid: 'BVmobilebar03',
          cid: 2003,
          title: 'Record rotation',
          artist: 'Rotation artist',
        ),
      );

      await tester.pumpWidget(
        _buildSubject(
          db: db,
          fakeAudioHandler: fakeAudioHandler,
          fakePlayerRepository: fakePlayerRepository,
          width: 390,
        ),
      );
      await _settle(tester);

      Transform recordTransform() {
        return tester.widget<Transform>(
          find.byKey(const ValueKey('player_bar_record_rotation')),
        );
      }

      List<double> transformStorage() {
        return List<double>.of(recordTransform().transform.storage);
      }

      expect(recordTransform().filterQuality, FilterQuality.high);
      final initialStorage = transformStorage();

      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final playingStorage = transformStorage();
      expect(playingStorage, isNot(equals(initialStorage)));

      await tester.pump(const Duration(seconds: 1));

      expect(transformStorage(), isNot(equals(playingStorage)));

      await tester.tap(find.byIcon(Icons.pause));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final pausedStorage = transformStorage();

      await tester.pump(const Duration(seconds: 1));

      expect(transformStorage(), pausedStorage);
    });
  });
}

Widget _buildSubject({
  required AppDatabase db,
  required _FakeAudioHandler fakeAudioHandler,
  required _FakePlayerRepository fakePlayerRepository,
  double width = 720,
}) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      audioHandlerProvider.overrideWithValue(fakeAudioHandler),
      playerRepositoryProvider.overrideWithValue(fakePlayerRepository),
      playerParseRepositoryProvider.overrideWithValue(_FakeParseRepository()),
      playerResumeSeekDelayProvider.overrideWithValue(Duration.zero),
    ],
    child: buildTestApp(
      SizedBox(
        width: width,
        child: const PlayerBar(),
      ),
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump();
}

Future<int> _seedSong(
  AppDatabase db, {
  required String bvid,
  required int cid,
  required String title,
}) {
  return db.into(db.songs).insert(
        SongsCompanion.insert(
          bvid: bvid,
          cid: cid,
          originTitle: title,
          originArtist: '测试歌手',
        ),
      );
}

Future<void> _seedFavorite(AppDatabase db, int songId) async {
  final playlistId = await db.into(db.playlists).insert(
        PlaylistsCompanion.insert(
          name: '@@favorites@@',
          isFavorite: const Value(true),
          sortOrder: const Value(-1),
        ),
      );
  await db.into(db.playlistSongs).insert(
        PlaylistSongsCompanion.insert(
          playlistId: playlistId,
          songId: songId,
        ),
      );
}

Future<void> _seedPlayerPreferences({
  required AudioTrack track,
}) async {
  SharedPreferences.setMockInitialValues({
    'player_current_track': jsonEncode(track.toJson()),
    'player_queue': jsonEncode([track.toJson()]),
    'player_current_index': 0,
    'player_position_ms': 0,
    'player_play_mode': PlayMode.sequential.index,
    'player_volume': 1.0,
  });
}

AudioTrack _track({
  required int songId,
  required String bvid,
  required int cid,
  required String title,
  String artist = '测试歌手',
}) {
  return AudioTrack(
    songId: songId,
    bvid: bvid,
    cid: cid,
    title: title,
    artist: artist,
    duration: const Duration(minutes: 3),
  );
}

class _FakePlayerRepository implements PlayerRepository {
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _playingController = StreamController<bool>.broadcast();
  final _completedController = StreamController<void>.broadcast();

  @override
  Stream<void> get completedStream => _completedController.stream;

  @override
  Stream<Duration> get durationStream => _durationController.stream;

  @override
  Stream<bool> get playingStream => _playingController.stream;

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Future<void> dispose() async {
    await _positionController.close();
    await _durationController.close();
    await _playingController.close();
    await _completedController.close();
  }

  @override
  Future<void> pause() async {
    _playingController.add(false);
  }

  @override
  Future<void> play(AudioTrack track) async {
    _playingController.add(true);
    _durationController.add(track.duration);
  }

  @override
  Future<void> resume() async {
    _playingController.add(true);
  }

  @override
  Future<void> seek(Duration position) async {
    _positionController.add(position);
  }

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> stop() async {
    _playingController.add(false);
  }
}

class _FakeParseRepository implements ParseRepository {
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
    return streamInfo;
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
  Future<List<VideoTag>> getVideoTags(String bvid) {
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

class _FakeAudioHandler extends BusicAudioHandler {}
