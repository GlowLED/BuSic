import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist.freezed.dart';
part 'playlist.g.dart';

/// Domain model representing a user-created playlist.
@freezed
class Playlist with _$Playlist {
  const factory Playlist({
    /// Database primary key.
    required int id,

    /// Playlist display name.
    required String name,

    /// Cover image URL (first song's cover or user-set).
    String? coverUrl,

    /// Number of songs in this playlist.
    @Default(0) int songCount,

    /// Creation timestamp.
    required DateTime createdAt,
  }) = _Playlist;

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);
}
