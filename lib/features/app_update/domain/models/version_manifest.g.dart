// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VersionManifestImpl _$$VersionManifestImplFromJson(
        Map<String, dynamic> json) =>
    _$VersionManifestImpl(
      latest: json['latest'] as String,
      minSupported: json['min_supported'] as String,
      versions: (json['versions'] as List<dynamic>)
          .map((e) => VersionEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$VersionManifestImplToJson(
        _$VersionManifestImpl instance) =>
    <String, dynamic>{
      'latest': instance.latest,
      'min_supported': instance.minSupported,
      'versions': instance.versions,
    };

_$VersionEntryImpl _$$VersionEntryImplFromJson(Map<String, dynamic> json) =>
    _$VersionEntryImpl(
      version: json['version'] as String,
      build: (json['build'] as num).toInt(),
      date: json['date'] as String,
      changelog: json['changelog'] as String,
      forceUpdateBelow: json['force_update_below'] as String?,
      assets: (json['assets'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, PlatformAssets.fromJson(e as Map<String, dynamic>)),
      ),
      checksums: (json['checksums'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$VersionEntryImplToJson(_$VersionEntryImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'build': instance.build,
      'date': instance.date,
      'changelog': instance.changelog,
      'force_update_below': instance.forceUpdateBelow,
      'assets': instance.assets,
      'checksums': instance.checksums,
    };

_$PlatformAssetsImpl _$$PlatformAssetsImplFromJson(Map<String, dynamic> json) =>
    _$PlatformAssetsImpl(
      github: json['github'] as String?,
      lanzou: json['lanzou'] == null
          ? null
          : LanzouAsset.fromJson(json['lanzou'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PlatformAssetsImplToJson(
        _$PlatformAssetsImpl instance) =>
    <String, dynamic>{
      'github': instance.github,
      'lanzou': instance.lanzou,
    };

_$LanzouAssetImpl _$$LanzouAssetImplFromJson(Map<String, dynamic> json) =>
    _$LanzouAssetImpl(
      url: json['url'] as String,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$$LanzouAssetImplToJson(_$LanzouAssetImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'password': instance.password,
    };
