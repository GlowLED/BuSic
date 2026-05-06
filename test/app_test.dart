import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/app.dart';
import 'package:busic/core/database/app_database.dart';
import 'package:busic/features/app_update/application/update_notifier.dart';
import 'package:busic/features/app_update/domain/models/update_state.dart';
import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/auth/data/auth_repository.dart';
import 'package:busic/features/auth/domain/models/qr_poll_result.dart';
import 'package:busic/features/auth/domain/models/user.dart';
import 'package:busic/features/player/application/player_notifier.dart';
import 'package:busic/features/player/domain/models/player_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('startup probes saved auth session and notifies when invalid',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final authRepository = _FakeAuthRepository(
      loadSessionResult: const User(
        userId: '42',
        nickname: 'stale user',
        sessdata: 'stale-sess',
        biliJct: 'stale-csrf',
        isLoggedIn: true,
      ),
      refreshResults: [null],
    );
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        authRepositoryProvider.overrideWithValue(authRepository),
        playerNotifierProvider.overrideWith(_FakePlayerNotifier.new),
        updateNotifierProvider.overrideWith(_FakeUpdateNotifier.new),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const App(),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 10));
    }

    expect(authRepository.loadSessionCallCount, 1);
    expect(authRepository.refreshSessionCallCount, 1);
    expect(authRepository.clearSessionCallCount, 1);
    expect(container.read(authSessionNoticeProvider), isNull);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.byWidgetPredicate((widget) {
        final text = widget is Text ? widget.data ?? '' : '';
        return text.contains('Bilibili login has expired') ||
            text.contains('B 站登录已失效');
      }),
      findsOneWidget,
    );
  });
}

class _FakeUpdateNotifier extends UpdateNotifier {
  @override
  UpdateState build() => const UpdateState.idle();

  @override
  Future<void> checkForUpdate({bool silent = false}) async {}
}

class _FakePlayerNotifier extends PlayerNotifier {
  @override
  PlayerState build() => const PlayerState();
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    required this.loadSessionResult,
    List<User?> refreshResults = const [],
  }) : refreshResults = List.of(refreshResults);

  final User? loadSessionResult;
  final List<User?> refreshResults;

  int loadSessionCallCount = 0;
  int refreshSessionCallCount = 0;
  int clearSessionCallCount = 0;

  @override
  Future<void> clearSession() async {
    clearSessionCallCount++;
  }

  @override
  Future<({String qrUrl, String qrKey})> generateQrCode() async {
    return (qrUrl: 'https://example.com/qr', qrKey: 'qr-key');
  }

  @override
  Future<User?> loadSession() async {
    loadSessionCallCount++;
    return loadSessionResult;
  }

  @override
  Future<QrPollResult> pollQrStatus(String qrKey) async {
    return const QrPollResult(code: 86101, message: 'not scanned');
  }

  @override
  Future<User?> refreshSession() async {
    refreshSessionCallCount++;
    if (refreshResults.isEmpty) return null;
    return refreshResults.removeAt(0);
  }

  @override
  Future<User?> loginWithCookies({
    required String sessdata,
    required String biliJct,
    String? dedeUserId,
  }) async {
    if (refreshResults.isEmpty) return null;
    return refreshResults.removeAt(0);
  }

  @override
  Future<void> saveSession(User user) async {}
}
