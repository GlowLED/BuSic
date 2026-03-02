import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/playlist_repository.dart';
import '../domain/models/playlist.dart';
import '../domain/models/song_item.dart';

part 'playlist_notifier.g.dart';

/// State notifier managing playlist list and CRUD operations.
@riverpod
class PlaylistListNotifier extends _$PlaylistListNotifier {
  late final PlaylistRepository _repository;

  @override
  Future<List<Playlist>> build() async {
    // TODO: inject repository, load all playlists
    throw UnimplementedError();
  }

  /// Create a new playlist with [name].
  Future<void> createPlaylist(String name) async {
    // TODO: call repository.createPlaylist, refresh state
    throw UnimplementedError();
  }

  /// Delete a playlist by [id].
  Future<void> deletePlaylist(int id) async {
    // TODO: call repository.deletePlaylist, refresh state
    throw UnimplementedError();
  }

  /// Rename a playlist.
  Future<void> renamePlaylist(int id, String name) async {
    // TODO: call repository.renamePlaylist, refresh state
    throw UnimplementedError();
  }
}

/// State notifier managing songs within a specific playlist.
@riverpod
class PlaylistDetailNotifier extends _$PlaylistDetailNotifier {
  late final PlaylistRepository _repository;

  @override
  Future<List<SongItem>> build(int playlistId) async {
    // TODO: inject repository, load songs for playlistId
    throw UnimplementedError();
  }

  /// Add a song to this playlist.
  Future<void> addSong(int songId) async {
    // TODO: call repository.addSongToPlaylist, refresh state
    throw UnimplementedError();
  }

  /// Remove a song from this playlist.
  Future<void> removeSong(int songId) async {
    // TODO: call repository.removeSongFromPlaylist, refresh state
    throw UnimplementedError();
  }

  /// Reorder songs in this playlist.
  Future<void> reorderSongs(int oldIndex, int newIndex) async {
    // TODO: call repository.reorderSongs, refresh state
    throw UnimplementedError();
  }

  /// Update metadata for a song.
  Future<void> updateMetadata(
    int songId, {
    String? title,
    String? artist,
    String? coverUrl,
  }) async {
    // TODO: call repository.updateSongMetadata, refresh state
    throw UnimplementedError();
  }
}
