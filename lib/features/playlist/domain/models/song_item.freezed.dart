// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SongItem _$SongItemFromJson(Map<String, dynamic> json) {
  return _SongItem.fromJson(json);
}

/// @nodoc
mixin _$SongItem {
  /// Database primary key.
  int get id => throw _privateConstructorUsedError;

  /// Bilibili BV number.
  String get bvid => throw _privateConstructorUsedError;

  /// Bilibili CID.
  int get cid => throw _privateConstructorUsedError;

  /// Original title from Bilibili.
  String get originTitle => throw _privateConstructorUsedError;

  /// Original artist (UP主) from Bilibili.
  String get originArtist => throw _privateConstructorUsedError;

  /// User-customized title override.
  String? get customTitle => throw _privateConstructorUsedError;

  /// User-customized artist override.
  String? get customArtist => throw _privateConstructorUsedError;

  /// Cover image URL.
  String? get coverUrl => throw _privateConstructorUsedError;

  /// Duration in seconds.
  int get duration => throw _privateConstructorUsedError;

  /// Local file path if cached.
  String? get localPath => throw _privateConstructorUsedError;

  /// Serializes this SongItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SongItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SongItemCopyWith<SongItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongItemCopyWith<$Res> {
  factory $SongItemCopyWith(SongItem value, $Res Function(SongItem) then) =
      _$SongItemCopyWithImpl<$Res, SongItem>;
  @useResult
  $Res call(
      {int id,
      String bvid,
      int cid,
      String originTitle,
      String originArtist,
      String? customTitle,
      String? customArtist,
      String? coverUrl,
      int duration,
      String? localPath});
}

/// @nodoc
class _$SongItemCopyWithImpl<$Res, $Val extends SongItem>
    implements $SongItemCopyWith<$Res> {
  _$SongItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SongItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bvid = null,
    Object? cid = null,
    Object? originTitle = null,
    Object? originArtist = null,
    Object? customTitle = freezed,
    Object? customArtist = freezed,
    Object? coverUrl = freezed,
    Object? duration = null,
    Object? localPath = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      cid: null == cid
          ? _value.cid
          : cid // ignore: cast_nullable_to_non_nullable
              as int,
      originTitle: null == originTitle
          ? _value.originTitle
          : originTitle // ignore: cast_nullable_to_non_nullable
              as String,
      originArtist: null == originArtist
          ? _value.originArtist
          : originArtist // ignore: cast_nullable_to_non_nullable
              as String,
      customTitle: freezed == customTitle
          ? _value.customTitle
          : customTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      customArtist: freezed == customArtist
          ? _value.customArtist
          : customArtist // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      localPath: freezed == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SongItemImplCopyWith<$Res>
    implements $SongItemCopyWith<$Res> {
  factory _$$SongItemImplCopyWith(
          _$SongItemImpl value, $Res Function(_$SongItemImpl) then) =
      __$$SongItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String bvid,
      int cid,
      String originTitle,
      String originArtist,
      String? customTitle,
      String? customArtist,
      String? coverUrl,
      int duration,
      String? localPath});
}

/// @nodoc
class __$$SongItemImplCopyWithImpl<$Res>
    extends _$SongItemCopyWithImpl<$Res, _$SongItemImpl>
    implements _$$SongItemImplCopyWith<$Res> {
  __$$SongItemImplCopyWithImpl(
      _$SongItemImpl _value, $Res Function(_$SongItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SongItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bvid = null,
    Object? cid = null,
    Object? originTitle = null,
    Object? originArtist = null,
    Object? customTitle = freezed,
    Object? customArtist = freezed,
    Object? coverUrl = freezed,
    Object? duration = null,
    Object? localPath = freezed,
  }) {
    return _then(_$SongItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      cid: null == cid
          ? _value.cid
          : cid // ignore: cast_nullable_to_non_nullable
              as int,
      originTitle: null == originTitle
          ? _value.originTitle
          : originTitle // ignore: cast_nullable_to_non_nullable
              as String,
      originArtist: null == originArtist
          ? _value.originArtist
          : originArtist // ignore: cast_nullable_to_non_nullable
              as String,
      customTitle: freezed == customTitle
          ? _value.customTitle
          : customTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      customArtist: freezed == customArtist
          ? _value.customArtist
          : customArtist // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      localPath: freezed == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SongItemImpl extends _SongItem {
  const _$SongItemImpl(
      {required this.id,
      required this.bvid,
      required this.cid,
      required this.originTitle,
      required this.originArtist,
      this.customTitle,
      this.customArtist,
      this.coverUrl,
      this.duration = 0,
      this.localPath})
      : super._();

  factory _$SongItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongItemImplFromJson(json);

  /// Database primary key.
  @override
  final int id;

  /// Bilibili BV number.
  @override
  final String bvid;

  /// Bilibili CID.
  @override
  final int cid;

  /// Original title from Bilibili.
  @override
  final String originTitle;

  /// Original artist (UP主) from Bilibili.
  @override
  final String originArtist;

  /// User-customized title override.
  @override
  final String? customTitle;

  /// User-customized artist override.
  @override
  final String? customArtist;

  /// Cover image URL.
  @override
  final String? coverUrl;

  /// Duration in seconds.
  @override
  @JsonKey()
  final int duration;

  /// Local file path if cached.
  @override
  final String? localPath;

  @override
  String toString() {
    return 'SongItem(id: $id, bvid: $bvid, cid: $cid, originTitle: $originTitle, originArtist: $originArtist, customTitle: $customTitle, customArtist: $customArtist, coverUrl: $coverUrl, duration: $duration, localPath: $localPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bvid, bvid) || other.bvid == bvid) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.originTitle, originTitle) ||
                other.originTitle == originTitle) &&
            (identical(other.originArtist, originArtist) ||
                other.originArtist == originArtist) &&
            (identical(other.customTitle, customTitle) ||
                other.customTitle == customTitle) &&
            (identical(other.customArtist, customArtist) ||
                other.customArtist == customArtist) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, bvid, cid, originTitle,
      originArtist, customTitle, customArtist, coverUrl, duration, localPath);

  /// Create a copy of SongItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SongItemImplCopyWith<_$SongItemImpl> get copyWith =>
      __$$SongItemImplCopyWithImpl<_$SongItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SongItemImplToJson(
      this,
    );
  }
}

abstract class _SongItem extends SongItem {
  const factory _SongItem(
      {required final int id,
      required final String bvid,
      required final int cid,
      required final String originTitle,
      required final String originArtist,
      final String? customTitle,
      final String? customArtist,
      final String? coverUrl,
      final int duration,
      final String? localPath}) = _$SongItemImpl;
  const _SongItem._() : super._();

  factory _SongItem.fromJson(Map<String, dynamic> json) =
      _$SongItemImpl.fromJson;

  /// Database primary key.
  @override
  int get id;

  /// Bilibili BV number.
  @override
  String get bvid;

  /// Bilibili CID.
  @override
  int get cid;

  /// Original title from Bilibili.
  @override
  String get originTitle;

  /// Original artist (UP主) from Bilibili.
  @override
  String get originArtist;

  /// User-customized title override.
  @override
  String? get customTitle;

  /// User-customized artist override.
  @override
  String? get customArtist;

  /// Cover image URL.
  @override
  String? get coverUrl;

  /// Duration in seconds.
  @override
  int get duration;

  /// Local file path if cached.
  @override
  String? get localPath;

  /// Create a copy of SongItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SongItemImplCopyWith<_$SongItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
