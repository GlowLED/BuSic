import '../domain/models/audio_stream_info.dart';
import '../domain/models/bvid_info.dart';
import 'parse_repository.dart';

/// Concrete implementation of [ParseRepository] using Bilibili API + BiliDio.
class ParseRepositoryImpl implements ParseRepository {
  // TODO: inject BiliDio instance via constructor

  @override
  Future<BvidInfo> getVideoInfo(String bvid) {
    // TODO: GET /x/web-interface/view?bvid=...
    // Parse response.data into BvidInfo with pages list
    throw UnimplementedError();
  }

  @override
  Future<AudioStreamInfo> getAudioStream(
    String bvid,
    int cid, {
    int? quality,
  }) {
    // TODO: GET /x/player/wbi/playurl?bvid=...&cid=...&fnval=16
    // Extract audio dash stream from response
    // Apply WBI signing to request parameters
    throw UnimplementedError();
  }

  @override
  Future<List<BvidInfo>> searchVideos(
    String keyword, {
    int page = 1,
    int pageSize = 20,
  }) {
    // TODO: GET /x/web-interface/wbi/search/type?keyword=...&search_type=video
    throw UnimplementedError();
  }

  @override
  Future<({String imgKey, String subKey})> fetchWbiKeys() {
    // TODO: GET /x/web-interface/nav
    // Extract wbi_img.img_url and wbi_img.sub_url
    throw UnimplementedError();
  }
}
