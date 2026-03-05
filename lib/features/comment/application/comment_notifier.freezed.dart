// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommentState {
  /// Resolved numeric AID for the video.
  int get aid => throw _privateConstructorUsedError;

  /// Loaded comments.
  List<Comment> get comments => throw _privateConstructorUsedError;

  /// Pagination cursor for the next page.
  int get nextCursor => throw _privateConstructorUsedError;

  /// Whether all comments have been loaded.
  bool get isEnd => throw _privateConstructorUsedError;

  /// Sort mode: 2 = time (最新), 3 = popularity (热门).
  int get sortMode => throw _privateConstructorUsedError;

  /// Total comment count.
  int get totalCount => throw _privateConstructorUsedError;

  /// Whether more comments are being loaded.
  bool get isLoadingMore => throw _privateConstructorUsedError;

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentStateCopyWith<CommentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentStateCopyWith<$Res> {
  factory $CommentStateCopyWith(
          CommentState value, $Res Function(CommentState) then) =
      _$CommentStateCopyWithImpl<$Res, CommentState>;
  @useResult
  $Res call(
      {int aid,
      List<Comment> comments,
      int nextCursor,
      bool isEnd,
      int sortMode,
      int totalCount,
      bool isLoadingMore});
}

/// @nodoc
class _$CommentStateCopyWithImpl<$Res, $Val extends CommentState>
    implements $CommentStateCopyWith<$Res> {
  _$CommentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aid = null,
    Object? comments = null,
    Object? nextCursor = null,
    Object? isEnd = null,
    Object? sortMode = null,
    Object? totalCount = null,
    Object? isLoadingMore = null,
  }) {
    return _then(_value.copyWith(
      aid: null == aid
          ? _value.aid
          : aid // ignore: cast_nullable_to_non_nullable
              as int,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      nextCursor: null == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as int,
      isEnd: null == isEnd
          ? _value.isEnd
          : isEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      sortMode: null == sortMode
          ? _value.sortMode
          : sortMode // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentStateImplCopyWith<$Res>
    implements $CommentStateCopyWith<$Res> {
  factory _$$CommentStateImplCopyWith(
          _$CommentStateImpl value, $Res Function(_$CommentStateImpl) then) =
      __$$CommentStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int aid,
      List<Comment> comments,
      int nextCursor,
      bool isEnd,
      int sortMode,
      int totalCount,
      bool isLoadingMore});
}

/// @nodoc
class __$$CommentStateImplCopyWithImpl<$Res>
    extends _$CommentStateCopyWithImpl<$Res, _$CommentStateImpl>
    implements _$$CommentStateImplCopyWith<$Res> {
  __$$CommentStateImplCopyWithImpl(
      _$CommentStateImpl _value, $Res Function(_$CommentStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aid = null,
    Object? comments = null,
    Object? nextCursor = null,
    Object? isEnd = null,
    Object? sortMode = null,
    Object? totalCount = null,
    Object? isLoadingMore = null,
  }) {
    return _then(_$CommentStateImpl(
      aid: null == aid
          ? _value.aid
          : aid // ignore: cast_nullable_to_non_nullable
              as int,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      nextCursor: null == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as int,
      isEnd: null == isEnd
          ? _value.isEnd
          : isEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      sortMode: null == sortMode
          ? _value.sortMode
          : sortMode // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CommentStateImpl implements _CommentState {
  const _$CommentStateImpl(
      {this.aid = 0,
      final List<Comment> comments = const [],
      this.nextCursor = 0,
      this.isEnd = false,
      this.sortMode = 3,
      this.totalCount = 0,
      this.isLoadingMore = false})
      : _comments = comments;

  /// Resolved numeric AID for the video.
  @override
  @JsonKey()
  final int aid;

  /// Loaded comments.
  final List<Comment> _comments;

  /// Loaded comments.
  @override
  @JsonKey()
  List<Comment> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  /// Pagination cursor for the next page.
  @override
  @JsonKey()
  final int nextCursor;

  /// Whether all comments have been loaded.
  @override
  @JsonKey()
  final bool isEnd;

  /// Sort mode: 2 = time (最新), 3 = popularity (热门).
  @override
  @JsonKey()
  final int sortMode;

  /// Total comment count.
  @override
  @JsonKey()
  final int totalCount;

  /// Whether more comments are being loaded.
  @override
  @JsonKey()
  final bool isLoadingMore;

  @override
  String toString() {
    return 'CommentState(aid: $aid, comments: $comments, nextCursor: $nextCursor, isEnd: $isEnd, sortMode: $sortMode, totalCount: $totalCount, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentStateImpl &&
            (identical(other.aid, aid) || other.aid == aid) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.isEnd, isEnd) || other.isEnd == isEnd) &&
            (identical(other.sortMode, sortMode) ||
                other.sortMode == sortMode) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      aid,
      const DeepCollectionEquality().hash(_comments),
      nextCursor,
      isEnd,
      sortMode,
      totalCount,
      isLoadingMore);

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentStateImplCopyWith<_$CommentStateImpl> get copyWith =>
      __$$CommentStateImplCopyWithImpl<_$CommentStateImpl>(this, _$identity);
}

abstract class _CommentState implements CommentState {
  const factory _CommentState(
      {final int aid,
      final List<Comment> comments,
      final int nextCursor,
      final bool isEnd,
      final int sortMode,
      final int totalCount,
      final bool isLoadingMore}) = _$CommentStateImpl;

  /// Resolved numeric AID for the video.
  @override
  int get aid;

  /// Loaded comments.
  @override
  List<Comment> get comments;

  /// Pagination cursor for the next page.
  @override
  int get nextCursor;

  /// Whether all comments have been loaded.
  @override
  bool get isEnd;

  /// Sort mode: 2 = time (最新), 3 = popularity (热门).
  @override
  int get sortMode;

  /// Total comment count.
  @override
  int get totalCount;

  /// Whether more comments are being loaded.
  @override
  bool get isLoadingMore;

  /// Create a copy of CommentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentStateImplCopyWith<_$CommentStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
