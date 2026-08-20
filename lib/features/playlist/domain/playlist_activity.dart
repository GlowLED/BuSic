import 'dart:math' as math;

import 'models/playlist.dart';

/// Tier of a playlist card in the library grid, derived from activity score.
enum PlaylistTier {
  /// Highest-activity playlists — rendered as large spanning cards.
  featured,

  /// Default presentation for playlists with some activity.
  standard,

  /// Low or no activity — rendered as smaller compact cards.
  compact,
}

/// Pure helpers for computing playlist activity scores, assigning card tiers,
/// and sorting the library by activity. Kept dependency-free for unit tests.
class PlaylistActivity {
  PlaylistActivity._();

  /// Recency decay half-life in days: after this long without an active event
  /// the recency term halves.
  static const double recencyHalfLifeDays = 30;

  /// Weight of the recency term relative to the play-count term.
  static const double recencyWeight = 3.0;

  /// Fraction of the most active playlists promoted to the featured tier.
  static const double featuredRatio = 0.2;

  /// Fraction of the least active playlists demoted to the compact tier.
  static const double compactRatio = 0.4;

  /// Minimum size of the featured tier (keeps at least one featured card).
  static const int featuredMinCount = 1;

  /// Activity score combining a normalized play count and a recency decay.
  ///
  /// Returns 0 for playlists that have never been active, which also covers
  /// playlists whose history predates the activity-tracking migration.
  static double score(Playlist playlist, {DateTime? now}) {
    final lastPlayedAt = playlist.lastPlayedAt;
    if (lastPlayedAt == null || playlist.playCount <= 0) return 0;

    final current = now ?? DateTime.now();
    final days = current.difference(lastPlayedAt).inHours / 24.0;
    final decay = math.pow(0.5, days / recencyHalfLifeDays).toDouble();
    final countTerm = math.log(1 + playlist.playCount);
    return countTerm + recencyWeight * decay;
  }

  /// Number of playlists promoted to the featured tier.
  static int featuredCount(int total) {
    if (total < 2) return 0;
    final count = (total * featuredRatio).ceil();
    return math.min(math.max(count, featuredMinCount), total);
  }

  /// Number of playlists demoted to the compact tier.
  static int compactCount(int total) {
    return (total * compactRatio).floor();
  }

  /// Assigns a tier to [playlist] relative to the whole [list].
  ///
  /// The favorites playlist is always [PlaylistTier.standard]. Featured and
  /// compact tiers are ranked among non-favorite playlists, so the pinned
  /// favorites card does not consume a featured slot.
  static PlaylistTier tierFor(
    Playlist playlist,
    List<Playlist> list, {
    DateTime? now,
  }) {
    if (playlist.isFavorite) return PlaylistTier.standard;
    final activeList = list.where((p) => !p.isFavorite).toList(growable: false);
    final index = activeList.indexWhere((p) => p.id == playlist.id);
    if (index < 0 || score(playlist, now: now) <= 0) {
      return PlaylistTier.compact;
    }
    if (index < featuredCount(activeList.length)) {
      return PlaylistTier.featured;
    }
    if (index >= activeList.length - compactCount(activeList.length)) {
      return PlaylistTier.compact;
    }
    return PlaylistTier.standard;
  }

  /// Sorts playlists for display: favorites pinned first, then by activity
  /// score descending, ties broken by creation time descending.
  static List<Playlist> sortByActivity(List<Playlist> playlists, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final scored = playlists.map((p) => (playlist: p, score: score(p, now: current))).toList();
    scored.sort((a, b) {
      if (a.playlist.isFavorite != b.playlist.isFavorite) {
        return a.playlist.isFavorite ? -1 : 1;
      }
      final scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) return scoreComparison;
      return b.playlist.createdAt.compareTo(a.playlist.createdAt);
    });
    return scored.map((entry) => entry.playlist).toList();
  }
}