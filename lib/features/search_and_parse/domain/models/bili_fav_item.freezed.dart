// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bili_fav_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BiliFavItem {

/// BV 号
 String get bvid;/// 视频标题
 String get title;/// UP 主名称
 String get upper;/// 封面 URL
 String? get cover;/// 时长（秒）
 int get duration;/// 首 P 的 CID
 int get firstCid;/// 是否已失效（B 站 attr 第 9 位）
 bool get isInvalid;
/// Create a copy of BiliFavItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BiliFavItemCopyWith<BiliFavItem> get copyWith => _$BiliFavItemCopyWithImpl<BiliFavItem>(this as BiliFavItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BiliFavItem&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.title, title) || other.title == title)&&(identical(other.upper, upper) || other.upper == upper)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.firstCid, firstCid) || other.firstCid == firstCid)&&(identical(other.isInvalid, isInvalid) || other.isInvalid == isInvalid));
}


@override
int get hashCode => Object.hash(runtimeType,bvid,title,upper,cover,duration,firstCid,isInvalid);

@override
String toString() {
  return 'BiliFavItem(bvid: $bvid, title: $title, upper: $upper, cover: $cover, duration: $duration, firstCid: $firstCid, isInvalid: $isInvalid)';
}


}

/// @nodoc
abstract mixin class $BiliFavItemCopyWith<$Res>  {
  factory $BiliFavItemCopyWith(BiliFavItem value, $Res Function(BiliFavItem) _then) = _$BiliFavItemCopyWithImpl;
@useResult
$Res call({
 String bvid, String title, String upper, String? cover, int duration, int firstCid, bool isInvalid
});




}
/// @nodoc
class _$BiliFavItemCopyWithImpl<$Res>
    implements $BiliFavItemCopyWith<$Res> {
  _$BiliFavItemCopyWithImpl(this._self, this._then);

  final BiliFavItem _self;
  final $Res Function(BiliFavItem) _then;

/// Create a copy of BiliFavItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bvid = null,Object? title = null,Object? upper = null,Object? cover = freezed,Object? duration = null,Object? firstCid = null,Object? isInvalid = null,}) {
  return _then(_self.copyWith(
bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,upper: null == upper ? _self.upper : upper // ignore: cast_nullable_to_non_nullable
as String,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,firstCid: null == firstCid ? _self.firstCid : firstCid // ignore: cast_nullable_to_non_nullable
as int,isInvalid: null == isInvalid ? _self.isInvalid : isInvalid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BiliFavItem].
extension BiliFavItemPatterns on BiliFavItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BiliFavItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BiliFavItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BiliFavItem value)  $default,){
final _that = this;
switch (_that) {
case _BiliFavItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BiliFavItem value)?  $default,){
final _that = this;
switch (_that) {
case _BiliFavItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bvid,  String title,  String upper,  String? cover,  int duration,  int firstCid,  bool isInvalid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BiliFavItem() when $default != null:
return $default(_that.bvid,_that.title,_that.upper,_that.cover,_that.duration,_that.firstCid,_that.isInvalid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bvid,  String title,  String upper,  String? cover,  int duration,  int firstCid,  bool isInvalid)  $default,) {final _that = this;
switch (_that) {
case _BiliFavItem():
return $default(_that.bvid,_that.title,_that.upper,_that.cover,_that.duration,_that.firstCid,_that.isInvalid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bvid,  String title,  String upper,  String? cover,  int duration,  int firstCid,  bool isInvalid)?  $default,) {final _that = this;
switch (_that) {
case _BiliFavItem() when $default != null:
return $default(_that.bvid,_that.title,_that.upper,_that.cover,_that.duration,_that.firstCid,_that.isInvalid);case _:
  return null;

}
}

}

/// @nodoc


class _BiliFavItem implements BiliFavItem {
  const _BiliFavItem({required this.bvid, required this.title, required this.upper, this.cover, required this.duration, required this.firstCid, this.isInvalid = false});
  

/// BV 号
@override final  String bvid;
/// 视频标题
@override final  String title;
/// UP 主名称
@override final  String upper;
/// 封面 URL
@override final  String? cover;
/// 时长（秒）
@override final  int duration;
/// 首 P 的 CID
@override final  int firstCid;
/// 是否已失效（B 站 attr 第 9 位）
@override@JsonKey() final  bool isInvalid;

/// Create a copy of BiliFavItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BiliFavItemCopyWith<_BiliFavItem> get copyWith => __$BiliFavItemCopyWithImpl<_BiliFavItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BiliFavItem&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.title, title) || other.title == title)&&(identical(other.upper, upper) || other.upper == upper)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.firstCid, firstCid) || other.firstCid == firstCid)&&(identical(other.isInvalid, isInvalid) || other.isInvalid == isInvalid));
}


@override
int get hashCode => Object.hash(runtimeType,bvid,title,upper,cover,duration,firstCid,isInvalid);

@override
String toString() {
  return 'BiliFavItem(bvid: $bvid, title: $title, upper: $upper, cover: $cover, duration: $duration, firstCid: $firstCid, isInvalid: $isInvalid)';
}


}

/// @nodoc
abstract mixin class _$BiliFavItemCopyWith<$Res> implements $BiliFavItemCopyWith<$Res> {
  factory _$BiliFavItemCopyWith(_BiliFavItem value, $Res Function(_BiliFavItem) _then) = __$BiliFavItemCopyWithImpl;
@override @useResult
$Res call({
 String bvid, String title, String upper, String? cover, int duration, int firstCid, bool isInvalid
});




}
/// @nodoc
class __$BiliFavItemCopyWithImpl<$Res>
    implements _$BiliFavItemCopyWith<$Res> {
  __$BiliFavItemCopyWithImpl(this._self, this._then);

  final _BiliFavItem _self;
  final $Res Function(_BiliFavItem) _then;

/// Create a copy of BiliFavItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bvid = null,Object? title = null,Object? upper = null,Object? cover = freezed,Object? duration = null,Object? firstCid = null,Object? isInvalid = null,}) {
  return _then(_BiliFavItem(
bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,upper: null == upper ? _self.upper : upper // ignore: cast_nullable_to_non_nullable
as String,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,firstCid: null == firstCid ? _self.firstCid : firstCid // ignore: cast_nullable_to_non_nullable
as int,isInvalid: null == isInvalid ? _self.isInvalid : isInvalid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
