// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SongItem {

/// Database primary key.
 int get id;/// Bilibili BV number.
 String get bvid;/// Bilibili CID.
 int get cid;/// Original title from Bilibili.
 String get originTitle;/// Original artist (UP主) from Bilibili.
 String get originArtist;/// User-customized title override.
 String? get customTitle;/// User-customized artist override.
 String? get customArtist;/// Cover image URL.
 String? get coverUrl;/// Duration in seconds.
 int get duration;/// Audio quality code of the cached file (0 = not cached).
 int get audioQuality;/// Local file path if cached.
 String? get localPath;
/// Create a copy of SongItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SongItemCopyWith<SongItem> get copyWith => _$SongItemCopyWithImpl<SongItem>(this as SongItem, _$identity);

  /// Serializes this SongItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SongItem&&(identical(other.id, id) || other.id == id)&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.originTitle, originTitle) || other.originTitle == originTitle)&&(identical(other.originArtist, originArtist) || other.originArtist == originArtist)&&(identical(other.customTitle, customTitle) || other.customTitle == customTitle)&&(identical(other.customArtist, customArtist) || other.customArtist == customArtist)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.audioQuality, audioQuality) || other.audioQuality == audioQuality)&&(identical(other.localPath, localPath) || other.localPath == localPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bvid,cid,originTitle,originArtist,customTitle,customArtist,coverUrl,duration,audioQuality,localPath);

@override
String toString() {
  return 'SongItem(id: $id, bvid: $bvid, cid: $cid, originTitle: $originTitle, originArtist: $originArtist, customTitle: $customTitle, customArtist: $customArtist, coverUrl: $coverUrl, duration: $duration, audioQuality: $audioQuality, localPath: $localPath)';
}


}

/// @nodoc
abstract mixin class $SongItemCopyWith<$Res>  {
  factory $SongItemCopyWith(SongItem value, $Res Function(SongItem) _then) = _$SongItemCopyWithImpl;
@useResult
$Res call({
 int id, String bvid, int cid, String originTitle, String originArtist, String? customTitle, String? customArtist, String? coverUrl, int duration, int audioQuality, String? localPath
});




}
/// @nodoc
class _$SongItemCopyWithImpl<$Res>
    implements $SongItemCopyWith<$Res> {
  _$SongItemCopyWithImpl(this._self, this._then);

  final SongItem _self;
  final $Res Function(SongItem) _then;

/// Create a copy of SongItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bvid = null,Object? cid = null,Object? originTitle = null,Object? originArtist = null,Object? customTitle = freezed,Object? customArtist = freezed,Object? coverUrl = freezed,Object? duration = null,Object? audioQuality = null,Object? localPath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as int,originTitle: null == originTitle ? _self.originTitle : originTitle // ignore: cast_nullable_to_non_nullable
as String,originArtist: null == originArtist ? _self.originArtist : originArtist // ignore: cast_nullable_to_non_nullable
as String,customTitle: freezed == customTitle ? _self.customTitle : customTitle // ignore: cast_nullable_to_non_nullable
as String?,customArtist: freezed == customArtist ? _self.customArtist : customArtist // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,audioQuality: null == audioQuality ? _self.audioQuality : audioQuality // ignore: cast_nullable_to_non_nullable
as int,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SongItem].
extension SongItemPatterns on SongItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SongItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SongItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SongItem value)  $default,){
final _that = this;
switch (_that) {
case _SongItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SongItem value)?  $default,){
final _that = this;
switch (_that) {
case _SongItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String bvid,  int cid,  String originTitle,  String originArtist,  String? customTitle,  String? customArtist,  String? coverUrl,  int duration,  int audioQuality,  String? localPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SongItem() when $default != null:
return $default(_that.id,_that.bvid,_that.cid,_that.originTitle,_that.originArtist,_that.customTitle,_that.customArtist,_that.coverUrl,_that.duration,_that.audioQuality,_that.localPath);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String bvid,  int cid,  String originTitle,  String originArtist,  String? customTitle,  String? customArtist,  String? coverUrl,  int duration,  int audioQuality,  String? localPath)  $default,) {final _that = this;
switch (_that) {
case _SongItem():
return $default(_that.id,_that.bvid,_that.cid,_that.originTitle,_that.originArtist,_that.customTitle,_that.customArtist,_that.coverUrl,_that.duration,_that.audioQuality,_that.localPath);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String bvid,  int cid,  String originTitle,  String originArtist,  String? customTitle,  String? customArtist,  String? coverUrl,  int duration,  int audioQuality,  String? localPath)?  $default,) {final _that = this;
switch (_that) {
case _SongItem() when $default != null:
return $default(_that.id,_that.bvid,_that.cid,_that.originTitle,_that.originArtist,_that.customTitle,_that.customArtist,_that.coverUrl,_that.duration,_that.audioQuality,_that.localPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SongItem extends SongItem {
  const _SongItem({required this.id, required this.bvid, required this.cid, required this.originTitle, required this.originArtist, this.customTitle, this.customArtist, this.coverUrl, this.duration = 0, this.audioQuality = 0, this.localPath}): super._();
  factory _SongItem.fromJson(Map<String, dynamic> json) => _$SongItemFromJson(json);

/// Database primary key.
@override final  int id;
/// Bilibili BV number.
@override final  String bvid;
/// Bilibili CID.
@override final  int cid;
/// Original title from Bilibili.
@override final  String originTitle;
/// Original artist (UP主) from Bilibili.
@override final  String originArtist;
/// User-customized title override.
@override final  String? customTitle;
/// User-customized artist override.
@override final  String? customArtist;
/// Cover image URL.
@override final  String? coverUrl;
/// Duration in seconds.
@override@JsonKey() final  int duration;
/// Audio quality code of the cached file (0 = not cached).
@override@JsonKey() final  int audioQuality;
/// Local file path if cached.
@override final  String? localPath;

/// Create a copy of SongItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SongItemCopyWith<_SongItem> get copyWith => __$SongItemCopyWithImpl<_SongItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SongItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SongItem&&(identical(other.id, id) || other.id == id)&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.originTitle, originTitle) || other.originTitle == originTitle)&&(identical(other.originArtist, originArtist) || other.originArtist == originArtist)&&(identical(other.customTitle, customTitle) || other.customTitle == customTitle)&&(identical(other.customArtist, customArtist) || other.customArtist == customArtist)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.audioQuality, audioQuality) || other.audioQuality == audioQuality)&&(identical(other.localPath, localPath) || other.localPath == localPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bvid,cid,originTitle,originArtist,customTitle,customArtist,coverUrl,duration,audioQuality,localPath);

@override
String toString() {
  return 'SongItem(id: $id, bvid: $bvid, cid: $cid, originTitle: $originTitle, originArtist: $originArtist, customTitle: $customTitle, customArtist: $customArtist, coverUrl: $coverUrl, duration: $duration, audioQuality: $audioQuality, localPath: $localPath)';
}


}

/// @nodoc
abstract mixin class _$SongItemCopyWith<$Res> implements $SongItemCopyWith<$Res> {
  factory _$SongItemCopyWith(_SongItem value, $Res Function(_SongItem) _then) = __$SongItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String bvid, int cid, String originTitle, String originArtist, String? customTitle, String? customArtist, String? coverUrl, int duration, int audioQuality, String? localPath
});




}
/// @nodoc
class __$SongItemCopyWithImpl<$Res>
    implements _$SongItemCopyWith<$Res> {
  __$SongItemCopyWithImpl(this._self, this._then);

  final _SongItem _self;
  final $Res Function(_SongItem) _then;

/// Create a copy of SongItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bvid = null,Object? cid = null,Object? originTitle = null,Object? originArtist = null,Object? customTitle = freezed,Object? customArtist = freezed,Object? coverUrl = freezed,Object? duration = null,Object? audioQuality = null,Object? localPath = freezed,}) {
  return _then(_SongItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as int,originTitle: null == originTitle ? _self.originTitle : originTitle // ignore: cast_nullable_to_non_nullable
as String,originArtist: null == originArtist ? _self.originArtist : originArtist // ignore: cast_nullable_to_non_nullable
as String,customTitle: freezed == customTitle ? _self.customTitle : customTitle // ignore: cast_nullable_to_non_nullable
as String?,customArtist: freezed == customArtist ? _self.customArtist : customArtist // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,audioQuality: null == audioQuality ? _self.audioQuality : audioQuality // ignore: cast_nullable_to_non_nullable
as int,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
