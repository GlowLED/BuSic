import 'package:freezed_annotation/freezed_annotation.dart';

part 'bili_fav_folder.freezed.dart';

/// B 站用户收藏夹信息。
///
/// 由 `/x/v3/fav/folder/created/list-all` API 返回。
@freezed
class BiliFavFolder with _$BiliFavFolder {
  const factory BiliFavFolder({
    /// 收藏夹 media_id（用于查询收藏夹内容）
    required int id,

    /// 收藏夹标题
    required String title,

    /// 收藏夹内视频数量
    required int mediaCount,
  }) = _BiliFavFolder;
}
