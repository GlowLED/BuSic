// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AudioTrackImpl _$$AudioTrackImplFromJson(Map<String, dynamic> json) =>
    _$AudioTrackImpl(
      songId: (json['songId'] as num).toInt(),
      bvid: json['bvid'] as String,
      cid: (json['cid'] as num).toInt(),
      title: json['title'] as String,
      artist: json['artist'] as String,
      coverUrl: json['coverUrl'] as String?,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      streamUrl: json['streamUrl'] as String?,
      localPath: json['localPath'] as String?,
      quality: (json['quality'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$AudioTrackImplToJson(_$AudioTrackImpl instance) =>
    <String, dynamic>{
      'songId': instance.songId,
      'bvid': instance.bvid,
      'cid': instance.cid,
      'title': instance.title,
      'artist': instance.artist,
      'coverUrl': instance.coverUrl,
      'duration': instance.duration.inMicroseconds,
      'streamUrl': instance.streamUrl,
      'localPath': instance.localPath,
      'quality': instance.quality,
    };
