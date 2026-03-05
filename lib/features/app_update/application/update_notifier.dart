import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/logger.dart';
import '../data/lanzou_resolver.dart';
import '../data/update_repository_impl.dart';
import '../domain/models/app_version.dart';
import '../domain/models/download_channel.dart';
import '../domain/models/update_state.dart';
import '../domain/models/version_manifest.dart';

part 'update_notifier.g.dart';

const _kTag = 'UpdateNotifier';
const _kSkippedVersionKey = 'update_skipped_version';
const _kLastCheckKey = 'update_last_check';
const _kCheckCooldownMs = 24 * 60 * 60 * 1000; // 24 hours

// SharedPreferences keys for download state persistence
const _kDownloadVersionKey = 'update_dl_version';
const _kDownloadChannelKey = 'update_dl_channel';
const _kDownloadPathKey = 'update_dl_path';
const _kDownloadUrlKey = 'update_dl_url';

@riverpod
class UpdateNotifier extends _$UpdateNotifier {
  CancelToken? _cancelToken;
  final UpdateRepositoryImpl _repo = UpdateRepositoryImpl();

  @override
  UpdateState build() => const UpdateState.idle();

  /// Check for updates.
  ///
  /// When [silent] is true (e.g. on app startup), only shows UI if an update
  /// is found and respects the 24-hour cooldown + skipped version.
  Future<void> checkForUpdate({bool silent = false}) async {
    final keepAlive = ref.keepAlive();
    try {
      if (silent) {
        final prefs = await SharedPreferences.getInstance();
        final lastCheck = prefs.getInt(_kLastCheckKey) ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastCheck < _kCheckCooldownMs) {
          AppLogger.info(
            'Silent check skipped (cooldown active)',
            tag: _kTag,
          );
          return;
        }
      }

      state = const UpdateState.checking();

      final info = await _repo.checkForUpdate();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        _kLastCheckKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      if (info.currentVersion >= info.latestVersion) {
        state = const UpdateState.idle();
        return;
      }

      if (!info.isForceUpdate && silent) {
        final skipped = prefs.getString(_kSkippedVersionKey);
        if (skipped == info.latestVersion.semver) {
          AppLogger.info(
            'Version ${info.latestVersion} was skipped by user',
            tag: _kTag,
          );
          state = const UpdateState.idle();
          return;
        }
      }

      state = UpdateState.available(info);
    } catch (e, st) {
      AppLogger.error(
        'Update check failed',
        tag: _kTag,
        error: e,
        stackTrace: st,
      );
      if (!silent) {
        state = UpdateState.error(e.toString());
      } else {
        state = const UpdateState.idle();
      }
    } finally {
      keepAlive.close();
    }
  }

  /// Start downloading with a selected channel.
  Future<void> startDownloadWithChannel(DownloadChannel channel) async {
    final keepAlive = ref.keepAlive();
    try {
      final currentState = state;
      final info = switch (currentState) {
        UpdateStateAvailable(:final info) => info,
        _ => null,
      };
      if (info == null) return;

      _cancelToken = CancelToken();

      var downloadUrl = info.downloadUrls[channel];
      if (downloadUrl == null) {
        state = const UpdateState.error('该渠道暂无此版本');
        return;
      }

      // For Lanzou channel, resolve direct URL first
      if (channel == DownloadChannel.lanzou) {
        try {
          downloadUrl = await _repo.resolveLanzouUrl(
            downloadUrl,
            password: info.lanzouPassword,
          );
        } catch (e) {
          AppLogger.warning(
            'Lanzou resolve failed, opening browser: $e',
            tag: _kTag,
          );
          LanzouResolver.openInBrowser(info.downloadUrls[channel]!);
          state = UpdateState.error(e.toString());
          return;
        }
      }

      final tempDir = await getTemporaryDirectory();
      final savePath = p.join(tempDir.path, info.assetName);

      state = UpdateState.downloading(
        info: info,
        progress: 0,
        speed: 0,
        channel: channel,
      );

      await _persistDownloadState(
        version: info.latestVersion.semver,
        channel: channel,
        savePath: savePath,
        downloadUrl: downloadUrl,
      );

      await _repo.downloadUpdate(
        url: downloadUrl,
        savePath: savePath,
        cancelToken: _cancelToken,
        onProgress: (progress, speed) {
          state = UpdateState.downloading(
            info: info,
            progress: progress,
            speed: speed,
            channel: channel,
          );
        },
      );

      final checksumOk = await _repo.verifyChecksum(
        savePath,
        info.assetName,
        info.latestVersion.semver,
      );

      if (!checksumOk) {
        state = const UpdateState.error(
          'Download verification failed. Please try again.',
        );
        return;
      }

      await _clearPersistedDownloadState();

      state = UpdateState.readyToInstall(
        info: info,
        localPath: savePath,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        // Only reset to idle if truly cancelled (not paused)
        if (state is! UpdateStatePaused) {
          state = const UpdateState.idle();
        }
        return;
      }
      AppLogger.error('Download failed', tag: _kTag, error: e);
      state = UpdateState.error(e.message ?? 'Download failed');
    } catch (e, st) {
      AppLogger.error('Download failed', tag: _kTag, error: e, stackTrace: st);
      state = UpdateState.error(e.toString());
    } finally {
      keepAlive.close();
    }
  }

  /// Legacy method — starts download with GitHub channel.
  Future<void> startDownload() async {
    await startDownloadWithChannel(DownloadChannel.github);
  }

  /// Pause the current download.
  void pauseDownload() {
    final currentState = state;
    if (currentState is! UpdateStateDownloading) return;

    _cancelToken?.cancel('User paused');
    _cancelToken = null;

    final downloadedBytes =
        (currentState.progress * currentState.totalBytes).toInt();

    final savePath = p.join(
      Directory.systemTemp.path,
      currentState.info.assetName,
    );

    state = UpdateState.paused(
      info: currentState.info,
      progress: currentState.progress,
      channel: currentState.channel,
      downloadedBytes: downloadedBytes,
      totalBytes: currentState.totalBytes,
      localPath: savePath,
    );
  }

  /// Resume a paused download (with range request).
  Future<void> resumeDownload() async {
    final keepAlive = ref.keepAlive();
    try {
      final currentState = state;
      if (currentState is! UpdateStatePaused) return;

      _cancelToken = CancelToken();

      var downloadUrl = currentState.info.downloadUrls[currentState.channel];
      if (downloadUrl == null) return;

      if (currentState.channel == DownloadChannel.lanzou) {
        try {
          downloadUrl = await _repo.resolveLanzouUrl(
            downloadUrl,
            password: currentState.info.lanzouPassword,
          );
        } catch (e) {
          state = UpdateState.error(e.toString());
          return;
        }
      }

      state = UpdateState.downloading(
        info: currentState.info,
        progress: currentState.progress,
        speed: 0,
        channel: currentState.channel,
        downloadedBytes: currentState.downloadedBytes,
        totalBytes: currentState.totalBytes,
      );

      await _repo.downloadUpdate(
        url: downloadUrl,
        savePath: currentState.localPath,
        cancelToken: _cancelToken,
        startByte: currentState.downloadedBytes,
        onProgress: (progress, speed) {
          state = UpdateState.downloading(
            info: currentState.info,
            progress: progress,
            speed: speed,
            channel: currentState.channel,
          );
        },
      );

      final checksumOk = await _repo.verifyChecksum(
        currentState.localPath,
        currentState.info.assetName,
        currentState.info.latestVersion.semver,
      );

      if (!checksumOk) {
        state = const UpdateState.error(
          'Download verification failed. Please try again.',
        );
        return;
      }

      await _clearPersistedDownloadState();

      state = UpdateState.readyToInstall(
        info: currentState.info,
        localPath: currentState.localPath,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      AppLogger.error('Resume download failed', tag: _kTag, error: e);
      state = UpdateState.error(e.message ?? 'Download failed');
    } catch (e, st) {
      AppLogger.error('Resume failed', tag: _kTag, error: e, stackTrace: st);
      state = UpdateState.error(e.toString());
    } finally {
      keepAlive.close();
    }
  }

  /// Download a specific history version with selected channel.
  Future<void> downloadHistoryVersion(
    String version,
    DownloadChannel channel,
  ) async {
    final keepAlive = ref.keepAlive();
    try {
      state = const UpdateState.checking();

      final info = await _repo.getVersionInfo(version);
      _cancelToken = CancelToken();

      var downloadUrl = info.downloadUrls[channel];
      if (downloadUrl == null) {
        state = const UpdateState.error('该渠道暂无此版本');
        return;
      }

      if (channel == DownloadChannel.lanzou) {
        try {
          downloadUrl = await _repo.resolveLanzouUrl(
            downloadUrl,
            password: info.lanzouPassword,
          );
        } catch (e) {
          LanzouResolver.openInBrowser(info.downloadUrls[channel]!);
          state = UpdateState.error(e.toString());
          return;
        }
      }

      final tempDir = await getTemporaryDirectory();
      final savePath = p.join(tempDir.path, info.assetName);

      state = UpdateState.downloading(
        info: info,
        progress: 0,
        speed: 0,
        channel: channel,
      );

      await _repo.downloadUpdate(
        url: downloadUrl,
        savePath: savePath,
        cancelToken: _cancelToken,
        onProgress: (progress, speed) {
          state = UpdateState.downloading(
            info: info,
            progress: progress,
            speed: speed,
            channel: channel,
          );
        },
      );

      final checksumOk = await _repo.verifyChecksum(
        savePath,
        info.assetName,
        info.latestVersion.semver,
      );

      if (!checksumOk) {
        state = const UpdateState.error(
          'Download verification failed. Please try again.',
        );
        return;
      }

      state = UpdateState.readyToInstall(
        info: info,
        localPath: savePath,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        state = const UpdateState.idle();
        return;
      }
      AppLogger.error('Download failed', tag: _kTag, error: e);
      state = UpdateState.error(e.message ?? 'Download failed');
    } catch (e, st) {
      AppLogger.error('Download failed', tag: _kTag, error: e, stackTrace: st);
      state = UpdateState.error(e.toString());
    } finally {
      keepAlive.close();
    }
  }

  /// Fetch all history versions from manifest.
  Future<List<VersionEntry>> fetchHistoryVersions() async {
    final manifest = await _repo.fetchManifest();
    return manifest.versions;
  }

  /// Apply the downloaded update.
  Future<void> applyUpdate() async {
    final keepAlive = ref.keepAlive();
    try {
      final currentState = state;
      if (currentState is! UpdateStateReadyToInstall) return;

      await _repo.applyUpdate(currentState.localPath);
    } catch (e, st) {
      AppLogger.error('Apply update failed', tag: _kTag, error: e,
          stackTrace: st);
      state = UpdateState.error(e.toString());
    } finally {
      keepAlive.close();
    }
  }

  /// Mark the current remote version as skipped.
  Future<void> skipVersion(AppVersion version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSkippedVersionKey, version.semver);
    state = const UpdateState.idle();
  }

  /// Cancel an in-progress download.
  void cancelDownload() {
    _cancelToken?.cancel('User cancelled');
    _cancelToken = null;
    _clearPersistedDownloadState();
    state = const UpdateState.idle();
  }

  // ── Download state persistence ──────────────────────────────────

  Future<void> _persistDownloadState({
    required String version,
    required DownloadChannel channel,
    required String savePath,
    required String downloadUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDownloadVersionKey, version);
    await prefs.setString(_kDownloadChannelKey, channel.name);
    await prefs.setString(_kDownloadPathKey, savePath);
    await prefs.setString(_kDownloadUrlKey, downloadUrl);
  }

  Future<void> _clearPersistedDownloadState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kDownloadVersionKey);
    await prefs.remove(_kDownloadChannelKey);
    await prefs.remove(_kDownloadPathKey);
    await prefs.remove(_kDownloadUrlKey);
  }
}
