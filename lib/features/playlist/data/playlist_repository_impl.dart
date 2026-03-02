import '../domain/models/playlist.dart';
import '../domain/models/song_item.dart';
import 'playlist_repository.dart';

/// Concrete implementation of [PlaylistRepository] using Drift database.
class PlaylistRepositoryImpl implements PlaylistRepository {
  // TODO: inject AppDatabase instance via constructor

  @override
  Future<List<Playlist>> getAllPlaylists() {
    // TODO: SELECT * FROM playlists ORDER BY sort_order
    throw UnimplementedError();
  }

  @override
  Future<Playlist?> getPlaylistById(int id) {
    // TODO: SELECT * FROM playlists WHERE id = ?
    throw UnimplementedError();
  }

  @override
  Future<Playlist> createPlaylist(String name) {
    // TODO: INSERT INTO playlists, return created Playlist
    throw UnimplementedError();
  }

  @override
  Future<void> deletePlaylist(int id) {
    // TODO: DELETE FROM playlists WHERE id = ?
    // Also DELETE FROM playlist_songs WHERE playlist_id = ?
    throw UnimplementedError();
  }

  @override
  Future<void> renamePlaylist(int id, String name) {
    // TODO: UPDATE playlists SET name = ? WHERE id = ?
    throw UnimplementedError();
  }

  @override
  Future<void> updatePlaylistCover(int id, String? coverUrl) {
    // TODO: UPDATE playlists SET cover_url = ? WHERE id = ?
    throw UnimplementedError();
  }

  @override
  Future<List<SongItem>> getSongsInPlaylist(int playlistId) {
    // TODO: JOIN playlist_songs with songs table
    throw UnimplementedError();
  }

  @override
  Future<void> addSongToPlaylist(int playlistId, int songId) {
    // TODO: INSERT INTO playlist_songs
    throw UnimplementedError();
  }

  @override
  Future<void> addSongsToPlaylist(int playlistId, List<int> songIds) {
    // TODO: batch INSERT INTO playlist_songs
    throw UnimplementedError();
  }

  @override
  Future<void> removeSongFromPlaylist(int playlistId, int songId) {
    // TODO: DELETE FROM playlist_songs WHERE playlist_id = ? AND song_id = ?
    throw UnimplementedError();
  }

  @override
  Future<void> reorderSongs(int playlistId, int oldIndex, int newIndex) {
    // TODO: update sort_order for affected rows
    throw UnimplementedError();
  }

  @override
  Future<int> upsertSong({
    required String bvid,
    required int cid,
    required String originTitle,
    required String originArtist,
    String? coverUrl,
    int duration = 0,
    int audioQuality = 0,
  }) {
    // TODO: INSERT OR REPLACE INTO songs
    throw UnimplementedError();
  }

  @override
  Future<void> updateSongMetadata(
    int songId, {
    String? customTitle,
    String? customArtist,
    String? coverUrl,
  }) {
    // TODO: UPDATE songs SET custom_title=?, custom_artist=? WHERE id = ?
    throw UnimplementedError();
  }

  @override
  Future<void> updateSongLocalPath(int songId, String? localPath) {
    // TODO: UPDATE songs SET local_path = ? WHERE id = ?
    throw UnimplementedError();
  }

  @override
  Future<SongItem?> getSongById(int id) {
    // TODO: SELECT * FROM songs WHERE id = ?
    throw UnimplementedError();
  }

  @override
  Future<List<SongItem>> searchSongs(String keyword) {
    // TODO: SELECT * FROM songs WHERE title LIKE ? OR artist LIKE ?
    throw UnimplementedError();
  }
}
