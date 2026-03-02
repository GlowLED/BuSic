import '../domain/models/qr_poll_result.dart';
import '../domain/models/user.dart';
import 'auth_repository.dart';

/// Concrete implementation of [AuthRepository] using Bilibili API + Drift.
class AuthRepositoryImpl implements AuthRepository {
  // TODO: inject BiliDio and AppDatabase via constructor

  @override
  Future<({String qrUrl, String qrKey})> generateQrCode() {
    // TODO: call https://passport.bilibili.com/x/passport-login/web/qrcode/generate
    throw UnimplementedError();
  }

  @override
  Future<QrPollResult> pollQrStatus(String qrKey) {
    // TODO: call https://passport.bilibili.com/x/passport-login/web/qrcode/poll
    throw UnimplementedError();
  }

  @override
  Future<void> saveSession(User user) {
    // TODO: save to UserSessions table via Drift
    throw UnimplementedError();
  }

  @override
  Future<User?> loadSession() {
    // TODO: query latest session from UserSessions table
    throw UnimplementedError();
  }

  @override
  Future<void> clearSession() {
    // TODO: delete session from DB + clear cookies
    throw UnimplementedError();
  }

  @override
  Future<User?> refreshSession() {
    // TODO: call cookie refresh API
    throw UnimplementedError();
  }
}
