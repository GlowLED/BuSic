import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/utils/logger.dart';

/// Full URLs for fetching the remote pubspec.yaml (version manifest).
///
/// jsdelivr is the primary source (CDN, reliable in China & international).
/// Three confirmed-working GitHub proxies as fallback.
/// Direct raw.githubusercontent.com last (blocked in China).
const kMetadataUrls = [
  'https://cdn.jsdelivr.net/gh/GlowLED/BuSic@main/pubspec.yaml',
  'https://gh-proxy.com/https://raw.githubusercontent.com/GlowLED/BuSic/main/pubspec.yaml',
  'https://ghfast.top/https://raw.githubusercontent.com/GlowLED/BuSic/main/pubspec.yaml',
  'https://ghproxy.net/https://raw.githubusercontent.com/GlowLED/BuSic/main/pubspec.yaml',
  'https://raw.githubusercontent.com/GlowLED/BuSic/main/pubspec.yaml',
];

/// Full URLs for fetching the versions manifest JSON (new V2 source of truth).
const kManifestUrls = [
  'https://cdn.jsdelivr.net/gh/GlowLED/BuSic@main/versions-manifest.json',
  'https://gh-proxy.com/https://raw.githubusercontent.com/GlowLED/BuSic/main/versions-manifest.json',
  'https://ghfast.top/https://raw.githubusercontent.com/GlowLED/BuSic/main/versions-manifest.json',
  'https://ghproxy.net/https://raw.githubusercontent.com/GlowLED/BuSic/main/versions-manifest.json',
  'https://raw.githubusercontent.com/GlowLED/BuSic/main/versions-manifest.json',
];

/// GitHub proxy endpoints for release asset downloads.
///
/// Direct github.com first (fastest for international users).
/// Three confirmed-working proxies for China users.
const kReleaseProxies = [
  'https://github.com',
  'https://gh-proxy.com/https://github.com',
  'https://ghfast.top/https://github.com',
  'https://ghproxy.net/https://github.com',
];

const _kProbeTimeout = Duration(seconds: 5);
const _kTag = 'ProxyProber';

/// Probes a list of proxy base URLs and returns the fastest responding one.
///
/// Sends concurrent HEAD requests to a small known file and picks the first
/// successful response.
class ProxyProber {
  final Dio _dio;

  /// In-memory cache: proxyList hashCode → fastest proxy.
  final Map<int, String> _cache = {};

  ProxyProber({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: _kProbeTimeout,
              receiveTimeout: _kProbeTimeout,
            ));

  /// Probe [proxies] by fetching [testPath] via HEAD and return the fastest.
  ///
  /// Falls back to the first entry in [proxies] if all probes fail.
  Future<String> probe(
    List<String> proxies, {
    String testPath = '/GlowLED/BuSic/main/pubspec.yaml',
  }) async {
    final key = Object.hashAll(proxies);
    if (_cache.containsKey(key)) return _cache[key]!;

    AppLogger.info(
      'Probing ${proxies.length} proxies …',
      tag: _kTag,
    );

    final completer = Completer<String>();
    var failCount = 0;
    final total = proxies.length;

    for (final proxy in proxies) {
      () async {
        try {
          final url = '$proxy$testPath';
          final response = await _dio.head<dynamic>(
            url,
            options: Options(
              followRedirects: true,
              // Any HTTP response (even 4xx) proves the server is reachable.
              // Only connection errors / timeouts count as failures.
              validateStatus: (s) => s != null,
            ),
          );
          if (response.statusCode != null && !completer.isCompleted) {
            completer.complete(proxy);
            return;
          }
        } catch (e) {
          AppLogger.info('Probe failed for $proxy: $e', tag: _kTag);
        }
        failCount++;
        if (failCount >= total && !completer.isCompleted) {
          completer.complete(proxies.first);
        }
      }();
    }

    final result = await completer.future;

    _cache[key] = result;
    AppLogger.info('Selected proxy: $result', tag: _kTag);
    return result;
  }

  /// Clear the cached probe results.
  void clearCache() => _cache.clear();
}
