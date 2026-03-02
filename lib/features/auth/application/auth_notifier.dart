import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';
import '../domain/models/user.dart';

part 'auth_notifier.g.dart';

/// State notifier managing the authentication lifecycle.
///
/// Provides the current [User] session state and exposes methods
/// for login, logout, and session validation.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository _repository;

  @override
  Future<User?> build() async {
    // TODO: inject repository, attempt to load existing session
    throw UnimplementedError();
  }

  /// Start the QR code login flow.
  ///
  /// Returns the QR code URL to display and begins polling.
  Future<String> login() async {
    // TODO: generate QR code, start polling timer, update state
    throw UnimplementedError();
  }

  /// Log out the current user.
  ///
  /// Clears the session from database and resets state.
  Future<void> logout() async {
    // TODO: clear session via repository, reset state to null
    throw UnimplementedError();
  }

  /// Check if the current session is still valid.
  Future<void> checkSession() async {
    // TODO: validate session, refresh if needed
    throw UnimplementedError();
  }
}
