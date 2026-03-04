import '../domain/models/shared_playlist.dart';

/// 在线分享服务接口（可替换后端实现）
///
/// 后续可对接 jsonbin.io / GitHub Gist 等免费服务。
/// 当前仅定义接口，暂不实现。
abstract class ShareRemoteRepository {
  /// 上传歌单数据，返回资源 ID
  Future<String> uploadPlaylist(SharedPlaylist playlist);

  /// 根据资源 ID 下载歌单数据
  Future<SharedPlaylist> downloadPlaylist(String resourceId);

  /// 删除已分享的歌单（可选）
  Future<void> deleteSharedPlaylist(String resourceId);
}
