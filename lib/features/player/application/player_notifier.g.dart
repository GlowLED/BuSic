// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier managing the audio player lifecycle.
///
/// Controls playback, queue management, and mode switching.
/// Listens to the [PlayerRepository] streams and updates [PlayerState] accordingly.
/// Persists playback state (track, queue, position) for restore on next launch.

@ProviderFor(PlayerNotifier)
final playerNotifierProvider = PlayerNotifierProvider._();

/// State notifier managing the audio player lifecycle.
///
/// Controls playback, queue management, and mode switching.
/// Listens to the [PlayerRepository] streams and updates [PlayerState] accordingly.
/// Persists playback state (track, queue, position) for restore on next launch.
final class PlayerNotifierProvider
    extends $NotifierProvider<PlayerNotifier, PlayerState> {
  /// State notifier managing the audio player lifecycle.
  ///
  /// Controls playback, queue management, and mode switching.
  /// Listens to the [PlayerRepository] streams and updates [PlayerState] accordingly.
  /// Persists playback state (track, queue, position) for restore on next launch.
  PlayerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerNotifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerNotifierHash();

  @$internal
  @override
  PlayerNotifier create() => PlayerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerState>(value),
    );
  }
}

String _$playerNotifierHash() => r'a1a86b061360a643ac1ac66e814266b081a053d2';

/// State notifier managing the audio player lifecycle.
///
/// Controls playback, queue management, and mode switching.
/// Listens to the [PlayerRepository] streams and updates [PlayerState] accordingly.
/// Persists playback state (track, queue, position) for restore on next launch.

abstract class _$PlayerNotifier extends $Notifier<PlayerState> {
  PlayerState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PlayerState, PlayerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerState, PlayerState>,
              PlayerState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
