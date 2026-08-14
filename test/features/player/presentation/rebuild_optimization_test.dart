import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/core/database/app_database.dart';
import 'package:busic/core/services/audio_handler.dart';
import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/playlist/presentation/playlist_detail_screen.dart';
import 'package:busic/features/player/application/player_notifier.dart';
import 'package:busic/features/player/data/player_repository.dart';
import 'package:busic/features/player/domain/models/audio_track.dart';
import 'package:busic/features/player/domain/models/play_mode.dart';
import 'package:busic/features/player/domain/models/player_state.dart';
import 'package:busic/features/player/presentation/full_player_screen.dart';
import 'package:busic/features/player/presentation/player_bar.dart';
import 'package:busic/features/search_and_parse/data/parse_repository.dart';
import 'package:busic/features/search_and_parse/domain/models/audio_stream_info.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_folder.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_item.dart';
import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/domain/models/video_tag.dart';
import 'package:busic/main.dart';

import '../../../test_helpers/test_app.dart';

/// 渲染性能回归：播放 position tick（60Hz）不应重建大组件。
///
/// 播放过程中 `PlayerNotifier` 每个 tick 都会 `copyWith(position:)`，
/// 若组件全量 watch 就会整树重建。
///
/// 测试原理：[_MirrorCounter] 与大组件 watch **同一切片**（select 相同），
/// 因此它的 build 次数 == 大组件的 build 次数。断言 tick 不改变 counter，
/// 等价于断言大组件不随 tick 重建；切歌/暂停等正向控制仍会增长。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late _FakePlayerRepository repo;
  late _FakeAudioHandler audioHandler;
  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = _FakePlayerRepository();
    audioHandler = _FakeAudioHandler();
    container = _buildContainer(db, repo, audioHandler);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Widget wrap(Widget child) {
    return UncontrolledProviderScope(
      container: container,
      child: buildTestApp(child),
    );
  }

  /// 每秒发出一个 position tick；秒级变化足以让时间标签可见更新，
  /// 同时模拟持续播放的连续状态流。
  Future<void> emitTicks(WidgetTester tester, int count) async {
    for (var i = 1; i <= count; i++) {
      repo.emitPosition(Duration(seconds: i));
      await tester.pump();
    }
  }

  int countOf(WidgetTester tester) {
    return tester.state<_MirrorCounterState>(find.byType(_MirrorCounter)).count;
  }

  /// 正向控制：切换播放状态必然改变 isPlaying / currentTrack，
  /// 对应的大组件应当重建（counter 增长）。
  ///
  /// 不能在测试体内直接 `await` 播放器命令：恢复播放路径里存在
  /// `Future.delayed(seekDelay)` 等零时长 timer，fake async 时钟下必须
  /// 先 `pump()` 推进时钟，timer 才会触发，命令 Future 才会完成。
  Future<void> togglePlayback(WidgetTester tester) async {
    final done = container.read(playerNotifierProvider.notifier).togglePlayback();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await done;
    await tester.pump();
  }

  group('播放 position tick 不重建大组件', () {
    testWidgets('PlayerBar 桌面端：tick 只更新进度/时间叶节点', (tester) async {
      // 桌面视口：isDesktop 需要宽度 >= 840 才渲染时间标签。
      tester.view.physicalSize = const Size(1200, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      _seedPlayerPreferences(track: _track(songId: 1, title: '底栏曲目'));

      await tester.pumpWidget(
        wrap(
          _MirrorCounter(
            selector: (s) => (
              s.currentTrack,
              s.isPlaying,
              s.playMode,
              s.playlistName,
              s.volume,
            ),
            builder: (_) => const SizedBox(
              width: 1200,
              height: 64,
              child: PlayerBar(),
            ),
          ),
        ),
      );
      await _settle(tester);

      // 正向控制：切播放状态仍触发重建（此时 position=0，恢复播放不触发
      // seek 延时，可被 pump 驱动的零时长 timer 完成）
      await togglePlayback(tester);
      final afterToggle = countOf(tester);
      expect(afterToggle, greaterThan(1));

      // 播放中持续 8 个 position tick：PlayerBar 不应随之重建
      await emitTicks(tester, 8);
      expect(countOf(tester), afterToggle);
      // 但时间标签已跟随 position 更新（60Hz 叶节点按需重建）
      expect(find.text('0:08 / 3:00'), findsOneWidget);
    });

    testWidgets('FullPlayerScreen：tick 不重建全屏（含模糊背景）', (tester) async {
      // 竖屏视口，避免宽屏布局的 section switcher 溢出。
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      _seedPlayerPreferences(track: _track(songId: 2, title: '全屏曲目'));

      await tester.pumpWidget(
        wrap(
          _MirrorCounter(
            selector: (s) => s.currentTrack,
            builder: (_) => const FullPlayerScreen(),
          ),
        ),
      );
      await _settle(tester);

      final before = countOf(tester);

      await emitTicks(tester, 8);
      expect(countOf(tester), before);

      // 正向控制：切歌触发 currentTrack 变化 → 重建
      await container
          .read(playerNotifierProvider.notifier)
          .playTrack(_track(songId: 3, title: '切歌后的曲目'));
      await _settle(tester);
      expect(countOf(tester), greaterThan(before));
    });

    testWidgets('PlaylistDetailScreen：tick 不重建整张歌曲列表', (tester) async {
      final playlistId = await _seedPlaylistWithSongs(db);
      _seedPlayerPreferences(track: _track(songId: 1, title: '歌单曲目'));

      await tester.pumpWidget(
        wrap(
          _MirrorCounter(
            selector: (s) => (s.currentTrack?.songId, s.isPlaying),
            builder: (_) => PlaylistDetailScreen(playlistId: playlistId),
          ),
        ),
      );
      await _settle(tester);

      // 等待歌曲数据异步加载完成
      await tester.pump(const Duration(milliseconds: 100));
      await _settle(tester);
      expect(find.byType(PlaylistDetailScreen), findsOneWidget);
      expect(find.text('歌单内歌曲A'), findsOneWidget);

      // 正向控制：播放状态变化（isPlaying 翻转）→ 重建
      await togglePlayback(tester);
      final afterToggle = countOf(tester);
      expect(afterToggle, greaterThan(1));

      // 播放中持续 8 个 position tick：整张歌曲列表不应随之重建
      await emitTicks(tester, 8);
      expect(countOf(tester), afterToggle);
    });
  });
}

ProviderContainer _buildContainer(
  AppDatabase db,
  _FakePlayerRepository repo,
  _FakeAudioHandler audioHandler,
) {
  return ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      audioHandlerProvider.overrideWithValue(audioHandler),
      playerRepositoryProvider.overrideWithValue(repo),
      playerParseRepositoryProvider.overrideWithValue(_FakeParseRepository()),
      playerResumeSeekDelayProvider.overrideWithValue(Duration.zero),
      playerFadeDelayProvider.overrideWithValue((_) async {}),
    ],
  );
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump();
}

void _seedPlayerPreferences({required AudioTrack track}) {
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
  required String title,
}) {
  return AudioTrack(
    songId: songId,
    bvid: 'BVtest0001',
    cid: songId + 100,
    title: title,
    artist: '测试歌手',
    duration: const Duration(minutes: 3),
  );
}

Future<int> _seedPlaylistWithSongs(AppDatabase db) async {
  final playlistId = await db.into(db.playlists).insert(
        PlaylistsCompanion.insert(
          name: '性能测试歌单',
          sortOrder: const Value(1),
        ),
      );
  for (var i = 0; i < 5; i++) {
    final songId = await db.into(db.songs).insert(
          SongsCompanion.insert(
            bvid: 'BVperf000$i',
            cid: i + 1,
            originTitle: '歌单内歌曲${String.fromCharCode(65 + i)}',
            originArtist: '测试歌手',
          ),
        );
    await db.into(db.playlistSongs).insert(
          PlaylistSongsCompanion.insert(
            playlistId: playlistId,
            songId: songId,
          ),
        );
  }
  return playlistId;
}

/// 镜像大组件 watch 的 select 切片；build 次数与大组件一致。
///
/// 大组件（PlayerBar / FullPlayerScreen / PlaylistDetailScreen）都只 watch
/// 各自切片，因此只要它们在同一帧内重建，counter 也必然同帧重建。
class _MirrorCounter extends ConsumerStatefulWidget {
  const _MirrorCounter({required this.selector, required this.builder});

  final Object? Function(PlayerState state) selector;
  final WidgetBuilder builder;

  @override
  ConsumerState<_MirrorCounter> createState() => _MirrorCounterState();
}

class _MirrorCounterState extends ConsumerState<_MirrorCounter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    ref.watch(playerNotifierProvider.select(widget.selector));
    count++;
    return widget.builder(context);
  }
}

class _FakePlayerRepository implements PlayerRepository {
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _playingController = StreamController<bool>.broadcast();
  final _completedController = StreamController<void>.broadcast();

  void emitPosition(Duration position) => _positionController.add(position);

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
  Future<void> pause() async => _playingController.add(false);

  @override
  Future<void> play(AudioTrack track) async {
    _playingController.add(true);
    _durationController.add(track.duration);
  }

  @override
  Future<void> resume() async => _playingController.add(true);

  @override
  Future<void> seek(Duration position) async {
    _positionController.add(position);
  }

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> stop() async => _playingController.add(false);
}

class _FakeParseRepository implements ParseRepository {
  @override
  Future<({String imgKey, String subKey})> fetchWbiKeys() {
    throw UnimplementedError();
  }

  @override
  Future<List<AudioStreamInfo>> getAvailableQualities(String bvid, int cid) {
    throw UnimplementedError();
  }

  @override
  Future<AudioStreamInfo> getAudioStream(
    String bvid,
    int cid, {
    int? quality,
  }) async {
    return const AudioStreamInfo(
      url: 'https://example.com/audio.m4s',
      quality: 30280,
    );
  }

  @override
  Future<List<BiliFavFolder>> getFavoriteFolders(int mid) {
    throw UnimplementedError();
  }

  @override
  Future<List<BiliFavFolder>> getCollectedFavoriteFolders(
    int mid, {
    int page = 1,
    int pageSize = 20,
  }) {
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
