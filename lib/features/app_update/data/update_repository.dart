import 'package:dio/dio.dart';

import '../domain/models/update_info.dart';

/// Abstract interface for the app update repository.
abstract class UpdateRepository {
  /// Fetch remote version info and compare with local version.
  Future<UpdateInfo> checkForUpdate();

  /// Download the update asset to [savePath].
  ///
  /// Returns the local file path of the downloaded asset.
  Future<String> downloadUpdate({
    required String url,
    required String savePath,
    required void Function(double progress, double speed) onProgress,
    CancelToken? cancelToken,
  });

  /// Apply the downloaded update (platform-specific).
  Future<void> applyUpdate(String localPath);

  /// Warm-up: probe proxies and cache the fastest one.
  Future<void> probeProxies();
}
