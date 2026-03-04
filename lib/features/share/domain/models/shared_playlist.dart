import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_playlist.freezed.dart';
part 'shared_playlist.g.dart';

/// 歌单分享数据包（精简版，优化剪贴板体积）
///
/// JSON 键名缩短（v/n/s/b/c/ct/ca），显著减小序列化体积。
/// 导入时根据 bvid+cid 调用 B 站 API 拉取元数据。
@freezed
class SharedPlaylist with _$SharedPlaylist {
  const factory SharedPlaylist({
    /// 格式版本号，用于向前兼容
    @JsonKey(name: 'v') @Default(1) int version,

    /// 歌单名称
    @JsonKey(name: 'n') required String name,

    /// 歌曲列表
    @JsonKey(name: 's') required List<SharedSong> songs,
  }) = _SharedPlaylist;

  factory SharedPlaylist.fromJson(Map<String, dynamic> json) =>
      _$SharedPlaylistFromJson(json);
}

/// 分享歌曲（仅含重建所需的最小字段）
///
/// 导入时根据 bvid+cid 调用 B 站 API 拉取元数据（标题/作者/封面/时长）。
/// 仅当用户修改过自定义标题/作者时才携带 ct/ca 字段。
@freezed
class SharedSong with _$SharedSong {
  const factory SharedSong({
    /// Bilibili BV 号（全局唯一标识之一）
    @JsonKey(name: 'b') required String bvid,

    /// Bilibili CID（全局唯一标识之二）
    @JsonKey(name: 'c') required int cid,

    /// 用户自定义标题（仅在用户修改过时包含，否则省略）
    @JsonKey(name: 'ct', includeIfNull: false) String? customTitle,

    /// 用户自定义作者（仅在用户修改过时包含，否则省略）
    @JsonKey(name: 'ca', includeIfNull: false) String? customArtist,
  }) = _SharedSong;

  factory SharedSong.fromJson(Map<String, dynamic> json) =>
      _$SharedSongFromJson(json);
}
