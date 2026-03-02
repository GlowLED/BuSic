import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_track.freezed.dart';
part 'audio_track.g.dart';

/// Domain model representing a single audio track for playback.
///
/// Contains all metadata needed for playback and display,
/// with resolved stream URL or local file path.
@freezed
class AudioTrack with _$AudioTrack {
  const factory AudioTrack({
    /// Database song ID.
    required int songId,

    /// Bilibili BV number.
    required String bvid,

    /// Bilibili CID (page identifier).
    required int cid,

    /// Display title (custom or origin).
    required String title,

    /// Display artist (custom or origin).
    required String artist,

    /// Cover image URL.
    String? coverUrl,

    /// Track duration.
    required Duration duration,

    /// Resolved audio stream URL (for network playback).
    String? streamUrl,

    /// Local file path (for cached/downloaded playback).
    String? localPath,

    /// Audio quality identifier.
    @Default(0) int quality,
  }) = _AudioTrack;

  factory AudioTrack.fromJson(Map<String, dynamic> json) =>
      _$AudioTrackFromJson(json);
}
