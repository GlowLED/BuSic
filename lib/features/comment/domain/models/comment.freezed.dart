// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Comment {
  /// Comment ID (rpid).
  int get rpid => throw _privateConstructorUsedError;

  /// Commenter's user ID.
  int get mid => throw _privateConstructorUsedError;

  /// Commenter's display name.
  String get username => throw _privateConstructorUsedError;

  /// Commenter's avatar URL.
  String get avatarUrl => throw _privateConstructorUsedError;

  /// Comment text content.
  String get content => throw _privateConstructorUsedError;

  /// Unix timestamp in seconds.
  int get ctime => throw _privateConstructorUsedError;

  /// Number of likes.
  int get likeCount => throw _privateConstructorUsedError;

  /// Number of replies (child comments).
  int get replyCount => throw _privateConstructorUsedError;

  /// Whether the current user has liked this comment.
  bool get isLiked => throw _privateConstructorUsedError;

  /// Preview of child replies (usually 0-3 from the main list).
  List<Comment> get replies => throw _privateConstructorUsedError;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentCopyWith<Comment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) then) =
      _$CommentCopyWithImpl<$Res, Comment>;
  @useResult
  $Res call(
      {int rpid,
      int mid,
      String username,
      String avatarUrl,
      String content,
      int ctime,
      int likeCount,
      int replyCount,
      bool isLiked,
      List<Comment> replies});
}

/// @nodoc
class _$CommentCopyWithImpl<$Res, $Val extends Comment>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rpid = null,
    Object? mid = null,
    Object? username = null,
    Object? avatarUrl = null,
    Object? content = null,
    Object? ctime = null,
    Object? likeCount = null,
    Object? replyCount = null,
    Object? isLiked = null,
    Object? replies = null,
  }) {
    return _then(_value.copyWith(
      rpid: null == rpid
          ? _value.rpid
          : rpid // ignore: cast_nullable_to_non_nullable
              as int,
      mid: null == mid
          ? _value.mid
          : mid // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      ctime: null == ctime
          ? _value.ctime
          : ctime // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      replies: null == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentImplCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$$CommentImplCopyWith(
          _$CommentImpl value, $Res Function(_$CommentImpl) then) =
      __$$CommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int rpid,
      int mid,
      String username,
      String avatarUrl,
      String content,
      int ctime,
      int likeCount,
      int replyCount,
      bool isLiked,
      List<Comment> replies});
}

/// @nodoc
class __$$CommentImplCopyWithImpl<$Res>
    extends _$CommentCopyWithImpl<$Res, _$CommentImpl>
    implements _$$CommentImplCopyWith<$Res> {
  __$$CommentImplCopyWithImpl(
      _$CommentImpl _value, $Res Function(_$CommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rpid = null,
    Object? mid = null,
    Object? username = null,
    Object? avatarUrl = null,
    Object? content = null,
    Object? ctime = null,
    Object? likeCount = null,
    Object? replyCount = null,
    Object? isLiked = null,
    Object? replies = null,
  }) {
    return _then(_$CommentImpl(
      rpid: null == rpid
          ? _value.rpid
          : rpid // ignore: cast_nullable_to_non_nullable
              as int,
      mid: null == mid
          ? _value.mid
          : mid // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      ctime: null == ctime
          ? _value.ctime
          : ctime // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      replies: null == replies
          ? _value._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
    ));
  }
}

/// @nodoc

class _$CommentImpl implements _Comment {
  const _$CommentImpl(
      {required this.rpid,
      required this.mid,
      required this.username,
      required this.avatarUrl,
      required this.content,
      required this.ctime,
      required this.likeCount,
      required this.replyCount,
      this.isLiked = false,
      final List<Comment> replies = const []})
      : _replies = replies;

  /// Comment ID (rpid).
  @override
  final int rpid;

  /// Commenter's user ID.
  @override
  final int mid;

  /// Commenter's display name.
  @override
  final String username;

  /// Commenter's avatar URL.
  @override
  final String avatarUrl;

  /// Comment text content.
  @override
  final String content;

  /// Unix timestamp in seconds.
  @override
  final int ctime;

  /// Number of likes.
  @override
  final int likeCount;

  /// Number of replies (child comments).
  @override
  final int replyCount;

  /// Whether the current user has liked this comment.
  @override
  @JsonKey()
  final bool isLiked;

  /// Preview of child replies (usually 0-3 from the main list).
  final List<Comment> _replies;

  /// Preview of child replies (usually 0-3 from the main list).
  @override
  @JsonKey()
  List<Comment> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  @override
  String toString() {
    return 'Comment(rpid: $rpid, mid: $mid, username: $username, avatarUrl: $avatarUrl, content: $content, ctime: $ctime, likeCount: $likeCount, replyCount: $replyCount, isLiked: $isLiked, replies: $replies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentImpl &&
            (identical(other.rpid, rpid) || other.rpid == rpid) &&
            (identical(other.mid, mid) || other.mid == mid) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.ctime, ctime) || other.ctime == ctime) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            const DeepCollectionEquality().equals(other._replies, _replies));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      rpid,
      mid,
      username,
      avatarUrl,
      content,
      ctime,
      likeCount,
      replyCount,
      isLiked,
      const DeepCollectionEquality().hash(_replies));

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      __$$CommentImplCopyWithImpl<_$CommentImpl>(this, _$identity);
}

abstract class _Comment implements Comment {
  const factory _Comment(
      {required final int rpid,
      required final int mid,
      required final String username,
      required final String avatarUrl,
      required final String content,
      required final int ctime,
      required final int likeCount,
      required final int replyCount,
      final bool isLiked,
      final List<Comment> replies}) = _$CommentImpl;

  /// Comment ID (rpid).
  @override
  int get rpid;

  /// Commenter's user ID.
  @override
  int get mid;

  /// Commenter's display name.
  @override
  String get username;

  /// Commenter's avatar URL.
  @override
  String get avatarUrl;

  /// Comment text content.
  @override
  String get content;

  /// Unix timestamp in seconds.
  @override
  int get ctime;

  /// Number of likes.
  @override
  int get likeCount;

  /// Number of replies (child comments).
  @override
  int get replyCount;

  /// Whether the current user has liked this comment.
  @override
  bool get isLiked;

  /// Preview of child replies (usually 0-3 from the main list).
  @override
  List<Comment> get replies;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
