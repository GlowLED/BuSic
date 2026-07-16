// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier managing the authentication lifecycle.
///
/// Provides the current [User] session state and exposes methods
/// for login, logout, and session validation.

@ProviderFor(AuthNotifier)
final authNotifierProvider = AuthNotifierProvider._();

/// State notifier managing the authentication lifecycle.
///
/// Provides the current [User] session state and exposes methods
/// for login, logout, and session validation.
final class AuthNotifierProvider
    extends $AsyncNotifierProvider<AuthNotifier, User?> {
  /// State notifier managing the authentication lifecycle.
  ///
  /// Provides the current [User] session state and exposes methods
  /// for login, logout, and session validation.
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();
}

String _$authNotifierHash() => r'1abfb666ac5e1bbc35d32819d1b7d8c30f7535f1';

/// State notifier managing the authentication lifecycle.
///
/// Provides the current [User] session state and exposes methods
/// for login, logout, and session validation.

abstract class _$AuthNotifier extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
