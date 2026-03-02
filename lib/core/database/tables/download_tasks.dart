import 'package:drift/drift.dart';

import 'songs.dart';

/// Download status enum stored as integer in database.
/// 0=pending, 1=downloading, 2=completed, 3=failed
class DownloadTasks extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key referencing [Songs.id].
  IntColumn get songId => integer().references(Songs, #id)();

  /// Download status: 0=pending, 1=downloading, 2=completed, 3=failed.
  IntColumn get status => integer().withDefault(const Constant(0))();

  /// Download progress (0.0 - 1.0), stored as integer percentage (0-100).
  IntColumn get progress => integer().withDefault(const Constant(0))();

  /// Target local file path.
  TextColumn get filePath => text().nullable()();

  /// Timestamp when the download task was created.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
