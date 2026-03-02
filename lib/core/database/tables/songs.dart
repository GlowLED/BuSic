import 'package:drift/drift.dart';

/// Songs table storing both original and user-customized metadata.
///
/// Fields prefixed with `origin` are fetched from Bilibili.
/// Fields prefixed with `custom` are user overrides.
/// UI should display `custom` values when non-null, falling back to `origin`.
class Songs extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Bilibili BV number (e.g., "BV1xx411c7mD").
  TextColumn get bvid => text().withLength(min: 1, max: 20)();

  /// Bilibili CID (unique per video page/part).
  IntColumn get cid => integer()();

  /// Original title fetched from Bilibili.
  TextColumn get originTitle => text()();

  /// Original artist (UP主 name) fetched from Bilibili.
  TextColumn get originArtist => text()();

  /// User-customized title (nullable, overrides originTitle when set).
  TextColumn get customTitle => text().nullable()();

  /// User-customized artist (nullable, overrides originArtist when set).
  TextColumn get customArtist => text().nullable()();

  /// Cover image URL.
  TextColumn get coverUrl => text().nullable()();

  /// Duration in seconds.
  IntColumn get duration => integer().withDefault(const Constant(0))();

  /// Audio quality identifier (e.g., 30280 for 192kbps).
  IntColumn get audioQuality => integer().withDefault(const Constant(0))();

  /// Local file path if cached/downloaded.
  TextColumn get localPath => text().nullable()();

  /// Timestamp when the song was added.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
