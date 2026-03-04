import 'shared_playlist.dart';

/// 歌曲元数据预览信息（用于导入选择界面）
///
/// 在导入前预取 B 站 API 获得歌曲标题等信息，
/// 让用户在导入前看到实际歌名并选择要导入的歌曲。
class SongMetadataPreview {
  /// 原始分享歌曲数据
  final SharedSong song;

  /// 展示用标题（优先级：customTitle > API 获取的标题 > bvid）
  final String displayTitle;

  /// 展示用作者
  final String displayArtist;

  /// 是否本地已存在该歌曲
  final bool existsLocally;

  /// 是否获取元数据失败
  final bool fetchFailed;

  const SongMetadataPreview({
    required this.song,
    required this.displayTitle,
    required this.displayArtist,
    this.existsLocally = false,
    this.fetchFailed = false,
  });
}
