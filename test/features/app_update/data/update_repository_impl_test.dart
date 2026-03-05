import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/app_update/data/proxy_prober.dart';
import 'package:busic/features/app_update/data/update_repository_impl.dart';

/// Mock HTTP adapter for repository tests.
class _MockAdapter implements HttpClientAdapter {
  final Map<String, _MockResponse> _routes = {};

  void registerRoute(String urlPattern, _MockResponse response) {
    _routes[urlPattern] = response;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final url = options.uri.toString();

    for (final entry in _routes.entries) {
      if (url.contains(entry.key)) {
        if (entry.value.error != null) {
          throw entry.value.error!;
        }
        return ResponseBody.fromString(
          entry.value.body,
          entry.value.statusCode,
          headers: entry.value.headers,
        );
      }
    }

    throw DioException(
      requestOptions: options,
      type: DioExceptionType.connectionError,
      message: 'No mock route for $url',
    );
  }

  @override
  void close({bool force = false}) {}
}

class _MockResponse {
  final String body;
  final int statusCode;
  final Map<String, List<String>> headers;
  final DioException? error;

  _MockResponse({
    this.body = '',
// ignore: unused_element_parameter
    this.statusCode = 200,
    this.headers = const {
      Headers.contentTypeHeader: ['text/plain'],
    },
    // ignore: unused_element_parameter
    this.error,
  });
}

/// Fake ProxyProber that always returns the first proxy.
class _FakeProber extends ProxyProber {
  _FakeProber() : super(dio: Dio());

  @override
  Future<String> probe(
    List<String> proxies, {
    String testPath = '/GlowLED/BuSic/main/pubspec.yaml',
  }) async {
    return proxies.first;
  }
}

void main() {
  // ──── SECTION 1: 下载功能 ────

  group('UpdateRepositoryImpl.downloadUpdate', () {
    late Dio dio;
    late _MockAdapter mockAdapter;
    late UpdateRepositoryImpl repo;

    setUp(() {
      dio = Dio();
      mockAdapter = _MockAdapter();
      dio.httpClientAdapter = mockAdapter;

      repo = UpdateRepositoryImpl(
        dio: dio,
        prober: _FakeProber(),
      );
    });

    test('下载文件并回调进度', () async {
      final tempDir = await Directory.systemTemp.createTemp('busic_dl_test');
      final savePath = '${tempDir.path}/test_download.bin';

      // Register a download route
      mockAdapter.registerRoute(
        'download/test-asset',
        _MockResponse(
          body: 'Hello, this is a test file content for download testing.',
          headers: {
            Headers.contentTypeHeader: ['application/octet-stream'],
          },
        ),
      );

      final progressValues = <double>[];

      try {
        final result = await repo.downloadUpdate(
          url: 'https://example.com/download/test-asset',
          savePath: savePath,
          onProgress: (progress, speed) {
            progressValues.add(progress);
          },
        );

        expect(result, savePath);
        expect(File(savePath).existsSync(), true);
      } finally {
        await tempDir.delete(recursive: true);
      }
    });
  });

  // ──── SECTION 2: SHA-256 校验 ────

  group('UpdateRepositoryImpl.verifyChecksum', () {
    late Dio dio;
    late _MockAdapter mockAdapter;
    late UpdateRepositoryImpl repo;

    setUp(() {
      dio = Dio();
      mockAdapter = _MockAdapter();
      dio.httpClientAdapter = mockAdapter;

      repo = UpdateRepositoryImpl(
        dio: dio,
        prober: _FakeProber(),
      );
    });

    test('checksum 文件不可用时返回 true（不阻断更新）', () async {
      // No checksum route registered — will fail with connection error
      final tempDir = await Directory.systemTemp.createTemp('busic_cs_test');
      final filePath = '${tempDir.path}/test.apk';
      await File(filePath).writeAsString('test content');

      try {
        final result = await repo.verifyChecksum(
          filePath,
          'busic-android.apk',
          '1.0.0',
        );
        expect(result, true);
      } finally {
        await tempDir.delete(recursive: true);
      }
    });

    test('checksum 匹配时返回 true', () async {
      final tempDir = await Directory.systemTemp.createTemp('busic_cs_test2');
      final filePath = '${tempDir.path}/test.apk';
      const content = 'test file for checksum';
      await File(filePath).writeAsString(content);

      // Calculate the expected SHA-256
      final bytes = await File(filePath).readAsBytes();
      final expectedHash = sha256.convert(bytes).toString();

      mockAdapter.registerRoute(
        'checksums.sha256',
        _MockResponse(
          body: '$expectedHash  busic-android.apk\n',
        ),
      );

      try {
        final result = await repo.verifyChecksum(
          filePath,
          'busic-android.apk',
          '1.0.0',
        );
        expect(result, true);
      } finally {
        await tempDir.delete(recursive: true);
      }
    });

    test('checksum 不匹配时返回 false', () async {
      final tempDir = await Directory.systemTemp.createTemp('busic_cs_test3');
      final filePath = '${tempDir.path}/test.apk';
      await File(filePath).writeAsString('actual content');

      mockAdapter.registerRoute(
        'checksums.sha256',
        _MockResponse(
          body:
              'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  busic-android.apk\n',
        ),
      );

      try {
        final result = await repo.verifyChecksum(
          filePath,
          'busic-android.apk',
          '1.0.0',
        );
        expect(result, false);
      } finally {
        await tempDir.delete(recursive: true);
      }
    });

    test('checksum 文件中找不到对应 asset 时返回 true', () async {
      final tempDir = await Directory.systemTemp.createTemp('busic_cs_test4');
      final filePath = '${tempDir.path}/test.apk';
      await File(filePath).writeAsString('content');

      mockAdapter.registerRoute(
        'checksums.sha256',
        _MockResponse(
          body: 'abcdef123456  busic-linux-x64.tar.gz\n',
        ),
      );

      try {
        final result = await repo.verifyChecksum(
          filePath,
          'busic-android.apk',
          '1.0.0',
        );
        expect(result, true); // Not found → skip verification
      } finally {
        await tempDir.delete(recursive: true);
      }
    });
  });

  // ──── SECTION 3: probeProxies ────

  group('UpdateRepositoryImpl.probeProxies', () {
    test('probeProxies 调用 prober 不抛异常', () async {
      final dio = Dio();
      final repo = UpdateRepositoryImpl(
        dio: dio,
        prober: _FakeProber(),
      );

      // Should not throw
      await repo.probeProxies();
    });
  });
}
