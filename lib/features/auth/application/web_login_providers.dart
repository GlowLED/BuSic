import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart' as p;

import '../../../core/utils/logger.dart';
import '../../../core/utils/platform_utils.dart';
import '../data/bili_web_login_cookie_store.dart';

enum WebLoginAvailabilityStatus {
  available,
  unsupportedPlatform,
  webView2Missing,
  initializationFailed,
}

class WebLoginAvailability {
  const WebLoginAvailability._({
    required this.status,
    this.webViewEnvironment,
    this.error,
  });

  const WebLoginAvailability.available({
    WebViewEnvironment? webViewEnvironment,
  }) : this._(
          status: WebLoginAvailabilityStatus.available,
          webViewEnvironment: webViewEnvironment,
        );

  const WebLoginAvailability.unsupportedPlatform()
      : this._(status: WebLoginAvailabilityStatus.unsupportedPlatform);

  const WebLoginAvailability.webView2Missing()
      : this._(status: WebLoginAvailabilityStatus.webView2Missing);

  const WebLoginAvailability.initializationFailed(Object error)
      : this._(
          status: WebLoginAvailabilityStatus.initializationFailed,
          error: error,
        );

  final WebLoginAvailabilityStatus status;
  final WebViewEnvironment? webViewEnvironment;
  final Object? error;

  bool get isAvailable => status == WebLoginAvailabilityStatus.available;
}

final webLoginAvailabilityProvider =
    FutureProvider.autoDispose<WebLoginAvailability>((ref) async {
  if (PlatformUtils.isLinux) {
    return const WebLoginAvailability.unsupportedPlatform();
  }

  if (!PlatformUtils.isWindows) {
    return const WebLoginAvailability.available();
  }

  try {
    final availableVersion = await WebViewEnvironment.getAvailableVersion();
    if (availableVersion == null) {
      return const WebLoginAvailability.webView2Missing();
    }

    final dataPath = await PlatformUtils.getDataPath();
    final webViewEnvironment = await WebViewEnvironment.create(
      settings: WebViewEnvironmentSettings(
        userDataFolder: p.join(dataPath, 'webview2'),
      ),
    );

    ref.onDispose(() {
      webViewEnvironment.dispose();
    });

    return WebLoginAvailability.available(
      webViewEnvironment: webViewEnvironment,
    );
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to initialize Windows WebView2 environment',
      tag: 'Auth',
      error: e,
      stackTrace: stackTrace,
    );
    return WebLoginAvailability.initializationFailed(e);
  }
});

final biliWebLoginCookieStoreProvider =
    Provider.autoDispose.family<BiliWebLoginCookieStore, WebViewEnvironment?>(
  (ref, webViewEnvironment) {
    return InAppBiliWebLoginCookieStore(
      webViewEnvironment: webViewEnvironment,
    );
  },
);
