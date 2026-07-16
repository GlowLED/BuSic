// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_backup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppBackup {

/// 备份格式版本
 int get version;/// App 版本号
 String get appVersion;/// 备份创建时间
 DateTime get createdAt;/// 所有歌单
 List<BackupPlaylist> get playlists;/// 所有歌曲（去重，全量）— 复用 SharedSong 精简结构
 List<SharedSong> get songs;/// 歌单-歌曲关联关系
 List<BackupPlaylistSong> get playlistSongs;/// 用户偏好设置
 BackupPreferences? get preferences;
/// Create a copy of AppBackup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppBackupCopyWith<AppBackup> get copyWith => _$AppBackupCopyWithImpl<AppBackup>(this as AppBackup, _$identity);

  /// Serializes this AppBackup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppBackup&&(identical(other.version, version) || other.version == version)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.playlists, playlists)&&const DeepCollectionEquality().equals(other.songs, songs)&&const DeepCollectionEquality().equals(other.playlistSongs, playlistSongs)&&(identical(other.preferences, preferences) || other.preferences == preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,appVersion,createdAt,const DeepCollectionEquality().hash(playlists),const DeepCollectionEquality().hash(songs),const DeepCollectionEquality().hash(playlistSongs),preferences);

@override
String toString() {
  return 'AppBackup(version: $version, appVersion: $appVersion, createdAt: $createdAt, playlists: $playlists, songs: $songs, playlistSongs: $playlistSongs, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class $AppBackupCopyWith<$Res>  {
  factory $AppBackupCopyWith(AppBackup value, $Res Function(AppBackup) _then) = _$AppBackupCopyWithImpl;
@useResult
$Res call({
 int version, String appVersion, DateTime createdAt, List<BackupPlaylist> playlists, List<SharedSong> songs, List<BackupPlaylistSong> playlistSongs, BackupPreferences? preferences
});


$BackupPreferencesCopyWith<$Res>? get preferences;

}
/// @nodoc
class _$AppBackupCopyWithImpl<$Res>
    implements $AppBackupCopyWith<$Res> {
  _$AppBackupCopyWithImpl(this._self, this._then);

  final AppBackup _self;
  final $Res Function(AppBackup) _then;

/// Create a copy of AppBackup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? appVersion = null,Object? createdAt = null,Object? playlists = null,Object? songs = null,Object? playlistSongs = null,Object? preferences = freezed,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,playlists: null == playlists ? _self.playlists : playlists // ignore: cast_nullable_to_non_nullable
as List<BackupPlaylist>,songs: null == songs ? _self.songs : songs // ignore: cast_nullable_to_non_nullable
as List<SharedSong>,playlistSongs: null == playlistSongs ? _self.playlistSongs : playlistSongs // ignore: cast_nullable_to_non_nullable
as List<BackupPlaylistSong>,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as BackupPreferences?,
  ));
}
/// Create a copy of AppBackup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupPreferencesCopyWith<$Res>? get preferences {
    if (_self.preferences == null) {
    return null;
  }

  return $BackupPreferencesCopyWith<$Res>(_self.preferences!, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppBackup].
extension AppBackupPatterns on AppBackup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppBackup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppBackup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppBackup value)  $default,){
final _that = this;
switch (_that) {
case _AppBackup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppBackup value)?  $default,){
final _that = this;
switch (_that) {
case _AppBackup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  String appVersion,  DateTime createdAt,  List<BackupPlaylist> playlists,  List<SharedSong> songs,  List<BackupPlaylistSong> playlistSongs,  BackupPreferences? preferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppBackup() when $default != null:
return $default(_that.version,_that.appVersion,_that.createdAt,_that.playlists,_that.songs,_that.playlistSongs,_that.preferences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  String appVersion,  DateTime createdAt,  List<BackupPlaylist> playlists,  List<SharedSong> songs,  List<BackupPlaylistSong> playlistSongs,  BackupPreferences? preferences)  $default,) {final _that = this;
switch (_that) {
case _AppBackup():
return $default(_that.version,_that.appVersion,_that.createdAt,_that.playlists,_that.songs,_that.playlistSongs,_that.preferences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  String appVersion,  DateTime createdAt,  List<BackupPlaylist> playlists,  List<SharedSong> songs,  List<BackupPlaylistSong> playlistSongs,  BackupPreferences? preferences)?  $default,) {final _that = this;
switch (_that) {
case _AppBackup() when $default != null:
return $default(_that.version,_that.appVersion,_that.createdAt,_that.playlists,_that.songs,_that.playlistSongs,_that.preferences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppBackup implements AppBackup {
  const _AppBackup({this.version = 1, required this.appVersion, required this.createdAt, required final  List<BackupPlaylist> playlists, required final  List<SharedSong> songs, required final  List<BackupPlaylistSong> playlistSongs, this.preferences}): _playlists = playlists,_songs = songs,_playlistSongs = playlistSongs;
  factory _AppBackup.fromJson(Map<String, dynamic> json) => _$AppBackupFromJson(json);

/// 备份格式版本
@override@JsonKey() final  int version;
/// App 版本号
@override final  String appVersion;
/// 备份创建时间
@override final  DateTime createdAt;
/// 所有歌单
 final  List<BackupPlaylist> _playlists;
/// 所有歌单
@override List<BackupPlaylist> get playlists {
  if (_playlists is EqualUnmodifiableListView) return _playlists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playlists);
}

/// 所有歌曲（去重，全量）— 复用 SharedSong 精简结构
 final  List<SharedSong> _songs;
/// 所有歌曲（去重，全量）— 复用 SharedSong 精简结构
@override List<SharedSong> get songs {
  if (_songs is EqualUnmodifiableListView) return _songs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_songs);
}

/// 歌单-歌曲关联关系
 final  List<BackupPlaylistSong> _playlistSongs;
/// 歌单-歌曲关联关系
@override List<BackupPlaylistSong> get playlistSongs {
  if (_playlistSongs is EqualUnmodifiableListView) return _playlistSongs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playlistSongs);
}

/// 用户偏好设置
@override final  BackupPreferences? preferences;

/// Create a copy of AppBackup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppBackupCopyWith<_AppBackup> get copyWith => __$AppBackupCopyWithImpl<_AppBackup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppBackupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppBackup&&(identical(other.version, version) || other.version == version)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._playlists, _playlists)&&const DeepCollectionEquality().equals(other._songs, _songs)&&const DeepCollectionEquality().equals(other._playlistSongs, _playlistSongs)&&(identical(other.preferences, preferences) || other.preferences == preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,appVersion,createdAt,const DeepCollectionEquality().hash(_playlists),const DeepCollectionEquality().hash(_songs),const DeepCollectionEquality().hash(_playlistSongs),preferences);

@override
String toString() {
  return 'AppBackup(version: $version, appVersion: $appVersion, createdAt: $createdAt, playlists: $playlists, songs: $songs, playlistSongs: $playlistSongs, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class _$AppBackupCopyWith<$Res> implements $AppBackupCopyWith<$Res> {
  factory _$AppBackupCopyWith(_AppBackup value, $Res Function(_AppBackup) _then) = __$AppBackupCopyWithImpl;
@override @useResult
$Res call({
 int version, String appVersion, DateTime createdAt, List<BackupPlaylist> playlists, List<SharedSong> songs, List<BackupPlaylistSong> playlistSongs, BackupPreferences? preferences
});


@override $BackupPreferencesCopyWith<$Res>? get preferences;

}
/// @nodoc
class __$AppBackupCopyWithImpl<$Res>
    implements _$AppBackupCopyWith<$Res> {
  __$AppBackupCopyWithImpl(this._self, this._then);

  final _AppBackup _self;
  final $Res Function(_AppBackup) _then;

/// Create a copy of AppBackup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? appVersion = null,Object? createdAt = null,Object? playlists = null,Object? songs = null,Object? playlistSongs = null,Object? preferences = freezed,}) {
  return _then(_AppBackup(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,playlists: null == playlists ? _self._playlists : playlists // ignore: cast_nullable_to_non_nullable
as List<BackupPlaylist>,songs: null == songs ? _self._songs : songs // ignore: cast_nullable_to_non_nullable
as List<SharedSong>,playlistSongs: null == playlistSongs ? _self._playlistSongs : playlistSongs // ignore: cast_nullable_to_non_nullable
as List<BackupPlaylistSong>,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as BackupPreferences?,
  ));
}

/// Create a copy of AppBackup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupPreferencesCopyWith<$Res>? get preferences {
    if (_self.preferences == null) {
    return null;
  }

  return $BackupPreferencesCopyWith<$Res>(_self.preferences!, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}


/// @nodoc
mixin _$BackupPlaylist {

/// 原始 ID（用于关联关系映射）
 int get originalId;/// 歌单名称
 String get name;/// 歌单封面 URL
 String? get coverUrl;/// 排序序号
 int get sortOrder;/// 创建时间
 DateTime get createdAt;
/// Create a copy of BackupPlaylist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupPlaylistCopyWith<BackupPlaylist> get copyWith => _$BackupPlaylistCopyWithImpl<BackupPlaylist>(this as BackupPlaylist, _$identity);

  /// Serializes this BackupPlaylist to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupPlaylist&&(identical(other.originalId, originalId) || other.originalId == originalId)&&(identical(other.name, name) || other.name == name)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,originalId,name,coverUrl,sortOrder,createdAt);

@override
String toString() {
  return 'BackupPlaylist(originalId: $originalId, name: $name, coverUrl: $coverUrl, sortOrder: $sortOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BackupPlaylistCopyWith<$Res>  {
  factory $BackupPlaylistCopyWith(BackupPlaylist value, $Res Function(BackupPlaylist) _then) = _$BackupPlaylistCopyWithImpl;
@useResult
$Res call({
 int originalId, String name, String? coverUrl, int sortOrder, DateTime createdAt
});




}
/// @nodoc
class _$BackupPlaylistCopyWithImpl<$Res>
    implements $BackupPlaylistCopyWith<$Res> {
  _$BackupPlaylistCopyWithImpl(this._self, this._then);

  final BackupPlaylist _self;
  final $Res Function(BackupPlaylist) _then;

/// Create a copy of BackupPlaylist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originalId = null,Object? name = null,Object? coverUrl = freezed,Object? sortOrder = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
originalId: null == originalId ? _self.originalId : originalId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupPlaylist].
extension BackupPlaylistPatterns on BackupPlaylist {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupPlaylist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupPlaylist() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupPlaylist value)  $default,){
final _that = this;
switch (_that) {
case _BackupPlaylist():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupPlaylist value)?  $default,){
final _that = this;
switch (_that) {
case _BackupPlaylist() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int originalId,  String name,  String? coverUrl,  int sortOrder,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupPlaylist() when $default != null:
return $default(_that.originalId,_that.name,_that.coverUrl,_that.sortOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int originalId,  String name,  String? coverUrl,  int sortOrder,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BackupPlaylist():
return $default(_that.originalId,_that.name,_that.coverUrl,_that.sortOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int originalId,  String name,  String? coverUrl,  int sortOrder,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BackupPlaylist() when $default != null:
return $default(_that.originalId,_that.name,_that.coverUrl,_that.sortOrder,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupPlaylist implements BackupPlaylist {
  const _BackupPlaylist({required this.originalId, required this.name, this.coverUrl, required this.sortOrder, required this.createdAt});
  factory _BackupPlaylist.fromJson(Map<String, dynamic> json) => _$BackupPlaylistFromJson(json);

/// 原始 ID（用于关联关系映射）
@override final  int originalId;
/// 歌单名称
@override final  String name;
/// 歌单封面 URL
@override final  String? coverUrl;
/// 排序序号
@override final  int sortOrder;
/// 创建时间
@override final  DateTime createdAt;

/// Create a copy of BackupPlaylist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupPlaylistCopyWith<_BackupPlaylist> get copyWith => __$BackupPlaylistCopyWithImpl<_BackupPlaylist>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupPlaylistToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupPlaylist&&(identical(other.originalId, originalId) || other.originalId == originalId)&&(identical(other.name, name) || other.name == name)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,originalId,name,coverUrl,sortOrder,createdAt);

@override
String toString() {
  return 'BackupPlaylist(originalId: $originalId, name: $name, coverUrl: $coverUrl, sortOrder: $sortOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BackupPlaylistCopyWith<$Res> implements $BackupPlaylistCopyWith<$Res> {
  factory _$BackupPlaylistCopyWith(_BackupPlaylist value, $Res Function(_BackupPlaylist) _then) = __$BackupPlaylistCopyWithImpl;
@override @useResult
$Res call({
 int originalId, String name, String? coverUrl, int sortOrder, DateTime createdAt
});




}
/// @nodoc
class __$BackupPlaylistCopyWithImpl<$Res>
    implements _$BackupPlaylistCopyWith<$Res> {
  __$BackupPlaylistCopyWithImpl(this._self, this._then);

  final _BackupPlaylist _self;
  final $Res Function(_BackupPlaylist) _then;

/// Create a copy of BackupPlaylist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originalId = null,Object? name = null,Object? coverUrl = freezed,Object? sortOrder = null,Object? createdAt = null,}) {
  return _then(_BackupPlaylist(
originalId: null == originalId ? _self.originalId : originalId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$BackupPlaylistSong {

/// 原始歌单 ID
 int get playlistId;/// 歌曲的 bvid（用于跨设备映射）
 String get bvid;/// 歌曲的 cid
 int get cid;/// 排序
 int get sortOrder;
/// Create a copy of BackupPlaylistSong
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupPlaylistSongCopyWith<BackupPlaylistSong> get copyWith => _$BackupPlaylistSongCopyWithImpl<BackupPlaylistSong>(this as BackupPlaylistSong, _$identity);

  /// Serializes this BackupPlaylistSong to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupPlaylistSong&&(identical(other.playlistId, playlistId) || other.playlistId == playlistId)&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playlistId,bvid,cid,sortOrder);

@override
String toString() {
  return 'BackupPlaylistSong(playlistId: $playlistId, bvid: $bvid, cid: $cid, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $BackupPlaylistSongCopyWith<$Res>  {
  factory $BackupPlaylistSongCopyWith(BackupPlaylistSong value, $Res Function(BackupPlaylistSong) _then) = _$BackupPlaylistSongCopyWithImpl;
@useResult
$Res call({
 int playlistId, String bvid, int cid, int sortOrder
});




}
/// @nodoc
class _$BackupPlaylistSongCopyWithImpl<$Res>
    implements $BackupPlaylistSongCopyWith<$Res> {
  _$BackupPlaylistSongCopyWithImpl(this._self, this._then);

  final BackupPlaylistSong _self;
  final $Res Function(BackupPlaylistSong) _then;

/// Create a copy of BackupPlaylistSong
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playlistId = null,Object? bvid = null,Object? cid = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
playlistId: null == playlistId ? _self.playlistId : playlistId // ignore: cast_nullable_to_non_nullable
as int,bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupPlaylistSong].
extension BackupPlaylistSongPatterns on BackupPlaylistSong {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupPlaylistSong value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupPlaylistSong() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupPlaylistSong value)  $default,){
final _that = this;
switch (_that) {
case _BackupPlaylistSong():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupPlaylistSong value)?  $default,){
final _that = this;
switch (_that) {
case _BackupPlaylistSong() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int playlistId,  String bvid,  int cid,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupPlaylistSong() when $default != null:
return $default(_that.playlistId,_that.bvid,_that.cid,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int playlistId,  String bvid,  int cid,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _BackupPlaylistSong():
return $default(_that.playlistId,_that.bvid,_that.cid,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int playlistId,  String bvid,  int cid,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _BackupPlaylistSong() when $default != null:
return $default(_that.playlistId,_that.bvid,_that.cid,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupPlaylistSong implements BackupPlaylistSong {
  const _BackupPlaylistSong({required this.playlistId, required this.bvid, required this.cid, required this.sortOrder});
  factory _BackupPlaylistSong.fromJson(Map<String, dynamic> json) => _$BackupPlaylistSongFromJson(json);

/// 原始歌单 ID
@override final  int playlistId;
/// 歌曲的 bvid（用于跨设备映射）
@override final  String bvid;
/// 歌曲的 cid
@override final  int cid;
/// 排序
@override final  int sortOrder;

/// Create a copy of BackupPlaylistSong
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupPlaylistSongCopyWith<_BackupPlaylistSong> get copyWith => __$BackupPlaylistSongCopyWithImpl<_BackupPlaylistSong>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupPlaylistSongToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupPlaylistSong&&(identical(other.playlistId, playlistId) || other.playlistId == playlistId)&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playlistId,bvid,cid,sortOrder);

@override
String toString() {
  return 'BackupPlaylistSong(playlistId: $playlistId, bvid: $bvid, cid: $cid, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$BackupPlaylistSongCopyWith<$Res> implements $BackupPlaylistSongCopyWith<$Res> {
  factory _$BackupPlaylistSongCopyWith(_BackupPlaylistSong value, $Res Function(_BackupPlaylistSong) _then) = __$BackupPlaylistSongCopyWithImpl;
@override @useResult
$Res call({
 int playlistId, String bvid, int cid, int sortOrder
});




}
/// @nodoc
class __$BackupPlaylistSongCopyWithImpl<$Res>
    implements _$BackupPlaylistSongCopyWith<$Res> {
  __$BackupPlaylistSongCopyWithImpl(this._self, this._then);

  final _BackupPlaylistSong _self;
  final $Res Function(_BackupPlaylistSong) _then;

/// Create a copy of BackupPlaylistSong
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playlistId = null,Object? bvid = null,Object? cid = null,Object? sortOrder = null,}) {
  return _then(_BackupPlaylistSong(
playlistId: null == playlistId ? _self.playlistId : playlistId // ignore: cast_nullable_to_non_nullable
as int,bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BackupPreferences {

/// 主题模式
 String? get themeMode;/// 语言
 String? get locale;/// 首选音质
 int? get preferredQuality;/// 缓存路径
 String? get cachePath;
/// Create a copy of BackupPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupPreferencesCopyWith<BackupPreferences> get copyWith => _$BackupPreferencesCopyWithImpl<BackupPreferences>(this as BackupPreferences, _$identity);

  /// Serializes this BackupPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupPreferences&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.preferredQuality, preferredQuality) || other.preferredQuality == preferredQuality)&&(identical(other.cachePath, cachePath) || other.cachePath == cachePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,locale,preferredQuality,cachePath);

@override
String toString() {
  return 'BackupPreferences(themeMode: $themeMode, locale: $locale, preferredQuality: $preferredQuality, cachePath: $cachePath)';
}


}

/// @nodoc
abstract mixin class $BackupPreferencesCopyWith<$Res>  {
  factory $BackupPreferencesCopyWith(BackupPreferences value, $Res Function(BackupPreferences) _then) = _$BackupPreferencesCopyWithImpl;
@useResult
$Res call({
 String? themeMode, String? locale, int? preferredQuality, String? cachePath
});




}
/// @nodoc
class _$BackupPreferencesCopyWithImpl<$Res>
    implements $BackupPreferencesCopyWith<$Res> {
  _$BackupPreferencesCopyWithImpl(this._self, this._then);

  final BackupPreferences _self;
  final $Res Function(BackupPreferences) _then;

/// Create a copy of BackupPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = freezed,Object? locale = freezed,Object? preferredQuality = freezed,Object? cachePath = freezed,}) {
  return _then(_self.copyWith(
themeMode: freezed == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,preferredQuality: freezed == preferredQuality ? _self.preferredQuality : preferredQuality // ignore: cast_nullable_to_non_nullable
as int?,cachePath: freezed == cachePath ? _self.cachePath : cachePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupPreferences].
extension BackupPreferencesPatterns on BackupPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupPreferences value)  $default,){
final _that = this;
switch (_that) {
case _BackupPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _BackupPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? themeMode,  String? locale,  int? preferredQuality,  String? cachePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupPreferences() when $default != null:
return $default(_that.themeMode,_that.locale,_that.preferredQuality,_that.cachePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? themeMode,  String? locale,  int? preferredQuality,  String? cachePath)  $default,) {final _that = this;
switch (_that) {
case _BackupPreferences():
return $default(_that.themeMode,_that.locale,_that.preferredQuality,_that.cachePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? themeMode,  String? locale,  int? preferredQuality,  String? cachePath)?  $default,) {final _that = this;
switch (_that) {
case _BackupPreferences() when $default != null:
return $default(_that.themeMode,_that.locale,_that.preferredQuality,_that.cachePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupPreferences implements BackupPreferences {
  const _BackupPreferences({this.themeMode, this.locale, this.preferredQuality, this.cachePath});
  factory _BackupPreferences.fromJson(Map<String, dynamic> json) => _$BackupPreferencesFromJson(json);

/// 主题模式
@override final  String? themeMode;
/// 语言
@override final  String? locale;
/// 首选音质
@override final  int? preferredQuality;
/// 缓存路径
@override final  String? cachePath;

/// Create a copy of BackupPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupPreferencesCopyWith<_BackupPreferences> get copyWith => __$BackupPreferencesCopyWithImpl<_BackupPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupPreferences&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.preferredQuality, preferredQuality) || other.preferredQuality == preferredQuality)&&(identical(other.cachePath, cachePath) || other.cachePath == cachePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,locale,preferredQuality,cachePath);

@override
String toString() {
  return 'BackupPreferences(themeMode: $themeMode, locale: $locale, preferredQuality: $preferredQuality, cachePath: $cachePath)';
}


}

/// @nodoc
abstract mixin class _$BackupPreferencesCopyWith<$Res> implements $BackupPreferencesCopyWith<$Res> {
  factory _$BackupPreferencesCopyWith(_BackupPreferences value, $Res Function(_BackupPreferences) _then) = __$BackupPreferencesCopyWithImpl;
@override @useResult
$Res call({
 String? themeMode, String? locale, int? preferredQuality, String? cachePath
});




}
/// @nodoc
class __$BackupPreferencesCopyWithImpl<$Res>
    implements _$BackupPreferencesCopyWith<$Res> {
  __$BackupPreferencesCopyWithImpl(this._self, this._then);

  final _BackupPreferences _self;
  final $Res Function(_BackupPreferences) _then;

/// Create a copy of BackupPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = freezed,Object? locale = freezed,Object? preferredQuality = freezed,Object? cachePath = freezed,}) {
  return _then(_BackupPreferences(
themeMode: freezed == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,preferredQuality: freezed == preferredQuality ? _self.preferredQuality : preferredQuality // ignore: cast_nullable_to_non_nullable
as int?,cachePath: freezed == cachePath ? _self.cachePath : cachePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
