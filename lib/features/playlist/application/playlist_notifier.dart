import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_notifier.dart';
import '../data/playlist_repository.dart';
import '../data/playlist_repository_impl.dart';
import '../domain/models/playlist.dart';
import '../domain/models/song_item.dart';

part 'playlist_notifier.g.dart';

/// State notifier managing playlist list and CRUD operations.
@riverpod
class PlaylistListNotifier extends _$PlaylistListNotifier {
  late final PlaylistRepository _repository;

  @override
  Future<List<Playlist>> build() async {
    _repository = PlaylistRepositoryImpl(
      db: ref.read(databaseProvider),
    );
    return _repository.getAllPlaylists();
  }

  /// Create a new playlist with [name].
  Future<void> createPlaylist(String name) async {
    await _repository.createPlaylist(name);
    ref.invalidateSelf();
  }

  /// Delete a playlist by [id].
  Future<void> deletePlaylist(int id) async {
    await _repository.deletePlaylist(id);
    ref.invalidateSelf();
  }

  /// Rename a playlist.
  Future<void> renamePlaylist(int id, String name) async {
    await _repository.renamePlaylist(id, name);
    ref.invalidateSelf();
  }
}

/// State notifier managing songs within a specific playlist.
@riverpod
class PlaylistDetailNotifier extends _$PlaylistDetailNotifier {
  late final PlaylistRepository _repository;

  @override
  Future<List<SongItem>> build(int playlistId) async {
    _repository = PlaylistRepositoryImpl(
      db: ref.read(databaseProvider),
    );
    return _repository.getSongsInPlaylist(playlistId);
  }

  /// Add a song to this playlist.
  Future<void> addSong(int songId) async {
    await _repository.addSongToPlaylist(playlistId, songId);
    ref.invalidateSelf();
  }

  /// Remove a song from this playlist.
  Future<void> removeSong(int songId) async {
    await _repository.removeSongFromPlaylist(playlistId, songId);
    ref.invalidateSelf();
  }

  /// Reorder songs in this playlist.
  Future<void> reorderSongs(int oldIndex, int newIndex) async {
    await _repository.reorderSongs(playlistId, oldIndex, newIndex);
    ref.invalidateSelf();
  }

  /// Update metadata for a song.
  Future<void> updateMetadata(
    int songId, {
    String? title,
    String? artist,
    String? coverUrl,
  }) async {
    await _repository.updateSongMetadata(
      songId,
      customTitle: title,
      customArtist: artist,
      coverUrl: coverUrl,
    );
    ref.invalidateSelf();
  }
}
