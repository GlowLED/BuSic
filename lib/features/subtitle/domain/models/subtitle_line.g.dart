// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtitle_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubtitleLine _$SubtitleLineFromJson(Map<String, dynamic> json) =>
    _SubtitleLine(
      startTime: (json['startTime'] as num).toDouble(),
      endTime: (json['endTime'] as num).toDouble(),
      content: json['content'] as String,
      musicRatio: (json['musicRatio'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$SubtitleLineToJson(_SubtitleLine instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'content': instance.content,
      'musicRatio': instance.musicRatio,
    };
