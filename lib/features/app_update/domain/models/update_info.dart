import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_version.dart';
import 'download_channel.dart';

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

    /// File name of the asset (e.g. `busic-android.apk`).
    required String assetName,

    /// Optional link to external release notes.
    String? releaseNotesUrl,

    /// 各渠道下载 URL
    required Map<DownloadChannel, String> downloadUrls,

    /// 蓝奏云密码（如有）
    String? lanzouPassword,
  }) = _UpdateInfo;
}
