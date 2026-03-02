// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_poll_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QrPollResultImpl _$$QrPollResultImplFromJson(Map<String, dynamic> json) =>
    _$QrPollResultImpl(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$QrPollResultImplToJson(_$QrPollResultImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'url': instance.url,
    };
