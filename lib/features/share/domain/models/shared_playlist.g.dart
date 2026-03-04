// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SharedPlaylistImpl _$$SharedPlaylistImplFromJson(Map<String, dynamic> json) =>
    _$SharedPlaylistImpl(
      version: (json['v'] as num?)?.toInt() ?? 1,
      name: json['n'] as String,
      songs: (json['s'] as List<dynamic>)
          .map((e) => SharedSong.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SharedPlaylistImplToJson(
        _$SharedPlaylistImpl instance) =>
    <String, dynamic>{
      'v': instance.version,
      'n': instance.name,
      's': instance.songs,
    };

_$SharedSongImpl _$$SharedSongImplFromJson(Map<String, dynamic> json) =>
    _$SharedSongImpl(
      bvid: json['b'] as String,
      cid: (json['c'] as num).toInt(),
      customTitle: json['ct'] as String?,
      customArtist: json['ca'] as String?,
    );

Map<String, dynamic> _$$SharedSongImplToJson(_$SharedSongImpl instance) =>
    <String, dynamic>{
      'b': instance.bvid,
      'c': instance.cid,
      if (instance.customTitle case final value?) 'ct': value,
      if (instance.customArtist case final value?) 'ca': value,
    };
