import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/subtitle_data.dart';
import '../domain/models/subtitle_line.dart';
import 'subtitle_repository.dart';

/// Thrown when subtitle fetching requires a logged-in Bilibili session.
class SubtitleLoginRequiredException implements Exception {
  const SubtitleLoginRequiredException();

  @override
  String toString() => 'SubtitleLoginRequiredException';
}

/// Concrete implementation of [SubtitleRepository].
///
/// Fetches subtitles from Bilibili's `/x/player/v2` API with
/// prefix-validation + retry logic to work around the API instability
/// where wrong subtitle URLs are frequently returned.
class SubtitleRepositoryImpl implements SubtitleRepository {
  final BiliDio _biliDio;
  final AppDatabase _db;

  SubtitleRepositoryImpl({
    required BiliDio biliDio,
    required AppDatabase db,
  })  : _biliDio = biliDio,
        _db = db;

  @override
  Future<SubtitleData?> getSubtitle({
    required String bvid,
    required int cid,
  }) async {
    // 1. Check DB cache first
    final cached = await getCachedSubtitle(bvid: bvid, cid: cid);
    if (cached != null) {
      AppLogger.info(
        'Subtitle cache hit for $bvid:$cid',
        tag: 'Subtitle',
      );
      return cached;
    }

    // 2. Fetch from API
    final data = await fetchSubtitleFromApi(bvid: bvid, cid: cid);
    if (data != null) {
      // 3. Cache to DB
      await cacheSubtitle(bvid: bvid, cid: cid, data: data);
    }
    return data;
  }

  @override
  Future<SubtitleData?> getCachedSubtitle({
    required String bvid,
    required int cid,
  }) async {
    final query = _db.select(_db.subtitles)
      ..where(
        (t) => t.bvid.equals(bvid) & t.cid.equals(cid),
      );
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    try {
      final json = jsonDecode(row.subtitleJson) as Map<String, dynamic>;
      return SubtitleData.fromJson(json);
    } catch (e) {
      AppLogger.warning(
        'Failed to parse cached subtitle: $e',
        tag: 'Subtitle',
      );
      return null;
    }
  }

  @override
  Future<void> cacheSubtitle({
    required String bvid,
    required int cid,
    required SubtitleData data,
  }) async {
    await _db.into(_db.subtitles).insertOnConflictUpdate(
          SubtitlesCompanion.insert(
            bvid: bvid,
            cid: cid,
            subtitleJson: jsonEncode(data.toJson()),
            sourceType: Value(data.sourceType),
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
  }

  @override
  Future<SubtitleData?> fetchSubtitleFromApi({
    required String bvid,
    required int cid,
    int maxRetries = 10,
  }) async {
    // Step 1: Get aid for prefix validation
    final aid = await _getAid(bvid);

    // Step 2: Retry loop
    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        // 2a. Call /x/player/v2 to get subtitle list
        final subtitles = await _getSubtitleList(bvid, cid);
        if (subtitles.isEmpty) {
          AppLogger.info(
            'Attempt $attempt: no subtitles returned',
            tag: 'Subtitle',
          );
          await Future.delayed(const Duration(milliseconds: 400));
          continue;
        }

        // 2b. Find best subtitle (prefer AI, fallback to CC)
        final target = _findBestSubtitle(subtitles);
        if (target == null) {
          await Future.delayed(const Duration(milliseconds: 400));
          continue;
        }

        final subtitleUrl = target['subtitle_url'] as String;
        final isAi = subtitleUrl.contains('/bfs/ai_subtitle/');
        final sourceType = isAi ? 'ai' : 'cc';
        final language = target['lan'] as String? ?? '';

        // 2c. AI subtitle prefix validation
        if (isAi && !_validateAiSubtitleUrl(subtitleUrl, aid, cid)) {
          AppLogger.info(
            'Attempt $attempt: wrong prefix, retrying...',
            tag: 'Subtitle',
          );
          await Future.delayed(const Duration(milliseconds: 400));
          continue;
        }

        // 2d. Download subtitle content
        final content = await _fetchSubtitleContent(subtitleUrl);
        if (content == null) {
          await Future.delayed(const Duration(milliseconds: 400));
          continue;
        }

        // 2e. Parse into SubtitleData
        final result = _parseSubtitleContent(content, sourceType, language);
        if (result != null && result.lines.isNotEmpty) {
          AppLogger.info(
            'Subtitle fetched on attempt $attempt '
            '(${result.lines.length} lines, source=$sourceType)',
            tag: 'Subtitle',
          );
          return result;
        }
      } catch (e) {
        AppLogger.warning(
          'Subtitle attempt $attempt failed: $e',
          tag: 'Subtitle',
        );
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }

    AppLogger.info(
      'Subtitle retries exhausted for $bvid:$cid',
      tag: 'Subtitle',
    );
    return null;
  }

  // ── Private helpers ───────────────────────────────────────────

  /// Resolve BV number to aid via `/x/web-interface/view`.
  Future<int> _getAid(String bvid) async {
    final response = await _biliDio.get(
      '/x/web-interface/view',
      queryParameters: {'bvid': bvid},
    );
    final code = response.data['code'] as int? ?? 0;
    if (code == -101) {
      throw const SubtitleLoginRequiredException();
    }
    final data = response.data['data'];
    if (data == null) {
      throw Exception('Failed to resolve aid for $bvid');
    }
    return data['aid'] as int;
  }

  /// Fetch subtitle list from `/x/player/v2`.
  Future<List<Map<String, dynamic>>> _getSubtitleList(
    String bvid,
    int cid,
  ) async {
    final response = await _biliDio.get(
      '/x/player/v2',
      queryParameters: {'bvid': bvid, 'cid': cid},
    );
    final code = response.data['code'] as int? ?? 0;
    if (code == -101) {
      throw const SubtitleLoginRequiredException();
    }
    final data = response.data['data'];
    if (data == null) return [];

    final subtitle = data['subtitle'] as Map<String, dynamic>?;
    if (subtitle == null) return [];

    final subtitles = subtitle['subtitles'] as List?;
    if (subtitles == null || subtitles.isEmpty) return [];

    return subtitles.cast<Map<String, dynamic>>();
  }

  /// Pick the best subtitle entry: prefer AI zh, then any AI, then CC.
  Map<String, dynamic>? _findBestSubtitle(
    List<Map<String, dynamic>> subtitles,
  ) {
    // Priority: ai-zh > any AI > CC zh > any CC
    Map<String, dynamic>? aiZh;
    Map<String, dynamic>? anyAi;
    Map<String, dynamic>? ccZh;
    Map<String, dynamic>? anyCc;

    for (final s in subtitles) {
      final lan = s['lan'] as String? ?? '';
      final url = s['subtitle_url'] as String? ?? '';
      final isAi = url.contains('/bfs/ai_subtitle/');

      if (isAi) {
        if (lan.contains('zh')) {
          aiZh ??= s;
        }
        anyAi ??= s;
      } else {
        if (lan.contains('zh')) {
          ccZh ??= s;
        }
        anyCc ??= s;
      }
    }

    return aiZh ?? anyAi ?? ccZh ?? anyCc;
  }

  /// Validate that an AI subtitle URL path starts with `{aid}{cid}`.
  bool _validateAiSubtitleUrl(String url, int aid, int cid) {
    final parsed = Uri.parse(url.startsWith('//') ? 'https:$url' : url);
    final match = RegExp(r'/bfs/ai_subtitle/prod/(\d+)')
        .firstMatch(parsed.path);
    if (match == null) return false;
    final pathPrefix = match.group(1)!;
    final expected = '$aid$cid';
    return pathPrefix.startsWith(expected);
  }

  /// Download subtitle JSON content from the given URL.
  Future<Map<String, dynamic>?> _fetchSubtitleContent(String url) async {
    try {
      final fullUrl = url.startsWith('//') ? 'https:$url' : url;
      final response = await _biliDio.dio.get<dynamic>(fullUrl);

      if (response.data == null) return null;

      // Response may be already parsed as Map or be a string
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      if (response.data is String) {
        return jsonDecode(response.data as String) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      AppLogger.warning(
        'Failed to download subtitle content: $e',
        tag: 'Subtitle',
      );
      return null;
    }
  }

  /// Parse raw subtitle JSON into [SubtitleData].
  SubtitleData? _parseSubtitleContent(
    Map<String, dynamic> content,
    String sourceType,
    String language,
  ) {
    final body = content['body'] as List?;
    if (body == null || body.isEmpty) return null;

    final lines = <SubtitleLine>[];
    for (final item in body) {
      final map = item as Map<String, dynamic>;
      final text = (map['content'] as String? ?? '').trim();
      if (text.isEmpty) continue;

      lines.add(SubtitleLine(
        startTime: (map['from'] as num?)?.toDouble() ?? 0.0,
        endTime: (map['to'] as num?)?.toDouble() ?? 0.0,
        content: text,
        musicRatio: (map['music'] as num?)?.toDouble() ?? 0.0,
      ));
    }

    if (lines.isEmpty) return null;

    // Sort by start time
    lines.sort((a, b) => a.startTime.compareTo(b.startTime));

    return SubtitleData(
      lines: lines,
      sourceType: sourceType,
      language: language,
    );
  }
}
