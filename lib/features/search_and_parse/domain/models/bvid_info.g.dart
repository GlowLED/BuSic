// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bvid_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BvidInfoImpl _$$BvidInfoImplFromJson(Map<String, dynamic> json) =>
    _$BvidInfoImpl(
      bvid: json['bvid'] as String,
      title: json['title'] as String,
      owner: json['owner'] as String,
      ownerUid: (json['ownerUid'] as num?)?.toInt(),
      coverUrl: json['coverUrl'] as String?,
      pages: (json['pages'] as List<dynamic>?)
              ?.map((e) => PageInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      duration: (json['duration'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BvidInfoImplToJson(_$BvidInfoImpl instance) =>
    <String, dynamic>{
      'bvid': instance.bvid,
      'title': instance.title,
      'owner': instance.owner,
      'ownerUid': instance.ownerUid,
      'coverUrl': instance.coverUrl,
      'pages': instance.pages,
      'duration': instance.duration,
    };
