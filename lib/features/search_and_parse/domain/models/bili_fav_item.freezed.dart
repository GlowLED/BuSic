// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bili_fav_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BiliFavItem {
  /// BV 号
  String get bvid => throw _privateConstructorUsedError;

  /// 视频标题
  String get title => throw _privateConstructorUsedError;

  /// UP 主名称
  String get upper => throw _privateConstructorUsedError;

  /// 封面 URL
  String? get cover => throw _privateConstructorUsedError;

  /// 时长（秒）
  int get duration => throw _privateConstructorUsedError;

  /// 首 P 的 CID
  int get firstCid => throw _privateConstructorUsedError;

  /// 是否已失效（B 站 attr 第 9 位）
  bool get isInvalid => throw _privateConstructorUsedError;

  /// Create a copy of BiliFavItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BiliFavItemCopyWith<BiliFavItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BiliFavItemCopyWith<$Res> {
  factory $BiliFavItemCopyWith(
          BiliFavItem value, $Res Function(BiliFavItem) then) =
      _$BiliFavItemCopyWithImpl<$Res, BiliFavItem>;
  @useResult
  $Res call(
      {String bvid,
      String title,
      String upper,
      String? cover,
      int duration,
      int firstCid,
      bool isInvalid});
}

/// @nodoc
class _$BiliFavItemCopyWithImpl<$Res, $Val extends BiliFavItem>
    implements $BiliFavItemCopyWith<$Res> {
  _$BiliFavItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BiliFavItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bvid = null,
    Object? title = null,
    Object? upper = null,
    Object? cover = freezed,
    Object? duration = null,
    Object? firstCid = null,
    Object? isInvalid = null,
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
      upper: null == upper
          ? _value.upper
          : upper // ignore: cast_nullable_to_non_nullable
              as String,
      cover: freezed == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      firstCid: null == firstCid
          ? _value.firstCid
          : firstCid // ignore: cast_nullable_to_non_nullable
              as int,
      isInvalid: null == isInvalid
          ? _value.isInvalid
          : isInvalid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BiliFavItemImplCopyWith<$Res>
    implements $BiliFavItemCopyWith<$Res> {
  factory _$$BiliFavItemImplCopyWith(
          _$BiliFavItemImpl value, $Res Function(_$BiliFavItemImpl) then) =
      __$$BiliFavItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bvid,
      String title,
      String upper,
      String? cover,
      int duration,
      int firstCid,
      bool isInvalid});
}

/// @nodoc
class __$$BiliFavItemImplCopyWithImpl<$Res>
    extends _$BiliFavItemCopyWithImpl<$Res, _$BiliFavItemImpl>
    implements _$$BiliFavItemImplCopyWith<$Res> {
  __$$BiliFavItemImplCopyWithImpl(
      _$BiliFavItemImpl _value, $Res Function(_$BiliFavItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiliFavItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bvid = null,
    Object? title = null,
    Object? upper = null,
    Object? cover = freezed,
    Object? duration = null,
    Object? firstCid = null,
    Object? isInvalid = null,
  }) {
    return _then(_$BiliFavItemImpl(
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      upper: null == upper
          ? _value.upper
          : upper // ignore: cast_nullable_to_non_nullable
              as String,
      cover: freezed == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      firstCid: null == firstCid
          ? _value.firstCid
          : firstCid // ignore: cast_nullable_to_non_nullable
              as int,
      isInvalid: null == isInvalid
          ? _value.isInvalid
          : isInvalid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BiliFavItemImpl implements _BiliFavItem {
  const _$BiliFavItemImpl(
      {required this.bvid,
      required this.title,
      required this.upper,
      this.cover,
      required this.duration,
      required this.firstCid,
      this.isInvalid = false});

  /// BV 号
  @override
  final String bvid;

  /// 视频标题
  @override
  final String title;

  /// UP 主名称
  @override
  final String upper;

  /// 封面 URL
  @override
  final String? cover;

  /// 时长（秒）
  @override
  final int duration;

  /// 首 P 的 CID
  @override
  final int firstCid;

  /// 是否已失效（B 站 attr 第 9 位）
  @override
  @JsonKey()
  final bool isInvalid;

  @override
  String toString() {
    return 'BiliFavItem(bvid: $bvid, title: $title, upper: $upper, cover: $cover, duration: $duration, firstCid: $firstCid, isInvalid: $isInvalid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BiliFavItemImpl &&
            (identical(other.bvid, bvid) || other.bvid == bvid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.upper, upper) || other.upper == upper) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.firstCid, firstCid) ||
                other.firstCid == firstCid) &&
            (identical(other.isInvalid, isInvalid) ||
                other.isInvalid == isInvalid));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, bvid, title, upper, cover, duration, firstCid, isInvalid);

  /// Create a copy of BiliFavItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BiliFavItemImplCopyWith<_$BiliFavItemImpl> get copyWith =>
      __$$BiliFavItemImplCopyWithImpl<_$BiliFavItemImpl>(this, _$identity);
}

abstract class _BiliFavItem implements BiliFavItem {
  const factory _BiliFavItem(
      {required final String bvid,
      required final String title,
      required final String upper,
      final String? cover,
      required final int duration,
      required final int firstCid,
      final bool isInvalid}) = _$BiliFavItemImpl;

  /// BV 号
  @override
  String get bvid;

  /// 视频标题
  @override
  String get title;

  /// UP 主名称
  @override
  String get upper;

  /// 封面 URL
  @override
  String? get cover;

  /// 时长（秒）
  @override
  int get duration;

  /// 首 P 的 CID
  @override
  int get firstCid;

  /// 是否已失效（B 站 attr 第 9 位）
  @override
  bool get isInvalid;

  /// Create a copy of BiliFavItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BiliFavItemImplCopyWith<_$BiliFavItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
