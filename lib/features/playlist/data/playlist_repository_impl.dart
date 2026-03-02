import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/models/playlist.dart' as domain;
import '../domain/models/song_item.dart';
import 'playlist_repository.dart';

/// Concrete implementation of [PlaylistRepository] using Drift database.
class PlaylistRepositoryImpl implements PlaylistRepository {
  final AppDatabase _db;

  PlaylistRepositoryImpl({required AppDatabase db}) : _db = db;

  domain.Playlist _mapPlaylist(Playlist row, {int songCount = 0}) {
    return domain.Playlist(
      id: row.id,
      name: row.name,
      coverUrl: row.coverUrl,
      songCount: songCount,
      createdAt: row.createdAt,
    );
  }

  SongItem _mapSong(Song row) {
    return SongItem(
      id: row.id,
      bvid: row.bvid,
      cid: row.cid,
      originTitle: row.originTitle,
      originArtist: row.originArtist,
      customTitle: row.customTitle,
      customArtist: row.customArtist,
      coverUrl: row.coverUrl,
      duration: row.duration,
      localPath: row.localPath,
    );
  }

  @override
  Future<List<domain.Playlist>> getAllPlaylists() async {
    final rows = await (_db.select(_db.playlists)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();

    final result = <domain.Playlist>[];
    for (final row in rows) {
      final count = await (_db.selectOnly(_db.playlistSongs)
            ..addColumns([_db.playlistSongs.songId.count()])
            ..where(_db.playlistSongs.playlistId.equals(row.id)))
          .map((r) => r.read(_db.playlistSongs.songId.count()))
          .getSingle();
      result.add(_mapPlaylist(row, songCount: count ?? 0));
    }
    return result;
  }

  @override
  Future<domain.Playlist?> getPlaylistById(int id) async {
    final row = await (_db.select(_db.playlists)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;

    final count = await (_db.selectOnly(_db.playlistSongs)
          ..addColumns([_db.playlistSongs.songId.count()])
          ..where(_db.playlistSongs.playlistId.equals(id)))
        .map((r) => r.read(_db.playlistSongs.songId.count()))
        .getSingle();
    return _mapPlaylist(row, songCount: count ?? 0);
  }

  @override
  Future<domain.Playlist> createPlaylist(String name) async {
    final id = await _db.into(_db.playlists).insert(
          PlaylistsCompanion.insert(name: name),
        );
    return domain.Playlist(
      id: id,
      name: name,
      songCount: 0,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> deletePlaylist(int id) async {
    await (_db.delete(_db.playlistSongs)
          ..where((t) => t.playlistId.equals(id)))
        .go();
    await (_db.delete(_db.playlists)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> renamePlaylist(int id, String name) async {
    await (_db.update(_db.playlists)..where((t) => t.id.equals(id)))
        .write(PlaylistsCompanion(name: Value(name)));
  }

  @override
  Future<void> updatePlaylistCover(int id, String? coverUrl) async {
    await (_db.update(_db.playlists)..where((t) => t.id.equals(id)))
        .write(PlaylistsCompanion(coverUrl: Value(coverUrl)));
  }

  @override
  Future<List<SongItem>> getSongsInPlaylist(int playlistId) async {
    final query = _db.select(_db.songs).join([
      innerJoin(
        _db.playlistSongs,
        _db.playlistSongs.songId.equalsExp(_db.songs.id),
      ),
    ])
      ..where(_db.playlistSongs.playlistId.equals(playlistId))
      ..orderBy([OrderingTerm.asc(_db.playlistSongs.sortOrder)]);

    final rows = await query.get();
    return rows.map((row) => _mapSong(row.readTable(_db.songs))).toList();
  }

  @override
  Future<void> addSongToPlaylist(int playlistId, int songId) async {
    // Get max sort order
    final maxOrder = await (_db.selectOnly(_db.playlistSongs)
          ..addColumns([_db.playlistSongs.sortOrder.max()])
          ..where(_db.playlistSongs.playlistId.equals(playlistId)))
        .map((r) => r.read(_db.playlistSongs.sortOrder.max()))
        .getSingle();

    await _db.into(_db.playlistSongs).insert(
          PlaylistSongsCompanion.insert(
            playlistId: playlistId,
            songId: songId,
            sortOrder: Value((maxOrder ?? 0) + 1),
          ),
        );
  }

  @override
  Future<void> addSongsToPlaylist(int playlistId, List<int> songIds) async {
    await _db.batch((batch) {
      for (int i = 0; i < songIds.length; i++) {
        batch.insert(
          _db.playlistSongs,
          PlaylistSongsCompanion.insert(
            playlistId: playlistId,
            songId: songIds[i],
            sortOrder: Value(i),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  @override
  Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
    await (_db.delete(_db.playlistSongs)
          ..where((t) =>
              t.playlistId.equals(playlistId) & t.songId.equals(songId)))
        .go();
  }

  @override
  Future<void> reorderSongs(int playlistId, int oldIndex, int newIndex) async {
    final songs = await getSongsInPlaylist(playlistId);
    if (oldIndex < 0 || oldIndex >= songs.length) return;
    if (newIndex < 0 || newIndex >= songs.length) return;

    final movedSong = songs.removeAt(oldIndex);
    songs.insert(newIndex, movedSong);

    await _db.batch((batch) {
      for (int i = 0; i < songs.length; i++) {
        batch.update(
          _db.playlistSongs,
          PlaylistSongsCompanion(sortOrder: Value(i)),
          where: (t) =>
              t.playlistId.equals(playlistId) &
              t.songId.equals(songs[i].id),
        );
      }
    });
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
  }) async {
    // Check if song with same bvid+cid exists
    final existing = await (_db.select(_db.songs)
          ..where((t) => t.bvid.equals(bvid) & t.cid.equals(cid)))
        .getSingleOrNull();

    if (existing != null) {
      return existing.id;
    }

    return await _db.into(_db.songs).insert(
          SongsCompanion.insert(
            bvid: bvid,
            cid: cid,
            originTitle: originTitle,
            originArtist: originArtist,
            coverUrl: Value(coverUrl),
            duration: Value(duration),
            audioQuality: Value(audioQuality),
          ),
        );
  }

  @override
  Future<void> updateSongMetadata(
    int songId, {
    String? customTitle,
    String? customArtist,
    String? coverUrl,
  }) async {
    await (_db.update(_db.songs)..where((t) => t.id.equals(songId)))
        .write(SongsCompanion(
      customTitle: Value(customTitle),
      customArtist: Value(customArtist),
      coverUrl: Value(coverUrl),
    ));
  }

  @override
  Future<void> updateSongLocalPath(int songId, String? localPath) async {
    await (_db.update(_db.songs)..where((t) => t.id.equals(songId)))
        .write(SongsCompanion(localPath: Value(localPath)));
  }

  @override
  Future<SongItem?> getSongById(int id) async {
    final row = await (_db.select(_db.songs)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _mapSong(row) : null;
  }

  @override
  Future<List<SongItem>> searchSongs(String keyword) async {
    final pattern = '%$keyword%';
    final rows = await (_db.select(_db.songs)
          ..where((t) =>
              t.originTitle.like(pattern) |
              t.originArtist.like(pattern) |
              t.customTitle.like(pattern) |
              t.customArtist.like(pattern)))
        .get();
    return rows.map(_mapSong).toList();
  }
}
