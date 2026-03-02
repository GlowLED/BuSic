import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

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
  late final CookieJar _cookieJar;

  BiliDio._internal() {
    _cookieJar = PersistCookieJar();
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.bilibili.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Referer': 'https://www.bilibili.com',
        },
      ),
    );
    _dio.interceptors.addAll([
      CookieManager(_cookieJar),
      _BiliRefererInterceptor(),
      // TODO: add WBI signature interceptor
    ]);
  }

  /// Returns the singleton [BiliDio] instance.
  factory BiliDio() {
    _instance ??= BiliDio._internal();
    return _instance!;
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
    // TODO: implement with WBI signing for protected endpoints
    throw UnimplementedError();
  }

  /// Perform a POST request to [path] with optional [data].
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    // TODO: implement
    throw UnimplementedError();
  }

  /// Update stored cookies (e.g., after QR login).
  Future<void> updateCookies(Uri uri, List<Cookie> cookies) async {
    // TODO: implement
    throw UnimplementedError();
  }

  /// Clear all stored cookies (logout).
  Future<void> clearCookies() async {
    // TODO: implement
    throw UnimplementedError();
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
