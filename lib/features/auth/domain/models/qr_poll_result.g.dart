// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_poll_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QrPollResult _$QrPollResultFromJson(Map<String, dynamic> json) =>
    _QrPollResult(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$QrPollResultToJson(_QrPollResult instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'url': instance.url,
    };
