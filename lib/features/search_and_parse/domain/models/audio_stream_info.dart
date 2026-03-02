import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_stream_info.freezed.dart';
part 'audio_stream_info.g.dart';

/// Information about a resolved audio stream URL from Bilibili.
@freezed
class AudioStreamInfo with _$AudioStreamInfo {
  const factory AudioStreamInfo({
    /// Direct audio stream URL (m4s format).
    required String url,

    /// Audio quality identifier:
    /// - 30216: 64kbps
    /// - 30232: 132kbps
    /// - 30280: 192kbps (login required)
    /// - 30250: Dolby Atmos (login + SVIP)
    /// - 30251: Hi-Res (login + SVIP)
    required int quality,

    /// MIME type (typically "audio/mp4").
    String? mimeType,

    /// Stream bandwidth in bits per second.
    int? bandwidth,

    /// URL expiration timestamp.
    DateTime? expireTime,

    /// Backup URLs in case the primary fails.
    @Default([]) List<String> backupUrls,
  }) = _AudioStreamInfo;

  factory AudioStreamInfo.fromJson(Map<String, dynamic> json) =>
      _$AudioStreamInfoFromJson(json);
}
