import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart' as p;

import '../../../core/utils/logger.dart';
import '../../../core/utils/platform_utils.dart';
import '../data/bili_web_login_cookie_store.dart';
import '../data/linux_managed_browser_login_service.dart';

enum WebLoginMode { embeddedWebView, managedBrowser }

enum WebLoginHostPlatform { linux, windows, other }

enum WebLoginAvailabilityStatus {
  available,
  unsupportedPlatform,
  browserMissing,
  webView2Missing,
  initializationFailed,
}

class WebLoginAvailability {
  const WebLoginAvailability._({
    required this.status,
    this.mode = WebLoginMode.embeddedWebView,
    this.webViewEnvironment,
    this.error,
  });

  const WebLoginAvailability.available({
    WebLoginMode mode = WebLoginMode.embeddedWebView,
    WebViewEnvironment? webViewEnvironment,
  }) : this._(
         status: WebLoginAvailabilityStatus.available,
         mode: mode,
         webViewEnvironment: webViewEnvironment,
       );

  const WebLoginAvailability.unsupportedPlatform()
    : this._(status: WebLoginAvailabilityStatus.unsupportedPlatform);

  const WebLoginAvailability.browserMissing()
    : this._(status: WebLoginAvailabilityStatus.browserMissing);

  const WebLoginAvailability.webView2Missing()
    : this._(status: WebLoginAvailabilityStatus.webView2Missing);

  const WebLoginAvailability.initializationFailed(Object error)
    : this._(
        status: WebLoginAvailabilityStatus.initializationFailed,
        error: error,
      );

  final WebLoginAvailabilityStatus status;
  final WebLoginMode mode;
  final WebViewEnvironment? webViewEnvironment;
  final Object? error;

  bool get isAvailable => status == WebLoginAvailabilityStatus.available;
}

final webLoginAvailabilityProvider =
    FutureProvider.autoDispose<WebLoginAvailability>((ref) async {
      final hostPlatform = ref.watch(webLoginHostPlatformProvider);

      if (hostPlatform == WebLoginHostPlatform.linux) {
        final service = ref.watch(linuxManagedBrowserLoginServiceProvider);
        final available = await service.isAvailable();
        if (!available) {
          return const WebLoginAvailability.browserMissing();
        }
        return const WebLoginAvailability.available(
          mode: WebLoginMode.managedBrowser,
        );
      }

      if (hostPlatform != WebLoginHostPlatform.windows) {
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

final webLoginHostPlatformProvider = Provider<WebLoginHostPlatform>((ref) {
  if (PlatformUtils.isLinux || defaultTargetPlatform == TargetPlatform.linux) {
    return WebLoginHostPlatform.linux;
  }
  if (PlatformUtils.isWindows ||
      defaultTargetPlatform == TargetPlatform.windows) {
    return WebLoginHostPlatform.windows;
  }
  return WebLoginHostPlatform.other;
});

final biliWebLoginCookieStoreProvider = Provider.autoDispose
    .family<BiliWebLoginCookieStore, WebViewEnvironment?>((
      ref,
      webViewEnvironment,
    ) {
      return InAppBiliWebLoginCookieStore(
        webViewEnvironment: webViewEnvironment,
      );
    });

final linuxManagedBrowserLoginServiceProvider =
    Provider<LinuxManagedBrowserLoginService>((ref) {
      return ProcessLinuxManagedBrowserLoginService();
    });
