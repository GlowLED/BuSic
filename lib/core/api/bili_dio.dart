import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../utils/logger.dart';

/// Singleton Dio HTTP client configured for Bilibili API requests.
///
/// Features:
/// - Raw session cookie injection (bypasses Dart's strict Cookie parser)
/// - Referer header injection (required by Bilibili)
/// - Configurable timeout and base URL
class BiliDio {
  static BiliDio? _instance;
  late final Dio _dio;

  /// Raw session cookies stored as name->value map.
  /// Bilibili's SESSDATA contains commas which Dart's Cookie class rejects,
  /// so we handle cookies as raw strings instead.
  final Map<String, String> _sessionCookies = {};

  /// Path to persist cookies on disk.
  static String? _cookiePersistPath;

  BiliDio._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.bilibili.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
              '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Referer': 'https://www.bilibili.com',
        },
      ),
    );
    _dio.interceptors.addAll([
      _RawCookieInterceptor(this),
      _BiliRefererInterceptor(),
    ]);
  }

  /// Returns the singleton [BiliDio] instance.
  factory BiliDio() {
    _instance ??= BiliDio._internal();
    return _instance!;
  }

  /// Initialize persistent cookie storage directory.
  static Future<void> initCookieStorage() async {
    final dir = await getApplicationDocumentsDirectory();
    _cookiePersistPath = p.join(dir.path, 'busic', 'cookies.json');
    // Load persisted cookies
    await BiliDio()._loadPersistedCookies();
  }

  /// Set raw session cookies (e.g., after QR login).
  ///
  /// Values may contain commas and other characters that Dart's Cookie
  /// class rejects -- they are stored and injected as raw strings.
  Future<void> setSessionCookies(Map<String, String> cookies) async {
    _sessionCookies.addAll(cookies);
    await _persistCookies();
  }

  /// Clear all stored cookies (logout).
  Future<void> clearCookies() async {
    _sessionCookies.clear();
    await _persistCookies();
  }

  /// The underlying [Dio] instance for direct use.
  Dio get dio => _dio;

  /// Perform a GET request to [path] with optional [queryParameters].
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Perform a POST request to [path] with optional [data].
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Download a file from [url] to [savePath] with progress callback.
  Future<Response> download(
    String url,
    String savePath, {
    void Function(int received, int total)? onReceiveProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      options: Options(headers: headers),
    );
  }

  Future<void> _loadPersistedCookies() async {
    if (_cookiePersistPath == null) return;
    try {
      final file = File(_cookiePersistPath!);
      if (await file.exists()) {
        final json = await file.readAsString();
        final map = Map<String, String>.from(jsonDecode(json) as Map);
        _sessionCookies.addAll(map);
        AppLogger.info(
          'Loaded ${_sessionCookies.length} persisted cookies',
          tag: 'BiliDio',
        );
      }
    } catch (e) {
      AppLogger.warning('Failed to load cookies: $e', tag: 'BiliDio');
    }
  }

  Future<void> _persistCookies() async {
    if (_cookiePersistPath == null) return;
    try {
      final file = File(_cookiePersistPath!);
      final dir = file.parent;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      await file.writeAsString(jsonEncode(_sessionCookies));
    } catch (e) {
      AppLogger.warning('Failed to persist cookies: $e', tag: 'BiliDio');
    }
  }
}

/// Interceptor that injects raw session cookies into request headers.
///
/// This bypasses Dart's strict Cookie class which rejects commas in values
/// (common in Bilibili's SESSDATA cookie).
class _RawCookieInterceptor extends Interceptor {
  final BiliDio _biliDio;

  _RawCookieInterceptor(this._biliDio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_biliDio._sessionCookies.isNotEmpty) {
      final cookieStr = _biliDio._sessionCookies.entries
          .map((e) => '${e.key}=${e.value}')
          .join('; ');
      options.headers[HttpHeaders.cookieHeader] = cookieStr;
    }
    handler.next(options);
  }
}

/// Interceptor that ensures the Referer header is set for all requests.
class _BiliRefererInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Referer'] ??= 'https://www.bilibili.com';
    handler.next(options);
  }
}
