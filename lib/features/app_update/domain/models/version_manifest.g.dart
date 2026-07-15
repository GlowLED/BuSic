// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VersionManifest _$VersionManifestFromJson(Map<String, dynamic> json) =>
    _VersionManifest(
      latest: json['latest'] as String,
      minSupported: json['min_supported'] as String,
      versions: (json['versions'] as List<dynamic>)
          .map((e) => VersionEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VersionManifestToJson(_VersionManifest instance) =>
    <String, dynamic>{
      'latest': instance.latest,
      'min_supported': instance.minSupported,
      'versions': instance.versions,
    };

_VersionEntry _$VersionEntryFromJson(Map<String, dynamic> json) =>
    _VersionEntry(
      version: json['version'] as String,
      build: (json['build'] as num).toInt(),
      date: json['date'] as String,
      changelog: json['changelog'] as String,
      forceUpdateBelow: json['force_update_below'] as String?,
      assets: (json['assets'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, PlatformAssets.fromJson(e as Map<String, dynamic>)),
      ),
      checksums:
          (json['checksums'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$VersionEntryToJson(_VersionEntry instance) =>
    <String, dynamic>{
      'version': instance.version,
      'build': instance.build,
      'date': instance.date,
      'changelog': instance.changelog,
      'force_update_below': instance.forceUpdateBelow,
      'assets': instance.assets,
      'checksums': instance.checksums,
    };

_PlatformAssets _$PlatformAssetsFromJson(Map<String, dynamic> json) =>
    _PlatformAssets(
      github: json['github'] as String?,
      lanzou: json['lanzou'] == null
          ? null
          : LanzouAsset.fromJson(json['lanzou'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlatformAssetsToJson(_PlatformAssets instance) =>
    <String, dynamic>{'github': instance.github, 'lanzou': instance.lanzou};

_LanzouAsset _$LanzouAssetFromJson(Map<String, dynamic> json) => _LanzouAsset(
  url: json['url'] as String,
  password: json['password'] as String?,
);

Map<String, dynamic> _$LanzouAssetToJson(_LanzouAsset instance) =>
    <String, dynamic>{'url': instance.url, 'password': instance.password};
