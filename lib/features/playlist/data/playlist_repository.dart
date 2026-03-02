import '../domain/models/playlist.dart';
import '../domain/models/song_item.dart';

/// Abstract repository for playlist and song CRUD operations.
///
/// All data persistence is handled via Drift (SQLite).
abstract class PlaylistRepository {
  // ── Playlist CRUD ─────────────────────────────────────────────────────

  /// Get all playlists ordered by [sortOrder].
  Future<List<Playlist>> getAllPlaylists();

  /// Get a single playlist by [id].
  Future<Playlist?> getPlaylistById(int id);

  /// Create a new playlist with the given [name].
  ///
  /// Returns the newly created [Playlist] with its generated ID.
  Future<Playlist> createPlaylist(String name);

  /// Delete a playlist and all its song associations.
  Future<void> deletePlaylist(int id);

  /// Rename a playlist.
  Future<void> renamePlaylist(int id, String name);

  /// Update the cover URL for a playlist.
  Future<void> updatePlaylistCover(int id, String? coverUrl);

  // ── Songs within Playlist ─────────────────────────────────────────────

  /// Get all songs in a playlist, ordered by [sortOrder].
  Future<List<SongItem>> getSongsInPlaylist(int playlistId);

  /// Add a song to a playlist.
  ///
  /// If the song doesn't exist in the Songs table yet, it will be created.
  Future<void> addSongToPlaylist(int playlistId, int songId);

  /// Add multiple songs to a playlist at once (batch import).
  Future<void> addSongsToPlaylist(int playlistId, List<int> songIds);

  /// Remove a song from a playlist.
  Future<void> removeSongFromPlaylist(int playlistId, int songId);

  /// Reorder a song within a playlist.
  Future<void> reorderSongs(int playlistId, int oldIndex, int newIndex);

  // ── Song Metadata ─────────────────────────────────────────────────────

  /// Create or update a song record in the Songs table.
  ///
  /// Returns the song's database ID.
  Future<int> upsertSong({
    required String bvid,
    required int cid,
    required String originTitle,
    required String originArtist,
    String? coverUrl,
    int duration = 0,
    int audioQuality = 0,
  });

  /// Update user-customized metadata for a song.
  ///
  /// Pass `null` to clear a custom field (revert to origin).
  Future<void> updateSongMetadata(
    int songId, {
    String? customTitle,
    String? customArtist,
    String? coverUrl,
  });

  /// Update the local cache path for a song.
  Future<void> updateSongLocalPath(int songId, String? localPath);

  /// Get a single song by its database [id].
  Future<SongItem?> getSongById(int id);

  /// Search songs by title or artist keyword.
  Future<List<SongItem>> searchSongs(String keyword);
}
