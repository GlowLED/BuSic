import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_stats.freezed.dart';
part 'video_stats.g.dart';

/// Bilibili video engagement counters.
@freezed
class VideoStats with _$VideoStats {
  const factory VideoStats({
    /// View count.
    @Default(0) int view,

    /// Danmaku count.
    @Default(0) int danmaku,

    /// Reply/comment count.
    @Default(0) int reply,

    /// Favorite count.
    @Default(0) int favorite,

    /// Coin count.
    @Default(0) int coin,

    /// Share count.
    @Default(0) int share,

    /// Like count.
    @Default(0) int like,
  }) = _VideoStats;

  factory VideoStats.fromJson(Map<String, dynamic> json) =>
      _$VideoStatsFromJson(json);
}
