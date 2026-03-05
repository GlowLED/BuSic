// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bili_fav_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BiliFavFolder {
  /// 收藏夹 media_id（用于查询收藏夹内容）
  int get id => throw _privateConstructorUsedError;

  /// 收藏夹标题
  String get title => throw _privateConstructorUsedError;

  /// 收藏夹内视频数量
  int get mediaCount => throw _privateConstructorUsedError;

  /// Create a copy of BiliFavFolder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BiliFavFolderCopyWith<BiliFavFolder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BiliFavFolderCopyWith<$Res> {
  factory $BiliFavFolderCopyWith(
          BiliFavFolder value, $Res Function(BiliFavFolder) then) =
      _$BiliFavFolderCopyWithImpl<$Res, BiliFavFolder>;
  @useResult
  $Res call({int id, String title, int mediaCount});
}

/// @nodoc
class _$BiliFavFolderCopyWithImpl<$Res, $Val extends BiliFavFolder>
    implements $BiliFavFolderCopyWith<$Res> {
  _$BiliFavFolderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BiliFavFolder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? mediaCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      mediaCount: null == mediaCount
          ? _value.mediaCount
          : mediaCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BiliFavFolderImplCopyWith<$Res>
    implements $BiliFavFolderCopyWith<$Res> {
  factory _$$BiliFavFolderImplCopyWith(
          _$BiliFavFolderImpl value, $Res Function(_$BiliFavFolderImpl) then) =
      __$$BiliFavFolderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String title, int mediaCount});
}

/// @nodoc
class __$$BiliFavFolderImplCopyWithImpl<$Res>
    extends _$BiliFavFolderCopyWithImpl<$Res, _$BiliFavFolderImpl>
    implements _$$BiliFavFolderImplCopyWith<$Res> {
  __$$BiliFavFolderImplCopyWithImpl(
      _$BiliFavFolderImpl _value, $Res Function(_$BiliFavFolderImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiliFavFolder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? mediaCount = null,
  }) {
    return _then(_$BiliFavFolderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      mediaCount: null == mediaCount
          ? _value.mediaCount
          : mediaCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BiliFavFolderImpl implements _BiliFavFolder {
  const _$BiliFavFolderImpl(
      {required this.id, required this.title, required this.mediaCount});

  /// 收藏夹 media_id（用于查询收藏夹内容）
  @override
  final int id;

  /// 收藏夹标题
  @override
  final String title;

  /// 收藏夹内视频数量
  @override
  final int mediaCount;

  @override
  String toString() {
    return 'BiliFavFolder(id: $id, title: $title, mediaCount: $mediaCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BiliFavFolderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.mediaCount, mediaCount) ||
                other.mediaCount == mediaCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, mediaCount);

  /// Create a copy of BiliFavFolder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BiliFavFolderImplCopyWith<_$BiliFavFolderImpl> get copyWith =>
      __$$BiliFavFolderImplCopyWithImpl<_$BiliFavFolderImpl>(this, _$identity);
}

abstract class _BiliFavFolder implements BiliFavFolder {
  const factory _BiliFavFolder(
      {required final int id,
      required final String title,
      required final int mediaCount}) = _$BiliFavFolderImpl;

  /// 收藏夹 media_id（用于查询收藏夹内容）
  @override
  int get id;

  /// 收藏夹标题
  @override
  String get title;

  /// 收藏夹内视频数量
  @override
  int get mediaCount;

  /// Create a copy of BiliFavFolder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BiliFavFolderImplCopyWith<_$BiliFavFolderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
