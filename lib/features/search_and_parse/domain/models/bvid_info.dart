import 'package:freezed_annotation/freezed_annotation.dart';

import 'page_info.dart';

part 'bvid_info.freezed.dart';
part 'bvid_info.g.dart';

/// Domain model representing parsed Bilibili video information.
///
/// Contains the video's metadata and its page list (多P).
@freezed
class BvidInfo with _$BvidInfo {
  const factory BvidInfo({
    /// Bilibili BV number.
    required String bvid,

    /// Video title.
    required String title,

    /// Video owner (UP主) display name.
    required String owner,

    /// Video owner UID.
    int? ownerUid,

    /// Cover image URL.
    String? coverUrl,

    /// List of video pages (分P). Single-page videos have one entry.
    @Default([]) List<PageInfo> pages,

    /// Total duration in seconds (all pages combined).
    @Default(0) int duration,
  }) = _BvidInfo;

  factory BvidInfo.fromJson(Map<String, dynamic> json) =>
      _$BvidInfoFromJson(json);
}
