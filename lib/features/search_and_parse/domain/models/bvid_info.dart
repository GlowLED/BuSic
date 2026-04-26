import 'package:freezed_annotation/freezed_annotation.dart';

import 'page_info.dart';
import 'video_rights.dart';
import 'video_stats.dart';
import 'video_tag.dart';

part 'bvid_info.freezed.dart';
part 'bvid_info.g.dart';

/// Domain model representing parsed Bilibili video information.
///
/// Contains the video's metadata and its page list (多P).
@freezed
class BvidInfo with _$BvidInfo {
  @JsonSerializable(explicitToJson: true)
  const factory BvidInfo({
    /// Bilibili BV number.
    required String bvid,

    /// Bilibili AV number.
    int? aid,

    /// Video title.
    required String title,

    /// Video description.
    @Default('') String description,

    /// Published timestamp in seconds.
    int? pubdate,

    /// Bilibili category name.
    String? tname,

    /// Video owner (UP主) display name.
    required String owner,

    /// Video owner UID.
    int? ownerUid,

    /// Video owner avatar URL.
    String? ownerFace,

    /// Cover image URL.
    String? coverUrl,

    /// List of video pages (分P). Single-page videos have one entry.
    @Default([]) List<PageInfo> pages,

    /// Total duration in seconds (all pages combined).
    @Default(0) int duration,

    /// Video engagement counters.
    @Default(VideoStats()) VideoStats stats,

    /// Video permission and copyright flags.
    @Default(VideoRights()) VideoRights rights,

    /// Tags associated with this video.
    @Default([]) List<VideoTag> tags,
  }) = _BvidInfo;

  factory BvidInfo.fromJson(Map<String, dynamic> json) =>
      _$BvidInfoFromJson(json);
}
