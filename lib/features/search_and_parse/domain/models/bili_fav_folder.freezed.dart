// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bili_fav_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BiliFavFolder {

/// 收藏夹 media_id（用于查询收藏夹内容）
 int get id;/// 收藏夹标题
 String get title;/// 收藏夹内视频数量
 int get mediaCount;/// 收藏夹创建者名称（仅对收藏的收藏夹有效，自己的为 null）
 String? get ownerName;
/// Create a copy of BiliFavFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BiliFavFolderCopyWith<BiliFavFolder> get copyWith => _$BiliFavFolderCopyWithImpl<BiliFavFolder>(this as BiliFavFolder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BiliFavFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaCount, mediaCount) || other.mediaCount == mediaCount)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,mediaCount,ownerName);

@override
String toString() {
  return 'BiliFavFolder(id: $id, title: $title, mediaCount: $mediaCount, ownerName: $ownerName)';
}


}

/// @nodoc
abstract mixin class $BiliFavFolderCopyWith<$Res>  {
  factory $BiliFavFolderCopyWith(BiliFavFolder value, $Res Function(BiliFavFolder) _then) = _$BiliFavFolderCopyWithImpl;
@useResult
$Res call({
 int id, String title, int mediaCount, String? ownerName
});




}
/// @nodoc
class _$BiliFavFolderCopyWithImpl<$Res>
    implements $BiliFavFolderCopyWith<$Res> {
  _$BiliFavFolderCopyWithImpl(this._self, this._then);

  final BiliFavFolder _self;
  final $Res Function(BiliFavFolder) _then;

/// Create a copy of BiliFavFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? mediaCount = null,Object? ownerName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaCount: null == mediaCount ? _self.mediaCount : mediaCount // ignore: cast_nullable_to_non_nullable
as int,ownerName: freezed == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BiliFavFolder].
extension BiliFavFolderPatterns on BiliFavFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BiliFavFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BiliFavFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BiliFavFolder value)  $default,){
final _that = this;
switch (_that) {
case _BiliFavFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BiliFavFolder value)?  $default,){
final _that = this;
switch (_that) {
case _BiliFavFolder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  int mediaCount,  String? ownerName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BiliFavFolder() when $default != null:
return $default(_that.id,_that.title,_that.mediaCount,_that.ownerName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  int mediaCount,  String? ownerName)  $default,) {final _that = this;
switch (_that) {
case _BiliFavFolder():
return $default(_that.id,_that.title,_that.mediaCount,_that.ownerName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  int mediaCount,  String? ownerName)?  $default,) {final _that = this;
switch (_that) {
case _BiliFavFolder() when $default != null:
return $default(_that.id,_that.title,_that.mediaCount,_that.ownerName);case _:
  return null;

}
}

}

/// @nodoc


class _BiliFavFolder implements BiliFavFolder {
  const _BiliFavFolder({required this.id, required this.title, required this.mediaCount, this.ownerName});
  

/// 收藏夹 media_id（用于查询收藏夹内容）
@override final  int id;
/// 收藏夹标题
@override final  String title;
/// 收藏夹内视频数量
@override final  int mediaCount;
/// 收藏夹创建者名称（仅对收藏的收藏夹有效，自己的为 null）
@override final  String? ownerName;

/// Create a copy of BiliFavFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BiliFavFolderCopyWith<_BiliFavFolder> get copyWith => __$BiliFavFolderCopyWithImpl<_BiliFavFolder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BiliFavFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaCount, mediaCount) || other.mediaCount == mediaCount)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,mediaCount,ownerName);

@override
String toString() {
  return 'BiliFavFolder(id: $id, title: $title, mediaCount: $mediaCount, ownerName: $ownerName)';
}


}

/// @nodoc
abstract mixin class _$BiliFavFolderCopyWith<$Res> implements $BiliFavFolderCopyWith<$Res> {
  factory _$BiliFavFolderCopyWith(_BiliFavFolder value, $Res Function(_BiliFavFolder) _then) = __$BiliFavFolderCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, int mediaCount, String? ownerName
});




}
/// @nodoc
class __$BiliFavFolderCopyWithImpl<$Res>
    implements _$BiliFavFolderCopyWith<$Res> {
  __$BiliFavFolderCopyWithImpl(this._self, this._then);

  final _BiliFavFolder _self;
  final $Res Function(_BiliFavFolder) _then;

/// Create a copy of BiliFavFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? mediaCount = null,Object? ownerName = freezed,}) {
  return _then(_BiliFavFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaCount: null == mediaCount ? _self.mediaCount : mediaCount // ignore: cast_nullable_to_non_nullable
as int,ownerName: freezed == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
