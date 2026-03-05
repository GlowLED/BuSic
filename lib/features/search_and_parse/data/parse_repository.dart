import '../domain/models/audio_stream_info.dart';
import '../domain/models/bili_fav_folder.dart';
import '../domain/models/bili_fav_item.dart';
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

  /// Get all available audio quality options for a specific video page.
  ///
  /// Returns a list of [AudioStreamInfo] sorted by quality descending.
  /// The available qualities depend on the video and user's login status.
  Future<List<AudioStreamInfo>> getAvailableQualities(
    String bvid,
    int cid,
  );

  /// Fetch the current WBI signing keys from Bilibili nav API.
  ///
  /// Returns the (imgKey, subKey) pair needed for WBI-signed requests.
  Future<({String imgKey, String subKey})> fetchWbiKeys();

  // ── B 站收藏夹 ───────────────────────────────────────────────────────

  /// 获取用户的所有收藏夹列表（需要登录）。
  ///
  /// [mid] 为用户 UID，从已登录的 User 对象获取。
  Future<List<BiliFavFolder>> getFavoriteFolders(int mid);

  /// 获取收藏夹中的所有视频（自动分页拉取全量）。
  ///
  /// [mediaId] 为收藏夹 ID（[BiliFavFolder.id]）。
  /// 自动过滤已失效视频。
  /// [onProgress] 回调 (已拉取数, 总数) 用于进度提示。
  Future<List<BiliFavItem>> getFavoriteFolderItems(
    int mediaId, {
    void Function(int fetched, int total)? onProgress,
  });
}
