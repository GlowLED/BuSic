import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/shared/widgets/ui_scale_shortcuts.dart';

void main() {
  testWidgets('文本框聚焦时支持 Ctrl 主键盘和数字键盘缩放', (tester) async {
    var increases = 0;
    var decreases = 0;
    var resets = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: UiScaleShortcuts(
          onIncrease: () => increases++,
          onDecrease: () => decreases++,
          onReset: () => resets++,
          child: const Scaffold(body: TextField(autofocus: true)),
        ),
      ),
    );
    await tester.pump();

    await _sendModifiedKey(
      tester,
      LogicalKeyboardKey.equal,
      LogicalKeyboardKey.controlLeft,
    );
    await _sendModifiedKey(
      tester,
      LogicalKeyboardKey.equal,
      LogicalKeyboardKey.controlLeft,
      shift: true,
    );
    await _sendModifiedKey(
      tester,
      LogicalKeyboardKey.numpadAdd,
      LogicalKeyboardKey.controlLeft,
    );
    await _sendModifiedKey(
      tester,
      LogicalKeyboardKey.minus,
      LogicalKeyboardKey.controlLeft,
    );
    await _sendModifiedKey(
      tester,
      LogicalKeyboardKey.numpadSubtract,
      LogicalKeyboardKey.controlLeft,
    );
    await _sendModifiedKey(
      tester,
      LogicalKeyboardKey.digit0,
      LogicalKeyboardKey.controlLeft,
    );
    await _sendModifiedKey(
      tester,
      LogicalKeyboardKey.numpad0,
      LogicalKeyboardKey.controlLeft,
    );

    expect(increases, 3);
    expect(decreases, 2);
    expect(resets, 2);
  });

  testWidgets('可选支持 Meta 快捷键、按键重复和禁用状态', (tester) async {
    var increases = 0;

    Future<void> pump({required bool enabled}) {
      return tester.pumpWidget(
        MaterialApp(
          home: UiScaleShortcuts(
            enabled: enabled,
            enableMetaShortcuts: true,
            onIncrease: () => increases++,
            onDecrease: () {},
            onReset: () {},
            child: const Scaffold(body: TextField(autofocus: true)),
          ),
        ),
      );
    }

    await pump(enabled: true);
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.equal);
    await tester.sendKeyRepeatEvent(LogicalKeyboardKey.equal);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.equal);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
    expect(increases, 2);

    await pump(enabled: false);
    await _sendModifiedKey(
      tester,
      LogicalKeyboardKey.equal,
      LogicalKeyboardKey.controlLeft,
    );
    expect(increases, 2);
  });
}

Future<void> _sendModifiedKey(
  WidgetTester tester,
  LogicalKeyboardKey key,
  LogicalKeyboardKey modifier, {
  bool shift = false,
}) async {
  await tester.sendKeyDownEvent(modifier);
  if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyEvent(key);
  if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyUpEvent(modifier);
}
