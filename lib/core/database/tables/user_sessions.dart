import 'package:drift/drift.dart';

/// User session table for persisting Bilibili login credentials.
///
/// Stores the cookie fields needed for authenticated API requests
/// and basic user profile info for display.
class UserSessions extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Bilibili SESSDATA cookie value.
  TextColumn get sessdata => text()();

  /// Bilibili bili_jct (CSRF token) cookie value.
  TextColumn get biliJct => text()();

  /// Bilibili DedeUserID.
  TextColumn get dedeUserId => text()();

  /// Session expiration timestamp.
  DateTimeColumn get expires => dateTime().nullable()();

  /// User avatar URL.
  TextColumn get avatarUrl => text().nullable()();

  /// User display name / nickname.
  TextColumn get nickname => text().nullable()();
}
