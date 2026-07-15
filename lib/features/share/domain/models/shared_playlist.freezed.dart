// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_playlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SharedPlaylist {

/// 格式版本号，用于向前兼容
@JsonKey(name: 'v') int get version;/// 歌单名称
@JsonKey(name: 'n') String get name;/// 歌曲列表
@JsonKey(name: 's') List<SharedSong> get songs;
/// Create a copy of SharedPlaylist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedPlaylistCopyWith<SharedPlaylist> get copyWith => _$SharedPlaylistCopyWithImpl<SharedPlaylist>(this as SharedPlaylist, _$identity);

  /// Serializes this SharedPlaylist to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedPlaylist&&(identical(other.version, version) || other.version == version)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.songs, songs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,name,const DeepCollectionEquality().hash(songs));

@override
String toString() {
  return 'SharedPlaylist(version: $version, name: $name, songs: $songs)';
}


}

/// @nodoc
abstract mixin class $SharedPlaylistCopyWith<$Res>  {
  factory $SharedPlaylistCopyWith(SharedPlaylist value, $Res Function(SharedPlaylist) _then) = _$SharedPlaylistCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'v') int version,@JsonKey(name: 'n') String name,@JsonKey(name: 's') List<SharedSong> songs
});




}
/// @nodoc
class _$SharedPlaylistCopyWithImpl<$Res>
    implements $SharedPlaylistCopyWith<$Res> {
  _$SharedPlaylistCopyWithImpl(this._self, this._then);

  final SharedPlaylist _self;
  final $Res Function(SharedPlaylist) _then;

/// Create a copy of SharedPlaylist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? name = null,Object? songs = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,songs: null == songs ? _self.songs : songs // ignore: cast_nullable_to_non_nullable
as List<SharedSong>,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedPlaylist].
extension SharedPlaylistPatterns on SharedPlaylist {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedPlaylist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedPlaylist() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedPlaylist value)  $default,){
final _that = this;
switch (_that) {
case _SharedPlaylist():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedPlaylist value)?  $default,){
final _that = this;
switch (_that) {
case _SharedPlaylist() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'v')  int version, @JsonKey(name: 'n')  String name, @JsonKey(name: 's')  List<SharedSong> songs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedPlaylist() when $default != null:
return $default(_that.version,_that.name,_that.songs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'v')  int version, @JsonKey(name: 'n')  String name, @JsonKey(name: 's')  List<SharedSong> songs)  $default,) {final _that = this;
switch (_that) {
case _SharedPlaylist():
return $default(_that.version,_that.name,_that.songs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'v')  int version, @JsonKey(name: 'n')  String name, @JsonKey(name: 's')  List<SharedSong> songs)?  $default,) {final _that = this;
switch (_that) {
case _SharedPlaylist() when $default != null:
return $default(_that.version,_that.name,_that.songs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharedPlaylist implements SharedPlaylist {
  const _SharedPlaylist({@JsonKey(name: 'v') this.version = 1, @JsonKey(name: 'n') required this.name, @JsonKey(name: 's') required final  List<SharedSong> songs}): _songs = songs;
  factory _SharedPlaylist.fromJson(Map<String, dynamic> json) => _$SharedPlaylistFromJson(json);

/// 格式版本号，用于向前兼容
@override@JsonKey(name: 'v') final  int version;
/// 歌单名称
@override@JsonKey(name: 'n') final  String name;
/// 歌曲列表
 final  List<SharedSong> _songs;
/// 歌曲列表
@override@JsonKey(name: 's') List<SharedSong> get songs {
  if (_songs is EqualUnmodifiableListView) return _songs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_songs);
}


/// Create a copy of SharedPlaylist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedPlaylistCopyWith<_SharedPlaylist> get copyWith => __$SharedPlaylistCopyWithImpl<_SharedPlaylist>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedPlaylistToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedPlaylist&&(identical(other.version, version) || other.version == version)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._songs, _songs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,name,const DeepCollectionEquality().hash(_songs));

@override
String toString() {
  return 'SharedPlaylist(version: $version, name: $name, songs: $songs)';
}


}

/// @nodoc
abstract mixin class _$SharedPlaylistCopyWith<$Res> implements $SharedPlaylistCopyWith<$Res> {
  factory _$SharedPlaylistCopyWith(_SharedPlaylist value, $Res Function(_SharedPlaylist) _then) = __$SharedPlaylistCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'v') int version,@JsonKey(name: 'n') String name,@JsonKey(name: 's') List<SharedSong> songs
});




}
/// @nodoc
class __$SharedPlaylistCopyWithImpl<$Res>
    implements _$SharedPlaylistCopyWith<$Res> {
  __$SharedPlaylistCopyWithImpl(this._self, this._then);

  final _SharedPlaylist _self;
  final $Res Function(_SharedPlaylist) _then;

/// Create a copy of SharedPlaylist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? name = null,Object? songs = null,}) {
  return _then(_SharedPlaylist(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,songs: null == songs ? _self._songs : songs // ignore: cast_nullable_to_non_nullable
as List<SharedSong>,
  ));
}


}


/// @nodoc
mixin _$SharedSong {

/// Bilibili BV 号（全局唯一标识之一）
@JsonKey(name: 'b') String get bvid;/// Bilibili CID（全局唯一标识之二）
@JsonKey(name: 'c') int get cid;/// 用户自定义标题（仅在用户修改过时包含，否则省略）
@JsonKey(name: 'ct', includeIfNull: false) String? get customTitle;/// 用户自定义作者（仅在用户修改过时包含，否则省略）
@JsonKey(name: 'ca', includeIfNull: false) String? get customArtist;
/// Create a copy of SharedSong
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedSongCopyWith<SharedSong> get copyWith => _$SharedSongCopyWithImpl<SharedSong>(this as SharedSong, _$identity);

  /// Serializes this SharedSong to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedSong&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.customTitle, customTitle) || other.customTitle == customTitle)&&(identical(other.customArtist, customArtist) || other.customArtist == customArtist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bvid,cid,customTitle,customArtist);

@override
String toString() {
  return 'SharedSong(bvid: $bvid, cid: $cid, customTitle: $customTitle, customArtist: $customArtist)';
}


}

/// @nodoc
abstract mixin class $SharedSongCopyWith<$Res>  {
  factory $SharedSongCopyWith(SharedSong value, $Res Function(SharedSong) _then) = _$SharedSongCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'b') String bvid,@JsonKey(name: 'c') int cid,@JsonKey(name: 'ct', includeIfNull: false) String? customTitle,@JsonKey(name: 'ca', includeIfNull: false) String? customArtist
});




}
/// @nodoc
class _$SharedSongCopyWithImpl<$Res>
    implements $SharedSongCopyWith<$Res> {
  _$SharedSongCopyWithImpl(this._self, this._then);

  final SharedSong _self;
  final $Res Function(SharedSong) _then;

/// Create a copy of SharedSong
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bvid = null,Object? cid = null,Object? customTitle = freezed,Object? customArtist = freezed,}) {
  return _then(_self.copyWith(
bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as int,customTitle: freezed == customTitle ? _self.customTitle : customTitle // ignore: cast_nullable_to_non_nullable
as String?,customArtist: freezed == customArtist ? _self.customArtist : customArtist // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedSong].
extension SharedSongPatterns on SharedSong {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedSong value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedSong() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedSong value)  $default,){
final _that = this;
switch (_that) {
case _SharedSong():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedSong value)?  $default,){
final _that = this;
switch (_that) {
case _SharedSong() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'b')  String bvid, @JsonKey(name: 'c')  int cid, @JsonKey(name: 'ct', includeIfNull: false)  String? customTitle, @JsonKey(name: 'ca', includeIfNull: false)  String? customArtist)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedSong() when $default != null:
return $default(_that.bvid,_that.cid,_that.customTitle,_that.customArtist);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'b')  String bvid, @JsonKey(name: 'c')  int cid, @JsonKey(name: 'ct', includeIfNull: false)  String? customTitle, @JsonKey(name: 'ca', includeIfNull: false)  String? customArtist)  $default,) {final _that = this;
switch (_that) {
case _SharedSong():
return $default(_that.bvid,_that.cid,_that.customTitle,_that.customArtist);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'b')  String bvid, @JsonKey(name: 'c')  int cid, @JsonKey(name: 'ct', includeIfNull: false)  String? customTitle, @JsonKey(name: 'ca', includeIfNull: false)  String? customArtist)?  $default,) {final _that = this;
switch (_that) {
case _SharedSong() when $default != null:
return $default(_that.bvid,_that.cid,_that.customTitle,_that.customArtist);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharedSong implements SharedSong {
  const _SharedSong({@JsonKey(name: 'b') required this.bvid, @JsonKey(name: 'c') required this.cid, @JsonKey(name: 'ct', includeIfNull: false) this.customTitle, @JsonKey(name: 'ca', includeIfNull: false) this.customArtist});
  factory _SharedSong.fromJson(Map<String, dynamic> json) => _$SharedSongFromJson(json);

/// Bilibili BV 号（全局唯一标识之一）
@override@JsonKey(name: 'b') final  String bvid;
/// Bilibili CID（全局唯一标识之二）
@override@JsonKey(name: 'c') final  int cid;
/// 用户自定义标题（仅在用户修改过时包含，否则省略）
@override@JsonKey(name: 'ct', includeIfNull: false) final  String? customTitle;
/// 用户自定义作者（仅在用户修改过时包含，否则省略）
@override@JsonKey(name: 'ca', includeIfNull: false) final  String? customArtist;

/// Create a copy of SharedSong
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedSongCopyWith<_SharedSong> get copyWith => __$SharedSongCopyWithImpl<_SharedSong>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedSongToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedSong&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.customTitle, customTitle) || other.customTitle == customTitle)&&(identical(other.customArtist, customArtist) || other.customArtist == customArtist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bvid,cid,customTitle,customArtist);

@override
String toString() {
  return 'SharedSong(bvid: $bvid, cid: $cid, customTitle: $customTitle, customArtist: $customArtist)';
}


}

/// @nodoc
abstract mixin class _$SharedSongCopyWith<$Res> implements $SharedSongCopyWith<$Res> {
  factory _$SharedSongCopyWith(_SharedSong value, $Res Function(_SharedSong) _then) = __$SharedSongCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'b') String bvid,@JsonKey(name: 'c') int cid,@JsonKey(name: 'ct', includeIfNull: false) String? customTitle,@JsonKey(name: 'ca', includeIfNull: false) String? customArtist
});




}
/// @nodoc
class __$SharedSongCopyWithImpl<$Res>
    implements _$SharedSongCopyWith<$Res> {
  __$SharedSongCopyWithImpl(this._self, this._then);

  final _SharedSong _self;
  final $Res Function(_SharedSong) _then;

/// Create a copy of SharedSong
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bvid = null,Object? cid = null,Object? customTitle = freezed,Object? customArtist = freezed,}) {
  return _then(_SharedSong(
bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as int,customTitle: freezed == customTitle ? _self.customTitle : customTitle // ignore: cast_nullable_to_non_nullable
as String?,customArtist: freezed == customArtist ? _self.customArtist : customArtist // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
