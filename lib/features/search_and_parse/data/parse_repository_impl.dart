import '../../../core/api/bili_dio.dart';
import '../../../core/api/wbi_sign.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/audio_stream_info.dart';
import '../domain/models/bili_fav_folder.dart';
import '../domain/models/bili_fav_item.dart';
import '../domain/models/bvid_info.dart';
import '../domain/models/page_info.dart';
import '../domain/models/video_rights.dart';
import '../domain/models/video_stats.dart';
import '../domain/models/video_tag.dart';
import 'parse_repository.dart';

/// Concrete implementation of [ParseRepository] using Bilibili API + BiliDio.
class ParseRepositoryImpl implements ParseRepository {
  final BiliDio _biliDio;

  // Cached WBI keys
  String? _imgKey;
  String? _subKey;
  DateTime? _keysExpiry;

  ParseRepositoryImpl({required BiliDio biliDio}) : _biliDio = biliDio;

  Future<void> _ensureWbiKeys() async {
    if (_imgKey == null ||
        _subKey == null ||
        _keysExpiry == null ||
        DateTime.now().isAfter(_keysExpiry!)) {
      final keys = await fetchWbiKeys();
      _imgKey = keys.imgKey;
      _subKey = keys.subKey;
      _keysExpiry = DateTime.now().add(const Duration(minutes: 30));
    }
  }

  @override
  Future<BvidInfo> getVideoInfo(String bvid) async {
    final response = await _biliDio.get(
      '/x/web-interface/view',
      queryParameters: {'bvid': bvid},
    );
    final code = _asInt(response.data['code']) ?? 0;
    if (code != 0) {
      final message = response.data['message'] as String? ?? '获取视频信息失败';
      throw Exception(message);
    }

    final data = response.data['data'];
    if (data is! Map<String, dynamic>) {
      throw Exception('view returned null data');
    }

    return _mapVideoInfo(data, fallbackBvid: bvid);
  }

  @override
  Future<AudioStreamInfo> getAudioStream(
    String bvid,
    int cid, {
    int? quality,
  }) async {
    await _ensureWbiKeys();

    final params = WbiSign.encodeWbi(
      {
        'bvid': bvid,
        'cid': cid,
        'fnval': 4048, // DASH + all quality flags
        'fnver': 0,
        'fourk': 1,
      },
      imgKey: _imgKey!,
      subKey: _subKey!,
    );

    final response = await _biliDio.get(
      '/x/player/wbi/playurl',
      queryParameters: params,
    );
    final data = response.data['data'];
    if (data == null) {
      throw Exception('playurl returned null data');
    }
    final dash = data['dash'] as Map<String, dynamic>?;
    if (dash == null) {
      throw Exception('No DASH data available');
    }
    final audioStreams = dash['audio'] as List? ?? [];

    // Collect all audio streams (standard + Dolby + Hi-Res)
    final allStreams = <Map<String, dynamic>>[
      ...List<Map<String, dynamic>>.from(audioStreams),
    ];

    // Dolby Atmos streams
    final dolby = dash['dolby'] as Map<String, dynamic>?;
    if (dolby != null) {
      final dolbyAudio = dolby['audio'];
      if (dolbyAudio is List) {
        allStreams.addAll(List<Map<String, dynamic>>.from(dolbyAudio));
      }
    }

    // Hi-Res FLAC stream
    final flac = dash['flac'] as Map<String, dynamic>?;
    if (flac != null) {
      final flacAudio = flac['audio'];
      if (flacAudio is Map<String, dynamic>) {
        allStreams.add(flacAudio);
      }
    }

    if (allStreams.isEmpty) {
      throw Exception('No audio streams available');
    }

    // Sort by quality descending, pick best or requested
    allStreams.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));

    Map<String, dynamic> selected;
    if (quality != null) {
      selected = allStreams.firstWhere(
        (s) => s['id'] == quality,
        orElse: () => allStreams.first,
      );
    } else {
      selected = allStreams.first;
    }

    final backupUrls =
        (selected['backupUrl'] as List?)?.map((e) => e.toString()).toList() ??
            [];

    return AudioStreamInfo(
      url: selected['baseUrl'] as String? ?? selected['base_url'] as String,
      quality: selected['id'] as int,
      mimeType: selected['mimeType'] as String? ?? 'audio/mp4',
      bandwidth: selected['bandwidth'] as int?,
      backupUrls: backupUrls,
    );
  }

  @override
  Future<List<AudioStreamInfo>> getAvailableQualities(
    String bvid,
    int cid,
  ) async {
    await _ensureWbiKeys();

    final params = WbiSign.encodeWbi(
      {
        'bvid': bvid,
        'cid': cid,
        'fnval': 4048, // DASH + HDR + 4K + DolbyAudio + DolbyVision + 8K + AV1
        'fnver': 0,
        'fourk': 1,
      },
      imgKey: _imgKey!,
      subKey: _subKey!,
    );

    final response = await _biliDio.get(
      '/x/player/wbi/playurl',
      queryParameters: params,
    );
    final data = response.data['data'];
    if (data == null) {
      // Fallback: retry with fnval=16 if extended flags fail
      AppLogger.info('Retrying getAvailableQualities with fnval=16',
          tag: 'Parse');
      return _getAvailableQualitiesFallback(bvid, cid);
    }
    final dash = data['dash'] as Map<String, dynamic>?;
    if (dash == null) {
      AppLogger.error('playurl returned null dash', tag: 'Parse');
      return [];
    }
    final audioStreams = dash['audio'] as List? ?? [];
    AppLogger.info(
      'DASH audio streams: ${audioStreams.length}, '
      'dolby: ${dash['dolby']?.runtimeType}, '
      'dolby.audio: ${(dash['dolby'] as Map<String, dynamic>?)?['audio']?.runtimeType}, '
      'flac: ${dash['flac']?.runtimeType}, '
      'flac.audio: ${(dash['flac'] as Map<String, dynamic>?)?['audio']?.runtimeType}',
      tag: 'Parse',
    );

    final results = <AudioStreamInfo>[];
    for (final stream in audioStreams) {
      final backupUrls =
          (stream['backupUrl'] as List?)?.map((e) => e.toString()).toList() ??
              [];
      results.add(AudioStreamInfo(
        url: stream['baseUrl'] as String? ?? stream['base_url'] as String,
        quality: stream['id'] as int,
        mimeType: stream['mimeType'] as String? ?? 'audio/mp4',
        bandwidth: stream['bandwidth'] as int?,
        backupUrls: backupUrls,
      ));
    }

    // Dolby Atmos streams
    final dolby = dash['dolby'] as Map<String, dynamic>?;
    if (dolby != null) {
      final dolbyAudio = dolby['audio'];
      if (dolbyAudio is List) {
        for (final stream in dolbyAudio) {
          final backupUrls = (stream['backupUrl'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
          results.add(AudioStreamInfo(
            url: stream['baseUrl'] as String? ?? stream['base_url'] as String,
            quality: stream['id'] as int,
            mimeType: stream['mimeType'] as String? ?? 'audio/mp4',
            bandwidth: stream['bandwidth'] as int?,
            backupUrls: backupUrls,
          ));
        }
      }
    }

    // Hi-Res FLAC stream
    final flac = dash['flac'] as Map<String, dynamic>?;
    if (flac != null) {
      final flacAudio = flac['audio'];
      if (flacAudio is Map<String, dynamic>) {
        final backupUrls = (flacAudio['backupUrl'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        results.add(AudioStreamInfo(
          url: flacAudio['baseUrl'] as String? ??
              flacAudio['base_url'] as String,
          quality: flacAudio['id'] as int,
          mimeType: flacAudio['mimeType'] as String? ?? 'audio/mp4',
          bandwidth: flacAudio['bandwidth'] as int?,
          backupUrls: backupUrls,
        ));
      }
    }

    // Sort by quality descending
    results.sort((a, b) => b.quality.compareTo(a.quality));
    return results;
  }

  /// Fallback quality fetch using fnval=16 (basic DASH only).
  Future<List<AudioStreamInfo>> _getAvailableQualitiesFallback(
    String bvid,
    int cid,
  ) async {
    final params = WbiSign.encodeWbi(
      {
        'bvid': bvid,
        'cid': cid,
        'fnval': 16,
        'fnver': 0,
        'fourk': 1,
      },
      imgKey: _imgKey!,
      subKey: _subKey!,
    );

    final response = await _biliDio.get(
      '/x/player/wbi/playurl',
      queryParameters: params,
    );
    final data = response.data['data'];
    if (data == null) return [];
    final dash = data['dash'] as Map<String, dynamic>?;
    if (dash == null) return [];
    final audioStreams = dash['audio'] as List? ?? [];

    final results = <AudioStreamInfo>[];
    for (final stream in audioStreams) {
      final backupUrls =
          (stream['backupUrl'] as List?)?.map((e) => e.toString()).toList() ??
              [];
      results.add(AudioStreamInfo(
        url: stream['baseUrl'] as String? ?? stream['base_url'] as String,
        quality: stream['id'] as int,
        mimeType: stream['mimeType'] as String? ?? 'audio/mp4',
        bandwidth: stream['bandwidth'] as int?,
        backupUrls: backupUrls,
      ));
    }
    results.sort((a, b) => b.quality.compareTo(a.quality));
    return results;
  }

  @override
  Future<({List<BvidInfo> results, int numPages})> searchVideos(
    String keyword, {
    int page = 1,
    int pageSize = 20,
  }) async {
    await _ensureWbiKeys();

    final params = WbiSign.encodeWbi(
      {
        'keyword': keyword,
        'search_type': 'video',
        'page': page,
        'page_size': pageSize,
      },
      imgKey: _imgKey!,
      subKey: _subKey!,
    );

    final response = await _biliDio.get(
      '/x/web-interface/wbi/search/type',
      queryParameters: params,
    );
    final data = response.data['data'];
    final numPages = data['numPages'] as int? ?? 1;
    final results = data['result'] as List? ?? [];

    final videoList = results.map((item) {
      final title = (item['title'] as String? ?? '')
          .replaceAll(RegExp(r'<[^>]*>'), ''); // Strip HTML tags
      return BvidInfo(
        bvid: item['bvid'] as String? ?? '',
        title: title,
        owner: item['author'] as String? ?? '',
        coverUrl: 'https:${item['pic'] ?? ''}',
        duration: _parseDuration(item['duration'] as String? ?? '0'),
      );
    }).toList();

    return (results: videoList, numPages: numPages);
  }

  @override
  Future<List<VideoTag>> getVideoTags(String bvid) async {
    try {
      final response = await _biliDio.get(
        '/x/tag/archive/tags',
        queryParameters: {'bvid': bvid},
      );
      final data = response.data['data'];
      if (data is! List) {
        return [];
      }

      final tags = <VideoTag>[];
      for (final item in data) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final rawId = item['tag_id'] ?? item['id'];
        final id = rawId is int ? rawId : int.tryParse('$rawId') ?? 0;
        final name =
            item['tag_name'] as String? ?? item['name'] as String? ?? '';
        if (name.isEmpty) {
          continue;
        }
        tags.add(VideoTag(id: id, name: name));
      }
      return tags;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch video tags',
        tag: 'Parse',
        error: error,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  int _parseDuration(String durationStr) {
    // Format: "MM:SS" or "HH:MM:SS"
    final parts = durationStr.split(':');
    try {
      if (parts.length == 2) {
        return int.parse(parts[0]) * 60 + int.parse(parts[1]);
      } else if (parts.length == 3) {
        return int.parse(parts[0]) * 3600 +
            int.parse(parts[1]) * 60 +
            int.parse(parts[2]);
      }
      return int.tryParse(durationStr) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<({String imgKey, String subKey})> fetchWbiKeys() async {
    final response = await _biliDio.get('/x/web-interface/nav');
    final data = response.data['data'];
    final wbiImg = data['wbi_img'];
    final imgUrl = wbiImg['img_url'] as String;
    final subUrl = wbiImg['sub_url'] as String;

    AppLogger.info('Fetched WBI keys', tag: 'Parse');
    return WbiSign.extractKeys(imgUrl: imgUrl, subUrl: subUrl);
  }

  // ── B 站收藏夹 ───────────────────────────────────────────────────────

  @override
  Future<List<BiliFavFolder>> getFavoriteFolders(int mid) async {
    final response = await _biliDio.get(
      '/x/v3/fav/folder/created/list-all',
      queryParameters: {'up_mid': mid},
    );
    final data = response.data['data'];
    if (data == null) {
      AppLogger.warning('getFavoriteFolders: data is null', tag: 'Parse');
      return [];
    }
    final list = data['list'] as List<dynamic>? ?? [];
    return list
        .map((item) => BiliFavFolder(
              id: item['id'] as int,
              title: item['title'] as String,
              mediaCount: item['media_count'] as int,
            ))
        .toList();
  }

  @override
  Future<List<BiliFavItem>> getFavoriteFolderItems(
    int mediaId, {
    void Function(int fetched, int total)? onProgress,
  }) async {
    final items = <BiliFavItem>[];
    int page = 1;
    bool hasMore = true;

    while (hasMore) {
      final response = await _biliDio.get(
        '/x/v3/fav/resource/list',
        queryParameters: {
          'media_id': mediaId,
          'pn': page,
          'ps': 20,
        },
      );
      final data = response.data['data'];
      if (data == null) break;

      final medias = data['medias'] as List<dynamic>? ?? [];
      final totalCount =
          (data['info'] as Map<String, dynamic>?)?['media_count'] as int? ?? 0;

      for (final media in medias) {
        final attr = media['attr'] as int? ?? 0;
        final isInvalid = ((attr >> 9) & 1) == 1;
        // 跳过已失效视频
        if (isInvalid) continue;

        final bvid = media['bvid'] as String?;
        if (bvid == null || bvid.isEmpty) continue;

        items.add(BiliFavItem(
          bvid: bvid,
          title: media['title'] as String? ?? '',
          upper:
              (media['upper'] as Map<String, dynamic>?)?['name'] as String? ??
                  '',
          cover: media['cover'] as String?,
          duration: media['duration'] as int? ?? 0,
          firstCid:
              (media['ugc'] as Map<String, dynamic>?)?['first_cid'] as int? ??
                  0,
        ));
      }

      hasMore = data['has_more'] as bool? ?? false;
      onProgress?.call(items.length, totalCount);
      page++;
    }

    return items;
  }

  BvidInfo _mapVideoInfo(
    Map<String, dynamic> data, {
    required String fallbackBvid,
  }) {
    final owner = _asStringMap(data['owner']);
    final pagesRaw = data['pages'] as List? ?? [];
    final pages = pagesRaw
        .whereType<Map<String, dynamic>>()
        .map((page) => PageInfo(
              cid: _asInt(page['cid']) ?? 0,
              page: _asInt(page['page']) ?? 0,
              partTitle: page['part'] as String? ?? '',
              duration: _asInt(page['duration']) ?? 0,
            ))
        .toList();

    return BvidInfo(
      bvid: data['bvid'] as String? ?? fallbackBvid,
      aid: _asInt(data['aid']),
      title: data['title'] as String? ?? '',
      description:
          data['desc'] as String? ?? data['description'] as String? ?? '',
      pubdate: _asInt(data['pubdate']),
      tname: data['tname'] as String?,
      owner: owner?['name'] as String? ?? '',
      ownerUid: _asInt(owner?['mid']),
      ownerFace: owner?['face'] as String?,
      coverUrl: data['pic'] as String?,
      pages: pages,
      duration: _asInt(data['duration']) ?? 0,
      stats: _mapVideoStats(data['stat']),
      rights: _mapVideoRights(data['rights']),
    );
  }

  VideoStats _mapVideoStats(Object? raw) {
    final stat = _asStringMap(raw);
    if (stat == null) return const VideoStats();

    return VideoStats(
      view: _asInt(stat['view']) ?? 0,
      danmaku: _asInt(stat['danmaku']) ?? 0,
      reply: _asInt(stat['reply']) ?? 0,
      favorite: _asInt(stat['favorite']) ?? 0,
      coin: _asInt(stat['coin']) ?? 0,
      share: _asInt(stat['share']) ?? 0,
      like: _asInt(stat['like']) ?? 0,
    );
  }

  VideoRights _mapVideoRights(Object? raw) {
    final rights = _asStringMap(raw);
    if (rights == null) return const VideoRights();

    return VideoRights(
      noReprint: _asBool(rights['no_reprint'] ?? rights['noReprint']),
    );
  }

  Map<String, dynamic>? _asStringMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry('$key', value));
    }
    return null;
  }

  int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  bool _asBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      return value == '1' || value.toLowerCase() == 'true';
    }
    return false;
  }
}
