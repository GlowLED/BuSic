import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_version.dart';

part 'update_info.freezed.dart';

/// Information about an available update.
@freezed
class UpdateInfo with _$UpdateInfo {
  const factory UpdateInfo({
    /// The latest version available on GitHub.
    required AppVersion latestVersion,

    /// The currently installed version.
    required AppVersion currentVersion,

    /// Changelog / release notes text.
    required String changelog,

    /// Whether this update is mandatory (current version below min_supported).
    required bool isForceUpdate,

    /// Download URL for the platform-specific asset.
    required String downloadUrl,

    /// File name of the asset (e.g. `busic-android.apk`).
    required String assetName,

    /// Optional link to external release notes.
    String? releaseNotesUrl,
  }) = _UpdateInfo;
}
