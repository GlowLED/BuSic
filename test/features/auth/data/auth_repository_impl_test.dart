import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/api/bili_dio.dart';
import 'package:busic/core/database/app_database.dart';
import 'package:busic/features/auth/data/auth_repository_impl.dart';
import 'package:busic/features/auth/domain/models/user.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late BiliDio biliDio;
  late _RecordingAdapter biliAdapter;
  late Dio authDio;
  late _RecordingAdapter authAdapter;
  late AuthRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    biliDio = BiliDio();
    await biliDio.clearCookies();

    biliAdapter = _RecordingAdapter();
    biliDio.dio.httpClientAdapter = biliAdapter;

    authDio = Dio();
    authAdapter = _RecordingAdapter();
    authDio.httpClientAdapter = authAdapter;

    repository = AuthRepositoryImpl(
      biliDio: biliDio,
      db: db,
      authDio: authDio,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('AuthRepositoryImpl', () {
    test('saveSession 会写入数据库，并在后续请求中带上 raw cookies', () async {
      biliAdapter.register(
        '/x/web-interface/nav',
        body: {
          'code': 0,
          'data': {
            'uname': '刷新后的昵称',
            'face': 'https://example.com/avatar.png',
          },
        },
      );

      const user = User(
        userId: '10086',
        nickname: '测试用户',
        avatarUrl: 'https://example.com/original.png',
        sessdata: 'sess-token',
        biliJct: 'csrf-token',
        isLoggedIn: true,
      );

      await repository.saveSession(user);
      final refreshed = await repository.refreshSession();

      final sessions = await db.select(db.userSessions).get();
      expect(sessions, hasLength(1));
      expect(sessions.single.dedeUserId, '10086');
      expect(sessions.single.sessdata, 'sess-token');
      expect(refreshed?.nickname, '刷新后的昵称');
      expect(
        biliAdapter.lastRequest?.headers['Cookie'],
        contains('SESSDATA=sess-token'),
      );
      expect(
        biliAdapter.lastRequest?.headers['Cookie'],
        contains('bili_jct=csrf-token'),
      );
      expect(
        biliAdapter.lastRequest?.headers['Cookie'],
        contains('DedeUserID=10086'),
      );
    });

    test('loadSession 会返回最近一次会话并恢复 cookies', () async {
      await db.into(db.userSessions).insert(
            UserSessionsCompanion.insert(
              sessdata: 'older-sess',
              biliJct: 'older-csrf',
              dedeUserId: '1',
              nickname: const Value('旧会话'),
            ),
          );
      await db.into(db.userSessions).insert(
            UserSessionsCompanion.insert(
              sessdata: 'latest-sess',
              biliJct: 'latest-csrf',
              dedeUserId: '2',
              nickname: const Value('新会话'),
            ),
          );
      biliAdapter.register('/probe', body: {'ok': true});

      final user = await repository.loadSession();
      await biliDio.get('/probe');

      expect(user?.userId, '2');
      expect(user?.nickname, '新会话');
      expect(
        biliAdapter.lastRequest?.headers['Cookie'],
        contains('SESSDATA=latest-sess'),
      );
      expect(
        biliAdapter.lastRequest?.headers['Cookie'],
        contains('bili_jct=latest-csrf'),
      );
    });

    test('clearSession 会清空数据库和内存 cookies', () async {
      biliAdapter.register('/probe', body: {'ok': true});

      await repository.saveSession(const User(
        userId: '3',
        nickname: '待退出',
        sessdata: 'logout-sess',
        biliJct: 'logout-csrf',
        isLoggedIn: true,
      ));
      await repository.clearSession();
      await biliDio.get('/probe');

      final sessions = await db.select(db.userSessions).get();
      expect(sessions, isEmpty);
      expect(biliAdapter.lastRequest?.headers['Cookie'], isNull);
    });

    test('refreshSession 失败时返回 null，不向外抛异常', () async {
      await repository.saveSession(const User(
        userId: '4',
        nickname: '失效用户',
        sessdata: 'bad-sess',
        biliJct: 'bad-csrf',
        isLoggedIn: true,
      ));
      biliAdapter.registerError('/x/web-interface/nav');

      final result = await repository.refreshSession();

      expect(result, isNull);
    });

    test('generateQrCode 和 pollQrStatus 能解析 passport 响应', () async {
      authAdapter.register(
        'qrcode/generate',
        body: {
          'data': {
            'url': 'https://example.com/qr',
            'qrcode_key': 'qr-key',
          },
        },
      );
      authAdapter.register(
        'qrcode/poll',
        body: {
          'data': {
            'code': 86090,
            'message': '已扫码',
            'url': 'https://callback.example.com',
          },
        },
      );

      final qr = await repository.generateQrCode();
      final poll = await repository.pollQrStatus('qr-key');

      expect(qr.qrUrl, 'https://example.com/qr');
      expect(qr.qrKey, 'qr-key');
      expect(poll.code, 86090);
      expect(poll.message, '已扫码');
      expect(
          authAdapter.lastRequest?.uri.queryParameters['qrcode_key'], 'qr-key');
    });
  });
}

class _RecordingAdapter implements HttpClientAdapter {
  final Map<String, _AdapterResponse> _responses = {};
  RequestOptions? lastRequest;

  void register(String pattern, {required Object body}) {
    _responses[pattern] = _AdapterResponse(body: body);
  }

  void registerError(String pattern) {
    _responses[pattern] = const _AdapterResponse(error: true);
  }

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    final url = options.uri.toString();

    for (final entry in _responses.entries) {
      if (!url.contains(entry.key)) continue;

      if (entry.value.error) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'Simulated failure for $url',
        );
      }

      return ResponseBody.fromString(
        jsonEncode(entry.value.body),
        200,
        headers: const {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    }

    throw DioException(
      requestOptions: options,
      type: DioExceptionType.connectionError,
      message: 'No mock route for $url',
    );
  }
}

class _AdapterResponse {
  const _AdapterResponse({
    this.body,
    this.error = false,
  });

  final Object? body;
  final bool error;
}
