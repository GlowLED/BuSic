import '../domain/models/shared_playlist.dart';
import '../domain/models/share_state.dart';
import '../domain/models/song_metadata_preview.dart';

/// 歌单分享 Repository 抽象接口（离线分享核心）
///
/// 负责歌单的导出编码、解码解析、以及导入（含元数据拉取）。
abstract class ShareRepository {
  /// 将歌单导出为分享格式（精简，仅含 bvid+cid+自定义字段）
  Future<SharedPlaylist> exportPlaylist(int playlistId);

  /// 将 [SharedPlaylist] 编码为剪贴板字符串（`busic://playlist/<base64>`）
  String encodeForClipboard(SharedPlaylist playlist);

  /// 从剪贴板字符串解码 [SharedPlaylist]
  ///
  /// 如果数据格式无效，抛出 [FormatException]。
  SharedPlaylist decodeFromClipboard(String data);

  /// 导入歌单：创建歌单 + 逐首拉取元数据（本地已有则复用）+ 关联
  ///
  /// [overrideName] 可选，用于覆盖歌单名称（避免重名）。
  /// [onProgress] 回调报告导入进度（已处理数 / 总数）。
  Future<ShareImportResult> importPlaylist(
    SharedPlaylist playlist, {
    String? overrideName,
    void Function(int current, int total)? onProgress,
  });

  /// 预取歌曲元数据（标题、作者）用于导入预览
  ///
  /// 按 bvid 去重调用 B 站 API，返回每首歌的展示信息。
  Future<List<SongMetadataPreview>> prefetchMetadata(List<SharedSong> songs);
}
