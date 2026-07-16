// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageInfo _$PageInfoFromJson(Map<String, dynamic> json) => _PageInfo(
  cid: (json['cid'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  partTitle: json['partTitle'] as String,
  duration: (json['duration'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PageInfoToJson(_PageInfo instance) => <String, dynamic>{
  'cid': instance.cid,
  'page': instance.page,
  'partTitle': instance.partTitle,
  'duration': instance.duration,
};
