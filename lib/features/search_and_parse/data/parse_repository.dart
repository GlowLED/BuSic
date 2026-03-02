import '../domain/models/audio_stream_info.dart';
import '../domain/models/bvid_info.dart';

/// Abstract repository for Bilibili video parsing and audio stream resolution.
///
/// This is the core decoupled parsing engine — if Bilibili API changes,
/// only the implementation of this repository needs to be updated.
abstract class ParseRepository {
  /// Fetch video information including multi-page (多P) data.
  ///
  /// Calls the Bilibili `web-interface/view` API.
  /// The [bvid] should be a valid BV number (e.g., "BV1xx411c7mD").
  Future<BvidInfo> getVideoInfo(String bvid);

  /// Resolve the real audio stream URL for a specific page.
  ///
  /// Calls the Bilibili `player/wbi/playurl` API.
  /// Requires [bvid] and [cid] to identify the page.
  /// Optionally specify [quality] to request a specific audio quality.
  /// Higher qualities may require authentication (cookies).
  Future<AudioStreamInfo> getAudioStream(
    String bvid,
    int cid, {
    int? quality,
  });

  /// Search Bilibili videos by keyword (optional extension).
  ///
  /// Returns a list of [BvidInfo] matching the search query.
  /// [page] is 1-based for pagination.
  Future<List<BvidInfo>> searchVideos(
    String keyword, {
    int page = 1,
    int pageSize = 20,
  });

  /// Fetch the current WBI signing keys from Bilibili nav API.
  ///
  /// Returns the (imgKey, subKey) pair needed for WBI-signed requests.
  Future<({String imgKey, String subKey})> fetchWbiKeys();
}
