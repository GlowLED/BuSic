import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Global keyboard bindings for desktop interface scaling.
class UiScaleShortcuts extends StatelessWidget {
  const UiScaleShortcuts({
    super.key,
    required this.onIncrease,
    required this.onDecrease,
    required this.onReset,
    required this.child,
    this.enabled = true,
    this.enableMetaShortcuts = false,
  });

  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onReset;
  final Widget child;
  final bool enabled;
  final bool enableMetaShortcuts;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final bindings = <ShortcutActivator, VoidCallback>{
      _UiScaleShortcutActivator(
        keys: {LogicalKeyboardKey.equal, LogicalKeyboardKey.numpadAdd},
        control: true,
        allowShift: true,
      ): onIncrease,
      _UiScaleShortcutActivator(
        keys: {LogicalKeyboardKey.minus, LogicalKeyboardKey.numpadSubtract},
        control: true,
      ): onDecrease,
      _UiScaleShortcutActivator(
        keys: {LogicalKeyboardKey.digit0, LogicalKeyboardKey.numpad0},
        control: true,
      ): onReset,
    };

    if (enableMetaShortcuts) {
      bindings.addAll({
        _UiScaleShortcutActivator(
          keys: {LogicalKeyboardKey.equal, LogicalKeyboardKey.numpadAdd},
          meta: true,
          allowShift: true,
        ): onIncrease,
        _UiScaleShortcutActivator(
          keys: {LogicalKeyboardKey.minus, LogicalKeyboardKey.numpadSubtract},
          meta: true,
        ): onDecrease,
        _UiScaleShortcutActivator(
          keys: {LogicalKeyboardKey.digit0, LogicalKeyboardKey.numpad0},
          meta: true,
        ): onReset,
      });
    }

    return CallbackShortcuts(bindings: bindings, child: child);
  }
}

class _UiScaleShortcutActivator extends ShortcutActivator {
  const _UiScaleShortcutActivator({
    required this.keys,
    this.control = false,
    this.meta = false,
    this.allowShift = false,
  });

  final Set<LogicalKeyboardKey> keys;
  final bool control;
  final bool meta;
  final bool allowShift;

  @override
  Iterable<LogicalKeyboardKey> get triggers => keys;

  @override
  String debugDescribeKeys() {
    final modifier = control ? 'Control' : 'Meta';
    final keyNames = keys.map((key) => key.debugName ?? key.keyLabel).join('/');
    return '$modifier + $keyNames';
  }

  @override
  bool accepts(KeyEvent event, HardwareKeyboard state) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return false;
    if (!keys.contains(event.logicalKey)) return false;
    if (state.isControlPressed != control || state.isMetaPressed != meta) {
      return false;
    }
    if (state.isAltPressed || (!allowShift && state.isShiftPressed)) {
      return false;
    }
    return true;
  }
}
