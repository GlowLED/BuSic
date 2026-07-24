import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/services/audio_handler.dart';

void main() {
  test('平台播放命令会等待异步播放器回调完成', () async {
    final callbackGate = Completer<void>();
    final handler = BusicAudioHandler();
    var callbackStarted = false;
    var commandCompleted = false;
    handler.onPlay = () async {
      callbackStarted = true;
      await callbackGate.future;
    };

    final command = handler.play().then((_) {
      commandCompleted = true;
    });
    await Future<void>.delayed(Duration.zero);

    expect(callbackStarted, isTrue);
    expect(commandCompleted, isFalse);

    callbackGate.complete();
    await command;

    expect(commandCompleted, isTrue);
  });
}
