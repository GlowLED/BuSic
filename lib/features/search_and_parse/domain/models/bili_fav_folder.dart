import 'package:freezed_annotation/freezed_annotation.dart';

part 'bili_fav_folder.freezed.dart';

/// B 站收藏夹信息。
///
/// 由以下 API 返回：
/// - `/x/v3/fav/folder/created/list-all`（自己的收藏夹，ownerName 为 null）
/// - `/x/v3/fav/folder/collected/list`（收藏的收藏夹，ownerName 为 UP 主名称）
@freezed
abstract class BiliFavFolder with _$BiliFavFolder {
  const factory BiliFavFolder({
    /// 收藏夹 media_id（用于查询收藏夹内容）
    required int id,

    /// 收藏夹标题
    required String title,

    /// 收藏夹内视频数量
    required int mediaCount,

    /// 收藏夹创建者名称（仅对收藏的收藏夹有效，自己的为 null）
    String? ownerName,
  }) = _BiliFavFolder;
}
