import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/api/bili_dio.dart';
import 'package:busic/features/search_and_parse/data/video_interaction_exception.dart';
import 'package:busic/features/search_and_parse/data/video_interaction_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BiliDio biliDio;
  late _QueuedHttpClientAdapter adapter;
  late VideoInteractionRepositoryImpl repository;

  setUp(() async {
    biliDio = BiliDio();
    await biliDio.clearCookies();
    adapter = _QueuedHttpClientAdapter();
    biliDio.dio.httpClientAdapter = adapter;
    repository = VideoInteractionRepositoryImpl(biliDio: biliDio);
  });

  group('VideoInteractionRepositoryImpl.getInteractionState', () {
    test('会合并点赞、投币和收藏状态', () async {
      adapter.register(
        '/x/web-interface/archive/has/like',
        body: {
          'code': 0,
          'message': '0',
          'data': 1,
        },
      );
      adapter.register(
        '/x/web-interface/archive/coins',
        body: {
          'code': 0,
          'message': '0',
          'data': {'multiply': 2},
        },
      );
      adapter.register(
        '/x/v2/fav/video/favoured',
        body: {
          'code': 0,
          'message': '0',
          'data': {
            'count': 3,
            'favoured': true,
          },
        },
      );

      final state = await repository.getInteractionState(
        aid: 123456,
        bvid: 'BV1xx411c7mD',
      );

      expect(state.isLiked, isTrue);
      expect(state.coinsGiven, 2);
      expect(state.isFavorited, isTrue);
      expect(state.isBusy, isFalse);
      expect(state.lastError, isNull);
      expect(
        adapter.requests.first.uri.queryParameters['bvid'],
        'BV1xx411c7mD',
      );
    });

    test('单项状态读取失败时返回该项默认值', () async {
      adapter.registerError('/x/web-interface/archive/has/like');
      adapter.register(
        '/x/web-interface/archive/coins',
        body: {
          'code': 0,
          'message': '0',
          'data': {'multiply': 1},
        },
      );
      adapter.register(
        '/x/v2/fav/video/favoured',
        body: {
          'code': 0,
          'message': '0',
          'data': {'favoured': true},
        },
      );

      final state = await repository.getInteractionState(
        aid: 123456,
        bvid: 'BV1xx411c7mD',
      );

      expect(state.isLiked, isFalse);
      expect(state.coinsGiven, 1);
      expect(state.isFavorited, isTrue);
    });
  });

  group('VideoInteractionRepositoryImpl writes', () {
    test('点赞和取消点赞使用 archive like 接口', () async {
      adapter.register(
        '/x/web-interface/archive/like',
        body: {
          'code': 0,
          'message': '0',
        },
      );

      await repository.setLike(aid: 123456, like: true, csrf: 'csrf-token');
      var request = adapter.requests.single;
      expect(request.uri.path, '/x/web-interface/archive/like');
      expect(request.method, 'POST');
      expect(request.form['aid'], '123456');
      expect(request.form['like'], '1');
      expect(request.form['csrf'], 'csrf-token');

      adapter.requests.clear();
      await repository.setLike(aid: 123456, like: false, csrf: 'csrf-token');
      request = adapter.requests.single;
      expect(request.form['like'], '2');
    });

    test('投币使用 coin add 接口并携带同时点赞选项', () async {
      adapter.register(
        '/x/web-interface/coin/add',
        body: {
          'code': 0,
          'message': '0',
          'data': {'like': true},
        },
      );

      await repository.addCoin(
        aid: 123456,
        multiply: 2,
        alsoLike: true,
        csrf: 'csrf-token',
      );

      final request = adapter.requests.single;
      expect(request.uri.path, '/x/web-interface/coin/add');
      expect(request.method, 'POST');
      expect(request.form['aid'], '123456');
      expect(request.form['multiply'], '2');
      expect(request.form['select_like'], '1');
      expect(request.form['cross_domain'], 'true');
      expect(request.form['csrf'], 'csrf-token');
    });

    test('添加收藏夹使用 fav resource deal 接口', () async {
      adapter.register(
        '/x/v3/fav/resource/deal',
        body: {
          'code': 0,
          'message': '0',
          'data': {'success_num': 1},
        },
      );

      await repository.addToFavoriteFolder(
        aid: 123456,
        mediaId: 789,
        csrf: 'csrf-token',
      );

      final request = adapter.requests.single;
      expect(request.uri.path, '/x/v3/fav/resource/deal');
      expect(request.method, 'POST');
      expect(request.form['rid'], '123456');
      expect(request.form['type'], '2');
      expect(request.form['add_media_ids'], '789');
      expect(request.form['platform'], 'web');
      expect(request.form['csrf'], 'csrf-token');
    });

    test('分享记录使用 share add 接口', () async {
      adapter.register(
        '/x/web-interface/share/add',
        body: {
          'code': 0,
          'message': '0',
          'data': 1,
        },
      );

      await repository.recordShare(
        aid: 123456,
        bvid: 'BV1xx411c7mD',
        csrf: 'csrf-token',
      );

      final request = adapter.requests.single;
      expect(request.uri.path, '/x/web-interface/share/add');
      expect(request.method, 'POST');
      expect(request.form['aid'], '123456');
      expect(request.form['bvid'], 'BV1xx411c7mD');
      expect(request.form['source'], 'web_normal');
      expect(request.form['csrf'], 'csrf-token');
    });

    test('B 站错误码会转换为 VideoInteractionException', () async {
      adapter.register(
        '/x/web-interface/archive/like',
        body: {
          'code': 65004,
          'message': '取消赞失败',
        },
      );

      await expectLater(
        () => repository.setLike(
          aid: 123456,
          like: false,
          csrf: 'csrf-token',
        ),
        throwsA(
          isA<VideoInteractionException>()
              .having((error) => error.code, 'code', 65004)
              .having((error) => error.message, 'message', '取消赞失败'),
        ),
      );
    });
  });
}

class _QueuedHttpClientAdapter implements HttpClientAdapter {
  final List<_RecordedRequest> requests = [];
  final Map<String, List<_MockHttpResponse>> _responses = {};

  void register(
    String pattern, {
    required Object body,
    int statusCode = 200,
  }) {
    _responses[pattern] = [
      _MockHttpResponse(body: body, statusCode: statusCode),
    ];
  }

  void registerError(String pattern) {
    _responses[pattern] = [
      const _MockHttpResponse(error: true),
    ];
  }

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final requestBody = await _readRequestBody(requestStream, options.data);
    requests.add(_RecordedRequest(
      method: options.method,
      uri: options.uri,
      headers: Map<String, dynamic>.from(options.headers),
      body: requestBody,
    ));

    final url = options.uri.toString();
    for (final entry in _responses.entries) {
      if (!url.contains(entry.key)) continue;

      final responses = entry.value;
      final response =
          responses.length > 1 ? responses.removeAt(0) : responses.first;
      if (response.error) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'Simulated failure for $url',
        );
      }

      return ResponseBody.fromString(
        jsonEncode(response.body),
        response.statusCode,
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

  Future<String> _readRequestBody(
    Stream<List<int>>? requestStream,
    Object? data,
  ) async {
    if (requestStream != null) {
      final chunks = await requestStream.toList();
      final bytes = chunks.expand((chunk) => chunk).toList();
      if (bytes.isNotEmpty) {
        return utf8.decode(bytes);
      }
    }

    if (data is Map) {
      return Uri(
        queryParameters: data.map((key, value) => MapEntry('$key', '$value')),
      ).query;
    }

    return '';
  }
}

class _RecordedRequest {
  const _RecordedRequest({
    required this.method,
    required this.uri,
    required this.headers,
    required this.body,
  });

  final String method;
  final Uri uri;
  final Map<String, dynamic> headers;
  final String body;

  Map<String, String> get form => Uri.splitQueryString(body);
}

class _MockHttpResponse {
  const _MockHttpResponse({
    this.body,
    this.statusCode = 200,
    this.error = false,
  });

  final Object? body;
  final int statusCode;
  final bool error;
}
