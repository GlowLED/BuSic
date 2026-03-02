import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_info.freezed.dart';
part 'page_info.g.dart';

/// Information about a single page (分P) of a Bilibili video.
@freezed
class PageInfo with _$PageInfo {
  const factory PageInfo({
    /// Bilibili CID (unique identifier for this page).
    required int cid,

    /// Page number (1-based).
    required int page,

    /// Page/part title.
    required String partTitle,

    /// Duration of this page in seconds.
    @Default(0) int duration,
  }) = _PageInfo;

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
}
