import 'package:freezed_annotation/freezed_annotation.dart';

part 'song_item.freezed.dart';
part 'song_item.g.dart';

/// Display-ready song model used in playlist views.
///
/// Combines origin and custom metadata — UI layer should use
/// [displayTitle] and [displayArtist] for rendering.
@freezed
class SongItem with _$SongItem {
  const SongItem._();

  const factory SongItem({
    /// Database primary key.
    required int id,

    /// Bilibili BV number.
    required String bvid,

    /// Bilibili CID.
    required int cid,

    /// Original title from Bilibili.
    required String originTitle,

    /// Original artist (UP主) from Bilibili.
    required String originArtist,

    /// User-customized title override.
    String? customTitle,

    /// User-customized artist override.
    String? customArtist,

    /// Cover image URL.
    String? coverUrl,

    /// Duration in seconds.
    @Default(0) int duration,

    /// Local file path if cached.
    String? localPath,
  }) = _SongItem;

  /// Resolved display title: custom overrides origin.
  String get displayTitle => customTitle ?? originTitle;

  /// Resolved display artist: custom overrides origin.
  String get displayArtist => customArtist ?? originArtist;

  /// Whether the song has been cached locally.
  bool get isCached => localPath != null;

  factory SongItem.fromJson(Map<String, dynamic> json) =>
      _$SongItemFromJson(json);
}
