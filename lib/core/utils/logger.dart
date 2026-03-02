import 'package:flutter/foundation.dart';

/// Simple application logger with severity levels.
///
/// Wraps [debugPrint] with level prefixes for consistent log formatting.
/// In release builds, logs are suppressed.
class AppLogger {
  AppLogger._();

  /// Log an informational message.
  static void info(String message, {String? tag}) {
    // TODO: implement with conditional logging
    throw UnimplementedError();
  }

  /// Log a warning message.
  static void warning(String message, {String? tag}) {
    // TODO: implement with conditional logging
    throw UnimplementedError();
  }

  /// Log an error message with optional [error] and [stackTrace].
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // TODO: implement with conditional logging
    throw UnimplementedError();
  }
}
