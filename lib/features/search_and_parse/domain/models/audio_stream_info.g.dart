// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_stream_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AudioStreamInfo _$AudioStreamInfoFromJson(Map<String, dynamic> json) =>
    _AudioStreamInfo(
      url: json['url'] as String,
      quality: (json['quality'] as num).toInt(),
      mimeType: json['mimeType'] as String?,
      bandwidth: (json['bandwidth'] as num?)?.toInt(),
      expireTime: json['expireTime'] == null
          ? null
          : DateTime.parse(json['expireTime'] as String),
      backupUrls:
          (json['backupUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AudioStreamInfoToJson(_AudioStreamInfo instance) =>
    <String, dynamic>{
      'url': instance.url,
      'quality': instance.quality,
      'mimeType': instance.mimeType,
      'bandwidth': instance.bandwidth,
      'expireTime': instance.expireTime?.toIso8601String(),
      'backupUrls': instance.backupUrls,
    };
