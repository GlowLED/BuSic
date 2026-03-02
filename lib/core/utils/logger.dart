import 'package:flutter/foundation.dart';

/// Simple application logger with severity levels.
///
/// Wraps [debugPrint] with level prefixes for consistent log formatting.
/// In release builds, logs are suppressed.
class AppLogger {
  AppLogger._();

  static String _format(String level, String message, String? tag) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    final prefix = tag != null ? '[$level][$tag]' : '[$level]';
    return '$timestamp $prefix $message';
  }

  /// Log an informational message.
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint(_format('INFO', message, tag));
    }
  }

  /// Log a warning message.
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint(_format('WARN', message, tag));
    }
  }

  /// Log an error message with optional [error] and [stackTrace].
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      debugPrint(_format('ERROR', message, tag));
      if (error != null) {
        debugPrint('  Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('  StackTrace: $stackTrace');
      }
    }
  }
}
