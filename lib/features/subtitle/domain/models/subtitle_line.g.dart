// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtitle_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubtitleLineImpl _$$SubtitleLineImplFromJson(Map<String, dynamic> json) =>
    _$SubtitleLineImpl(
      startTime: (json['startTime'] as num).toDouble(),
      endTime: (json['endTime'] as num).toDouble(),
      content: json['content'] as String,
      musicRatio: (json['musicRatio'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$SubtitleLineImplToJson(_$SubtitleLineImpl instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'content': instance.content,
      'musicRatio': instance.musicRatio,
    };
