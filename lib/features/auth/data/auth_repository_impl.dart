import 'dart:io';

import 'package:drift/drift.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/qr_poll_result.dart';
import '../domain/models/user.dart';
import 'auth_repository.dart';

/// Concrete implementation of [AuthRepository] using Bilibili API + Drift.
class AuthRepositoryImpl implements AuthRepository {
  final BiliDio _biliDio;
  final AppDatabase _db;

  AuthRepositoryImpl({required BiliDio biliDio, required AppDatabase db})
      : _biliDio = biliDio,
        _db = db;

  @override
  Future<({String qrUrl, String qrKey})> generateQrCode() async {
    final response = await _biliDio.get(
      'https://passport.bilibili.com/x/passport-login/web/qrcode/generate',
    );
    final data = response.data['data'];
    return (
      qrUrl: data['url'] as String,
      qrKey: data['qrcode_key'] as String,
    );
  }

  @override
  Future<QrPollResult> pollQrStatus(String qrKey) async {
    final response = await _biliDio.get(
      'https://passport.bilibili.com/x/passport-login/web/qrcode/poll',
      queryParameters: {'qrcode_key': qrKey},
    );
    final data = response.data['data'];
    return QrPollResult(
      code: data['code'] as int,
      message: data['message'] as String,
      url: data['url'] as String?,
    );
  }

  @override
  Future<void> saveSession(User user) async {
    await _db.into(_db.userSessions).insert(
          UserSessionsCompanion.insert(
            sessdata: user.sessdata,
            biliJct: user.biliJct,
            dedeUserId: user.userId,
            avatarUrl: Value(user.avatarUrl),
            nickname: Value(user.nickname),
          ),
        );

    // Update cookies in BiliDio
    final uri = Uri.parse('https://bilibili.com');
    await _biliDio.updateCookies(uri, [
      Cookie('SESSDATA', user.sessdata),
      Cookie('bili_jct', user.biliJct),
      Cookie('DedeUserID', user.userId),
    ]);
  }

  @override
  Future<User?> loadSession() async {
    final sessions = await (_db.select(_db.userSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .get();

    if (sessions.isEmpty) return null;

    final session = sessions.first;

    // Restore cookies
    final uri = Uri.parse('https://bilibili.com');
    await _biliDio.updateCookies(uri, [
      Cookie('SESSDATA', session.sessdata),
      Cookie('bili_jct', session.biliJct),
      Cookie('DedeUserID', session.dedeUserId),
    ]);

    return User(
      userId: session.dedeUserId,
      nickname: session.nickname ?? '用户',
      avatarUrl: session.avatarUrl,
      sessdata: session.sessdata,
      biliJct: session.biliJct,
      isLoggedIn: true,
    );
  }

  @override
  Future<void> clearSession() async {
    await _db.delete(_db.userSessions).go();
    await _biliDio.clearCookies();
  }

  @override
  Future<User?> refreshSession() async {
    try {
      // Try to fetch user info to validate session
      final response = await _biliDio.get(
        '/x/web-interface/nav',
      );
      final data = response.data;
      if (data['code'] == 0) {
        final userData = data['data'];
        final existing = await loadSession();
        if (existing != null) {
          final updated = existing.copyWith(
            nickname: userData['uname'] as String? ?? existing.nickname,
            avatarUrl: userData['face'] as String?,
            isLoggedIn: true,
          );
          return updated;
        }
      }
      return null;
    } catch (e) {
      AppLogger.error('Session refresh failed', tag: 'Auth', error: e);
      return null;
    }
  }
}
