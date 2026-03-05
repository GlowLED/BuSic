import 'package:dio/dio.dart';

import '../domain/models/update_info.dart';
import '../domain/models/version_manifest.dart';

/// Abstract interface for the app update repository.
abstract class UpdateRepository {
  /// Fetch the version manifest (all history versions).
  Future<VersionManifest> fetchManifest();

  /// Fetch remote version info and compare with local version.
  Future<UpdateInfo> checkForUpdate();

  /// Get download info for a specific historical version.
  Future<UpdateInfo> getVersionInfo(String version);

  /// Download the update asset to [savePath].
  ///
  /// Returns the local file path of the downloaded asset.
  Future<String> downloadUpdate({
    required String url,
    required String savePath,
    required void Function(double progress, double speed) onProgress,
    CancelToken? cancelToken,
    int startByte,
  });

  /// Resolve a Lanzou share URL to a direct download link.
  Future<String> resolveLanzouUrl(String shareUrl, {String? password});

  /// Apply the downloaded update (platform-specific).
  Future<void> applyUpdate(String localPath);

  /// Warm-up: probe proxies and cache the fastest one.
  Future<void> probeProxies();
}
