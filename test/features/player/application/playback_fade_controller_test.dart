import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/player/application/playback_fade_controller.dart';

void main() {
  group('PlaybackFadeController', () {
    test('渐入按单调步进精确到达目标音量', () async {
      final calls = <double>[];
      final controller = PlaybackFadeController(
        setVolume: (volume) async => calls.add(volume),
        initialVolume: 0,
        tickInterval: const Duration(milliseconds: 50),
        delay: (_) async {},
      );

      final completed = await controller.fadeTo(
        target: 0.8,
        duration: const Duration(milliseconds: 200),
        phase: PlaybackFadePhase.fadeIn,
      );

      expect(completed, isTrue);
      expect(calls, hasLength(4));
      expect(calls.last, closeTo(0.8, 0.0001));
      for (var index = 1; index < calls.length; index++) {
        expect(calls[index], greaterThan(calls[index - 1]));
      }
      expect(controller.effectiveVolume, closeTo(0.8, 0.0001));
      expect(controller.phase, PlaybackFadePhase.idle);
    });

    test('渐出按单调步进精确到达静音', () async {
      final calls = <double>[];
      final controller = PlaybackFadeController(
        setVolume: (volume) async => calls.add(volume),
        initialVolume: 1,
        tickInterval: const Duration(milliseconds: 50),
        delay: (_) async {},
      );

      await controller.fadeTo(
        target: 0,
        duration: const Duration(milliseconds: 150),
        phase: PlaybackFadePhase.fadeOut,
      );

      expect(calls, hasLength(3));
      expect(calls.last, closeTo(0, 0.0001));
      for (var index = 1; index < calls.length; index++) {
        expect(calls[index], lessThan(calls[index - 1]));
      }
    });

    test('取消后旧渐变不会覆盖新的即时音量', () async {
      final calls = <double>[];
      final delays = <Completer<void>>[];
      final controller = PlaybackFadeController(
        setVolume: (volume) async => calls.add(volume),
        initialVolume: 0,
        tickInterval: const Duration(milliseconds: 50),
        delay: (_) {
          final completer = Completer<void>();
          delays.add(completer);
          return completer.future;
        },
      );

      final oldFade = controller.fadeTo(
        target: 1,
        duration: const Duration(milliseconds: 100),
        phase: PlaybackFadePhase.fadeIn,
      );
      await Future<void>.delayed(Duration.zero);

      await controller.setImmediate(0.35);
      delays.single.complete();

      expect(await oldFade, isFalse);
      expect(calls, [0.35]);
      expect(controller.effectiveVolume, closeTo(0.35, 0.0001));
    });

    test('零时长渐变即时安全落到目标值', () async {
      final calls = <double>[];
      final controller = PlaybackFadeController(
        setVolume: (volume) async => calls.add(volume),
        initialVolume: 0,
        delay: (_) async {},
      );

      await controller.fadeTo(
        target: 0,
        duration: Duration.zero,
        phase: PlaybackFadePhase.fadeOut,
      );

      expect(calls, [0]);
      expect(controller.effectiveVolume, 0);
    });

    test('渐入过程中会跟随更新后的用户目标音量', () async {
      final calls = <double>[];
      var target = 1.0;
      var delayCount = 0;
      final controller = PlaybackFadeController(
        setVolume: (volume) async => calls.add(volume),
        initialVolume: 0,
        tickInterval: const Duration(milliseconds: 50),
        delay: (_) async {
          delayCount++;
          if (delayCount == 2) target = 0.4;
        },
      );

      await controller.fadeTo(
        target: target,
        targetProvider: () => target,
        duration: const Duration(milliseconds: 200),
        phase: PlaybackFadePhase.fadeIn,
      );

      expect(calls.last, closeTo(0.4, 0.0001));
      expect(controller.effectiveVolume, closeTo(0.4, 0.0001));
    });

    test('异步音量写入会串行执行且最新命令最终生效', () async {
      final calls = <double>[];
      final firstWriteGate = Completer<void>();
      final controller = PlaybackFadeController(
        setVolume: (volume) async {
          calls.add(volume);
          if (calls.length == 1) {
            await firstWriteGate.future;
          }
        },
        initialVolume: 1,
        delay: (_) async {},
      );

      final oldFade = controller.fadeTo(
        target: 0,
        duration: Duration.zero,
        phase: PlaybackFadePhase.fadeOut,
      );
      await Future<void>.delayed(Duration.zero);

      final latestWrite = controller.setImmediate(0.75);
      await Future<void>.delayed(Duration.zero);
      expect(calls, [0]);

      firstWriteGate.complete();

      expect(await oldFade, isFalse);
      expect(await latestWrite, isTrue);
      expect(calls, [0, 0.75]);
      expect(controller.effectiveVolume, closeTo(0.75, 0.0001));
    });
  });
}
