/// Utility functions for formatting and parsing.
class Formatters {
  Formatters._();

  /// Format a [Duration] into "mm:ss" or "hh:mm:ss" string.
  ///
  /// Example: `Duration(minutes: 3, seconds: 42)` → `"3:42"`
  static String formatDuration(Duration duration) {
    // TODO: implement
    throw UnimplementedError();
  }

  /// Extract a BV number from a Bilibili URL or raw BV string.
  ///
  /// Supports formats:
  /// - `BV1xx411c7mD` (raw)
  /// - `https://www.bilibili.com/video/BV1xx411c7mD`
  /// - `https://b23.tv/xxxxx` (short URL, needs redirect resolution)
  ///
  /// Returns `null` if no valid BV number is found.
  static String? parseBvid(String input) {
    // TODO: implement BV number extraction regex
    throw UnimplementedError();
  }

  /// Format a file size in bytes to human-readable string.
  ///
  /// Example: `1048576` → `"1.0 MB"`
  static String formatFileSize(int bytes) {
    // TODO: implement
    throw UnimplementedError();
  }

  /// Format a timestamp to a relative time string.
  ///
  /// Example: "3 minutes ago", "2 hours ago", "yesterday"
  static String formatRelativeTime(DateTime dateTime) {
    // TODO: implement
    throw UnimplementedError();
  }
}
