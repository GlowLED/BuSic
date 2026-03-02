import '../../../core/api/bili_dio.dart';
import '../../../core/api/wbi_sign.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/audio_stream_info.dart';
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
        'fnval': 16, // Request DASH format
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
    final dash = data['dash'];
    final audioStreams = dash['audio'] as List? ?? [];

    if (audioStreams.isEmpty) {
      throw Exception('No audio streams available');
    }

    // Sort by quality descending, pick best or requested
    final sorted = List<Map<String, dynamic>>.from(audioStreams)
      ..sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));

    Map<String, dynamic> selected;
    if (quality != null) {
      selected = sorted.firstWhere(
        (s) => s['id'] == quality,
        orElse: () => sorted.first,
      );
    } else {
      selected = sorted.first;
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
  Future<List<BvidInfo>> searchVideos(
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
    final results = data['result'] as List? ?? [];

    return results.map((item) {
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
}
