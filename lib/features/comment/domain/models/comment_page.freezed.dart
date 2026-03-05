// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommentPage {
  /// Total number of comments.
  int get totalCount => throw _privateConstructorUsedError;

  /// Cursor for the next page (used in `/x/v2/reply/main`).
  int get next => throw _privateConstructorUsedError;

  /// Whether this is the last page.
  bool get isEnd => throw _privateConstructorUsedError;

  /// Comments in this page.
  List<Comment> get replies => throw _privateConstructorUsedError;

  /// Create a copy of CommentPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentPageCopyWith<CommentPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentPageCopyWith<$Res> {
  factory $CommentPageCopyWith(
          CommentPage value, $Res Function(CommentPage) then) =
      _$CommentPageCopyWithImpl<$Res, CommentPage>;
  @useResult
  $Res call({int totalCount, int next, bool isEnd, List<Comment> replies});
}

/// @nodoc
class _$CommentPageCopyWithImpl<$Res, $Val extends CommentPage>
    implements $CommentPageCopyWith<$Res> {
  _$CommentPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? next = null,
    Object? isEnd = null,
    Object? replies = null,
  }) {
    return _then(_value.copyWith(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      next: null == next
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as int,
      isEnd: null == isEnd
          ? _value.isEnd
          : isEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      replies: null == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentPageImplCopyWith<$Res>
    implements $CommentPageCopyWith<$Res> {
  factory _$$CommentPageImplCopyWith(
          _$CommentPageImpl value, $Res Function(_$CommentPageImpl) then) =
      __$$CommentPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalCount, int next, bool isEnd, List<Comment> replies});
}

/// @nodoc
class __$$CommentPageImplCopyWithImpl<$Res>
    extends _$CommentPageCopyWithImpl<$Res, _$CommentPageImpl>
    implements _$$CommentPageImplCopyWith<$Res> {
  __$$CommentPageImplCopyWithImpl(
      _$CommentPageImpl _value, $Res Function(_$CommentPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? next = null,
    Object? isEnd = null,
    Object? replies = null,
  }) {
    return _then(_$CommentPageImpl(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      next: null == next
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as int,
      isEnd: null == isEnd
          ? _value.isEnd
          : isEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      replies: null == replies
          ? _value._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
    ));
  }
}

/// @nodoc

class _$CommentPageImpl implements _CommentPage {
  const _$CommentPageImpl(
      {required this.totalCount,
      required this.next,
      required this.isEnd,
      required final List<Comment> replies})
      : _replies = replies;

  /// Total number of comments.
  @override
  final int totalCount;

  /// Cursor for the next page (used in `/x/v2/reply/main`).
  @override
  final int next;

  /// Whether this is the last page.
  @override
  final bool isEnd;

  /// Comments in this page.
  final List<Comment> _replies;

  /// Comments in this page.
  @override
  List<Comment> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  @override
  String toString() {
    return 'CommentPage(totalCount: $totalCount, next: $next, isEnd: $isEnd, replies: $replies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentPageImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.isEnd, isEnd) || other.isEnd == isEnd) &&
            const DeepCollectionEquality().equals(other._replies, _replies));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalCount, next, isEnd,
      const DeepCollectionEquality().hash(_replies));

  /// Create a copy of CommentPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentPageImplCopyWith<_$CommentPageImpl> get copyWith =>
      __$$CommentPageImplCopyWithImpl<_$CommentPageImpl>(this, _$identity);
}

abstract class _CommentPage implements CommentPage {
  const factory _CommentPage(
      {required final int totalCount,
      required final int next,
      required final bool isEnd,
      required final List<Comment> replies}) = _$CommentPageImpl;

  /// Total number of comments.
  @override
  int get totalCount;

  /// Cursor for the next page (used in `/x/v2/reply/main`).
  @override
  int get next;

  /// Whether this is the last page.
  @override
  bool get isEnd;

  /// Comments in this page.
  @override
  List<Comment> get replies;

  /// Create a copy of CommentPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentPageImplCopyWith<_$CommentPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
