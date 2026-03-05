import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/logger.dart';
import '../data/update_repository_impl.dart';
import '../domain/models/app_version.dart';
import '../domain/models/update_state.dart';

part 'update_notifier.g.dart';

const _kTag = 'UpdateNotifier';
const _kSkippedVersionKey = 'update_skipped_version';
const _kLastCheckKey = 'update_last_check';
const _kCheckCooldownMs = 24 * 60 * 60 * 1000; // 24 hours

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
        // Respect 24h cooldown for silent checks
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

      // Record check time
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        _kLastCheckKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      // Compare versions
      if (info.currentVersion >= info.latestVersion) {
        state = const UpdateState.idle();
        return;
      }

      // Check if user skipped this version (only for non-force updates)
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

  /// Start downloading the update package.
  Future<void> startDownload() async {
    final keepAlive = ref.keepAlive();
    try {
      final currentState = state;
      if (currentState is! UpdateStateAvailable) return;

      final info = currentState.info;
      _cancelToken = CancelToken();

      // Determine save path
      final tempDir = await getTemporaryDirectory();
      final savePath = p.join(tempDir.path, info.assetName);

      state = UpdateState.downloading(
        info: info,
        progress: 0,
        speed: 0,
      );

      await _repo.downloadUpdate(
        url: info.downloadUrl,
        savePath: savePath,
        cancelToken: _cancelToken,
        onProgress: (progress, speed) {
          state = UpdateState.downloading(
            info: info,
            progress: progress,
            speed: speed,
          );
        },
      );

      // Verify checksum
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
  }
}
