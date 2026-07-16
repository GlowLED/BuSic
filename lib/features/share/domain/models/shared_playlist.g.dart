// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SharedPlaylist _$SharedPlaylistFromJson(Map<String, dynamic> json) =>
    _SharedPlaylist(
      version: (json['v'] as num?)?.toInt() ?? 1,
      name: json['n'] as String,
      songs: (json['s'] as List<dynamic>)
          .map((e) => SharedSong.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SharedPlaylistToJson(_SharedPlaylist instance) =>
    <String, dynamic>{
      'v': instance.version,
      'n': instance.name,
      's': instance.songs,
    };

_SharedSong _$SharedSongFromJson(Map<String, dynamic> json) => _SharedSong(
  bvid: json['b'] as String,
  cid: (json['c'] as num).toInt(),
  customTitle: json['ct'] as String?,
  customArtist: json['ca'] as String?,
);

Map<String, dynamic> _$SharedSongToJson(_SharedSong instance) =>
    <String, dynamic>{
      'b': instance.bvid,
      'c': instance.cid,
      'ct': ?instance.customTitle,
      'ca': ?instance.customArtist,
    };
