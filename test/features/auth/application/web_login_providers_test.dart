import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/auth/application/web_login_providers.dart';
import 'package:busic/features/auth/data/linux_managed_browser_login_service.dart';
import 'package:busic/features/auth/domain/models/bili_login_cookies.dart';

void main() {
  test('uses managed browser mode when Linux has a supported browser',
      () async {
    final container = ProviderContainer(
      overrides: [
        webLoginHostPlatformProvider.overrideWithValue(
          WebLoginHostPlatform.linux,
        ),
        linuxManagedBrowserLoginServiceProvider.overrideWithValue(
          const _FakeLinuxManagedBrowserLoginService(isAvailable: true),
        ),
      ],
    );
    addTearDown(container.dispose);

    final availability =
        await container.read(webLoginAvailabilityProvider.future);

    expect(availability.status, WebLoginAvailabilityStatus.available);
    expect(availability.mode, WebLoginMode.managedBrowser);
  });

  test('reports missing browser when Linux has no supported browser', () async {
    final container = ProviderContainer(
      overrides: [
        webLoginHostPlatformProvider.overrideWithValue(
          WebLoginHostPlatform.linux,
        ),
        linuxManagedBrowserLoginServiceProvider.overrideWithValue(
          const _FakeLinuxManagedBrowserLoginService(isAvailable: false),
        ),
      ],
    );
    addTearDown(container.dispose);

    final availability =
        await container.read(webLoginAvailabilityProvider.future);

    expect(availability.status, WebLoginAvailabilityStatus.browserMissing);
  });
}

class _FakeLinuxManagedBrowserLoginService
    implements LinuxManagedBrowserLoginService {
  const _FakeLinuxManagedBrowserLoginService({required bool isAvailable})
      : _isAvailable = isAvailable;

  final bool _isAvailable;

  @override
  Future<bool> isAvailable() async {
    return _isAvailable;
  }

  @override
  Future<LinuxManagedBrowserLoginSession> startLogin() async {
    return const _FakeLinuxManagedBrowserLoginSession();
  }
}

class _FakeLinuxManagedBrowserLoginSession
    implements LinuxManagedBrowserLoginSession {
  const _FakeLinuxManagedBrowserLoginSession();

  @override
  Future<void> close() async {}

  @override
  Future<BiliLoginCookies?> readBiliCookies() async {
    return null;
  }
}
