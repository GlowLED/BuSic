import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../domain/models/bili_login_cookies.dart';

abstract class BiliWebLoginCookieStore {
  Future<BiliLoginCookies?> readBiliCookies();

  Future<void> clearBiliCookies();
}

class InAppBiliWebLoginCookieStore implements BiliWebLoginCookieStore {
  InAppBiliWebLoginCookieStore({
    CookieManager? cookieManager,
    WebViewEnvironment? webViewEnvironment,
  }) : _cookieManager =
           cookieManager ??
           CookieManager.instance(webViewEnvironment: webViewEnvironment);

  static final _cookieUrls = [
    WebUri('https://www.bilibili.com'),
    WebUri('https://passport.bilibili.com'),
    WebUri('https://api.bilibili.com'),
  ];

  final CookieManager _cookieManager;

  @override
  Future<BiliLoginCookies?> readBiliCookies() async {
    final cookieMap = <String, String>{};
    for (final url in _cookieUrls) {
      final cookies = await _cookieManager.getCookies(url: url);
      for (final cookie in cookies) {
        final value = cookie.value;
        if (value == null) continue;
        cookieMap[cookie.name] = value.toString();
      }
    }
    return BiliLoginCookies.fromCookieMap(cookieMap);
  }

  @override
  Future<void> clearBiliCookies() async {
    for (final url in _cookieUrls) {
      await _cookieManager.deleteCookies(url: url);
    }
  }
}
