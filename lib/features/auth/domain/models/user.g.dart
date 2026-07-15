// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  userId: json['userId'] as String,
  nickname: json['nickname'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  sessdata: json['sessdata'] as String,
  biliJct: json['biliJct'] as String,
  isLoggedIn: json['isLoggedIn'] as bool? ?? false,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'userId': instance.userId,
  'nickname': instance.nickname,
  'avatarUrl': instance.avatarUrl,
  'sessdata': instance.sessdata,
  'biliJct': instance.biliJct,
  'isLoggedIn': instance.isLoggedIn,
};
