import 'package:drift/drift.dart';

/// Subtitle cache table — one record per (bvid, cid) pair.
///
/// Stores serialized subtitle data fetched from Bilibili's AI subtitle
/// or CC subtitle system. Once cached, subtitles are served from DB
/// without hitting the network again.
class Subtitles extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Bilibili BV number.
  TextColumn get bvid => text().withLength(min: 1, max: 20)();

  /// Bilibili CID (page identifier).
  IntColumn get cid => integer()();

  /// Serialized subtitle data (JSON string of [SubtitleData]).
  TextColumn get subtitleJson => text()();

  /// Source type: 'ai' or 'cc'.
  TextColumn get sourceType =>
      text().withDefault(const Constant('ai'))();

  /// Creation timestamp (Unix milliseconds).
  IntColumn get createdAt => integer()();

  /// Unique constraint: one subtitle record per video page.
  @override
  List<Set<Column>> get uniqueKeys => [
        {bvid, cid},
      ];
}
