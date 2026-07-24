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
  late _SwitchableFadeDelay fadeDelay;
  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    fakePlayerRepository = _FakePlayerRepository();
    fakeParseRepository = _FakeParseRepository();
    fakeAudioHandler = _FakeAudioHandler();
    fadeDelay = _SwitchableFadeDelay();
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        audioHandlerProvider.overrideWithValue(fakeAudioHandler),
        playerRepositoryProvider.overrideWithValue(fakePlayerRepository),
        playerParseRepositoryProvider.overrideWithValue(fakeParseRepository),
        playerMprisServiceProvider.overrideWithValue(null),
        playerResumeSeekDelayProvider.overrideWithValue(Duration.zero),
        playerFadeTickIntervalProvider.overrideWithValue(
          const Duration(milliseconds: 500),
        ),
        playerFadeDelayProvider.overrideWithValue(fadeDelay.call),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  group('PlayerNotifier 可测试性回归', () {
    test('MPRIS 未启用时销毁 notifier 不抛异常', () async {
      final localContainer = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          audioHandlerProvider.overrideWithValue(fakeAudioHandler),
          playerRepositoryProvider.overrideWithValue(fakePlayerRepository),
          playerParseRepositoryProvider.overrideWithValue(fakeParseRepository),
          playerMprisServiceProvider.overrideWithValue(null),
          playerResumeSeekDelayProvider.overrideWithValue(Duration.zero),
          playerFadeTickIntervalProvider.overrideWithValue(
            const Duration(milliseconds: 500),
          ),
          playerFadeDelayProvider.overrideWithValue(fadeDelay.call),
        ],
      );

      localContainer.read(playerNotifierProvider);
      await _settle();

      expect(localContainer.dispose, returnsNormally);
    });

    test('恢复持久化状态后会同步音量到播放器仓储', () async {
      final track = _track(songId: 7, title: '恢复曲目');
      final queue = [track, _track(songId: 8, title: '队列第二首')];
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

      final songId = await db
          .into(db.songs)
          .insert(
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
        fakePlayerRepository.playedTracks.single.localPath,
        localFile.path,
      );
      expect(fakePlayerRepository.seekCalls, [
        const Duration(milliseconds: 2500),
      ]);

      final state = container.read(playerNotifierProvider);
      expect(state.currentTrack?.localPath, localFile.path);

      await tempDir.delete(recursive: true);
    });

    test('resume 会忽略恢复状态中的旧 streamUrl 并重新解析', () async {
      final track = _track(
        songId: 11,
        bvid: 'BVstale01',
        cid: 1101,
        title: '过期流地址歌曲',
        streamUrl: 'https://example.com/stale.m4s',
      );
      fakeParseRepository.streamInfo = const AudioStreamInfo(
        url: 'https://example.com/fresh.m4s',
        quality: 30280,
      );
      await _seedPlayerPreferences(
        track: track,
        queue: [track],
        currentIndex: 0,
        position: const Duration(seconds: 8),
        playMode: PlayMode.sequential,
        volume: 1,
      );

      container.read(playerNotifierProvider);
      await _settle();

      final restored = container.read(playerNotifierProvider);
      expect(restored.currentTrack?.streamUrl, isNull);
      expect(restored.queue.single.streamUrl, isNull);

      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.resume();
      await _settle();

      expect(fakeParseRepository.getAudioStreamCalls, 1);
      expect(fakePlayerRepository.playedTracks, hasLength(1));
      expect(
        fakePlayerRepository.playedTracks.single.streamUrl,
        'https://example.com/fresh.m4s',
      );
      expect(
        fakePlayerRepository.playedTracks.single.streamUrl,
        isNot('https://example.com/stale.m4s'),
      );
      expect(fakePlayerRepository.seekCalls, [const Duration(seconds: 8)]);
    });

    test('冷启动未加载媒体时 seekTo 会更新恢复进度并延后到底层 seek', () async {
      final track = _track(
        songId: 13,
        bvid: 'BVcoldseek01',
        cid: 1301,
        title: '冷启动拖动进度歌曲',
      );
      fakeParseRepository.streamInfo = const AudioStreamInfo(
        url: 'https://example.com/cold-seek-fresh.m4s',
        quality: 30280,
      );
      await _seedPlayerPreferences(
        track: track,
        queue: [track],
        currentIndex: 0,
        position: const Duration(seconds: 12),
        playMode: PlayMode.sequential,
        volume: 1,
      );

      container.read(playerNotifierProvider);
      await _settle();

      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.seekTo(const Duration(seconds: 65));
      await _settle();

      var state = container.read(playerNotifierProvider);
      expect(state.position, const Duration(seconds: 65));
      expect(fakePlayerRepository.seekCalls, isEmpty);
      expect(fakeAudioHandler.lastPosition, const Duration(seconds: 65));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('player_position_ms'), 65000);

      await notifier.resume();
      await _settle();

      state = container.read(playerNotifierProvider);
      expect(fakeParseRepository.getAudioStreamCalls, 1);
      expect(fakePlayerRepository.playedTracks, hasLength(1));
      expect(fakePlayerRepository.seekCalls, [const Duration(seconds: 65)]);
      expect(state.position, const Duration(seconds: 65));
    });

    test('已加载媒体时 seekTo 会更新状态并调用播放器 seek', () async {
      final track = _track(
        songId: 14,
        title: '已加载歌曲',
        streamUrl: 'https://example.com/loaded.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);

      await notifier.playTrack(track, queue: [track]);
      await _settle();

      await notifier.seekTo(const Duration(seconds: 30));
      await _settle();

      final state = container.read(playerNotifierProvider);
      expect(state.position, const Duration(seconds: 30));
      expect(fakePlayerRepository.seekCalls, [const Duration(seconds: 30)]);
      expect(fakeAudioHandler.lastPosition, const Duration(seconds: 30));
    });

    test('新曲从静音渐入且目标音量状态保持不变', () async {
      final track = _track(
        songId: 21,
        title: '渐入歌曲',
        streamUrl: 'https://example.com/fade-in.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await _settle();
      fakePlayerRepository.volumeCalls.clear();

      await notifier.playTrack(track, queue: [track]);

      expect(fakePlayerRepository.volumeCalls, [0, 0.5, 1]);
      expect(container.read(playerNotifierProvider).volume, 1);
      expect(fakePlayerRepository.playedTracks.single, track);
    });

    test('从暂停状态选择新曲会立即切换为播放意图', () async {
      final first = _track(
        songId: 39,
        title: '即时意图旧曲',
        streamUrl: 'https://example.com/immediate-old.m4s',
      );
      final second = _track(
        songId: 40,
        title: '即时意图新曲',
        streamUrl: 'https://example.com/immediate-new.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(first, queue: [first, second]);
      await notifier.pause();

      final playFuture = notifier.playTrack(second, queue: [first, second]);

      expect(container.read(playerNotifierProvider).isPlaying, isTrue);
      expect(fakeAudioHandler.lastPlaying, isTrue);

      await playFuture;
      expect(container.read(playerNotifierProvider).currentTrack, second);
    });

    test('暂停状态切换新曲失败时恢复原意图和实际静音音量', () async {
      final first = _track(
        songId: 41,
        title: '失败回滚旧曲',
        streamUrl: 'https://example.com/rollback-old.m4s',
      );
      final second = _track(
        songId: 42,
        title: '失败回滚新曲',
        streamUrl: 'https://example.com/rollback-new.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(first, queue: [first, second]);
      await notifier.pause();
      fakePlayerRepository.volumeCalls.clear();
      fakePlayerRepository.playError = StateError('play failed');

      await expectLater(
        notifier.playTrack(second, queue: [first, second]),
        throwsA(isA<StateError>()),
      );

      final state = container.read(playerNotifierProvider);
      expect(state.currentTrack, first);
      expect(state.isPlaying, isFalse);
      expect(fakeAudioHandler.lastPlaying, isFalse);
      expect(fakePlayerRepository.volumeCalls, isNot(contains(1)));
      expect(fakePlayerRepository.volumeCalls.last, 0);
    });

    test('暂停先渐出到静音再暂停且恢复时重新渐入', () async {
      final track = _track(
        songId: 22,
        title: '暂停渐变歌曲',
        streamUrl: 'https://example.com/pause-fade.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);
      fakePlayerRepository.volumeCalls.clear();

      await notifier.pause();
      expect(fakePlayerRepository.volumeCalls, [0.5, 0]);
      expect(container.read(playerNotifierProvider).isPlaying, isFalse);

      fakePlayerRepository.volumeCalls.clear();
      await notifier.resume();
      expect(fakePlayerRepository.volumeCalls, [0.5, 1]);
      expect(container.read(playerNotifierProvider).isPlaying, isTrue);
    });

    test('暂停点击后立即更新意图并在渐出完成后暂停引擎', () async {
      final track = _track(
        songId: 31,
        title: '即时暂停状态歌曲',
        streamUrl: 'https://example.com/immediate-pause.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);
      fakePlayerRepository.volumeCalls.clear();
      fadeDelay.gated = true;

      final pauseFuture = notifier.pause();
      await fadeDelay.waitForPendingCount(1);

      expect(container.read(playerNotifierProvider).isPlaying, isFalse);
      expect(fakeAudioHandler.lastPlaying, isFalse);
      expect(fakePlayerRepository.pauseCallCount, 0);

      fadeDelay.completeNext();
      await fadeDelay.waitForPendingCount(1);
      fadeDelay.completeNext();
      await pauseFuture;

      expect(fakePlayerRepository.volumeCalls, [0.5, 0]);
      expect(fakePlayerRepository.pauseCallCount, 1);
    });

    test('恢复点击后立即更新意图且不会先把当前音量强制归零', () async {
      final track = _track(
        songId: 32,
        title: '即时恢复状态歌曲',
        streamUrl: 'https://example.com/immediate-resume.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);
      await notifier.pause();
      fakePlayerRepository.volumeCalls.clear();
      fadeDelay.gated = true;

      final resumeFuture = notifier.resume();
      await fadeDelay.waitForPendingCount(1);

      expect(container.read(playerNotifierProvider).isPlaying, isTrue);
      expect(fakeAudioHandler.lastPlaying, isTrue);
      expect(fakePlayerRepository.resumeCallCount, 1);
      expect(fakePlayerRepository.volumeCalls, isEmpty);

      fadeDelay.completeNext();
      await fadeDelay.waitForPendingCount(1);
      fadeDelay.completeNext();
      await resumeFuture;

      expect(fakePlayerRepository.volumeCalls, [0.5, 1]);
    });

    test('渐出一半时恢复会从当前音量平滑反向且旧暂停失效', () async {
      final track = _track(
        songId: 33,
        title: '渐出反向歌曲',
        streamUrl: 'https://example.com/reverse-fade-out.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);
      fakePlayerRepository.volumeCalls.clear();
      fadeDelay.gated = true;

      final pauseFuture = notifier.pause();
      await fadeDelay.waitForPendingCount(1);
      fadeDelay.completeNext();
      await fadeDelay.waitForPendingCount(1);
      expect(fakePlayerRepository.volumeCalls, [0.5]);

      final resumeFuture = notifier.resume();
      expect(container.read(playerNotifierProvider).isPlaying, isTrue);
      await fadeDelay.waitForPendingCount(2);
      expect(fakePlayerRepository.volumeCalls, [0.5]);

      fadeDelay.completeNext();
      fadeDelay.completeNext();
      await Future.wait([pauseFuture, resumeFuture]);

      expect(fakePlayerRepository.volumeCalls, [0.5, 1]);
      expect(fakePlayerRepository.pauseCallCount, 0);
      expect(container.read(playerNotifierProvider).isPlaying, isTrue);
    });

    test('渐入一半时暂停会从当前音量平滑反向并保留暂停意图', () async {
      final track = _track(
        songId: 34,
        title: '渐入反向歌曲',
        streamUrl: 'https://example.com/reverse-fade-in.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);
      await notifier.pause();
      fakePlayerRepository.pauseCallCount = 0;
      fakePlayerRepository.volumeCalls.clear();
      fadeDelay.gated = true;

      final resumeFuture = notifier.resume();
      await fadeDelay.waitForPendingCount(1);
      fadeDelay.completeNext();
      await fadeDelay.waitForPendingCount(1);
      expect(fakePlayerRepository.volumeCalls, [0.5]);

      final pauseFuture = notifier.pause();
      expect(container.read(playerNotifierProvider).isPlaying, isFalse);
      await fadeDelay.waitForPendingCount(2);

      fadeDelay.completeNext();
      fadeDelay.completeNext();
      await Future.wait([resumeFuture, pauseFuture]);

      expect(fakePlayerRepository.volumeCalls, [0.5, 0]);
      expect(fakePlayerRepository.pauseCallCount, 1);
      expect(container.read(playerNotifierProvider).isPlaying, isFalse);
    });

    test('快速暂停播放反复点击始终以最后一次播放意图为准', () async {
      final track = _track(
        songId: 38,
        title: '快速反复点击歌曲',
        streamUrl: 'https://example.com/rapid-toggle.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);
      fakePlayerRepository.volumeCalls.clear();
      fadeDelay.gated = true;

      final pauseOne = notifier.pause();
      expect(container.read(playerNotifierProvider).isPlaying, isFalse);
      await fadeDelay.waitForPendingCount(1);

      final resumeOne = notifier.resume();
      expect(container.read(playerNotifierProvider).isPlaying, isTrue);
      final pauseTwo = notifier.pause();
      expect(container.read(playerNotifierProvider).isPlaying, isFalse);
      await fadeDelay.waitForPendingCount(2);

      final resumeTwo = notifier.resume();
      expect(container.read(playerNotifierProvider).isPlaying, isTrue);

      fadeDelay.completeNext();
      fadeDelay.completeNext();
      await Future.wait([pauseOne, resumeOne, pauseTwo, resumeTwo]);

      expect(container.read(playerNotifierProvider).isPlaying, isTrue);
      expect(fakePlayerRepository.pauseCallCount, 0);
      expect(fakePlayerRepository.volumeCalls, isNot(contains(0)));
    });

    test('旧暂停已进入引擎时恢复命令仍会在其后执行', () async {
      final track = _track(
        songId: 35,
        title: '传输串行歌曲',
        streamUrl: 'https://example.com/serialized-transport.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);
      final pauseGate = Completer<void>();
      fakePlayerRepository.pauseGate = pauseGate;

      final pauseFuture = notifier.pause();
      while (fakePlayerRepository.pauseCallCount == 0) {
        await Future<void>.delayed(Duration.zero);
      }

      final resumeFuture = notifier.resume();
      expect(container.read(playerNotifierProvider).isPlaying, isTrue);
      expect(fakePlayerRepository.resumeCallCount, 0);

      pauseGate.complete();
      await Future.wait([pauseFuture, resumeFuture]);

      expect(fakePlayerRepository.resumeCallCount, 1);
      expect(fakePlayerRepository.transportCalls, ['pause', 'resume']);
      expect(container.read(playerNotifierProvider).isPlaying, isTrue);
    });

    test('暂停失败时只回滚当前命令并恢复播放意图与音量', () async {
      final track = _track(
        songId: 36,
        title: '暂停失败恢复歌曲',
        streamUrl: 'https://example.com/pause-failure.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);
      fakePlayerRepository.volumeCalls.clear();
      fakePlayerRepository.transportCalls.clear();
      fakePlayerRepository.pauseError = StateError('pause failed');

      await expectLater(notifier.pause(), throwsA(isA<StateError>()));

      expect(container.read(playerNotifierProvider).isPlaying, isTrue);
      expect(fakeAudioHandler.lastPlaying, isTrue);
      expect(fakePlayerRepository.transportCalls, ['pause', 'resume']);
      expect(fakePlayerRepository.volumeCalls.last, 1);
    });

    test('恢复失败时回滚暂停意图并保持底层静音', () async {
      final track = _track(
        songId: 37,
        title: '恢复失败回滚歌曲',
        streamUrl: 'https://example.com/resume-failure.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);
      await notifier.pause();
      fakePlayerRepository.volumeCalls.clear();
      fakePlayerRepository.transportCalls.clear();
      fakePlayerRepository.resumeError = StateError('resume failed');

      await expectLater(notifier.resume(), throwsA(isA<StateError>()));

      expect(container.read(playerNotifierProvider).isPlaying, isFalse);
      expect(fakeAudioHandler.lastPlaying, isFalse);
      expect(fakePlayerRepository.transportCalls, ['resume', 'pause']);
      expect(fakePlayerRepository.volumeCalls, [0]);
    });

    test('手动切歌先渐出旧曲再让新曲渐入', () async {
      final first = _track(
        songId: 23,
        title: '切歌第一首',
        streamUrl: 'https://example.com/first.m4s',
      );
      final second = _track(
        songId: 24,
        title: '切歌第二首',
        streamUrl: 'https://example.com/second.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(first, queue: [first, second]);
      fakePlayerRepository.volumeCalls.clear();

      await notifier.next();

      expect(fakePlayerRepository.volumeCalls, [0.5, 0, 0, 0.5, 1]);
      expect(fakePlayerRepository.playedTracks.last.title, '切歌第二首');
      expect(container.read(playerNotifierProvider).currentIndex, 1);
    });

    test('自然结束前渐出且完成事件切歌时不重复渐出', () async {
      final first = _track(
        songId: 25,
        title: '自然结束第一首',
        streamUrl: 'https://example.com/natural-first.m4s',
      );
      final second = _track(
        songId: 26,
        title: '自然结束第二首',
        streamUrl: 'https://example.com/natural-second.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(first, queue: [first, second]);
      fakePlayerRepository.volumeCalls.clear();

      fakePlayerRepository.emitPosition(
        const Duration(minutes: 2, seconds: 59, milliseconds: 500),
      );
      await _settle();
      expect(fakePlayerRepository.volumeCalls, [0]);

      fakePlayerRepository.emitCompleted();
      await _settle();

      expect(fakePlayerRepository.volumeCalls, [0, 0, 0.5, 1]);
      expect(fakePlayerRepository.playedTracks.last.title, '自然结束第二首');
    });

    test('单曲循环自然结束后重新打开当前歌曲并渐入', () async {
      final track = _track(
        songId: 29,
        title: '单曲循环歌曲',
        streamUrl: 'https://example.com/repeat-one.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      notifier.setMode(PlayMode.repeatOne);
      await notifier.playTrack(track, queue: [track]);
      fakePlayerRepository.volumeCalls.clear();

      fakePlayerRepository.emitPosition(
        const Duration(minutes: 2, seconds: 59, milliseconds: 500),
      );
      await _settle();
      fakePlayerRepository.emitCompleted();
      await _settle();

      expect(fakePlayerRepository.playedTracks, [track, track]);
      expect(fakePlayerRepository.volumeCalls, [0, 0, 0.5, 1]);
      expect(container.read(playerNotifierProvider).currentIndex, 0);
    });

    test('从歌曲末尾跳回渐变窗口外会取消自然渐出并恢复目标音量', () async {
      final track = _track(
        songId: 30,
        title: '跳出渐变窗口歌曲',
        streamUrl: 'https://example.com/seek-out.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);
      fakePlayerRepository.volumeCalls.clear();

      fakePlayerRepository.emitPosition(
        const Duration(minutes: 2, seconds: 59, milliseconds: 500),
      );
      await _settle();
      expect(fakePlayerRepository.volumeCalls, [0]);

      await notifier.seekTo(const Duration(seconds: 30));
      await _settle();

      expect(fakePlayerRepository.volumeCalls.last, 1);
      expect(
        container.read(playerNotifierProvider).position,
        const Duration(seconds: 30),
      );
    });

    test('关闭播放渐变后播放和暂停保持即时行为', () async {
      SharedPreferences.setMockInitialValues({'playback_fade_enabled': false});
      final track = _track(
        songId: 27,
        title: '无渐变歌曲',
        streamUrl: 'https://example.com/no-fade.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await _settle();
      fakePlayerRepository.volumeCalls.clear();

      await notifier.playTrack(track, queue: [track]);
      await notifier.pause();

      expect(fakePlayerRepository.volumeCalls, [1]);
      expect(container.read(playerNotifierProvider).isPlaying, isFalse);
    });

    test('stop 渐出后重置位置并清除活动播放状态', () async {
      final track = _track(
        songId: 28,
        title: '停止歌曲',
        streamUrl: 'https://example.com/stop.m4s',
      );
      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.playTrack(track, queue: [track]);
      fakePlayerRepository.emitPosition(const Duration(seconds: 20));
      await _settle();
      fakePlayerRepository.volumeCalls.clear();

      await notifier.stop();

      expect(fakePlayerRepository.volumeCalls, [0.5, 0]);
      expect(fakePlayerRepository.stopCallCount, 1);
      expect(container.read(playerNotifierProvider).position, Duration.zero);
      expect(container.read(playerNotifierProvider).isPlaying, isFalse);
    });

    test('resume 会忽略不存在的本地路径并重新解析远端流', () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'player_missing_local_',
      );
      final missingPath = '${tempDir.path}/missing_track.m4s';
      await tempDir.delete(recursive: true);

      final track = _track(
        songId: 12,
        bvid: 'BVmissing01',
        cid: 1201,
        title: '失效本地路径歌曲',
        localPath: missingPath,
        streamUrl: 'https://example.com/stale-local-fallback.m4s',
      );
      fakeParseRepository.streamInfo = const AudioStreamInfo(
        url: 'https://example.com/fresh-after-missing-local.m4s',
        quality: 30232,
      );
      await _seedPlayerPreferences(
        track: track,
        queue: [track],
        currentIndex: 0,
        position: const Duration(milliseconds: 3500),
        playMode: PlayMode.sequential,
        volume: 1,
      );

      container.read(playerNotifierProvider);
      await _settle();

      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.resume();
      await _settle();

      expect(fakeParseRepository.getAudioStreamCalls, 1);
      expect(fakePlayerRepository.playedTracks, hasLength(1));
      expect(fakePlayerRepository.playedTracks.single.localPath, isNull);
      expect(
        fakePlayerRepository.playedTracks.single.streamUrl,
        'https://example.com/fresh-after-missing-local.m4s',
      );
      expect(fakePlayerRepository.seekCalls, [
        const Duration(milliseconds: 3500),
      ]);
    });

    test('下载完成信号会刷新队列中的最新 localPath', () async {
      final tempDir = await Directory.systemTemp.createTemp('player_refresh_');
      final localFile = File('${tempDir.path}/fresh_track.m4s');
      await localFile.writeAsString('fresh');

      final songId = await db
          .into(db.songs)
          .insert(
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
  final List<String> transportCalls = [];
  Completer<void>? pauseGate;
  Completer<void>? resumeGate;
  Object? playError;
  Object? pauseError;
  Object? resumeError;
  int pauseCallCount = 0;
  int resumeCallCount = 0;
  int stopCallCount = 0;

  void emitPosition(Duration position) {
    _positionController.add(position);
  }

  void emitCompleted() {
    _completedController.add(null);
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
    pauseCallCount++;
    transportCalls.add('pause');
    await pauseGate?.future;
    if (pauseError != null) throw pauseError!;
    _playingController.add(false);
  }

  @override
  Future<void> play(AudioTrack track) async {
    playedTracks.add(track);
    if (playError != null) throw playError!;
    _playingController.add(true);
    _durationController.add(track.duration);
  }

  @override
  Stream<bool> get playingStream => _playingController.stream;

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Future<void> resume() async {
    resumeCallCount++;
    transportCalls.add('resume');
    await resumeGate?.future;
    if (resumeError != null) throw resumeError!;
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

class _SwitchableFadeDelay {
  final List<Completer<void>> _pending = [];
  bool gated = false;

  Future<void> call(Duration duration) {
    if (!gated || duration == Duration.zero) return Future<void>.value();
    final completer = Completer<void>();
    _pending.add(completer);
    return completer.future;
  }

  Future<void> waitForPendingCount(int count) async {
    for (var attempt = 0; attempt < 100; attempt++) {
      if (_pending.length >= count) return;
      await Future<void>.delayed(Duration.zero);
    }
    fail('Timed out waiting for $count pending fade delays');
  }

  void completeNext() {
    if (_pending.isEmpty) {
      fail('No pending fade delay to complete');
    }
    _pending.removeAt(0).complete();
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
  Future<List<AudioStreamInfo>> getAvailableQualities(String bvid, int cid) {
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
