import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../utils/platform_utils.dart';

/// Desktop system tray service.
///
/// Provides:
/// - System tray icon with context menu (Show / Quit)
/// - Click-to-show behavior
/// - [destroy] for cleanup
class TrayService with TrayListener {
  TrayService._();
  static final TrayService instance = TrayService._();

  bool _initialized = false;

  /// Label callbacks set from the widget layer (for l10n).
  String Function()? _showLabel;
  String Function()? _quitLabel;

  /// Initialize the system tray icon and menu.
  ///
  /// [showLabel] / [quitLabel] are closures so labels can be re-evaluated
  /// on locale change.
  Future<void> initialize({
    String Function()? showLabel,
    String Function()? quitLabel,
  }) async {
    if (!PlatformUtils.isDesktop || _initialized) return;
    _initialized = true;
    _showLabel = showLabel;
    _quitLabel = quitLabel;

    trayManager.addListener(this);

    // Resolve icon path
    final iconPath = await _resolveIconPath();
    if (iconPath != null) {
      await trayManager.setIcon(iconPath);
    }

    await _rebuildMenu();
  }

  /// Rebuild the tray context menu (e.g. after locale change).
  Future<void> _rebuildMenu() async {
    final show = _showLabel?.call() ?? 'Show';
    final quit = _quitLabel?.call() ?? 'Quit';

    final menu = Menu(items: [
      MenuItem(key: 'show', label: show),
      MenuItem.separator(),
      MenuItem(key: 'quit', label: quit),
    ]);
    await trayManager.setContextMenu(menu);
  }

  /// Resolve the tray icon file path.
  ///
  /// On Windows we use the .ico bundled in runner/resources.
  /// On Linux/macOS we use the PNG from flutter assets.
  Future<String?> _resolveIconPath() async {
    if (Platform.isWindows) {
      // In a packaged Windows app the .exe sits next to data/
      final exeDir = p.dirname(Platform.resolvedExecutable);
      final ico = p.join(exeDir, 'data', 'flutter_assets', 'assets',
          'images', 'app_icon.png');
      if (await File(ico).exists()) return ico;
      // Fallback: runner resources
      return p.join(exeDir, 'runner', 'resources', 'app_icon.ico');
    }

    // Linux / macOS
    final exeDir = p.dirname(Platform.resolvedExecutable);
    final bundled = p.join(
        exeDir, 'data', 'flutter_assets', 'assets', 'images', 'app_icon.png');
    if (await File(bundled).exists()) return bundled;

    // Development fallback
    final fallbackBundled =  p.join(Directory.current.path, 'assets', 'images', 'app_icon.png');
    if (await File(fallbackBundled).exists()) {
      return fallbackBundled; 
    }
    return null;
  }

  // ─── TrayListener callbacks ───

  @override
  void onTrayIconMouseDown() {
    // Single click on tray icon → show & focus window
    _showWindow();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show':
        _showWindow();
        break;
      case 'quit':
        _quit();
        break;
    }
  }

  Future<void> _showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _quit() async {
    await destroy();
    await windowManager.setPreventClose(false);
    await windowManager.destroy();
  }

  /// Clean up tray resources.
  Future<void> destroy() async {
    if (!_initialized) return;
    trayManager.removeListener(this);
    await trayManager.destroy();
    _initialized = false;
  }
}
