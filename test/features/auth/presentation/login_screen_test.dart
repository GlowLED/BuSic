import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/auth/application/web_login_providers.dart';
import 'package:busic/features/auth/data/auth_repository.dart';
import 'package:busic/features/auth/data/linux_managed_browser_login_service.dart';
import 'package:busic/features/auth/domain/models/bili_login_cookies.dart';
import 'package:busic/features/auth/domain/models/qr_poll_result.dart';
import 'package:busic/features/auth/domain/models/user.dart';
import 'package:busic/features/auth/presentation/login_screen.dart';
import 'package:busic/features/auth/presentation/widgets/linux_managed_web_login_view.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  testWidgets('LoginScreen exposes QR, web, and cookie login modes', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          authQrPollIntervalProvider.overrideWithValue(
            const Duration(hours: 1),
          ),
          webLoginAvailabilityProvider.overrideWith(
            (ref) async => const WebLoginAvailability.unsupportedPlatform(),
          ),
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

  testWidgets(
    'LoginScreen explains missing supported browser on Linux web login',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
            authQrPollIntervalProvider.overrideWithValue(
              const Duration(hours: 1),
            ),
            webLoginHostPlatformProvider.overrideWithValue(
              WebLoginHostPlatform.linux,
            ),
            webLoginAvailabilityProvider.overrideWith(
              (ref) async => const WebLoginAvailability.browserMissing(),
            ),
          ],
          child: buildTestApp(const LoginScreen()),
        ),
      );

      await tester.pump();
      await tester.tap(find.text('Web Login'));
      await tester.pumpAndSettle();

      expect(find.text('No supported browser found'), findsOneWidget);
      expect(find.textContaining('Firefox'), findsOneWidget);
    },
  );

  testWidgets('LoginScreen starts Linux managed browser web login', (
    tester,
  ) async {
    final loginService = _FakeLinuxManagedBrowserLoginService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          authQrPollIntervalProvider.overrideWithValue(
            const Duration(hours: 1),
          ),
          webLoginHostPlatformProvider.overrideWithValue(
            WebLoginHostPlatform.linux,
          ),
          webLoginAvailabilityProvider.overrideWith(
            (ref) async => const WebLoginAvailability.available(
              mode: WebLoginMode.managedBrowser,
            ),
          ),
          linuxManagedBrowserLoginServiceProvider.overrideWithValue(
            loginService,
          ),
        ],
        child: buildTestApp(const LoginScreen()),
      ),
    );

    await tester.pump();
    await tester.tap(find.text('Web Login'));
    await tester.pumpAndSettle();

    expect(find.text('Linux Web Login'), findsOneWidget);

    final loginView = find.byType(LinuxManagedWebLoginView);
    final loginCard = find.ancestor(of: loginView, matching: find.byType(Card));
    final cardRect = tester.getRect(loginCard);
    final iconRect = tester.getRect(find.byIcon(Icons.open_in_browser));
    final titleRect = tester.getRect(find.text('Linux Web Login'));
    final descriptionRect = tester.getRect(
      find.text(
        'BuSic will open a temporary browser window and only read cookies '
        'from that isolated login session.',
      ),
    );
    final openButton = find.ancestor(
      of: find.text('Open login window'),
      matching: find.byType(FilledButton),
    );
    final buttonRect = tester.getRect(openButton);

    expect(titleRect.center.dx, closeTo(cardRect.center.dx, 1));
    expect(descriptionRect.center.dx, closeTo(cardRect.center.dx, 1));
    expect(buttonRect.center.dx, closeTo(cardRect.center.dx, 1));
    expect(buttonRect.width, lessThan(cardRect.width - 48));
    expect(
      (iconRect.top + buttonRect.bottom) / 2,
      closeTo(cardRect.center.dy, 1),
    );
    expect(titleRect.bottom, lessThan(descriptionRect.top));
    expect(descriptionRect.bottom, lessThan(buttonRect.top));

    await tester.tap(find.text('Open login window'));
    await tester.pumpAndSettle();

    expect(loginService.startCallCount, 1);
    expect(find.text('I have logged in'), findsOneWidget);

    await tester.tap(find.text('I have logged in'));
    await tester.pumpAndSettle();

    expect(find.text('Login cookies were not found yet'), findsOneWidget);
  });

  testWidgets('LoginScreen keeps Linux provider errors off embedded WebView', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          authQrPollIntervalProvider.overrideWithValue(
            const Duration(hours: 1),
          ),
          webLoginHostPlatformProvider.overrideWithValue(
            WebLoginHostPlatform.linux,
          ),
          webLoginAvailabilityProvider.overrideWith(
            (ref) async => throw StateError('probe failed'),
          ),
        ],
        child: buildTestApp(const LoginScreen()),
      ),
    );

    await tester.pump();
    await tester.tap(find.text('Web Login'));
    await tester.pumpAndSettle();

    expect(find.text('Web login failed to start'), findsOneWidget);
    expect(
      find.text(
        'The temporary browser login could not start. '
        'Use QR login or manual Cookie login.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('WebView2'), findsNothing);
  });

  testWidgets('LoginScreen forces managed browser card on Linux web login', (
    tester,
  ) async {
    final loginService = _FakeLinuxManagedBrowserLoginService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          authQrPollIntervalProvider.overrideWithValue(
            const Duration(hours: 1),
          ),
          webLoginHostPlatformProvider.overrideWithValue(
            WebLoginHostPlatform.linux,
          ),
          webLoginAvailabilityProvider.overrideWith(
            (ref) async => const WebLoginAvailability.available(),
          ),
          linuxManagedBrowserLoginServiceProvider.overrideWithValue(
            loginService,
          ),
        ],
        child: buildTestApp(const LoginScreen()),
      ),
    );

    await tester.pump();
    await tester.tap(find.text('Web Login'));
    await tester.pumpAndSettle();

    expect(find.text('Linux Web Login'), findsOneWidget);
    expect(find.text('Open login window'), findsOneWidget);
    expect(find.textContaining('WebView2'), findsNothing);
  });

  testWidgets('LoginScreen explains missing WebView2 on Windows web login', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          authQrPollIntervalProvider.overrideWithValue(
            const Duration(hours: 1),
          ),
          webLoginHostPlatformProvider.overrideWithValue(
            WebLoginHostPlatform.windows,
          ),
          webLoginAvailabilityProvider.overrideWith(
            (ref) async => const WebLoginAvailability.webView2Missing(),
          ),
        ],
        child: buildTestApp(const LoginScreen()),
      ),
    );

    await tester.pump();
    await tester.tap(find.text('Web Login'));
    await tester.pumpAndSettle();

    expect(find.text('WebView2 Runtime is missing'), findsOneWidget);
    expect(
      find.textContaining('Microsoft Edge WebView2 Runtime'),
      findsOneWidget,
    );
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> clearSession() async {}

  @override
  Future<({String qrUrl, String qrKey})> generateQrCode() async {
    return (qrUrl: 'https://example.com/qr', qrKey: 'qr-key');
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

class _FakeLinuxManagedBrowserLoginService
    implements LinuxManagedBrowserLoginService {
  int startCallCount = 0;

  @override
  Future<bool> isAvailable() async {
    return true;
  }

  @override
  Future<LinuxManagedBrowserLoginSession> startLogin() async {
    startCallCount++;
    return _FakeLinuxManagedBrowserLoginSession();
  }
}

class _FakeLinuxManagedBrowserLoginSession
    implements LinuxManagedBrowserLoginSession {
  @override
  Future<void> close() async {}

  @override
  Future<BiliLoginCookies?> readBiliCookies() async {
    return null;
  }
}
