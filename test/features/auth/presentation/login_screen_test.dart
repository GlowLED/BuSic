import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/auth/application/web_login_providers.dart';
import 'package:busic/features/auth/data/auth_repository.dart';
import 'package:busic/features/auth/domain/models/qr_poll_result.dart';
import 'package:busic/features/auth/domain/models/user.dart';
import 'package:busic/features/auth/presentation/login_screen.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  testWidgets('LoginScreen exposes QR, web, and cookie login modes', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          authQrPollIntervalProvider
              .overrideWithValue(const Duration(hours: 1)),
          webLoginSupportedProvider.overrideWithValue(false),
        ],
        child: buildTestApp(const LoginScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('QR Login'), findsOneWidget);
    expect(find.text('Web Login'), findsOneWidget);
    expect(find.text('Cookie Login'), findsOneWidget);

    await tester.tap(find.text('Web Login'));
    await tester.pumpAndSettle();

    expect(
      find.text('Web login is unavailable on this platform'),
      findsOneWidget,
    );
    expect(
      find.text('Use QR login or manual Cookie login on this device.'),
      findsOneWidget,
    );
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> clearSession() async {}

  @override
  Future<({String qrUrl, String qrKey})> generateQrCode() async {
    return (
      qrUrl: 'https://example.com/qr',
      qrKey: 'qr-key',
    );
  }

  @override
  Future<User?> loadSession() async {
    return null;
  }

  @override
  Future<User?> loginWithCookies({
    required String sessdata,
    required String biliJct,
    String? dedeUserId,
  }) async {
    return null;
  }

  @override
  Future<QrPollResult> pollQrStatus(String qrKey) async {
    return const QrPollResult(code: 86101, message: '未扫码');
  }

  @override
  Future<User?> refreshSession() async {
    return null;
  }

  @override
  Future<void> saveSession(User user) async {}
}
