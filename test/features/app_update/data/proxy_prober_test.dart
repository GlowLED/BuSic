import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/app_update/data/proxy_prober.dart';

/// A mock Dio adapter that allows controlling which hosts succeed or fail.
class _MockHttpClientAdapter implements HttpClientAdapter {
  final Set<String> _successHosts;
  final Duration _delay;

  _MockHttpClientAdapter({
    required Set<String> successHosts,
    Duration delay = Duration.zero,
  })  : _successHosts = successHosts,
        _delay = delay;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (_delay > Duration.zero) {
      await Future<void>.delayed(_delay);
    }

    final uri = options.uri;
    final host = '${uri.scheme}://${uri.host}';

    // Check if this host (or a proxy prefix) should succeed
    for (final successHost in _successHosts) {
      if (options.uri.toString().startsWith(successHost) ||
          host == successHost) {
        return ResponseBody.fromString(
          'OK',
          200,
          headers: {
            Headers.contentTypeHeader: ['text/plain'],
          },
        );
      }
    }

    throw DioException(
      requestOptions: options,
      type: DioExceptionType.connectionTimeout,
      message: 'Simulated timeout for $host',
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  // ──── SECTION 1: 代理探测基础行为 ────

  group('ProxyProber.probe 基础行为', () {
    test('全部成功时返回第一个响应的代理', () async {
      final dio = Dio();
      dio.httpClientAdapter = _MockHttpClientAdapter(
        successHosts: {
          'https://raw.githubusercontent.com',
          'https://ghfast.top',
        },
      );

      final prober = ProxyProber(dio: dio);
      final result = await prober.probe([
        'https://raw.githubusercontent.com',
        'https://ghfast.top/https://raw.githubusercontent.com',
      ]);

      // Should return one of the successful proxies
      expect(
        [
          'https://raw.githubusercontent.com',
          'https://ghfast.top/https://raw.githubusercontent.com',
        ],
        contains(result),
      );
    });

    test('全部失败时回退到第一个代理', () async {
      final dio = Dio();
      dio.httpClientAdapter = _MockHttpClientAdapter(
        successHosts: {}, // 全部失败
      );

      final prober = ProxyProber(dio: dio);
      final result = await prober.probe([
        'https://first.proxy',
        'https://second.proxy',
      ]);

      expect(result, 'https://first.proxy');
    });

    test('仅第二个代理成功时返回第二个', () async {
      final dio = Dio();
      dio.httpClientAdapter = _MockHttpClientAdapter(
        successHosts: {'https://second.proxy'},
      );

      final prober = ProxyProber(dio: dio);
      final result = await prober.probe([
        'https://first.proxy',
        'https://second.proxy',
      ]);

      expect(result, 'https://second.proxy');
    });
  });

  // ──── SECTION 2: 缓存行为 ────

  group('ProxyProber 缓存行为', () {
    test('相同代理列表第二次调用走缓存', () async {
      int callCount = 0;
      final dio = Dio();
      dio.httpClientAdapter = _CountingAdapter(
        onFetch: () => callCount++,
      );

      final prober = ProxyProber(dio: dio);
      final proxies = ['https://proxy-a.com', 'https://proxy-b.com'];

      await prober.probe(proxies);
      final countAfterFirst = callCount;

      await prober.probe(proxies);
      // 第二次不应发出新请求
      expect(callCount, countAfterFirst);
    });

    test('clearCache 后重新探测', () async {
      int callCount = 0;
      final dio = Dio();
      dio.httpClientAdapter = _CountingAdapter(
        onFetch: () => callCount++,
      );

      final prober = ProxyProber(dio: dio);
      final proxies = ['https://proxy-x.com'];

      await prober.probe(proxies);
      final countAfterFirst = callCount;

      prober.clearCache();
      await prober.probe(proxies);

      // 清除缓存后应重新发请求
      expect(callCount, greaterThan(countAfterFirst));
    });
  });

  // ──── SECTION 3: 代理常量 ────

  group('代理常量', () {
    test('kRawProxies 包含直连地址', () {
      expect(
        kRawProxies,
        contains('https://raw.githubusercontent.com'),
      );
    });

    test('kReleaseProxies 包含直连地址', () {
      expect(
        kReleaseProxies,
        contains('https://github.com'),
      );
    });

    test('代理列表非空', () {
      expect(kRawProxies, isNotEmpty);
      expect(kReleaseProxies, isNotEmpty);
    });
  });
}

/// Adapter that counts fetch calls and always succeeds.
class _CountingAdapter implements HttpClientAdapter {
  final void Function() onFetch;

  _CountingAdapter({required this.onFetch});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    onFetch();
    return ResponseBody.fromString(
      'OK',
      200,
      headers: {
        Headers.contentTypeHeader: ['text/plain'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
