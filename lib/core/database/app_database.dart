import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'tables/songs.dart';
import 'tables/playlists.dart';
import 'tables/playlist_songs.dart';
import 'tables/download_tasks.dart';
import 'tables/user_sessions.dart';
import 'tables/subtitles.dart';

part 'app_database.g.dart';

/// Main application database using Drift (SQLite).
///
/// Includes all tables for songs, playlists, downloads, and user sessions.
/// Run `dart run build_runner build` to generate the implementation.
@DriftDatabase(tables: [
  Songs,
  Playlists,
  PlaylistSongs,
  DownloadTasks,
  UserSessions,
  Subtitles,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Named constructor for testing with a provided [QueryExecutor].
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(downloadTasks, downloadTasks.quality);
        }
        if (from < 3) {
          await m.addColumn(playlists, playlists.isFavorite);
        }
        if (from < 4) {
          await m.createTable(subtitles);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'busic', 'busic.db'));
    return NativeDatabase.createInBackground(file);
  });
}
