import 'package:drift/drift.dart';

import 'playlists.dart';
import 'songs.dart';

/// Join table linking playlists to songs (many-to-many relationship).
class PlaylistSongs extends Table {
  /// Foreign key referencing [Playlists.id].
  IntColumn get playlistId =>
      integer().references(Playlists, #id)();

  /// Foreign key referencing [Songs.id].
  IntColumn get songId =>
      integer().references(Songs, #id)();

  /// Sort order within the playlist.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {playlistId, songId};
}
