import 'package:freezed_annotation/freezed_annotation.dart';
import 'shared_playlist.dart';

part 'app_backup.freezed.dart';
part 'app_backup.g.dart';

/// 完整数据备份包
///
/// 涵盖所有用户数据（不含登录凭据和下载任务），
/// 用于离线数据导出/导入。
@freezed
class AppBackup with _$AppBackup {
  const factory AppBackup({
    /// 备份格式版本
    @Default(1) int version,

    /// App 版本号
    required String appVersion,

    /// 备份创建时间
    required DateTime createdAt,

    /// 所有歌单
    required List<BackupPlaylist> playlists,

    /// 所有歌曲（去重，全量）— 复用 SharedSong 精简结构
    required List<SharedSong> songs,

    /// 歌单-歌曲关联关系
    required List<BackupPlaylistSong> playlistSongs,

    /// 用户偏好设置
    BackupPreferences? preferences,
  }) = _AppBackup;

  factory AppBackup.fromJson(Map<String, dynamic> json) =>
      _$AppBackupFromJson(json);
}

/// 备份用歌单数据
@freezed
class BackupPlaylist with _$BackupPlaylist {
  const factory BackupPlaylist({
    /// 原始 ID（用于关联关系映射）
    required int originalId,

    /// 歌单名称
    required String name,

    /// 歌单封面 URL
    String? coverUrl,

    /// 排序序号
    required int sortOrder,

    /// 创建时间
    required DateTime createdAt,
  }) = _BackupPlaylist;

  factory BackupPlaylist.fromJson(Map<String, dynamic> json) =>
      _$BackupPlaylistFromJson(json);
}

/// 备份用歌单歌曲关联
@freezed
class BackupPlaylistSong with _$BackupPlaylistSong {
  const factory BackupPlaylistSong({
    /// 原始歌单 ID
    required int playlistId,

    /// 歌曲的 bvid（用于跨设备映射）
    required String bvid,

    /// 歌曲的 cid
    required int cid,

    /// 排序
    required int sortOrder,
  }) = _BackupPlaylistSong;

  factory BackupPlaylistSong.fromJson(Map<String, dynamic> json) =>
      _$BackupPlaylistSongFromJson(json);
}

/// 备份用用户偏好
@freezed
class BackupPreferences with _$BackupPreferences {
  const factory BackupPreferences({
    /// 主题模式
    String? themeMode,

    /// 语言
    String? locale,

    /// 首选音质
    int? preferredQuality,

    /// 缓存路径
    String? cachePath,
  }) = _BackupPreferences;

  factory BackupPreferences.fromJson(Map<String, dynamic> json) =>
      _$BackupPreferencesFromJson(json);
}
