import '../domain/models/subtitle_data.dart';

/// Interface for subtitle/lyrics data access.
///
/// Abstracts the data source (API + DB cache) so the application layer
/// doesn't need to know about networking or persistence details.
abstract class SubtitleRepository {
  /// Get subtitle data, checking DB cache first, then fetching from API.
  ///
  /// Returns `null` if no subtitle is available after all retries.
  Future<SubtitleData?> getSubtitle({
    required String bvid,
    required int cid,
  });

  /// Get cached subtitle from the local database.
  Future<SubtitleData?> getCachedSubtitle({
    required String bvid,
    required int cid,
  });

  /// Save subtitle data to the local database cache.
  Future<void> cacheSubtitle({
    required String bvid,
    required int cid,
    required SubtitleData data,
  });

  /// Fetch subtitle from Bilibili API with prefix validation + retry logic.
  ///
  /// [maxRetries] controls the maximum number of fetch attempts (default 10).
  /// Returns `null` if all retries are exhausted without a valid match.
  Future<SubtitleData?> fetchSubtitleFromApi({
    required String bvid,
    required int cid,
    int maxRetries = 10,
  });
}
