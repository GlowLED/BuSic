import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Singleton Dio HTTP client configured for Bilibili API requests.
///
/// Features:
/// - Cookie persistence for authenticated requests
/// - Referer header injection (required by Bilibili)
/// - WBI signature interceptor
/// - Configurable timeout and base URL
class BiliDio {
  static BiliDio? _instance;
  late final Dio _dio;
  late final PersistCookieJar _cookieJar;

  BiliDio._internal() {
    _cookieJar = PersistCookieJar();
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.bilibili.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Referer': 'https://www.bilibili.com',
        },
      ),
    );
    _dio.interceptors.addAll([
      CookieManager(_cookieJar),
      _BiliRefererInterceptor(),
    ]);
  }

  /// Returns the singleton [BiliDio] instance.
  factory BiliDio() {
    _instance ??= BiliDio._internal();
    return _instance!;
  }

  /// Initialize persistent cookie storage.
  static Future<void> initCookieStorage() async {
    final dir = await getApplicationDocumentsDirectory();
    final cookiePath = p.join(dir.path, 'busic', 'cookies');
    final cookieDir = Directory(cookiePath);
    if (!await cookieDir.exists()) {
      await cookieDir.create(recursive: true);
    }
    BiliDio()._cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
    // Re-add cookie manager with persistent storage
    BiliDio()._dio.interceptors.removeWhere((i) => i is CookieManager);
    BiliDio()._dio.interceptors.insert(0, CookieManager(BiliDio()._cookieJar));
  }

  /// The underlying [Dio] instance for direct use.
  Dio get dio => _dio;

  /// The cookie jar for session management.
  CookieJar get cookieJar => _cookieJar;

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

  /// Update stored cookies (e.g., after QR login).
  Future<void> updateCookies(Uri uri, List<Cookie> cookies) async {
    await _cookieJar.saveFromResponse(uri, cookies);
  }

  /// Clear all stored cookies (logout).
  Future<void> clearCookies() async {
    await _cookieJar.deleteAll();
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
}

/// Interceptor that ensures the Referer header is set for all requests.
class _BiliRefererInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Referer'] ??= 'https://www.bilibili.com';
    handler.next(options);
  }
}
