import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/auth/domain/models/bili_login_cookies.dart';

void main() {
  group('BiliLoginCookies', () {
    test('fromCookieMap parses required Bilibili cookies', () {
      final cookies = BiliLoginCookies.fromCookieMap({
        'SESSDATA': ' sess-token ',
        'bili_jct': ' csrf-token ',
        'DedeUserID': ' 42 ',
      });

      expect(cookies, isNotNull);
      expect(cookies?.sessdata, 'sess-token');
      expect(cookies?.biliJct, 'csrf-token');
      expect(cookies?.dedeUserId, '42');
    });

    test('fromCookieMap allows missing DedeUserID', () {
      final cookies = BiliLoginCookies.fromCookieMap({
        'SESSDATA': 'sess-token',
        'bili_jct': 'csrf-token',
      });

      expect(cookies, isNotNull);
      expect(cookies?.dedeUserId, isNull);
    });

    test('fromCookieMap rejects incomplete login cookies', () {
      expect(
        BiliLoginCookies.fromCookieMap({'SESSDATA': 'sess-token'}),
        isNull,
      );
      expect(
        BiliLoginCookies.fromCookieMap({'bili_jct': 'csrf-token'}),
        isNull,
      );
    });
  });
}
