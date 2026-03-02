import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_poll_result.freezed.dart';
part 'qr_poll_result.g.dart';

/// Result of polling the QR code login status.
@freezed
class QrPollResult with _$QrPollResult {
  const factory QrPollResult({
    /// Status code:
    /// - 0: success
    /// - 86038: QR code expired
    /// - 86090: scanned, waiting for confirmation
    /// - 86101: not yet scanned
    required int code,

    /// Human-readable status message.
    required String message,

    /// Redirect URL on success (contains cookie params).
    String? url,
  }) = _QrPollResult;

  factory QrPollResult.fromJson(Map<String, dynamic> json) =>
      _$QrPollResultFromJson(json);
}
