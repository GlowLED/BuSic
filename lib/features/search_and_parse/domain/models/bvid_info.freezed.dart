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

  /// Video title.
  String get title => throw _privateConstructorUsedError;

  /// Video owner (UP主) display name.
  String get owner => throw _privateConstructorUsedError;

  /// Video owner UID.
  int? get ownerUid => throw _privateConstructorUsedError;

  /// Cover image URL.
  String? get coverUrl => throw _privateConstructorUsedError;

  /// List of video pages (分P). Single-page videos have one entry.
  List<PageInfo> get pages => throw _privateConstructorUsedError;

  /// Total duration in seconds (all pages combined).
  int get duration => throw _privateConstructorUsedError;

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
      String title,
      String owner,
      int? ownerUid,
      String? coverUrl,
      List<PageInfo> pages,
      int duration});
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
    Object? title = null,
    Object? owner = null,
    Object? ownerUid = freezed,
    Object? coverUrl = freezed,
    Object? pages = null,
    Object? duration = null,
  }) {
    return _then(_value.copyWith(
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      ownerUid: freezed == ownerUid
          ? _value.ownerUid
          : ownerUid // ignore: cast_nullable_to_non_nullable
              as int?,
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
    ) as $Val);
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
      String title,
      String owner,
      int? ownerUid,
      String? coverUrl,
      List<PageInfo> pages,
      int duration});
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
    Object? title = null,
    Object? owner = null,
    Object? ownerUid = freezed,
    Object? coverUrl = freezed,
    Object? pages = null,
    Object? duration = null,
  }) {
    return _then(_$BvidInfoImpl(
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      ownerUid: freezed == ownerUid
          ? _value.ownerUid
          : ownerUid // ignore: cast_nullable_to_non_nullable
              as int?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BvidInfoImpl implements _BvidInfo {
  const _$BvidInfoImpl(
      {required this.bvid,
      required this.title,
      required this.owner,
      this.ownerUid,
      this.coverUrl,
      final List<PageInfo> pages = const [],
      this.duration = 0})
      : _pages = pages;

  factory _$BvidInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BvidInfoImplFromJson(json);

  /// Bilibili BV number.
  @override
  final String bvid;

  /// Video title.
  @override
  final String title;

  /// Video owner (UP主) display name.
  @override
  final String owner;

  /// Video owner UID.
  @override
  final int? ownerUid;

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

  @override
  String toString() {
    return 'BvidInfo(bvid: $bvid, title: $title, owner: $owner, ownerUid: $ownerUid, coverUrl: $coverUrl, pages: $pages, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BvidInfoImpl &&
            (identical(other.bvid, bvid) || other.bvid == bvid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.ownerUid, ownerUid) ||
                other.ownerUid == ownerUid) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            const DeepCollectionEquality().equals(other._pages, _pages) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bvid, title, owner, ownerUid,
      coverUrl, const DeepCollectionEquality().hash(_pages), duration);

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
      required final String title,
      required final String owner,
      final int? ownerUid,
      final String? coverUrl,
      final List<PageInfo> pages,
      final int duration}) = _$BvidInfoImpl;

  factory _BvidInfo.fromJson(Map<String, dynamic> json) =
      _$BvidInfoImpl.fromJson;

  /// Bilibili BV number.
  @override
  String get bvid;

  /// Video title.
  @override
  String get title;

  /// Video owner (UP主) display name.
  @override
  String get owner;

  /// Video owner UID.
  @override
  int? get ownerUid;

  /// Cover image URL.
  @override
  String? get coverUrl;

  /// List of video pages (分P). Single-page videos have one entry.
  @override
  List<PageInfo> get pages;

  /// Total duration in seconds (all pages combined).
  @override
  int get duration;

  /// Create a copy of BvidInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BvidInfoImplCopyWith<_$BvidInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
