// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoStatsImpl _$$VideoStatsImplFromJson(Map<String, dynamic> json) =>
    _$VideoStatsImpl(
      view: (json['view'] as num?)?.toInt() ?? 0,
      danmaku: (json['danmaku'] as num?)?.toInt() ?? 0,
      reply: (json['reply'] as num?)?.toInt() ?? 0,
      favorite: (json['favorite'] as num?)?.toInt() ?? 0,
      coin: (json['coin'] as num?)?.toInt() ?? 0,
      share: (json['share'] as num?)?.toInt() ?? 0,
      like: (json['like'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$VideoStatsImplToJson(_$VideoStatsImpl instance) =>
    <String, dynamic>{
      'view': instance.view,
      'danmaku': instance.danmaku,
      'reply': instance.reply,
      'favorite': instance.favorite,
      'coin': instance.coin,
      'share': instance.share,
      'like': instance.like,
    };
