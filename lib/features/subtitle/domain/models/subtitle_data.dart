import 'package:freezed_annotation/freezed_annotation.dart';

import 'subtitle_line.dart';

part 'subtitle_data.freezed.dart';
part 'subtitle_data.g.dart';

/// Complete subtitle data for a single video/track.
///
/// Contains all subtitle lines sorted by time, plus metadata
/// about the subtitle source (AI-generated or CC).
@freezed
class SubtitleData with _$SubtitleData {
  const factory SubtitleData({
    /// Subtitle lines sorted by start time.
    required List<SubtitleLine> lines,

    /// Source type: 'ai' for AI-generated, 'cc' for community captions.
    required String sourceType,

    /// Language code (e.g. 'ai-zh', 'zh-Hans').
    @Default('') String language,
  }) = _SubtitleData;

  factory SubtitleData.fromJson(Map<String, dynamic> json) =>
      _$SubtitleDataFromJson(json);
}
