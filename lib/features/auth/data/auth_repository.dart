import '../domain/models/qr_poll_result.dart';
import '../domain/models/user.dart';

/// Abstract repository for Bilibili authentication operations.
///
/// Handles QR code login flow, session persistence, and logout.
abstract class AuthRepository {
  /// Request a new QR code for login.
  ///
  /// Returns a tuple of (qrUrl, qrKey):
  /// - [qrUrl]: The URL to encode as a QR code image.
  /// - [qrKey]: The key used for polling login status.
  Future<({String qrUrl, String qrKey})> generateQrCode();

  /// Poll the login status for the given [qrKey].
  ///
  /// Should be called every 2-3 seconds after QR code is displayed.
  /// Returns a [QrPollResult] indicating the current status.
  Future<QrPollResult> pollQrStatus(String qrKey);

  /// Save the authenticated user session to local database.
  Future<void> saveSession(User user);

  /// Load a previously saved session from local database.
  ///
  /// Returns `null` if no session exists or it has expired.
  Future<User?> loadSession();

  /// Clear the stored session and cookies (logout).
  Future<void> clearSession();

  /// Refresh session cookies if they are about to expire.
  ///
  /// Returns the refreshed [User] or `null` if refresh failed.
  Future<User?> refreshSession();
}
