import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/update_repository_impl.dart';
import '../domain/models/version_manifest.dart';

part 'manifest_cache.g.dart';

/// 版本清单缓存（全局，非 AutoDispose）
@Riverpod(keepAlive: true)
class ManifestCache extends _$ManifestCache {
  @override
  Future<VersionManifest> build() async {
    final repo = UpdateRepositoryImpl();
    return repo.fetchManifest();
  }

  /// 强制刷新缓存
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = UpdateRepositoryImpl();
      return repo.fetchManifest();
    });
  }
}
