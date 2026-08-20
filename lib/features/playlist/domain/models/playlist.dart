import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist.freezed.dart';
part 'playlist.g.dart';

/// Domain model representing a user-created playlist.
@freezed
abstract class Playlist with _$Playlist {
  const factory Playlist({
    /// Database primary key.
    required int id,

    /// Playlist display name.
    required String name,

    /// Cover image URL (first song's cover or user-set).
    String? coverUrl,

    /// Number of songs in this playlist.
    @Default(0) int songCount,

    /// Whether this is the system "My Favorites" playlist.
    @Default(false) bool isFavorite,

    /// Creation timestamp.
    required DateTime createdAt,

    /// Number of active events (song plays / detail visits).
    @Default(0) int playCount,

    /// Timestamp of the most recent active event, null if never active.
    DateTime? lastPlayedAt,
  }) = _Playlist;

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);
}
