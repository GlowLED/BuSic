import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/auth/data/linux_managed_browser_login_service.dart';
import 'package:busic/features/auth/domain/models/bili_login_cookies.dart';

void main() {
  group('LinuxManagedBrowserCookieParser', () {
    test('只提取 B 站登录 Cookie', () {
      final cookieMap = LinuxManagedBrowserCookieParser.extractBiliCookieMap([
        {
          'name': 'SESSDATA',
          'value': 'sess',
          'domain': '.bilibili.com',
        },
        {
          'name': 'bili_jct',
          'value': 'csrf',
          'domain': 'passport.bilibili.com',
        },
        {
          'name': 'DedeUserID',
          'value': '42',
          'domain': 'api.bilibili.com',
        },
        {
          'name': 'bili_jct',
          'value': {
            'type': 'base64',
            'value': 'Y3NyZi1mcm9tLWJpZGk=',
          },
          'domain': '.bilibili.com',
        },
        {
          'name': 'SESSDATA',
          'value': 'other',
          'domain': 'example.com',
        },
      ]);

      final cookies = BiliLoginCookies.fromCookieMap(cookieMap);

      expect(cookies?.sessdata, 'sess');
      expect(cookies?.biliJct, 'csrf-from-bidi');
      expect(cookies?.dedeUserId, '42');
    });

    test('缺少关键 Cookie 时返回不可登录数据', () {
      final cookieMap = LinuxManagedBrowserCookieParser.extractBiliCookieMap([
        {
          'name': 'SESSDATA',
          'value': 'sess',
          'domain': '.bilibili.com',
        },
      ]);

      expect(BiliLoginCookies.fromCookieMap(cookieMap), isNull);
    });
  });

  group('ProcessLinuxManagedBrowserLoginService', () {
    test('检测到第一个可用 Chromium 系浏览器', () async {
      final service = ProcessLinuxManagedBrowserLoginService(
        candidates: const [
          LinuxManagedBrowserCandidate(
            executable: 'missing-browser',
            kind: LinuxManagedBrowserKind.chromium,
            displayName: 'Missing',
          ),
          LinuxManagedBrowserCandidate(
            executable: 'chromium',
            kind: LinuxManagedBrowserKind.chromium,
            displayName: 'Chromium',
          ),
        ],
        runProcess: (executable, arguments) async {
          if (executable == 'chromium') {
            return ProcessResult(1, 0, 'Chromium 120', '');
          }
          throw ProcessException(executable, arguments, 'not found');
        },
      );

      expect(await service.isAvailable(), isTrue);
    });

    test('Chromium 和 Firefox 同时存在时优先选择 Chromium', () async {
      final service = ProcessLinuxManagedBrowserLoginService(
        candidates: const [
          LinuxManagedBrowserCandidate(
            executable: 'chromium',
            kind: LinuxManagedBrowserKind.chromium,
            displayName: 'Chromium',
          ),
          LinuxManagedBrowserCandidate(
            executable: 'firefox',
            kind: LinuxManagedBrowserKind.firefox,
            displayName: 'Firefox',
            minimumMajorVersion: 124,
          ),
        ],
        runProcess: (executable, arguments) async {
          return ProcessResult(
            1,
            0,
            executable == 'firefox'
                ? 'Mozilla Firefox 150.0.1'
                : 'Chromium 120',
            '',
          );
        },
      );

      final candidate = await service.findSupportedCandidate();

      expect(candidate?.executable, 'chromium');
      expect(candidate?.kind, LinuxManagedBrowserKind.chromium);
    });

    test('没有 Chromium 但 Firefox 版本足够时可用', () async {
      final service = ProcessLinuxManagedBrowserLoginService(
        candidates: const [
          LinuxManagedBrowserCandidate(
            executable: 'missing-browser',
            kind: LinuxManagedBrowserKind.chromium,
            displayName: 'Missing',
          ),
          LinuxManagedBrowserCandidate(
            executable: 'firefox',
            kind: LinuxManagedBrowserKind.firefox,
            displayName: 'Firefox',
            minimumMajorVersion: 124,
          ),
        ],
        runProcess: (executable, arguments) async {
          if (executable == 'firefox') {
            return ProcessResult(1, 0, 'Mozilla Firefox 150.0.1', '');
          }
          throw ProcessException(executable, arguments, 'not found');
        },
      );

      final candidate = await service.findSupportedCandidate();

      expect(await service.isAvailable(), isTrue);
      expect(candidate?.executable, 'firefox');
      expect(candidate?.kind, LinuxManagedBrowserKind.firefox);
    });

    test('Firefox 版本低于 124 时不可用', () async {
      final service = ProcessLinuxManagedBrowserLoginService(
        candidates: const [
          LinuxManagedBrowserCandidate(
            executable: 'firefox-esr',
            kind: LinuxManagedBrowserKind.firefox,
            displayName: 'Firefox ESR',
            minimumMajorVersion: 124,
          ),
        ],
        runProcess: (executable, arguments) async {
          return ProcessResult(1, 0, 'Mozilla Firefox 115.14.0esr', '');
        },
      );

      expect(await service.isAvailable(), isFalse);
    });

    test('没有受支持浏览器时不可用', () async {
      final service = ProcessLinuxManagedBrowserLoginService(
        candidates: const [
          LinuxManagedBrowserCandidate(
            executable: 'missing-browser',
            kind: LinuxManagedBrowserKind.chromium,
            displayName: 'Missing',
          ),
        ],
        runProcess: (executable, arguments) async {
          throw ProcessException(executable, arguments, 'not found');
        },
      );

      expect(await service.isAvailable(), isFalse);
    });
  });

  group('FirefoxBiDiEndpointParser', () {
    test('从 Firefox stderr 中解析 BiDi endpoint 并补 /session', () {
      final endpoint = FirefoxBiDiEndpointParser.extractEndpoint(
        'WebDriver BiDi listening on ws://127.0.0.1:46249',
      );

      expect(endpoint.toString(), 'ws://127.0.0.1:46249/session');
    });

    test('保留 Firefox 已带 path 的 BiDi endpoint', () {
      final endpoint = FirefoxBiDiEndpointParser.extractEndpoint(
        'WebDriver BiDi listening on ws://127.0.0.1:46249/session',
      );

      expect(endpoint.toString(), 'ws://127.0.0.1:46249/session');
    });
  });

  group('BrowserCookieResponseParser', () {
    test('解析 WebDriver BiDi storage.getCookies 响应', () {
      final cookies = BrowserCookieResponseParser.extractCookies(
        {
          'result': {
            'cookies': [
              {
                'name': 'SESSDATA',
                'value': {
                  'type': 'string',
                  'value': 'sess',
                },
                'domain': '.bilibili.com',
              },
            ],
            'partitionKey': <String, Object?>{},
          },
        },
        protocolName: 'WebDriver BiDi',
      );

      final cookieMap =
          LinuxManagedBrowserCookieParser.extractBiliCookieMap(cookies);

      expect(cookieMap['SESSDATA'], 'sess');
    });
  });
}
