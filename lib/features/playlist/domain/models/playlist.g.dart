// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaylistImpl _$$PlaylistImplFromJson(Map<String, dynamic> json) =>
    _$PlaylistImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      coverUrl: json['coverUrl'] as String?,
      songCount: (json['songCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PlaylistImplToJson(_$PlaylistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coverUrl': instance.coverUrl,
      'songCount': instance.songCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
