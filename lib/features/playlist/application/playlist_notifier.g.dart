// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier managing playlist list and CRUD operations.

@ProviderFor(PlaylistListNotifier)
final playlistListNotifierProvider = PlaylistListNotifierProvider._();

/// State notifier managing playlist list and CRUD operations.
final class PlaylistListNotifierProvider
    extends $AsyncNotifierProvider<PlaylistListNotifier, List<Playlist>> {
  /// State notifier managing playlist list and CRUD operations.
  PlaylistListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playlistListNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistListNotifierHash();

  @$internal
  @override
  PlaylistListNotifier create() => PlaylistListNotifier();
}

String _$playlistListNotifierHash() =>
    r'dc949eb60909e9a3cd625101ec35138dbae665e4';

/// State notifier managing playlist list and CRUD operations.

abstract class _$PlaylistListNotifier extends $AsyncNotifier<List<Playlist>> {
  FutureOr<List<Playlist>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Playlist>>, List<Playlist>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Playlist>>, List<Playlist>>,
              AsyncValue<List<Playlist>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// State notifier managing songs within a specific playlist.

@ProviderFor(PlaylistDetailNotifier)
final playlistDetailNotifierProvider = PlaylistDetailNotifierFamily._();

/// State notifier managing songs within a specific playlist.
final class PlaylistDetailNotifierProvider
    extends $AsyncNotifierProvider<PlaylistDetailNotifier, List<SongItem>> {
  /// State notifier managing songs within a specific playlist.
  PlaylistDetailNotifierProvider._({
    required PlaylistDetailNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'playlistDetailNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playlistDetailNotifierHash();

  @override
  String toString() {
    return r'playlistDetailNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PlaylistDetailNotifier create() => PlaylistDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is PlaylistDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistDetailNotifierHash() =>
    r'34f21071f7c22f17a6baceaef1ed0222e8940735';

/// State notifier managing songs within a specific playlist.

final class PlaylistDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PlaylistDetailNotifier,
          AsyncValue<List<SongItem>>,
          List<SongItem>,
          FutureOr<List<SongItem>>,
          int
        > {
  PlaylistDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'playlistDetailNotifierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// State notifier managing songs within a specific playlist.

  PlaylistDetailNotifierProvider call(int playlistId) =>
      PlaylistDetailNotifierProvider._(argument: playlistId, from: this);

  @override
  String toString() => r'playlistDetailNotifierProvider';
}

/// State notifier managing songs within a specific playlist.

abstract class _$PlaylistDetailNotifier extends $AsyncNotifier<List<SongItem>> {
  late final _$args = ref.$arg as int;
  int get playlistId => _$args;

  FutureOr<List<SongItem>> build(int playlistId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<SongItem>>, List<SongItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SongItem>>, List<SongItem>>,
              AsyncValue<List<SongItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
