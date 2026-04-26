// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bvid_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BvidInfo _$BvidInfoFromJson(Map<String, dynamic> json) {
  return _BvidInfo.fromJson(json);
}

/// @nodoc
mixin _$BvidInfo {
  /// Bilibili BV number.
  String get bvid => throw _privateConstructorUsedError;

  /// Bilibili AV number.
  int? get aid => throw _privateConstructorUsedError;

  /// Video title.
  String get title => throw _privateConstructorUsedError;

  /// Video description.
  String get description => throw _privateConstructorUsedError;

  /// Published timestamp in seconds.
  int? get pubdate => throw _privateConstructorUsedError;

  /// Bilibili category name.
  String? get tname => throw _privateConstructorUsedError;

  /// Video owner (UP主) display name.
  String get owner => throw _privateConstructorUsedError;

  /// Video owner UID.
  int? get ownerUid => throw _privateConstructorUsedError;

  /// Video owner avatar URL.
  String? get ownerFace => throw _privateConstructorUsedError;

  /// Cover image URL.
  String? get coverUrl => throw _privateConstructorUsedError;

  /// List of video pages (分P). Single-page videos have one entry.
  List<PageInfo> get pages => throw _privateConstructorUsedError;

  /// Total duration in seconds (all pages combined).
  int get duration => throw _privateConstructorUsedError;

  /// Video engagement counters.
  VideoStats get stats => throw _privateConstructorUsedError;

  /// Video permission and copyright flags.
  VideoRights get rights => throw _privateConstructorUsedError;

  /// Tags associated with this video.
  List<VideoTag> get tags => throw _privateConstructorUsedError;

  /// Serializes this BvidInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BvidInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BvidInfoCopyWith<BvidInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BvidInfoCopyWith<$Res> {
  factory $BvidInfoCopyWith(BvidInfo value, $Res Function(BvidInfo) then) =
      _$BvidInfoCopyWithImpl<$Res, BvidInfo>;
  @useResult
  $Res call(
      {String bvid,
      int? aid,
      String title,
      String description,
      int? pubdate,
      String? tname,
      String owner,
      int? ownerUid,
      String? ownerFace,
      String? coverUrl,
      List<PageInfo> pages,
      int duration,
      VideoStats stats,
      VideoRights rights,
      List<VideoTag> tags});

  $VideoStatsCopyWith<$Res> get stats;
  $VideoRightsCopyWith<$Res> get rights;
}

/// @nodoc
class _$BvidInfoCopyWithImpl<$Res, $Val extends BvidInfo>
    implements $BvidInfoCopyWith<$Res> {
  _$BvidInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BvidInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bvid = null,
    Object? aid = freezed,
    Object? title = null,
    Object? description = null,
    Object? pubdate = freezed,
    Object? tname = freezed,
    Object? owner = null,
    Object? ownerUid = freezed,
    Object? ownerFace = freezed,
    Object? coverUrl = freezed,
    Object? pages = null,
    Object? duration = null,
    Object? stats = null,
    Object? rights = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      aid: freezed == aid
          ? _value.aid
          : aid // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      pubdate: freezed == pubdate
          ? _value.pubdate
          : pubdate // ignore: cast_nullable_to_non_nullable
              as int?,
      tname: freezed == tname
          ? _value.tname
          : tname // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      ownerUid: freezed == ownerUid
          ? _value.ownerUid
          : ownerUid // ignore: cast_nullable_to_non_nullable
              as int?,
      ownerFace: freezed == ownerFace
          ? _value.ownerFace
          : ownerFace // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pages: null == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PageInfo>,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as VideoStats,
      rights: null == rights
          ? _value.rights
          : rights // ignore: cast_nullable_to_non_nullable
              as VideoRights,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<VideoTag>,
    ) as $Val);
  }

  /// Create a copy of BvidInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VideoStatsCopyWith<$Res> get stats {
    return $VideoStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }

  /// Create a copy of BvidInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VideoRightsCopyWith<$Res> get rights {
    return $VideoRightsCopyWith<$Res>(_value.rights, (value) {
      return _then(_value.copyWith(rights: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BvidInfoImplCopyWith<$Res>
    implements $BvidInfoCopyWith<$Res> {
  factory _$$BvidInfoImplCopyWith(
          _$BvidInfoImpl value, $Res Function(_$BvidInfoImpl) then) =
      __$$BvidInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bvid,
      int? aid,
      String title,
      String description,
      int? pubdate,
      String? tname,
      String owner,
      int? ownerUid,
      String? ownerFace,
      String? coverUrl,
      List<PageInfo> pages,
      int duration,
      VideoStats stats,
      VideoRights rights,
      List<VideoTag> tags});

  @override
  $VideoStatsCopyWith<$Res> get stats;
  @override
  $VideoRightsCopyWith<$Res> get rights;
}

/// @nodoc
class __$$BvidInfoImplCopyWithImpl<$Res>
    extends _$BvidInfoCopyWithImpl<$Res, _$BvidInfoImpl>
    implements _$$BvidInfoImplCopyWith<$Res> {
  __$$BvidInfoImplCopyWithImpl(
      _$BvidInfoImpl _value, $Res Function(_$BvidInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BvidInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bvid = null,
    Object? aid = freezed,
    Object? title = null,
    Object? description = null,
    Object? pubdate = freezed,
    Object? tname = freezed,
    Object? owner = null,
    Object? ownerUid = freezed,
    Object? ownerFace = freezed,
    Object? coverUrl = freezed,
    Object? pages = null,
    Object? duration = null,
    Object? stats = null,
    Object? rights = null,
    Object? tags = null,
  }) {
    return _then(_$BvidInfoImpl(
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      aid: freezed == aid
          ? _value.aid
          : aid // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      pubdate: freezed == pubdate
          ? _value.pubdate
          : pubdate // ignore: cast_nullable_to_non_nullable
              as int?,
      tname: freezed == tname
          ? _value.tname
          : tname // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      ownerUid: freezed == ownerUid
          ? _value.ownerUid
          : ownerUid // ignore: cast_nullable_to_non_nullable
              as int?,
      ownerFace: freezed == ownerFace
          ? _value.ownerFace
          : ownerFace // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pages: null == pages
          ? _value._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PageInfo>,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as VideoStats,
      rights: null == rights
          ? _value.rights
          : rights // ignore: cast_nullable_to_non_nullable
              as VideoRights,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<VideoTag>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$BvidInfoImpl implements _BvidInfo {
  const _$BvidInfoImpl(
      {required this.bvid,
      this.aid,
      required this.title,
      this.description = '',
      this.pubdate,
      this.tname,
      required this.owner,
      this.ownerUid,
      this.ownerFace,
      this.coverUrl,
      final List<PageInfo> pages = const [],
      this.duration = 0,
      this.stats = const VideoStats(),
      this.rights = const VideoRights(),
      final List<VideoTag> tags = const []})
      : _pages = pages,
        _tags = tags;

  factory _$BvidInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BvidInfoImplFromJson(json);

  /// Bilibili BV number.
  @override
  final String bvid;

  /// Bilibili AV number.
  @override
  final int? aid;

  /// Video title.
  @override
  final String title;

  /// Video description.
  @override
  @JsonKey()
  final String description;

  /// Published timestamp in seconds.
  @override
  final int? pubdate;

  /// Bilibili category name.
  @override
  final String? tname;

  /// Video owner (UP主) display name.
  @override
  final String owner;

  /// Video owner UID.
  @override
  final int? ownerUid;

  /// Video owner avatar URL.
  @override
  final String? ownerFace;

  /// Cover image URL.
  @override
  final String? coverUrl;

  /// List of video pages (分P). Single-page videos have one entry.
  final List<PageInfo> _pages;

  /// List of video pages (分P). Single-page videos have one entry.
  @override
  @JsonKey()
  List<PageInfo> get pages {
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pages);
  }

  /// Total duration in seconds (all pages combined).
  @override
  @JsonKey()
  final int duration;

  /// Video engagement counters.
  @override
  @JsonKey()
  final VideoStats stats;

  /// Video permission and copyright flags.
  @override
  @JsonKey()
  final VideoRights rights;

  /// Tags associated with this video.
  final List<VideoTag> _tags;

  /// Tags associated with this video.
  @override
  @JsonKey()
  List<VideoTag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'BvidInfo(bvid: $bvid, aid: $aid, title: $title, description: $description, pubdate: $pubdate, tname: $tname, owner: $owner, ownerUid: $ownerUid, ownerFace: $ownerFace, coverUrl: $coverUrl, pages: $pages, duration: $duration, stats: $stats, rights: $rights, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BvidInfoImpl &&
            (identical(other.bvid, bvid) || other.bvid == bvid) &&
            (identical(other.aid, aid) || other.aid == aid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.pubdate, pubdate) || other.pubdate == pubdate) &&
            (identical(other.tname, tname) || other.tname == tname) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.ownerUid, ownerUid) ||
                other.ownerUid == ownerUid) &&
            (identical(other.ownerFace, ownerFace) ||
                other.ownerFace == ownerFace) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            const DeepCollectionEquality().equals(other._pages, _pages) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.rights, rights) || other.rights == rights) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bvid,
      aid,
      title,
      description,
      pubdate,
      tname,
      owner,
      ownerUid,
      ownerFace,
      coverUrl,
      const DeepCollectionEquality().hash(_pages),
      duration,
      stats,
      rights,
      const DeepCollectionEquality().hash(_tags));

  /// Create a copy of BvidInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BvidInfoImplCopyWith<_$BvidInfoImpl> get copyWith =>
      __$$BvidInfoImplCopyWithImpl<_$BvidInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BvidInfoImplToJson(
      this,
    );
  }
}

abstract class _BvidInfo implements BvidInfo {
  const factory _BvidInfo(
      {required final String bvid,
      final int? aid,
      required final String title,
      final String description,
      final int? pubdate,
      final String? tname,
      required final String owner,
      final int? ownerUid,
      final String? ownerFace,
      final String? coverUrl,
      final List<PageInfo> pages,
      final int duration,
      final VideoStats stats,
      final VideoRights rights,
      final List<VideoTag> tags}) = _$BvidInfoImpl;

  factory _BvidInfo.fromJson(Map<String, dynamic> json) =
      _$BvidInfoImpl.fromJson;

  /// Bilibili BV number.
  @override
  String get bvid;

  /// Bilibili AV number.
  @override
  int? get aid;

  /// Video title.
  @override
  String get title;

  /// Video description.
  @override
  String get description;

  /// Published timestamp in seconds.
  @override
  int? get pubdate;

  /// Bilibili category name.
  @override
  String? get tname;

  /// Video owner (UP主) display name.
  @override
  String get owner;

  /// Video owner UID.
  @override
  int? get ownerUid;

  /// Video owner avatar URL.
  @override
  String? get ownerFace;

  /// Cover image URL.
  @override
  String? get coverUrl;

  /// List of video pages (分P). Single-page videos have one entry.
  @override
  List<PageInfo> get pages;

  /// Total duration in seconds (all pages combined).
  @override
  int get duration;

  /// Video engagement counters.
  @override
  VideoStats get stats;

  /// Video permission and copyright flags.
  @override
  VideoRights get rights;

  /// Tags associated with this video.
  @override
  List<VideoTag> get tags;

  /// Create a copy of BvidInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BvidInfoImplCopyWith<_$BvidInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
