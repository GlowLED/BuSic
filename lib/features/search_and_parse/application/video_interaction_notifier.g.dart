// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_interaction_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoInteractionNotifierHash() =>
    r'd37fb462c925fb342a67bd7f2e4bb6c3ae945783';

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

abstract class _$VideoInteractionNotifier
    extends BuildlessAutoDisposeAsyncNotifier<VideoInteractionState> {
  late final String bvid;
  late final int aid;

  FutureOr<VideoInteractionState> build(
    String bvid,
    int aid,
  );
}

/// Manages Bilibili interaction state for a parsed video detail page.
///
/// Copied from [VideoInteractionNotifier].
@ProviderFor(VideoInteractionNotifier)
const videoInteractionNotifierProvider = VideoInteractionNotifierFamily();

/// Manages Bilibili interaction state for a parsed video detail page.
///
/// Copied from [VideoInteractionNotifier].
class VideoInteractionNotifierFamily
    extends Family<AsyncValue<VideoInteractionState>> {
  /// Manages Bilibili interaction state for a parsed video detail page.
  ///
  /// Copied from [VideoInteractionNotifier].
  const VideoInteractionNotifierFamily();

  /// Manages Bilibili interaction state for a parsed video detail page.
  ///
  /// Copied from [VideoInteractionNotifier].
  VideoInteractionNotifierProvider call(
    String bvid,
    int aid,
  ) {
    return VideoInteractionNotifierProvider(
      bvid,
      aid,
    );
  }

  @override
  VideoInteractionNotifierProvider getProviderOverride(
    covariant VideoInteractionNotifierProvider provider,
  ) {
    return call(
      provider.bvid,
      provider.aid,
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
  String? get name => r'videoInteractionNotifierProvider';
}

/// Manages Bilibili interaction state for a parsed video detail page.
///
/// Copied from [VideoInteractionNotifier].
class VideoInteractionNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VideoInteractionNotifier,
        VideoInteractionState> {
  /// Manages Bilibili interaction state for a parsed video detail page.
  ///
  /// Copied from [VideoInteractionNotifier].
  VideoInteractionNotifierProvider(
    String bvid,
    int aid,
  ) : this._internal(
          () => VideoInteractionNotifier()
            ..bvid = bvid
            ..aid = aid,
          from: videoInteractionNotifierProvider,
          name: r'videoInteractionNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$videoInteractionNotifierHash,
          dependencies: VideoInteractionNotifierFamily._dependencies,
          allTransitiveDependencies:
              VideoInteractionNotifierFamily._allTransitiveDependencies,
          bvid: bvid,
          aid: aid,
        );

  VideoInteractionNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bvid,
    required this.aid,
  }) : super.internal();

  final String bvid;
  final int aid;

  @override
  FutureOr<VideoInteractionState> runNotifierBuild(
    covariant VideoInteractionNotifier notifier,
  ) {
    return notifier.build(
      bvid,
      aid,
    );
  }

  @override
  Override overrideWith(VideoInteractionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: VideoInteractionNotifierProvider._internal(
        () => create()
          ..bvid = bvid
          ..aid = aid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bvid: bvid,
        aid: aid,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VideoInteractionNotifier,
      VideoInteractionState> createElement() {
    return _VideoInteractionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoInteractionNotifierProvider &&
        other.bvid == bvid &&
        other.aid == aid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bvid.hashCode);
    hash = _SystemHash.combine(hash, aid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VideoInteractionNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<VideoInteractionState> {
  /// The parameter `bvid` of this provider.
  String get bvid;

  /// The parameter `aid` of this provider.
  int get aid;
}

class _VideoInteractionNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VideoInteractionNotifier,
        VideoInteractionState> with VideoInteractionNotifierRef {
  _VideoInteractionNotifierProviderElement(super.provider);

  @override
  String get bvid => (origin as VideoInteractionNotifierProvider).bvid;
  @override
  int get aid => (origin as VideoInteractionNotifierProvider).aid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
