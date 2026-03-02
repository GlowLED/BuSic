/// Utility functions for formatting and parsing.
class Formatters {
  Formatters._();

  /// Format a [Duration] into "mm:ss" or "hh:mm:ss" string.
  ///
  /// Example: `Duration(minutes: 3, seconds: 42)` → `"3:42"`
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
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
    final trimmed = input.trim();
    // Match BV number pattern: BV + 10 alphanumeric characters
    final regex = RegExp(r'(BV[a-zA-Z0-9]{10})');
    final match = regex.firstMatch(trimmed);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  /// Format a file size in bytes to human-readable string.
  ///
  /// Example: `1048576` → `"1.0 MB"`
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format a timestamp to a relative time string.
  ///
  /// Example: "3 minutes ago", "2 hours ago", "yesterday"
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}周前';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}个月前';
    return '${(diff.inDays / 365).floor()}年前';
  }
}
