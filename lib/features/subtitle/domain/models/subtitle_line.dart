import 'package:freezed_annotation/freezed_annotation.dart';

part 'subtitle_line.freezed.dart';
part 'subtitle_line.g.dart';

/// A single subtitle/lyric line with timing information.
///
/// Each line has a start and end time (in seconds) and the text content.
/// The [musicRatio] field indicates how "musical" the segment is
/// (1.0 = pure music/lyrics, 0.0 = pure speech).
@freezed
class SubtitleLine with _$SubtitleLine {
  const factory SubtitleLine({
    /// Start time in seconds.
    required double startTime,

    /// End time in seconds.
    required double endTime,

    /// Subtitle text content.
    required String content,

    /// Music ratio (0.0 = speech, 1.0 = music/lyrics).
    @Default(0.0) double musicRatio,
  }) = _SubtitleLine;

  factory SubtitleLine.fromJson(Map<String, dynamic> json) =>
      _$SubtitleLineFromJson(json);
}
