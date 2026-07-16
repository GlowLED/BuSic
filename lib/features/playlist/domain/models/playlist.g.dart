// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Playlist _$PlaylistFromJson(Map<String, dynamic> json) => _Playlist(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  coverUrl: json['coverUrl'] as String?,
  songCount: (json['songCount'] as num?)?.toInt() ?? 0,
  isFavorite: json['isFavorite'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PlaylistToJson(_Playlist instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'coverUrl': instance.coverUrl,
  'songCount': instance.songCount,
  'isFavorite': instance.isFavorite,
  'createdAt': instance.createdAt.toIso8601String(),
};
