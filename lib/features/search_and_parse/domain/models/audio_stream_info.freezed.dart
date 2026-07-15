// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_stream_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioStreamInfo {

/// Direct audio stream URL (m4s format).
 String get url;/// Audio quality identifier:
/// - 30216: 64kbps
/// - 30232: 132kbps
/// - 30280: 192kbps (login required)
/// - 30250: Dolby Atmos (login + SVIP)
/// - 30251: Hi-Res (login + SVIP)
 int get quality;/// MIME type (typically "audio/mp4").
 String? get mimeType;/// Stream bandwidth in bits per second.
 int? get bandwidth;/// URL expiration timestamp.
 DateTime? get expireTime;/// Backup URLs in case the primary fails.
 List<String> get backupUrls;
/// Create a copy of AudioStreamInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioStreamInfoCopyWith<AudioStreamInfo> get copyWith => _$AudioStreamInfoCopyWithImpl<AudioStreamInfo>(this as AudioStreamInfo, _$identity);

  /// Serializes this AudioStreamInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioStreamInfo&&(identical(other.url, url) || other.url == url)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.bandwidth, bandwidth) || other.bandwidth == bandwidth)&&(identical(other.expireTime, expireTime) || other.expireTime == expireTime)&&const DeepCollectionEquality().equals(other.backupUrls, backupUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,quality,mimeType,bandwidth,expireTime,const DeepCollectionEquality().hash(backupUrls));

@override
String toString() {
  return 'AudioStreamInfo(url: $url, quality: $quality, mimeType: $mimeType, bandwidth: $bandwidth, expireTime: $expireTime, backupUrls: $backupUrls)';
}


}

/// @nodoc
abstract mixin class $AudioStreamInfoCopyWith<$Res>  {
  factory $AudioStreamInfoCopyWith(AudioStreamInfo value, $Res Function(AudioStreamInfo) _then) = _$AudioStreamInfoCopyWithImpl;
@useResult
$Res call({
 String url, int quality, String? mimeType, int? bandwidth, DateTime? expireTime, List<String> backupUrls
});




}
/// @nodoc
class _$AudioStreamInfoCopyWithImpl<$Res>
    implements $AudioStreamInfoCopyWith<$Res> {
  _$AudioStreamInfoCopyWithImpl(this._self, this._then);

  final AudioStreamInfo _self;
  final $Res Function(AudioStreamInfo) _then;

/// Create a copy of AudioStreamInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? quality = null,Object? mimeType = freezed,Object? bandwidth = freezed,Object? expireTime = freezed,Object? backupUrls = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as int,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,bandwidth: freezed == bandwidth ? _self.bandwidth : bandwidth // ignore: cast_nullable_to_non_nullable
as int?,expireTime: freezed == expireTime ? _self.expireTime : expireTime // ignore: cast_nullable_to_non_nullable
as DateTime?,backupUrls: null == backupUrls ? _self.backupUrls : backupUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioStreamInfo].
extension AudioStreamInfoPatterns on AudioStreamInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioStreamInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioStreamInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioStreamInfo value)  $default,){
final _that = this;
switch (_that) {
case _AudioStreamInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioStreamInfo value)?  $default,){
final _that = this;
switch (_that) {
case _AudioStreamInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  int quality,  String? mimeType,  int? bandwidth,  DateTime? expireTime,  List<String> backupUrls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioStreamInfo() when $default != null:
return $default(_that.url,_that.quality,_that.mimeType,_that.bandwidth,_that.expireTime,_that.backupUrls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  int quality,  String? mimeType,  int? bandwidth,  DateTime? expireTime,  List<String> backupUrls)  $default,) {final _that = this;
switch (_that) {
case _AudioStreamInfo():
return $default(_that.url,_that.quality,_that.mimeType,_that.bandwidth,_that.expireTime,_that.backupUrls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  int quality,  String? mimeType,  int? bandwidth,  DateTime? expireTime,  List<String> backupUrls)?  $default,) {final _that = this;
switch (_that) {
case _AudioStreamInfo() when $default != null:
return $default(_that.url,_that.quality,_that.mimeType,_that.bandwidth,_that.expireTime,_that.backupUrls);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AudioStreamInfo implements AudioStreamInfo {
  const _AudioStreamInfo({required this.url, required this.quality, this.mimeType, this.bandwidth, this.expireTime, final  List<String> backupUrls = const []}): _backupUrls = backupUrls;
  factory _AudioStreamInfo.fromJson(Map<String, dynamic> json) => _$AudioStreamInfoFromJson(json);

/// Direct audio stream URL (m4s format).
@override final  String url;
/// Audio quality identifier:
/// - 30216: 64kbps
/// - 30232: 132kbps
/// - 30280: 192kbps (login required)
/// - 30250: Dolby Atmos (login + SVIP)
/// - 30251: Hi-Res (login + SVIP)
@override final  int quality;
/// MIME type (typically "audio/mp4").
@override final  String? mimeType;
/// Stream bandwidth in bits per second.
@override final  int? bandwidth;
/// URL expiration timestamp.
@override final  DateTime? expireTime;
/// Backup URLs in case the primary fails.
 final  List<String> _backupUrls;
/// Backup URLs in case the primary fails.
@override@JsonKey() List<String> get backupUrls {
  if (_backupUrls is EqualUnmodifiableListView) return _backupUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_backupUrls);
}


/// Create a copy of AudioStreamInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioStreamInfoCopyWith<_AudioStreamInfo> get copyWith => __$AudioStreamInfoCopyWithImpl<_AudioStreamInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudioStreamInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioStreamInfo&&(identical(other.url, url) || other.url == url)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.bandwidth, bandwidth) || other.bandwidth == bandwidth)&&(identical(other.expireTime, expireTime) || other.expireTime == expireTime)&&const DeepCollectionEquality().equals(other._backupUrls, _backupUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,quality,mimeType,bandwidth,expireTime,const DeepCollectionEquality().hash(_backupUrls));

@override
String toString() {
  return 'AudioStreamInfo(url: $url, quality: $quality, mimeType: $mimeType, bandwidth: $bandwidth, expireTime: $expireTime, backupUrls: $backupUrls)';
}


}

/// @nodoc
abstract mixin class _$AudioStreamInfoCopyWith<$Res> implements $AudioStreamInfoCopyWith<$Res> {
  factory _$AudioStreamInfoCopyWith(_AudioStreamInfo value, $Res Function(_AudioStreamInfo) _then) = __$AudioStreamInfoCopyWithImpl;
@override @useResult
$Res call({
 String url, int quality, String? mimeType, int? bandwidth, DateTime? expireTime, List<String> backupUrls
});




}
/// @nodoc
class __$AudioStreamInfoCopyWithImpl<$Res>
    implements _$AudioStreamInfoCopyWith<$Res> {
  __$AudioStreamInfoCopyWithImpl(this._self, this._then);

  final _AudioStreamInfo _self;
  final $Res Function(_AudioStreamInfo) _then;

/// Create a copy of AudioStreamInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? quality = null,Object? mimeType = freezed,Object? bandwidth = freezed,Object? expireTime = freezed,Object? backupUrls = null,}) {
  return _then(_AudioStreamInfo(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as int,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,bandwidth: freezed == bandwidth ? _self.bandwidth : bandwidth // ignore: cast_nullable_to_non_nullable
as int?,expireTime: freezed == expireTime ? _self.expireTime : expireTime // ignore: cast_nullable_to_non_nullable
as DateTime?,backupUrls: null == backupUrls ? _self._backupUrls : backupUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
