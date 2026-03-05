import 'package:freezed_annotation/freezed_annotation.dart';

part 'bili_fav_item.freezed.dart';

/// B 站收藏夹中的单个视频条目。
///
/// 由 `/x/v3/fav/resource/list` API 返回。
@freezed
class BiliFavItem with _$BiliFavItem {
  const factory BiliFavItem({
    /// BV 号
    required String bvid,

    /// 视频标题
    required String title,

    /// UP 主名称
    required String upper,

    /// 封面 URL
    String? cover,

    /// 时长（秒）
    required int duration,

    /// 首 P 的 CID
    required int firstCid,

    /// 是否已失效（B 站 attr 第 9 位）
    @Default(false) bool isInvalid,
  }) = _BiliFavItem;
}
