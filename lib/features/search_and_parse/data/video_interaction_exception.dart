/// Exception raised when a Bilibili video interaction request is rejected.
class VideoInteractionException implements Exception {
  const VideoInteractionException(this.code, this.message);

  /// Bilibili response code.
  final int code;

  /// Bilibili response message.
  final String message;

  @override
  String toString() => 'VideoInteractionException($code): $message';
}
