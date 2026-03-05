// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtitle_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subtitleNotifierHash() => r'24684258d7fd172bfb3ebef5feba2d378d70e0de';

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

abstract class _$SubtitleNotifier extends BuildlessAutoDisposeNotifier<
    ({
      SubtitleData? subtitleData,
      int currentLineIndex,
      SubtitleLoadStatus status,
      String? errorMessage
    })> {
  late final String bvid;
  late final int cid;

  ({
    SubtitleData? subtitleData,
    int currentLineIndex,
    SubtitleLoadStatus status,
    String? errorMessage
  }) build(
    String bvid,
    int cid,
  );
}

/// State notifier for subtitle/lyrics data of a specific video.
///
/// Uses family parameters `(bvid, cid)` so each video gets its own
/// independent subtitle instance with automatic disposal.
///
/// Copied from [SubtitleNotifier].
@ProviderFor(SubtitleNotifier)
const subtitleNotifierProvider = SubtitleNotifierFamily();

/// State notifier for subtitle/lyrics data of a specific video.
///
/// Uses family parameters `(bvid, cid)` so each video gets its own
/// independent subtitle instance with automatic disposal.
///
/// Copied from [SubtitleNotifier].
class SubtitleNotifierFamily extends Family<
    ({
      SubtitleData? subtitleData,
      int currentLineIndex,
      SubtitleLoadStatus status,
      String? errorMessage
    })> {
  /// State notifier for subtitle/lyrics data of a specific video.
  ///
  /// Uses family parameters `(bvid, cid)` so each video gets its own
  /// independent subtitle instance with automatic disposal.
  ///
  /// Copied from [SubtitleNotifier].
  const SubtitleNotifierFamily();

  /// State notifier for subtitle/lyrics data of a specific video.
  ///
  /// Uses family parameters `(bvid, cid)` so each video gets its own
  /// independent subtitle instance with automatic disposal.
  ///
  /// Copied from [SubtitleNotifier].
  SubtitleNotifierProvider call(
    String bvid,
    int cid,
  ) {
    return SubtitleNotifierProvider(
      bvid,
      cid,
    );
  }

  @override
  SubtitleNotifierProvider getProviderOverride(
    covariant SubtitleNotifierProvider provider,
  ) {
    return call(
      provider.bvid,
      provider.cid,
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
  String? get name => r'subtitleNotifierProvider';
}

/// State notifier for subtitle/lyrics data of a specific video.
///
/// Uses family parameters `(bvid, cid)` so each video gets its own
/// independent subtitle instance with automatic disposal.
///
/// Copied from [SubtitleNotifier].
class SubtitleNotifierProvider extends AutoDisposeNotifierProviderImpl<
    SubtitleNotifier,
    ({
      SubtitleData? subtitleData,
      int currentLineIndex,
      SubtitleLoadStatus status,
      String? errorMessage
    })> {
  /// State notifier for subtitle/lyrics data of a specific video.
  ///
  /// Uses family parameters `(bvid, cid)` so each video gets its own
  /// independent subtitle instance with automatic disposal.
  ///
  /// Copied from [SubtitleNotifier].
  SubtitleNotifierProvider(
    String bvid,
    int cid,
  ) : this._internal(
          () => SubtitleNotifier()
            ..bvid = bvid
            ..cid = cid,
          from: subtitleNotifierProvider,
          name: r'subtitleNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$subtitleNotifierHash,
          dependencies: SubtitleNotifierFamily._dependencies,
          allTransitiveDependencies:
              SubtitleNotifierFamily._allTransitiveDependencies,
          bvid: bvid,
          cid: cid,
        );

  SubtitleNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bvid,
    required this.cid,
  }) : super.internal();

  final String bvid;
  final int cid;

  @override
  ({
    SubtitleData? subtitleData,
    int currentLineIndex,
    SubtitleLoadStatus status,
    String? errorMessage
  }) runNotifierBuild(
    covariant SubtitleNotifier notifier,
  ) {
    return notifier.build(
      bvid,
      cid,
    );
  }

  @override
  Override overrideWith(SubtitleNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SubtitleNotifierProvider._internal(
        () => create()
          ..bvid = bvid
          ..cid = cid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bvid: bvid,
        cid: cid,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
      SubtitleNotifier,
      ({
        SubtitleData? subtitleData,
        int currentLineIndex,
        SubtitleLoadStatus status,
        String? errorMessage
      })> createElement() {
    return _SubtitleNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubtitleNotifierProvider &&
        other.bvid == bvid &&
        other.cid == cid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bvid.hashCode);
    hash = _SystemHash.combine(hash, cid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubtitleNotifierRef on AutoDisposeNotifierProviderRef<
    ({
      SubtitleData? subtitleData,
      int currentLineIndex,
      SubtitleLoadStatus status,
      String? errorMessage
    })> {
  /// The parameter `bvid` of this provider.
  String get bvid;

  /// The parameter `cid` of this provider.
  int get cid;
}

class _SubtitleNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<
        SubtitleNotifier,
        ({
          SubtitleData? subtitleData,
          int currentLineIndex,
          SubtitleLoadStatus status,
          String? errorMessage
        })> with SubtitleNotifierRef {
  _SubtitleNotifierProviderElement(super.provider);

  @override
  String get bvid => (origin as SubtitleNotifierProvider).bvid;
  @override
  int get cid => (origin as SubtitleNotifierProvider).cid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
