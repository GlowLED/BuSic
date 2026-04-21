import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/api/bili_dio.dart';
import 'package:busic/core/database/app_database.dart';
import 'package:busic/features/subtitle/data/subtitle_repository_impl.dart';
import 'package:busic/features/subtitle/domain/models/subtitle_data.dart';
import 'package:busic/features/subtitle/domain/models/subtitle_line.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late BiliDio biliDio;
  late _QueuedHttpClientAdapter adapter;
  late SubtitleRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    biliDio = BiliDio();
    await biliDio.clearCookies();
    adapter = _QueuedHttpClientAdapter();
    biliDio.dio.httpClientAdapter = adapter;
    repository = SubtitleRepositoryImpl(biliDio: biliDio, db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SubtitleRepositoryImpl.getSubtitle', () {
    test('命中缓存时直接返回，不再请求远端', () async {
      const cached = _SubtitleFixture.data;
      await repository.cacheSubtitle(
        bvid: 'BVcache01',
        cid: 1001,
        data: cached,
      );

      final result = await repository.getSubtitle(
        bvid: 'BVcache01',
        cid: 1001,
      );

      expect(result, cached);
      expect(adapter.requests, isEmpty);
    });
  });

  group('SubtitleRepositoryImpl.fetchSubtitleFromApi', () {
    test('AI 前缀错配时会重试，直到拿到合法字幕', () async {
      adapter.register(
        '/x/web-interface/view',
        body: {
          'code': 0,
          'data': {'aid': 123},
        },
      );
      adapter.registerSequence(
        '/x/player/v2',
        bodies: [
          {
            'code': 0,
            'data': {
              'subtitle': {
                'subtitles': [
                  {
                    'lan': 'ai-zh',
                    'subtitle_url':
                        '//i0.hdslb.com/bfs/ai_subtitle/prod/999999/wrong.json',
                  },
                ],
              },
            },
          },
          {
            'code': 0,
            'data': {
              'subtitle': {
                'subtitles': [
                  {
                    'lan': 'ai-zh',
                    'subtitle_url':
                        '//i0.hdslb.com/bfs/ai_subtitle/prod/123456/right.json',
                  },
                ],
              },
            },
          },
        ],
      );
      adapter.register(
        '123456/right.json',
        body: {
          'body': [
            {'from': 2.0, 'to': 3.0, 'content': '第二句'},
            {'from': 1.0, 'to': 1.5, 'content': '第一句'},
          ],
        },
      );

      final result = await repository.fetchSubtitleFromApi(
        bvid: 'BVretry01',
        cid: 456,
        maxRetries: 2,
      );

      expect(result, isNotNull);
      expect(result?.sourceType, 'ai');
      expect(result?.language, 'ai-zh');
      expect(result?.lines.map((line) => line.content), ['第一句', '第二句']);
      expect(adapter.matchCount('/x/player/v2'), 2);
    });

    test('接口返回 -101 时抛出登录异常', () async {
      adapter.register(
        '/x/web-interface/view',
        body: {'code': -101},
      );

      expect(
        () => repository.fetchSubtitleFromApi(
          bvid: 'BVlogin01',
          cid: 1,
          maxRetries: 1,
        ),
        throwsA(isA<SubtitleLoginRequiredException>()),
      );
    });

    test('AI 不可用时会回退到 CC，并过滤空行后按时间排序', () async {
      adapter.register(
        '/x/web-interface/view',
        body: {
          'code': 0,
          'data': {'aid': 321},
        },
      );
      adapter.register(
        '/x/player/v2',
        body: {
          'code': 0,
          'data': {
            'subtitle': {
              'subtitles': [
                {
                  'lan': 'zh-Hans',
                  'subtitle_url': '//i0.hdslb.com/bfs/subtitle/321654/cc.json',
                },
              ],
            },
          },
        },
      );
      adapter.register(
        '321654/cc.json',
        body: {
          'body': [
            {'from': 2.0, 'to': 3.0, 'content': '第二句'},
            {'from': 0.5, 'to': 1.0, 'content': '   '},
            {'from': 1.0, 'to': 1.5, 'content': '第一句'},
          ],
        },
      );

      final result = await repository.fetchSubtitleFromApi(
        bvid: 'BVcc01',
        cid: 654,
        maxRetries: 1,
      );

      expect(result, isNotNull);
      expect(result?.sourceType, 'cc');
      expect(result?.language, 'zh-Hans');
      expect(result?.lines, hasLength(2));
      expect(result?.lines.first.startTime, 1.0);
      expect(result?.lines.last.startTime, 2.0);
    });
  });
}

class _SubtitleFixture {
  static const data = SubtitleData(
    lines: [
      SubtitleLine(
        startTime: 0,
        endTime: 1,
        content: '缓存歌词',
        musicRatio: 0,
      ),
    ],
    sourceType: 'ai',
    language: 'ai-zh',
  );
}

class _QueuedHttpClientAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];
  final Map<String, List<_MockHttpResponse>> _responses = {};
  final Map<String, int> _matchCounts = {};

  void register(
    String pattern, {
    required Object body,
    int statusCode = 200,
  }) {
    _responses[pattern] = [
      _MockHttpResponse(body: body, statusCode: statusCode)
    ];
  }

  void registerSequence(
    String pattern, {
    required List<Object> bodies,
    int statusCode = 200,
  }) {
    _responses[pattern] = bodies
        .map((body) => _MockHttpResponse(body: body, statusCode: statusCode))
        .toList();
  }

  int matchCount(String pattern) => _matchCounts[pattern] ?? 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final url = options.uri.toString();

    for (final entry in _responses.entries) {
      if (!url.contains(entry.key)) continue;

      final responses = entry.value;
      final response =
          responses.length > 1 ? responses.removeAt(0) : responses.first;
      _matchCounts.update(entry.key, (count) => count + 1, ifAbsent: () => 1);

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
  _MockHttpResponse({
    required this.body,
    required this.statusCode,
  });

  final Object body;
  final int statusCode;
}
