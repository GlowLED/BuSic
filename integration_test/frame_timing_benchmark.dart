import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/core/database/app_database.dart';
import 'package:busic/core/services/audio_handler.dart';
import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/player/application/player_notifier.dart';
import 'package:busic/features/player/data/player_repository.dart';
import 'package:busic/features/player/domain/models/audio_track.dart';
import 'package:busic/features/player/domain/models/play_mode.dart';
import 'package:busic/features/player/presentation/player_bar.dart';
import 'package:busic/features/search_and_parse/data/parse_repository.dart';
import 'package:busic/features/search_and_parse/domain/models/audio_stream_info.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_folder.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_item.dart';
import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/domain/models/video_tag.dart';
import 'package:busic/main.dart';

import '../test/test_helpers/test_app.dart';

/// 前端渲染性能 FrameTiming 基准（macOS 桌面真机）。
///
/// 在真实渲染管线里驱动 PlayerBar + 60Hz position tick，采集每帧的
/// build/layout 与 raster 耗时，输出平均值与最差帧。运行方式：
///
/// ```sh
/// flutter test integration_test/frame_timing_benchmark.dart -d macos
/// ```
///
/// 优化前/后各跑一次对比 avg build(ms) 与 worst build(ms)：优化后
/// build 耗时应显著下降（position tick 不再重建整个播放栏）。
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PlayerBar 60Hz position tick 帧耗时基准', (tester) async {
    // 桌面视口：isDesktop 需要宽度 >= 840。
    tester.view.physicalSize = const Size(1200, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    const track = AudioTrack(
      songId: 1,
      bvid: 'BVbench0001',
      cid: 101,
      title: '基准曲目',
      artist: '基准歌手',
      duration: Duration(minutes: 3),
    );
    SharedPreferences.setMockInitialValues({
      'player_current_track': jsonEncode(track),
      'player_queue': jsonEncode([track]),
      'player_current_index': 0,
      'player_position_ms': 0,
      'player_play_mode': PlayMode.sequential.index,
      'player_volume': 1.0,
    });

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = _FakePlayerRepository();
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        audioHandlerProvider.overrideWithValue(_FakeAudioHandler()),
        playerRepositoryProvider.overrideWithValue(repo),
        playerParseRepositoryProvider.overrideWithValue(_FakeParseRepository()),
        playerResumeSeekDelayProvider.overrideWithValue(Duration.zero),
        playerFadeDelayProvider.overrideWithValue((_) async {}),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: buildTestApp(
          const SizedBox(width: 1200, height: 64, child: PlayerBar()),
        ),
      ),
    );
    // 让 restore 异步完成后进入稳定帧
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // 收集后续帧的 FrameTiming
    final timings = <FrameTiming>[];
    binding.addTimingsCallback((frames) => timings.addAll(frames));

    // 60Hz position tick，持续 ~3 秒
    const tickCount = 180;
    for (var i = 1; i <= tickCount; i++) {
      repo.emitPosition(Duration(milliseconds: (i * 1000 / 60).round()));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await tester.pumpAndSettle();

    final buildTimes = timings
        .map((t) => t.buildDuration.inMicroseconds / 1000)
        .toList()
      ..sort();
    if (buildTimes.isEmpty) {
      fail('未采集到任何 FrameTiming（请确认在真实设备/桌面端运行）');
    }

    double sum(List<double> xs) =>
        xs.fold(0, (a, b) => a + b);
    final avgBuild = sum(buildTimes) / buildTimes.length;
    final p95 = buildTimes[(buildTimes.length * 0.95).floor()];

    // ignore: avoid_print
    print(
      '[BENCH] frames=${buildTimes.length} '
      'avg_build=${avgBuild.toStringAsFixed(2)}ms '
      'p95_build=${p95.toStringAsFixed(2)}ms '
      'worst_build=${buildTimes.last.toStringAsFixed(2)}ms',
    );
    // 集成测试结果落盘，便于脚本对比。
    final out = File('build/frame_timing_benchmark_result.txt');
    out.createSync(recursive: true);
    out.writeAsStringSync(
      'frames=${buildTimes.length}\n'
      'avg_build_ms=${avgBuild.toStringAsFixed(2)}\n'
      'p95_build_ms=${p95.toStringAsFixed(2)}\n'
      'worst_build_ms=${buildTimes.last.toStringAsFixed(2)}\n',
    );

    // 弱断言：仅保证渲染管线有输出（真实对比靠前后两次运行）。
    expect(buildTimes.length, greaterThan(60));
    expect(tester.takeException(), isNull);
  });
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
