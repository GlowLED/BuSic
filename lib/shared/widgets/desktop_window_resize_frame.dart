import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/utils/platform_utils.dart';

/// Adds client-side resize hit targets for Linux frameless windows.
///
/// Linux desktop environments do not provide native resize edges once the
/// system title bar is hidden, so the Flutter surface must expose them.
class DesktopWindowResizeFrame extends StatefulWidget {
  const DesktopWindowResizeFrame({
    super.key,
    required this.child,
    this.enabled,
    this.resizeEdgeSize = 8,
  });

  final Widget child;
  final bool? enabled;
  final double resizeEdgeSize;

  @override
  State<DesktopWindowResizeFrame> createState() =>
      _DesktopWindowResizeFrameState();
}

class _DesktopWindowResizeFrameState extends State<DesktopWindowResizeFrame>
    with WindowListener {
  bool _isFullScreen = false;
  bool _isListening = false;
  bool _isMaximized = false;

  bool get _isEnabled => widget.enabled ?? PlatformUtils.isLinux;

  @override
  void initState() {
    super.initState();
    _syncWindowListener();
  }

  @override
  void didUpdateWidget(covariant DesktopWindowResizeFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncWindowListener();
  }

  @override
  void dispose() {
    if (_isListening) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  void _syncWindowListener() {
    if (_isEnabled && !_isListening) {
      windowManager.addListener(this);
      _isListening = true;
    } else if (!_isEnabled && _isListening) {
      windowManager.removeListener(this);
      _isListening = false;
      _isFullScreen = false;
      _isMaximized = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEnabled) return widget.child;

    final resizeDisabled = _isMaximized || _isFullScreen;

    return DragToResizeArea(
      resizeEdgeSize: widget.resizeEdgeSize,
      enableResizeEdges: resizeDisabled ? const <ResizeEdge>[] : null,
      child: widget.child,
    );
  }

  @override
  void onWindowMaximize() {
    if (mounted) setState(() => _isMaximized = true);
  }

  @override
  void onWindowUnmaximize() {
    if (mounted) setState(() => _isMaximized = false);
  }

  @override
  void onWindowEnterFullScreen() {
    if (mounted) setState(() => _isFullScreen = true);
  }

  @override
  void onWindowLeaveFullScreen() {
    if (mounted) setState(() => _isFullScreen = false);
  }
}
