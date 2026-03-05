// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playerNotifierHash() => r'cf096d8dd9ea00b675cb96316435c8d598e8e100';

/// State notifier managing the audio player lifecycle.
///
/// Controls playback, queue management, and mode switching.
/// Listens to the [PlayerRepository] streams and updates [PlayerState] accordingly.
/// Persists playback state (track, queue, position) for restore on next launch.
///
/// Copied from [PlayerNotifier].
@ProviderFor(PlayerNotifier)
final playerNotifierProvider =
    AutoDisposeNotifierProvider<PlayerNotifier, PlayerState>.internal(
  PlayerNotifier.new,
  name: r'playerNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PlayerNotifier = AutoDisposeNotifier<PlayerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
