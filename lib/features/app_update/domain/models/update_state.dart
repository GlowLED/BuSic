import 'package:freezed_annotation/freezed_annotation.dart';

import 'update_info.dart';

part 'update_state.freezed.dart';

/// State machine for the app update flow.
@freezed
class UpdateState with _$UpdateState {
  /// Idle — not checked yet or already up-to-date.
  const factory UpdateState.idle() = UpdateStateIdle;

  /// Checking remote version.
  const factory UpdateState.checking() = UpdateStateChecking;

  /// A new version is available.
  const factory UpdateState.available(UpdateInfo info) = UpdateStateAvailable;

  /// Downloading the update package.
  const factory UpdateState.downloading({
    required UpdateInfo info,
    required double progress,

    /// Download speed in bytes/second.
    required double speed,
  }) = UpdateStateDownloading;

  /// Download finished, ready to install.
  const factory UpdateState.readyToInstall({
    required UpdateInfo info,
    required String localPath,
  }) = UpdateStateReadyToInstall;

  /// An error occurred.
  const factory UpdateState.error(String message) = UpdateStateError;
}
