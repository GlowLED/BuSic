import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/utils/logger.dart';

/// GitHub proxy endpoints for raw file access.
const kRawProxies = [
  'https://raw.githubusercontent.com', // direct
  'https://ghfast.top/https://raw.githubusercontent.com',
  'https://raw.gitmirror.com',
  'https://fastraw.ixnic.net',
  'https://gh-raw.bjzhk.xyz/https://raw.githubusercontent.com',
];

/// GitHub proxy endpoints for release asset downloads.
const kReleaseProxies = [
  'https://github.com', // direct
  'https://ghfast.top/https://github.com',
  'https://ghproxy.cc/https://github.com',
  'https://gh-proxy.ygxz.in/https://github.com',
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
              validateStatus: (s) => s != null && s < 400,
            ),
          );
          if (response.statusCode != null &&
              response.statusCode! < 400 &&
              !completer.isCompleted) {
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
