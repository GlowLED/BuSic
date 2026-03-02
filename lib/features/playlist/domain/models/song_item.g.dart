// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongItemImpl _$$SongItemImplFromJson(Map<String, dynamic> json) =>
    _$SongItemImpl(
      id: (json['id'] as num).toInt(),
      bvid: json['bvid'] as String,
      cid: (json['cid'] as num).toInt(),
      originTitle: json['originTitle'] as String,
      originArtist: json['originArtist'] as String,
      customTitle: json['customTitle'] as String?,
      customArtist: json['customArtist'] as String?,
      coverUrl: json['coverUrl'] as String?,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      localPath: json['localPath'] as String?,
    );

Map<String, dynamic> _$$SongItemImplToJson(_$SongItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bvid': instance.bvid,
      'cid': instance.cid,
      'originTitle': instance.originTitle,
      'originArtist': instance.originArtist,
      'customTitle': instance.customTitle,
      'customArtist': instance.customArtist,
      'coverUrl': instance.coverUrl,
      'duration': instance.duration,
      'localPath': instance.localPath,
    };
