import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Platform detection and platform-specific utility methods.
class PlatformUtils {
  PlatformUtils._();

  /// Whether the current platform is a desktop OS (Windows, macOS, Linux).
  static bool get isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  /// Whether the current platform is a mobile OS (Android, iOS).
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  /// Whether the app is running on Android.
  static bool get isAndroid => Platform.isAndroid;

  /// Whether the app is running on Linux.
  static bool get isLinux => Platform.isLinux;

  /// Whether the app is running on Windows.
  static bool get isWindows => Platform.isWindows;

  /// Whether the app is running on macOS.
  static bool get isMacOS => Platform.isMacOS;

  /// Get the application's cache directory path for storing media files.
  ///
  /// - Desktop: `~/Music/BuSic/cache/` or platform equivalent
  /// - Android: App-specific external storage directory
  static Future<String> getCachePath() async {
    // TODO: implement platform-specific cache path resolution
    throw UnimplementedError();
  }

  /// Get the application's data directory path for database and config.
  static Future<String> getDataPath() async {
    // TODO: implement
    throw UnimplementedError();
  }
}
