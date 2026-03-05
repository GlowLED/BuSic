// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentNotifierHash() => r'6f09594eb3e6e11136476d1230533afdf6b7a40b';

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

abstract class _$CommentNotifier
    extends BuildlessAutoDisposeAsyncNotifier<CommentState> {
  late final String bvid;

  FutureOr<CommentState> build(
    String bvid,
  );
}

/// Riverpod notifier managing the comment list for a specific video.
///
/// Family parameter is the video's `bvid` string.
///
/// Copied from [CommentNotifier].
@ProviderFor(CommentNotifier)
const commentNotifierProvider = CommentNotifierFamily();

/// Riverpod notifier managing the comment list for a specific video.
///
/// Family parameter is the video's `bvid` string.
///
/// Copied from [CommentNotifier].
class CommentNotifierFamily extends Family<AsyncValue<CommentState>> {
  /// Riverpod notifier managing the comment list for a specific video.
  ///
  /// Family parameter is the video's `bvid` string.
  ///
  /// Copied from [CommentNotifier].
  const CommentNotifierFamily();

  /// Riverpod notifier managing the comment list for a specific video.
  ///
  /// Family parameter is the video's `bvid` string.
  ///
  /// Copied from [CommentNotifier].
  CommentNotifierProvider call(
    String bvid,
  ) {
    return CommentNotifierProvider(
      bvid,
    );
  }

  @override
  CommentNotifierProvider getProviderOverride(
    covariant CommentNotifierProvider provider,
  ) {
    return call(
      provider.bvid,
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
  String? get name => r'commentNotifierProvider';
}

/// Riverpod notifier managing the comment list for a specific video.
///
/// Family parameter is the video's `bvid` string.
///
/// Copied from [CommentNotifier].
class CommentNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CommentNotifier, CommentState> {
  /// Riverpod notifier managing the comment list for a specific video.
  ///
  /// Family parameter is the video's `bvid` string.
  ///
  /// Copied from [CommentNotifier].
  CommentNotifierProvider(
    String bvid,
  ) : this._internal(
          () => CommentNotifier()..bvid = bvid,
          from: commentNotifierProvider,
          name: r'commentNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$commentNotifierHash,
          dependencies: CommentNotifierFamily._dependencies,
          allTransitiveDependencies:
              CommentNotifierFamily._allTransitiveDependencies,
          bvid: bvid,
        );

  CommentNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bvid,
  }) : super.internal();

  final String bvid;

  @override
  FutureOr<CommentState> runNotifierBuild(
    covariant CommentNotifier notifier,
  ) {
    return notifier.build(
      bvid,
    );
  }

  @override
  Override overrideWith(CommentNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CommentNotifierProvider._internal(
        () => create()..bvid = bvid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bvid: bvid,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CommentNotifier, CommentState>
      createElement() {
    return _CommentNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentNotifierProvider && other.bvid == bvid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bvid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CommentNotifierRef on AutoDisposeAsyncNotifierProviderRef<CommentState> {
  /// The parameter `bvid` of this provider.
  String get bvid;
}

class _CommentNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CommentNotifier,
        CommentState> with CommentNotifierRef {
  _CommentNotifierProviderElement(super.provider);

  @override
  String get bvid => (origin as CommentNotifierProvider).bvid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
