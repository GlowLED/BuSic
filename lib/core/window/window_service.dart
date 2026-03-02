import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../utils/platform_utils.dart';

/// Desktop window management service.
///
/// Handles window initialization, sizing, and title bar configuration
/// for desktop platforms (Windows, macOS, Linux).
/// On mobile platforms, all methods are no-ops.
class WindowService {
  WindowService._();

  /// Initialize the desktop window with default size and properties.
  ///
  /// Should be called in [main] before [runApp] on desktop platforms.
  static Future<void> initialize() async {
    if (!PlatformUtils.isDesktop) return;

    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1200, 800),
      minimumSize: Size(800, 600),
      center: true,
      title: 'BuSic',
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  /// Update the window title.
  static Future<void> setTitle(String title) async {
    if (!PlatformUtils.isDesktop) return;
    // TODO: implement
    throw UnimplementedError();
  }

  /// Set the minimum window size.
  static Future<void> setMinSize(Size size) async {
    if (!PlatformUtils.isDesktop) return;
    // TODO: implement
    throw UnimplementedError();
  }

  /// Toggle fullscreen mode.
  static Future<void> toggleFullScreen() async {
    if (!PlatformUtils.isDesktop) return;
    // TODO: implement
    throw UnimplementedError();
  }
}
