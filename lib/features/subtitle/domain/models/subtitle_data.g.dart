// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtitle_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubtitleDataImpl _$$SubtitleDataImplFromJson(Map<String, dynamic> json) =>
    _$SubtitleDataImpl(
      lines: (json['lines'] as List<dynamic>)
          .map((e) => SubtitleLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      sourceType: json['sourceType'] as String,
      language: json['language'] as String? ?? '',
    );

Map<String, dynamic> _$$SubtitleDataImplToJson(_$SubtitleDataImpl instance) =>
    <String, dynamic>{
      'lines': instance.lines,
      'sourceType': instance.sourceType,
      'language': instance.language,
    };
