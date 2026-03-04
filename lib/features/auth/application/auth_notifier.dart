import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/logger.dart';
import '../data/auth_repository.dart';
import '../data/auth_repository_impl.dart';
import '../domain/models/user.dart';

part 'auth_notifier.g.dart';

/// State notifier managing the authentication lifecycle.
///
/// Provides the current [User] session state and exposes methods
/// for login, logout, and session validation.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  late AuthRepository _repository;
  Timer? _pollTimer;
  String? _currentQrKey;

  @override
  Future<User?> build() async {
    _repository = AuthRepositoryImpl(
      biliDio: BiliDio(),
      db: ref.read(databaseProvider),
    );
    ref.onDispose(() {
      _pollTimer?.cancel();
    });
    // Attempt to load existing session
    final user = await _repository.loadSession();
    if (user != null) {
      // Validate session
      final refreshed = await _repository.refreshSession();
      return refreshed ?? user;
    }
    return null;
  }

  /// Start the QR code login flow.
  ///
  /// Returns the QR code URL to display and begins polling.
  /// Optional callbacks [onScanned] and [onExpired] notify the UI of status.
  Future<String> login({
    void Function()? onScanned,
    void Function()? onExpired,
  }) async {
    final qrData = await _repository.generateQrCode();
    _currentQrKey = qrData.qrKey;

    // Start polling every 2 seconds
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_currentQrKey == null) {
        timer.cancel();
        return;
      }
      try {
        final result = await _repository.pollQrStatus(_currentQrKey!);
        switch (result.code) {
          case 0: // Success
            timer.cancel();
            _currentQrKey = null;
            // Parse cookies from the redirect URL
            if (result.url != null) {
              final uri = Uri.parse(result.url!);
              final params = uri.queryParameters;
              final user = User(
                userId: params['DedeUserID'] ?? '',
                nickname: '用户',
                sessdata: params['SESSDATA'] ?? '',
                biliJct: params['bili_jct'] ?? '',
                isLoggedIn: true,
              );
              await _repository.saveSession(user);
              // Refresh to get full user info
              final refreshed = await _repository.refreshSession();
              state = AsyncData(refreshed ?? user);
            }
            break;
          case 86038: // QR expired
            timer.cancel();
            _currentQrKey = null;
            onExpired?.call();
            AppLogger.warning('QR code expired', tag: 'Auth');
            break;
          case 86090: // Scanned, waiting confirmation
            onScanned?.call();
            AppLogger.info('QR scanned, waiting confirmation', tag: 'Auth');
            break;
          case 86101: // Not scanned
            break;
        }
      } catch (e) {
        AppLogger.error('Poll error', tag: 'Auth', error: e);
      }
    });

    return qrData.qrUrl;
  }

  /// Log out the current user.
  ///
  /// Clears the session from database and resets state.
  Future<void> logout() async {
    _pollTimer?.cancel();
    _currentQrKey = null;
    await _repository.clearSession();
    state = const AsyncData(null);
  }

  /// Log in by manually providing cookie values obtained from a browser.
  ///
  /// Saves the session and attempts to refresh user profile info.
  Future<void> loginWithCookie({
    required String sessdata,
    required String biliJct,
    required String dedeUserId,
  }) async {
    final user = User(
      userId: dedeUserId,
      nickname: '用户',
      sessdata: sessdata,
      biliJct: biliJct,
      isLoggedIn: true,
    );
    await _repository.saveSession(user);
    final refreshed = await _repository.refreshSession();
    if (refreshed != null) {
      state = AsyncData(refreshed);
    } else {
      // Cookie might be invalid — clear and throw
      await _repository.clearSession();
      throw Exception('Cookie无效或已过期');
    }
  }

  /// Check if the current session is still valid.
  Future<void> checkSession() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final refreshed = await _repository.refreshSession();
    if (refreshed != null) {
      state = AsyncData(refreshed);
    } else {
      state = const AsyncData(null);
    }
  }
}

/// Global database provider that should be overridden in ProviderScope.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database must be provided via override');
});
