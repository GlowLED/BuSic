// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manifest_cache.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 版本清单缓存（全局，非 AutoDispose）

@ProviderFor(ManifestCache)
final manifestCacheProvider = ManifestCacheProvider._();

/// 版本清单缓存（全局，非 AutoDispose）
final class ManifestCacheProvider
    extends $AsyncNotifierProvider<ManifestCache, VersionManifest> {
  /// 版本清单缓存（全局，非 AutoDispose）
  ManifestCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manifestCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manifestCacheHash();

  @$internal
  @override
  ManifestCache create() => ManifestCache();
}

String _$manifestCacheHash() => r'72927c0a75ecd6fc046e79a6bd6bf1d6427a8088';

/// 版本清单缓存（全局，非 AutoDispose）

abstract class _$ManifestCache extends $AsyncNotifier<VersionManifest> {
  FutureOr<VersionManifest> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<VersionManifest>, VersionManifest>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<VersionManifest>, VersionManifest>,
              AsyncValue<VersionManifest>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
