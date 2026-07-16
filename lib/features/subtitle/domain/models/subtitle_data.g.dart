// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtitle_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubtitleData _$SubtitleDataFromJson(Map<String, dynamic> json) =>
    _SubtitleData(
      lines: (json['lines'] as List<dynamic>)
          .map((e) => SubtitleLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      sourceType: json['sourceType'] as String,
      language: json['language'] as String? ?? '',
    );

Map<String, dynamic> _$SubtitleDataToJson(_SubtitleData instance) =>
    <String, dynamic>{
      'lines': instance.lines,
      'sourceType': instance.sourceType,
      'language': instance.language,
    };
