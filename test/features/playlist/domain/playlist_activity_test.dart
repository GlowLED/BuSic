import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/playlist/domain/models/playlist.dart';
import 'package:busic/features/playlist/domain/playlist_activity.dart';

void main() {
  Playlist playlist({
    int id = 1,
    String name = 'P',
    int playCount = 0,
    DateTime? lastPlayedAt,
    bool isFavorite = false,
    DateTime? createdAt,
  }) {
    return Playlist(
      id: id,
      name: name,
      playCount: playCount,
      lastPlayedAt: lastPlayedAt,
      isFavorite: isFavorite,
      createdAt: createdAt ?? DateTime(2026, 1, 1),
    );
  }

  final now = DateTime(2026, 6, 1, 12);

  group('score', () {
    test('is zero for a playlist that has never been active', () {
      expect(PlaylistActivity.score(playlist(), now: now), 0);
      expect(
        PlaylistActivity.score(playlist(playCount: 0), now: now),
        0,
      );
    });

    test('rewards both play count and recency', () {
      final recent = playlist(playCount: 5, lastPlayedAt: now);
      final old = playlist(playCount: 5, lastPlayedAt: now.subtract(
        const Duration(days: 30),
      ));
      final morePlayed = playlist(playCount: 20, lastPlayedAt: now);

      expect(
        PlaylistActivity.score(recent, now: now),
        greaterThan(PlaylistActivity.score(old, now: now)),
      );
      expect(
        PlaylistActivity.score(morePlayed, now: now),
        greaterThan(PlaylistActivity.score(recent, now: now)),
      );
    });

    test('decays the recency term with the configured half life', () {
      final fresh = playlist(playCount: 1, lastPlayedAt: now);
      final halfLife = playlist(
        playCount: 1,
        lastPlayedAt: now.subtract(
          Duration(days: PlaylistActivity.recencyHalfLifeDays.toInt()),
        ),
      );
      final freshScore = PlaylistActivity.score(fresh, now: now);
      final halfScore = PlaylistActivity.score(halfLife, now: now);
      expect(
        halfScore,
        closeTo(freshScore - PlaylistActivity.recencyWeight / 2, 1e-6),
      );
    });
  });

  group('sortByActivity', () {
    test('pins the favorites playlist first', () {
      final favorite = playlist(id: 9, isFavorite: true);
      final active = playlist(id: 1, playCount: 10, lastPlayedAt: now);
      final sorted = PlaylistActivity.sortByActivity([active, favorite], now: now);
      expect(sorted.first.id, 9);
    });

    test('orders remaining playlists by descending score then creation time', () {
      final hot = playlist(id: 1, playCount: 9, lastPlayedAt: now, createdAt: DateTime(2026, 5, 1));
      final medium = playlist(id: 2, playCount: 4, lastPlayedAt: now, createdAt: DateTime(2026, 5, 1));
      final cold = playlist(id: 3, playCount: 0);
      final sorted = PlaylistActivity.sortByActivity([medium, cold, hot], now: now);
      expect(sorted.map((p) => p.id).toList(), [1, 2, 3]);
    });

    test('breaks score ties by newest creation time', () {
      final a = playlist(id: 1, playCount: 3, lastPlayedAt: now, createdAt: DateTime(2026, 1, 1));
      final b = playlist(id: 2, playCount: 3, lastPlayedAt: now, createdAt: DateTime(2026, 5, 1));
      final sorted = PlaylistActivity.sortByActivity([a, b], now: now);
      expect(sorted.map((p) => p.id).toList(), [2, 1]);
    });
  });

  group('tierFor', () {
    test('treats the favorites playlist as standard regardless of activity', () {
      final favorite = playlist(id: 9, isFavorite: true, playCount: 999, lastPlayedAt: now);
      final sorted = [favorite, playlist(id: 1, playCount: 5, lastPlayedAt: now)];
      expect(PlaylistActivity.tierFor(favorite, sorted, now: now), PlaylistTier.standard);
    });

    test('classifies an inactive playlist as compact', () {
      final list = [playlist(id: 1, playCount: 5, lastPlayedAt: now), playlist(id: 2)];
      expect(PlaylistActivity.tierFor(list[1], list, now: now), PlaylistTier.compact);
    });

    test('promotes the most active playlists to featured', () {
      final list = List.generate(
        6,
        (i) => playlist(
          id: i + 1,
          playCount: 6 - i,
          lastPlayedAt: now,
          createdAt: DateTime(2026, 1, 1 + i),
        ),
      );
      final sorted = PlaylistActivity.sortByActivity(list, now: now);
      expect(
        PlaylistActivity.tierFor(sorted[0], sorted, now: now),
        PlaylistTier.featured,
      );
      expect(
        PlaylistActivity.tierFor(sorted[5], sorted, now: now),
        PlaylistTier.compact,
      );
    });

    test('featured tier keeps at least one card but none for a single playlist', () {
      expect(PlaylistActivity.featuredCount(1), 0);
      expect(PlaylistActivity.featuredCount(6), 2);
      expect(PlaylistActivity.featuredCount(10), 2);
    });
  });
}
