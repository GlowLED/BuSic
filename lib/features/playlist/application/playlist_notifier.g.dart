// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playlistListNotifierHash() =>
    r'2169fa903539dd81609a34d99fd5cf72ea367ec5';

/// State notifier managing playlist list and CRUD operations.
///
/// Copied from [PlaylistListNotifier].
@ProviderFor(PlaylistListNotifier)
final playlistListNotifierProvider = AutoDisposeAsyncNotifierProvider<
    PlaylistListNotifier, List<Playlist>>.internal(
  PlaylistListNotifier.new,
  name: r'playlistListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playlistListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PlaylistListNotifier = AutoDisposeAsyncNotifier<List<Playlist>>;
String _$playlistDetailNotifierHash() =>
    r'a0a263408cf71d7973453bb99e426d33dd7cc829';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PlaylistDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<SongItem>> {
  late final int playlistId;

  FutureOr<List<SongItem>> build(
    int playlistId,
  );
}

/// State notifier managing songs within a specific playlist.
///
/// Copied from [PlaylistDetailNotifier].
@ProviderFor(PlaylistDetailNotifier)
const playlistDetailNotifierProvider = PlaylistDetailNotifierFamily();

/// State notifier managing songs within a specific playlist.
///
/// Copied from [PlaylistDetailNotifier].
class PlaylistDetailNotifierFamily extends Family<AsyncValue<List<SongItem>>> {
  /// State notifier managing songs within a specific playlist.
  ///
  /// Copied from [PlaylistDetailNotifier].
  const PlaylistDetailNotifierFamily();

  /// State notifier managing songs within a specific playlist.
  ///
  /// Copied from [PlaylistDetailNotifier].
  PlaylistDetailNotifierProvider call(
    int playlistId,
  ) {
    return PlaylistDetailNotifierProvider(
      playlistId,
    );
  }

  @override
  PlaylistDetailNotifierProvider getProviderOverride(
    covariant PlaylistDetailNotifierProvider provider,
  ) {
    return call(
      provider.playlistId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'playlistDetailNotifierProvider';
}

/// State notifier managing songs within a specific playlist.
///
/// Copied from [PlaylistDetailNotifier].
class PlaylistDetailNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PlaylistDetailNotifier,
        List<SongItem>> {
  /// State notifier managing songs within a specific playlist.
  ///
  /// Copied from [PlaylistDetailNotifier].
  PlaylistDetailNotifierProvider(
    int playlistId,
  ) : this._internal(
          () => PlaylistDetailNotifier()..playlistId = playlistId,
          from: playlistDetailNotifierProvider,
          name: r'playlistDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$playlistDetailNotifierHash,
          dependencies: PlaylistDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              PlaylistDetailNotifierFamily._allTransitiveDependencies,
          playlistId: playlistId,
        );

  PlaylistDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.playlistId,
  }) : super.internal();

  final int playlistId;

  @override
  FutureOr<List<SongItem>> runNotifierBuild(
    covariant PlaylistDetailNotifier notifier,
  ) {
    return notifier.build(
      playlistId,
    );
  }

  @override
  Override overrideWith(PlaylistDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PlaylistDetailNotifierProvider._internal(
        () => create()..playlistId = playlistId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        playlistId: playlistId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PlaylistDetailNotifier,
      List<SongItem>> createElement() {
    return _PlaylistDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistDetailNotifierProvider &&
        other.playlistId == playlistId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, playlistId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlaylistDetailNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<SongItem>> {
  /// The parameter `playlistId` of this provider.
  int get playlistId;
}

class _PlaylistDetailNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PlaylistDetailNotifier,
        List<SongItem>> with PlaylistDetailNotifierRef {
  _PlaylistDetailNotifierProviderElement(super.provider);

  @override
  int get playlistId => (origin as PlaylistDetailNotifierProvider).playlistId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
