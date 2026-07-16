import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_notifier.dart';
import '../../player/domain/models/audio_track.dart';
import '../data/playlist_repository_impl.dart';
import 'playlist_notifier.dart';

part 'favorite_notifier.g.dart';

/// Manages the set of song IDs that are in the user's favorites playlist.
///
/// UI widgets watch this provider to render the heart icon state.
/// Call [loadFavoriteStatus] after loading a page's song list,
/// then [toggleFavorite] when the user taps the heart button.
@Riverpod(name: 'favoriteNotifierProvider')
class FavoriteNotifier extends _$FavoriteNotifier {
  late PlaylistRepositoryImpl _repository;

  @override
  Future<Set<int>> build() async {
    _repository = PlaylistRepositoryImpl(db: ref.read(databaseProvider));
    // Start with an empty set; pages call loadFavoriteStatus on demand.
    return {};
  }

  /// Load favorite status for a batch of song IDs.
  ///
  /// Merges results into the current state so that multiple pages
  /// can independently load without clearing each other's data.
  Future<void> loadFavoriteStatus(List<int> songIds) async {
    if (songIds.isEmpty) return;
    final favIds = await _repository.getFavoritedSongIds(songIds);
    final current = state.value ?? {};
    // Remove old entries for these songIds, then add back the favorited ones.
    final updated = <int>{
      ...current.where((id) => !songIds.contains(id)),
      ...favIds,
    };
    state = AsyncData(updated);
  }

  /// Toggle a song's favorite state and update the local cache.
  Future<void> toggleFavorite(int songId) async {
    ref.keepAlive();
    final isFav = await _repository.toggleFavorite(songId);
    final current = state.value ?? {};
    if (isFav) {
      state = AsyncData({...current, songId});
    } else {
      state = AsyncData({...current}..remove(songId));
    }
    // Refresh playlist list so the favorites song count updates.
    ref.invalidate(playlistListNotifierProvider);
  }

  /// Upsert a track into the database and toggle its favorite status.
  ///
  /// Used when a track with `songId == 0` (not yet persisted) is favorited.
  /// Returns the persisted song ID so the caller can update the queue.
  Future<int> favoriteFromTrack(AudioTrack track) async {
    ref.keepAlive();
    final songId = await _repository.upsertSong(
      bvid: track.bvid,
      cid: track.cid,
      originTitle: track.title,
      originArtist: track.artist,
      coverUrl: track.coverUrl,
      duration: track.duration.inSeconds,
      audioQuality: track.quality,
    );
    await toggleFavorite(songId);
    return songId;
  }

  /// Check whether a song is currently marked as favorited.
  bool isFavorited(int songId) {
    return state.value?.contains(songId) ?? false;
  }
}
