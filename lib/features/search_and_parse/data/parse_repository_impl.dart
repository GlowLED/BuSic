import '../../../core/api/bili_dio.dart';
import '../../../core/api/wbi_sign.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/audio_stream_info.dart';
import '../domain/models/bili_fav_folder.dart';
import '../domain/models/bili_fav_item.dart';
import '../domain/models/bvid_info.dart';
import '../domain/models/page_info.dart';
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
    if (_imgKey == null || _subKey == null ||
        _keysExpiry == null || DateTime.now().isAfter(_keysExpiry!)) {
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
    final data = response.data['data'];
    final pages = (data['pages'] as List).map((p) => PageInfo(
      cid: p['cid'] as int,
      page: p['page'] as int,
      partTitle: p['part'] as String? ?? '',
      duration: p['duration'] as int? ?? 0,
    )).toList();

    return BvidInfo(
      bvid: data['bvid'] as String,
      title: data['title'] as String,
      owner: data['owner']?['name'] as String? ?? '',
      ownerUid: data['owner']?['mid'] as int?,
      coverUrl: data['pic'] as String?,
      pages: pages,
      duration: data['duration'] as int? ?? 0,
    );
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

    final backupUrls = (selected['backupUrl'] as List?)
        ?.map((e) => e.toString()).toList() ?? [];

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
      AppLogger.info('Retrying getAvailableQualities with fnval=16', tag: 'Parse');
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
      final backupUrls = (stream['backupUrl'] as List?)
          ?.map((e) => e.toString()).toList() ?? [];
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
              ?.map((e) => e.toString()).toList() ?? [];
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
            ?.map((e) => e.toString()).toList() ?? [];
        results.add(AudioStreamInfo(
          url: flacAudio['baseUrl'] as String? ?? flacAudio['base_url'] as String,
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
      final backupUrls = (stream['backupUrl'] as List?)
          ?.map((e) => e.toString()).toList() ?? [];
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

  int _parseDuration(String durationStr) {
    // Format: "MM:SS" or "HH:MM:SS"
    final parts = durationStr.split(':');
    try {
      if (parts.length == 2) {
        return int.parse(parts[0]) * 60 + int.parse(parts[1]);
      } else if (parts.length == 3) {
        return int.parse(parts[0]) * 3600 + int.parse(parts[1]) * 60 + int.parse(parts[2]);
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
          upper: (media['upper'] as Map<String, dynamic>?)?['name']
                  as String? ??
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
}
