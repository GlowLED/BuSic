// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the set of song IDs that are in the user's favorites playlist.
///
/// UI widgets watch this provider to render the heart icon state.
/// Call [loadFavoriteStatus] after loading a page's song list,
/// then [toggleFavorite] when the user taps the heart button.

@ProviderFor(FavoriteNotifier)
final favoriteNotifierProvider = FavoriteNotifierProvider._();

/// Manages the set of song IDs that are in the user's favorites playlist.
///
/// UI widgets watch this provider to render the heart icon state.
/// Call [loadFavoriteStatus] after loading a page's song list,
/// then [toggleFavorite] when the user taps the heart button.
final class FavoriteNotifierProvider
    extends $AsyncNotifierProvider<FavoriteNotifier, Set<int>> {
  /// Manages the set of song IDs that are in the user's favorites playlist.
  ///
  /// UI widgets watch this provider to render the heart icon state.
  /// Call [loadFavoriteStatus] after loading a page's song list,
  /// then [toggleFavorite] when the user taps the heart button.
  FavoriteNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteNotifierHash();

  @$internal
  @override
  FavoriteNotifier create() => FavoriteNotifier();
}

String _$favoriteNotifierHash() => r'2a4b6fdccdd7c63e19fe74156095401a702c1e68';

/// Manages the set of song IDs that are in the user's favorites playlist.
///
/// UI widgets watch this provider to render the heart icon state.
/// Call [loadFavoriteStatus] after loading a page's song list,
/// then [toggleFavorite] when the user taps the heart button.

abstract class _$FavoriteNotifier extends $AsyncNotifier<Set<int>> {
  FutureOr<Set<int>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Set<int>>, Set<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<int>>, Set<int>>,
              AsyncValue<Set<int>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
