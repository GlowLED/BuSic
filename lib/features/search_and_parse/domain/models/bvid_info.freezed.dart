// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bvid_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BvidInfo {

/// Bilibili BV number.
 String get bvid;/// Bilibili AV number.
 int? get aid;/// Video title.
 String get title;/// Video description.
 String get description;/// Published timestamp in seconds.
 int? get pubdate;/// Bilibili category name.
 String? get tname;/// Video owner (UP主) display name.
 String get owner;/// Video owner UID.
 int? get ownerUid;/// Video owner avatar URL.
 String? get ownerFace;/// Cover image URL.
 String? get coverUrl;/// List of video pages (分P). Single-page videos have one entry.
 List<PageInfo> get pages;/// Total duration in seconds (all pages combined).
 int get duration;/// Video engagement counters.
 VideoStats get stats;/// Video permission and copyright flags.
 VideoRights get rights;/// Tags associated with this video.
 List<VideoTag> get tags;
/// Create a copy of BvidInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BvidInfoCopyWith<BvidInfo> get copyWith => _$BvidInfoCopyWithImpl<BvidInfo>(this as BvidInfo, _$identity);

  /// Serializes this BvidInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BvidInfo&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.aid, aid) || other.aid == aid)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.pubdate, pubdate) || other.pubdate == pubdate)&&(identical(other.tname, tname) || other.tname == tname)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.ownerUid, ownerUid) || other.ownerUid == ownerUid)&&(identical(other.ownerFace, ownerFace) || other.ownerFace == ownerFace)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other.pages, pages)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.rights, rights) || other.rights == rights)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bvid,aid,title,description,pubdate,tname,owner,ownerUid,ownerFace,coverUrl,const DeepCollectionEquality().hash(pages),duration,stats,rights,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'BvidInfo(bvid: $bvid, aid: $aid, title: $title, description: $description, pubdate: $pubdate, tname: $tname, owner: $owner, ownerUid: $ownerUid, ownerFace: $ownerFace, coverUrl: $coverUrl, pages: $pages, duration: $duration, stats: $stats, rights: $rights, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $BvidInfoCopyWith<$Res>  {
  factory $BvidInfoCopyWith(BvidInfo value, $Res Function(BvidInfo) _then) = _$BvidInfoCopyWithImpl;
@useResult
$Res call({
 String bvid, int? aid, String title, String description, int? pubdate, String? tname, String owner, int? ownerUid, String? ownerFace, String? coverUrl, List<PageInfo> pages, int duration, VideoStats stats, VideoRights rights, List<VideoTag> tags
});


$VideoStatsCopyWith<$Res> get stats;$VideoRightsCopyWith<$Res> get rights;

}
/// @nodoc
class _$BvidInfoCopyWithImpl<$Res>
    implements $BvidInfoCopyWith<$Res> {
  _$BvidInfoCopyWithImpl(this._self, this._then);

  final BvidInfo _self;
  final $Res Function(BvidInfo) _then;

/// Create a copy of BvidInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bvid = null,Object? aid = freezed,Object? title = null,Object? description = null,Object? pubdate = freezed,Object? tname = freezed,Object? owner = null,Object? ownerUid = freezed,Object? ownerFace = freezed,Object? coverUrl = freezed,Object? pages = null,Object? duration = null,Object? stats = null,Object? rights = null,Object? tags = null,}) {
  return _then(_self.copyWith(
bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,aid: freezed == aid ? _self.aid : aid // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pubdate: freezed == pubdate ? _self.pubdate : pubdate // ignore: cast_nullable_to_non_nullable
as int?,tname: freezed == tname ? _self.tname : tname // ignore: cast_nullable_to_non_nullable
as String?,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,ownerUid: freezed == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as int?,ownerFace: freezed == ownerFace ? _self.ownerFace : ownerFace // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<PageInfo>,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as VideoStats,rights: null == rights ? _self.rights : rights // ignore: cast_nullable_to_non_nullable
as VideoRights,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<VideoTag>,
  ));
}
/// Create a copy of BvidInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoStatsCopyWith<$Res> get stats {
  
  return $VideoStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of BvidInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoRightsCopyWith<$Res> get rights {
  
  return $VideoRightsCopyWith<$Res>(_self.rights, (value) {
    return _then(_self.copyWith(rights: value));
  });
}
}


/// Adds pattern-matching-related methods to [BvidInfo].
extension BvidInfoPatterns on BvidInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BvidInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BvidInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BvidInfo value)  $default,){
final _that = this;
switch (_that) {
case _BvidInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BvidInfo value)?  $default,){
final _that = this;
switch (_that) {
case _BvidInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bvid,  int? aid,  String title,  String description,  int? pubdate,  String? tname,  String owner,  int? ownerUid,  String? ownerFace,  String? coverUrl,  List<PageInfo> pages,  int duration,  VideoStats stats,  VideoRights rights,  List<VideoTag> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BvidInfo() when $default != null:
return $default(_that.bvid,_that.aid,_that.title,_that.description,_that.pubdate,_that.tname,_that.owner,_that.ownerUid,_that.ownerFace,_that.coverUrl,_that.pages,_that.duration,_that.stats,_that.rights,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bvid,  int? aid,  String title,  String description,  int? pubdate,  String? tname,  String owner,  int? ownerUid,  String? ownerFace,  String? coverUrl,  List<PageInfo> pages,  int duration,  VideoStats stats,  VideoRights rights,  List<VideoTag> tags)  $default,) {final _that = this;
switch (_that) {
case _BvidInfo():
return $default(_that.bvid,_that.aid,_that.title,_that.description,_that.pubdate,_that.tname,_that.owner,_that.ownerUid,_that.ownerFace,_that.coverUrl,_that.pages,_that.duration,_that.stats,_that.rights,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bvid,  int? aid,  String title,  String description,  int? pubdate,  String? tname,  String owner,  int? ownerUid,  String? ownerFace,  String? coverUrl,  List<PageInfo> pages,  int duration,  VideoStats stats,  VideoRights rights,  List<VideoTag> tags)?  $default,) {final _that = this;
switch (_that) {
case _BvidInfo() when $default != null:
return $default(_that.bvid,_that.aid,_that.title,_that.description,_that.pubdate,_that.tname,_that.owner,_that.ownerUid,_that.ownerFace,_that.coverUrl,_that.pages,_that.duration,_that.stats,_that.rights,_that.tags);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BvidInfo implements BvidInfo {
  const _BvidInfo({required this.bvid, this.aid, required this.title, this.description = '', this.pubdate, this.tname, required this.owner, this.ownerUid, this.ownerFace, this.coverUrl, final  List<PageInfo> pages = const [], this.duration = 0, this.stats = const VideoStats(), this.rights = const VideoRights(), final  List<VideoTag> tags = const []}): _pages = pages,_tags = tags;
  factory _BvidInfo.fromJson(Map<String, dynamic> json) => _$BvidInfoFromJson(json);

/// Bilibili BV number.
@override final  String bvid;
/// Bilibili AV number.
@override final  int? aid;
/// Video title.
@override final  String title;
/// Video description.
@override@JsonKey() final  String description;
/// Published timestamp in seconds.
@override final  int? pubdate;
/// Bilibili category name.
@override final  String? tname;
/// Video owner (UP主) display name.
@override final  String owner;
/// Video owner UID.
@override final  int? ownerUid;
/// Video owner avatar URL.
@override final  String? ownerFace;
/// Cover image URL.
@override final  String? coverUrl;
/// List of video pages (分P). Single-page videos have one entry.
 final  List<PageInfo> _pages;
/// List of video pages (分P). Single-page videos have one entry.
@override@JsonKey() List<PageInfo> get pages {
  if (_pages is EqualUnmodifiableListView) return _pages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pages);
}

/// Total duration in seconds (all pages combined).
@override@JsonKey() final  int duration;
/// Video engagement counters.
@override@JsonKey() final  VideoStats stats;
/// Video permission and copyright flags.
@override@JsonKey() final  VideoRights rights;
/// Tags associated with this video.
 final  List<VideoTag> _tags;
/// Tags associated with this video.
@override@JsonKey() List<VideoTag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of BvidInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BvidInfoCopyWith<_BvidInfo> get copyWith => __$BvidInfoCopyWithImpl<_BvidInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BvidInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BvidInfo&&(identical(other.bvid, bvid) || other.bvid == bvid)&&(identical(other.aid, aid) || other.aid == aid)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.pubdate, pubdate) || other.pubdate == pubdate)&&(identical(other.tname, tname) || other.tname == tname)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.ownerUid, ownerUid) || other.ownerUid == ownerUid)&&(identical(other.ownerFace, ownerFace) || other.ownerFace == ownerFace)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other._pages, _pages)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.rights, rights) || other.rights == rights)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bvid,aid,title,description,pubdate,tname,owner,ownerUid,ownerFace,coverUrl,const DeepCollectionEquality().hash(_pages),duration,stats,rights,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'BvidInfo(bvid: $bvid, aid: $aid, title: $title, description: $description, pubdate: $pubdate, tname: $tname, owner: $owner, ownerUid: $ownerUid, ownerFace: $ownerFace, coverUrl: $coverUrl, pages: $pages, duration: $duration, stats: $stats, rights: $rights, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$BvidInfoCopyWith<$Res> implements $BvidInfoCopyWith<$Res> {
  factory _$BvidInfoCopyWith(_BvidInfo value, $Res Function(_BvidInfo) _then) = __$BvidInfoCopyWithImpl;
@override @useResult
$Res call({
 String bvid, int? aid, String title, String description, int? pubdate, String? tname, String owner, int? ownerUid, String? ownerFace, String? coverUrl, List<PageInfo> pages, int duration, VideoStats stats, VideoRights rights, List<VideoTag> tags
});


@override $VideoStatsCopyWith<$Res> get stats;@override $VideoRightsCopyWith<$Res> get rights;

}
/// @nodoc
class __$BvidInfoCopyWithImpl<$Res>
    implements _$BvidInfoCopyWith<$Res> {
  __$BvidInfoCopyWithImpl(this._self, this._then);

  final _BvidInfo _self;
  final $Res Function(_BvidInfo) _then;

/// Create a copy of BvidInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bvid = null,Object? aid = freezed,Object? title = null,Object? description = null,Object? pubdate = freezed,Object? tname = freezed,Object? owner = null,Object? ownerUid = freezed,Object? ownerFace = freezed,Object? coverUrl = freezed,Object? pages = null,Object? duration = null,Object? stats = null,Object? rights = null,Object? tags = null,}) {
  return _then(_BvidInfo(
bvid: null == bvid ? _self.bvid : bvid // ignore: cast_nullable_to_non_nullable
as String,aid: freezed == aid ? _self.aid : aid // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pubdate: freezed == pubdate ? _self.pubdate : pubdate // ignore: cast_nullable_to_non_nullable
as int?,tname: freezed == tname ? _self.tname : tname // ignore: cast_nullable_to_non_nullable
as String?,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,ownerUid: freezed == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as int?,ownerFace: freezed == ownerFace ? _self.ownerFace : ownerFace // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,pages: null == pages ? _self._pages : pages // ignore: cast_nullable_to_non_nullable
as List<PageInfo>,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as VideoStats,rights: null == rights ? _self.rights : rights // ignore: cast_nullable_to_non_nullable
as VideoRights,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<VideoTag>,
  ));
}

/// Create a copy of BvidInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoStatsCopyWith<$Res> get stats {
  
  return $VideoStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of BvidInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoRightsCopyWith<$Res> get rights {
  
  return $VideoRightsCopyWith<$Res>(_self.rights, (value) {
    return _then(_self.copyWith(rights: value));
  });
}
}

// dart format on
