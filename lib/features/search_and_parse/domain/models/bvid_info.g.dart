// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bvid_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BvidInfoImpl _$$BvidInfoImplFromJson(Map<String, dynamic> json) =>
    _$BvidInfoImpl(
      bvid: json['bvid'] as String,
      aid: (json['aid'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      pubdate: (json['pubdate'] as num?)?.toInt(),
      tname: json['tname'] as String?,
      owner: json['owner'] as String,
      ownerUid: (json['ownerUid'] as num?)?.toInt(),
      ownerFace: json['ownerFace'] as String?,
      coverUrl: json['coverUrl'] as String?,
      pages: (json['pages'] as List<dynamic>?)
              ?.map((e) => PageInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      stats: json['stats'] == null
          ? const VideoStats()
          : VideoStats.fromJson(json['stats'] as Map<String, dynamic>),
      rights: json['rights'] == null
          ? const VideoRights()
          : VideoRights.fromJson(json['rights'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => VideoTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BvidInfoImplToJson(_$BvidInfoImpl instance) =>
    <String, dynamic>{
      'bvid': instance.bvid,
      'aid': instance.aid,
      'title': instance.title,
      'description': instance.description,
      'pubdate': instance.pubdate,
      'tname': instance.tname,
      'owner': instance.owner,
      'ownerUid': instance.ownerUid,
      'ownerFace': instance.ownerFace,
      'coverUrl': instance.coverUrl,
      'pages': instance.pages.map((e) => e.toJson()).toList(),
      'duration': instance.duration,
      'stats': instance.stats.toJson(),
      'rights': instance.rights.toJson(),
      'tags': instance.tags.map((e) => e.toJson()).toList(),
    };
