import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/api/bili_dio.dart';
import 'package:busic/features/search_and_parse/data/parse_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BiliDio biliDio;
  late _QueuedHttpClientAdapter adapter;
  late ParseRepositoryImpl repository;

  setUp(() async {
    biliDio = BiliDio();
    await biliDio.clearCookies();
    adapter = _QueuedHttpClientAdapter();
    biliDio.dio.httpClientAdapter = adapter;
    repository = ParseRepositoryImpl(biliDio: biliDio);
  });

  group('ParseRepositoryImpl.getVideoInfo', () {
    test('会映射视频详情的扩展字段', () async {
      adapter.register(
        '/x/web-interface/view',
        body: {
          'code': 0,
          'message': '0',
          'data': {
            'bvid': 'BV1xx411c7mD',
            'aid': 123456,
            'title': 'Night Drive',
            'desc': 'City pop mix',
            'pubdate': 1710000000,
            'tname': 'Music',
            'owner': {
              'name': 'BuSic',
              'mid': 42,
              'face': 'https://example.com/avatar.jpg',
            },
            'pic': 'https://example.com/cover.jpg',
            'pages': [
              {
                'cid': 1001,
                'page': 1,
                'part': 'P1',
                'duration': 245,
              },
              {
                'cid': 1002,
                'page': 2,
                'part': 'P2',
                'duration': 180,
              },
            ],
            'duration': 425,
            'stat': {
              'view': 10,
              'danmaku': 2,
              'reply': 3,
              'favorite': 4,
              'coin': 5,
              'share': 6,
              'like': 7,
            },
            'rights': {
              'no_reprint': 1,
            },
          },
        },
      );

      final info = await repository.getVideoInfo('BV1xx411c7mD');

      expect(info.bvid, 'BV1xx411c7mD');
      expect(info.aid, 123456);
      expect(info.title, 'Night Drive');
      expect(info.description, 'City pop mix');
      expect(info.pubdate, 1710000000);
      expect(info.tname, 'Music');
      expect(info.owner, 'BuSic');
      expect(info.ownerUid, 42);
      expect(info.ownerFace, 'https://example.com/avatar.jpg');
      expect(info.coverUrl, 'https://example.com/cover.jpg');
      expect(info.pages, hasLength(2));
      expect(info.pages.first.cid, 1001);
      expect(info.pages.last.partTitle, 'P2');
      expect(info.duration, 425);
      expect(info.stats.view, 10);
      expect(info.stats.danmaku, 2);
      expect(info.stats.reply, 3);
      expect(info.stats.favorite, 4);
      expect(info.stats.coin, 5);
      expect(info.stats.share, 6);
      expect(info.stats.like, 7);
      expect(info.rights.noReprint, isTrue);
      expect(info.tags, isEmpty);
    });
  });

  group('ParseRepositoryImpl.getVideoTags', () {
    test('会解析 tag_id 和 tag_name', () async {
      adapter.register(
        '/x/tag/archive/tags',
        body: {
          'code': 0,
          'message': '0',
          'data': [
            {
              'tag_id': 1,
              'tag_name': 'music',
            },
            {
              'id': '2',
              'name': 'live',
            },
            {
              'tag_id': 3,
              'tag_name': '',
            },
          ],
        },
      );

      final tags = await repository.getVideoTags('BV1xx411c7mD');

      expect(tags, hasLength(2));
      expect(tags.first.id, 1);
      expect(tags.first.name, 'music');
      expect(tags.last.id, 2);
      expect(tags.last.name, 'live');
    });

    test('请求失败时返回空列表', () async {
      adapter.registerError('/x/tag/archive/tags');

      final tags = await repository.getVideoTags('BV1xx411c7mD');

      expect(tags, isEmpty);
    });
  });
}

class _QueuedHttpClientAdapter implements HttpClientAdapter {
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
