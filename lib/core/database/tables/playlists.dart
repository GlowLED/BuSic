import 'package:drift/drift.dart';

/// Playlists table for user-created local playlists.
class Playlists extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Playlist display name.
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Optional cover image URL (first song cover or user-set).
  TextColumn get coverUrl => text().nullable()();

  /// Sort order for playlist list display.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Timestamp when the playlist was created.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
