import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_manifest.freezed.dart';
part 'version_manifest.g.dart';

/// 版本清单 — 所有历史版本及多渠道下载链接
@freezed
class VersionManifest with _$VersionManifest {
  const factory VersionManifest({
    required String latest,
    @JsonKey(name: 'min_supported') required String minSupported,
    required List<VersionEntry> versions,
  }) = _VersionManifest;

  factory VersionManifest.fromJson(Map<String, dynamic> json) =>
      _$VersionManifestFromJson(json);
}

/// 单个版本条目
@freezed
class VersionEntry with _$VersionEntry {
  const factory VersionEntry({
    required String version,
    required int build,
    required String date,
    required String changelog,
    @JsonKey(name: 'force_update_below') String? forceUpdateBelow,
    required Map<String, PlatformAssets> assets,
    @Default({}) Map<String, String> checksums,
  }) = _VersionEntry;

  factory VersionEntry.fromJson(Map<String, dynamic> json) =>
      _$VersionEntryFromJson(json);
}

/// 某个平台的下载资产（包含各渠道链接）
@freezed
class PlatformAssets with _$PlatformAssets {
  const factory PlatformAssets({
    String? github,
    LanzouAsset? lanzou,
  }) = _PlatformAssets;

  factory PlatformAssets.fromJson(Map<String, dynamic> json) =>
      _$PlatformAssetsFromJson(json);
}

/// 蓝奏云下载资产
@freezed
class LanzouAsset with _$LanzouAsset {
  const factory LanzouAsset({
    required String url,
    String? password,
  }) = _LanzouAsset;

  factory LanzouAsset.fromJson(Map<String, dynamic> json) =>
      _$LanzouAssetFromJson(json);
}
