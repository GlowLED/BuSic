import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/utils/logger.dart';
import '../domain/models/subtitle_data.dart';
import '../domain/models/subtitle_line.dart';

class ExternalLyricsRequestException implements Exception {
  const ExternalLyricsRequestException({
    required this.userMessage,
    required this.details,
  });

  final String userMessage;
  final String details;

  @override
  String toString() => '$userMessage\n$details';
}

class ExternalLyricSong {
  const ExternalLyricSong({
    required this.id,
    required this.name,
    required this.artists,
    required this.albumName,
  });

  final int id;
  final String name;
  final List<String> artists;
  final String albumName;

  String get artistText => artists.join(', ');

  factory ExternalLyricSong.fromJson(Map<String, dynamic> json) {
    final artists = (json['artists'] as List?)
            ?.map((item) =>
                (item as Map<String, dynamic>)['name'] as String? ?? '')
            .where((name) => name.isNotEmpty)
            .toList() ??
        const <String>[];

    final album = json['album'] as Map<String, dynamic>?;
    return ExternalLyricSong(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      artists: artists,
      albumName: album?['name'] as String? ?? '',
    );
  }
}

class ExternalLyricsRepository {
  ExternalLyricsRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://interface.music.163.com',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 20),
                headers: {
                  'User-Agent':
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                          '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                  'Host': 'interface.music.163.com',
                  'Accept': '*/*',
                  'Accept-Language': 'zh-CN,zh;q=0.9',
                  'Connection': 'keep-alive',
                  'Referer': 'https://music.163.com',
                },
              ),
            );

  final Dio _dio;

  Future<List<ExternalLyricSong>> searchSongs(
    String keyword, {
    int limit = 8,
  }) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return const [];

    try {
      final response = await _dio.get<dynamic>(
        '/api/search/get/web',
        queryParameters: {
          's': trimmed,
          'type': 1,
          'limit': limit,
        },
      );
      final data = _normalizeResponseBody(response.data);
      final result = data['result'];
      final songs = (result is Map ? result['songs'] : null) as List?;
      if (songs == null) return const [];

      return songs
          .cast<Map<String, dynamic>>()
          .map(ExternalLyricSong.fromJson)
          .where((song) => song.id > 0 && song.name.isNotEmpty)
          .toList();
    } on DioException catch (e, stackTrace) {
      AppLogger.error(
        'External lyric search request failed',
        tag: 'Subtitle',
        error: e,
        stackTrace: stackTrace,
      );
      throw _buildRequestException(
        phase: 'search',
        exception: e,
      );
    } catch (e) {
      AppLogger.warning('External lyric search failed: $e', tag: 'Subtitle');
      throw ExternalLyricsRequestException(
        userMessage: 'External lyric search failed',
        details: e.toString(),
      );
    }
  }

  Future<SubtitleData?> fetchSubtitleData(int songId) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/song/lyric',
        queryParameters: {
          'id': songId,
          'lv': 1,
          'kv': 1,
          'tv': -1,
        },
      );
      final data = _normalizeResponseBody(response.data);
      final lrc = data['lrc'];
      final tlyric = data['tlyric'];
      final rawLyric = (lrc is Map ? lrc['lyric'] : null) as String? ?? '';
      final rawTranslation =
          (tlyric is Map ? tlyric['lyric'] : null) as String? ?? '';
      return _parseLrc(rawLyric, translatedLrc: rawTranslation);
    } on DioException catch (e, stackTrace) {
      AppLogger.error(
        'External lyric content request failed',
        tag: 'Subtitle',
        error: e,
        stackTrace: stackTrace,
      );
      throw _buildRequestException(
        phase: 'lyric',
        exception: e,
      );
    } catch (e) {
      AppLogger.warning('External lyric fetch failed: $e', tag: 'Subtitle');
      throw ExternalLyricsRequestException(
        userMessage: 'External lyric fetch failed',
        details: e.toString(),
      );
    }
  }

  ExternalLyricsRequestException _buildRequestException({
    required String phase,
    required DioException exception,
  }) {
    final requestUri = exception.requestOptions.uri.toString();
    final method = exception.requestOptions.method;
    final statusCode = exception.response?.statusCode;
    final responseData = exception.response?.data;
    final rawError = exception.error;
    final rawErrorType = rawError?.runtimeType.toString() ?? 'null';
    final rawErrorText = rawError?.toString();
    final responseSnippet = responseData == null
        ? 'null'
        : responseData.toString().replaceAll('\n', ' ').substring(
              0,
              responseData.toString().length > 400
                  ? 400
                  : responseData.toString().length,
            );

    return ExternalLyricsRequestException(
      userMessage: phase == 'search'
          ? 'External lyric search failed'
          : 'External lyric fetch failed',
      details: [
        'phase: $phase',
        'type: ${exception.type.name}',
        'method: $method',
        'status: ${statusCode ?? 'N/A'}',
        'uri: $requestUri',
        'raw_error_type: $rawErrorType',
        if (rawErrorText != null && rawErrorText.isNotEmpty)
          'raw_error: $rawErrorText',
        if (exception.message != null && exception.message!.isNotEmpty)
          'message: ${exception.message}',
        'response: $responseSnippet',
      ].join('\n'),
    );
  }

  Map<String, dynamic> _normalizeResponseBody(dynamic data) {
    if (data == null) return const <String, dynamic>{};

    if (data is Map<String, dynamic>) return data;

    if (data is Map) {
      return data.map(
        (key, value) => MapEntry(key.toString(), value),
      );
    }

    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return const <String, dynamic>{};

      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return decoded.map(
          (key, value) => MapEntry(key.toString(), value),
        );
      }

      throw const FormatException('Response JSON root is not an object');
    }

    throw FormatException(
      'Unsupported response type: ${data.runtimeType}',
    );
  }

  SubtitleData? _parseLrc(
    String lrc, {
    String translatedLrc = '',
  }) {
    final mainEntries = _parseTimedEntries(lrc);
    if (mainEntries.isEmpty) return null;

    final translationMap = {
      for (final entry in _parseTimedEntries(translatedLrc))
        entry.timeMs: entry.text,
    };

    final lines = <SubtitleLine>[];
    for (var index = 0; index < mainEntries.length; index++) {
      final entry = mainEntries[index];
      final nextStartMs = index + 1 < mainEntries.length
          ? mainEntries[index + 1].timeMs
          : entry.timeMs + 8000;
      final translated = translationMap[entry.timeMs];
      final content = translated != null &&
              translated.isNotEmpty &&
              translated != entry.text
          ? '${entry.text}\n$translated'
          : entry.text;
      final endMs =
          nextStartMs > entry.timeMs ? nextStartMs : entry.timeMs + 3000;

      lines.add(
        SubtitleLine(
          startTime: entry.timeMs / 1000.0,
          endTime: endMs / 1000.0,
          content: content,
          musicRatio: 1.0,
        ),
      );
    }

    return SubtitleData(
      lines: lines,
      sourceType: 'external',
      language: 'external-lrc',
    );
  }

  List<_TimedLyricEntry> _parseTimedEntries(String lrc) {
    if (lrc.trim().isEmpty) return const [];

    final timestampRegExp = RegExp(r'\[(\d{1,2}):(\d{2})(?:[.:](\d{1,3}))?\]');
    final merged = <int, String>{};

    for (final rawLine in lrc.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;

      final matches = timestampRegExp.allMatches(line).toList();
      if (matches.isEmpty) continue;

      final text = line.replaceAll(timestampRegExp, '').trim();
      if (text.isEmpty) continue;

      for (final match in matches) {
        final minute = int.tryParse(match.group(1) ?? '') ?? 0;
        final second = int.tryParse(match.group(2) ?? '') ?? 0;
        final fraction = match.group(3) ?? '0';
        final milli = switch (fraction.length) {
          0 => 0,
          1 => (int.tryParse(fraction) ?? 0) * 100,
          2 => (int.tryParse(fraction) ?? 0) * 10,
          _ => int.tryParse(fraction.substring(0, 3)) ?? 0,
        };
        final timeMs = minute * 60000 + second * 1000 + milli;
        final existing = merged[timeMs];
        merged[timeMs] =
            existing == null || existing == text ? text : '$existing\n$text';
      }
    }

    final entries = merged.entries
        .map((entry) => _TimedLyricEntry(timeMs: entry.key, text: entry.value))
        .toList()
      ..sort((a, b) => a.timeMs.compareTo(b.timeMs));
    return entries;
  }
}

class _TimedLyricEntry {
  const _TimedLyricEntry({
    required this.timeMs,
    required this.text,
  });

  final int timeMs;
  final String text;
}
