// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommentState {

/// Resolved numeric AID for the video.
 int get aid;/// Loaded comments.
 List<Comment> get comments;/// Pagination cursor for the next page.
 int get nextCursor;/// Whether all comments have been loaded.
 bool get isEnd;/// Sort mode: 2 = time (最新), 3 = popularity (热门).
 int get sortMode;/// Total comment count.
 int get totalCount;/// Whether more comments are being loaded.
 bool get isLoadingMore;
/// Create a copy of CommentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentStateCopyWith<CommentState> get copyWith => _$CommentStateCopyWithImpl<CommentState>(this as CommentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentState&&(identical(other.aid, aid) || other.aid == aid)&&const DeepCollectionEquality().equals(other.comments, comments)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.isEnd, isEnd) || other.isEnd == isEnd)&&(identical(other.sortMode, sortMode) || other.sortMode == sortMode)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,aid,const DeepCollectionEquality().hash(comments),nextCursor,isEnd,sortMode,totalCount,isLoadingMore);

@override
String toString() {
  return 'CommentState(aid: $aid, comments: $comments, nextCursor: $nextCursor, isEnd: $isEnd, sortMode: $sortMode, totalCount: $totalCount, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $CommentStateCopyWith<$Res>  {
  factory $CommentStateCopyWith(CommentState value, $Res Function(CommentState) _then) = _$CommentStateCopyWithImpl;
@useResult
$Res call({
 int aid, List<Comment> comments, int nextCursor, bool isEnd, int sortMode, int totalCount, bool isLoadingMore
});




}
/// @nodoc
class _$CommentStateCopyWithImpl<$Res>
    implements $CommentStateCopyWith<$Res> {
  _$CommentStateCopyWithImpl(this._self, this._then);

  final CommentState _self;
  final $Res Function(CommentState) _then;

/// Create a copy of CommentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aid = null,Object? comments = null,Object? nextCursor = null,Object? isEnd = null,Object? sortMode = null,Object? totalCount = null,Object? isLoadingMore = null,}) {
  return _then(_self.copyWith(
aid: null == aid ? _self.aid : aid // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as int,isEnd: null == isEnd ? _self.isEnd : isEnd // ignore: cast_nullable_to_non_nullable
as bool,sortMode: null == sortMode ? _self.sortMode : sortMode // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentState].
extension CommentStatePatterns on CommentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentState value)  $default,){
final _that = this;
switch (_that) {
case _CommentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentState value)?  $default,){
final _that = this;
switch (_that) {
case _CommentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int aid,  List<Comment> comments,  int nextCursor,  bool isEnd,  int sortMode,  int totalCount,  bool isLoadingMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentState() when $default != null:
return $default(_that.aid,_that.comments,_that.nextCursor,_that.isEnd,_that.sortMode,_that.totalCount,_that.isLoadingMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int aid,  List<Comment> comments,  int nextCursor,  bool isEnd,  int sortMode,  int totalCount,  bool isLoadingMore)  $default,) {final _that = this;
switch (_that) {
case _CommentState():
return $default(_that.aid,_that.comments,_that.nextCursor,_that.isEnd,_that.sortMode,_that.totalCount,_that.isLoadingMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int aid,  List<Comment> comments,  int nextCursor,  bool isEnd,  int sortMode,  int totalCount,  bool isLoadingMore)?  $default,) {final _that = this;
switch (_that) {
case _CommentState() when $default != null:
return $default(_that.aid,_that.comments,_that.nextCursor,_that.isEnd,_that.sortMode,_that.totalCount,_that.isLoadingMore);case _:
  return null;

}
}

}

/// @nodoc


class _CommentState implements CommentState {
  const _CommentState({this.aid = 0, final  List<Comment> comments = const [], this.nextCursor = 0, this.isEnd = false, this.sortMode = 3, this.totalCount = 0, this.isLoadingMore = false}): _comments = comments;
  

/// Resolved numeric AID for the video.
@override@JsonKey() final  int aid;
/// Loaded comments.
 final  List<Comment> _comments;
/// Loaded comments.
@override@JsonKey() List<Comment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

/// Pagination cursor for the next page.
@override@JsonKey() final  int nextCursor;
/// Whether all comments have been loaded.
@override@JsonKey() final  bool isEnd;
/// Sort mode: 2 = time (最新), 3 = popularity (热门).
@override@JsonKey() final  int sortMode;
/// Total comment count.
@override@JsonKey() final  int totalCount;
/// Whether more comments are being loaded.
@override@JsonKey() final  bool isLoadingMore;

/// Create a copy of CommentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentStateCopyWith<_CommentState> get copyWith => __$CommentStateCopyWithImpl<_CommentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentState&&(identical(other.aid, aid) || other.aid == aid)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.isEnd, isEnd) || other.isEnd == isEnd)&&(identical(other.sortMode, sortMode) || other.sortMode == sortMode)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,aid,const DeepCollectionEquality().hash(_comments),nextCursor,isEnd,sortMode,totalCount,isLoadingMore);

@override
String toString() {
  return 'CommentState(aid: $aid, comments: $comments, nextCursor: $nextCursor, isEnd: $isEnd, sortMode: $sortMode, totalCount: $totalCount, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class _$CommentStateCopyWith<$Res> implements $CommentStateCopyWith<$Res> {
  factory _$CommentStateCopyWith(_CommentState value, $Res Function(_CommentState) _then) = __$CommentStateCopyWithImpl;
@override @useResult
$Res call({
 int aid, List<Comment> comments, int nextCursor, bool isEnd, int sortMode, int totalCount, bool isLoadingMore
});




}
/// @nodoc
class __$CommentStateCopyWithImpl<$Res>
    implements _$CommentStateCopyWith<$Res> {
  __$CommentStateCopyWithImpl(this._self, this._then);

  final _CommentState _self;
  final $Res Function(_CommentState) _then;

/// Create a copy of CommentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aid = null,Object? comments = null,Object? nextCursor = null,Object? isEnd = null,Object? sortMode = null,Object? totalCount = null,Object? isLoadingMore = null,}) {
  return _then(_CommentState(
aid: null == aid ? _self.aid : aid // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as int,isEnd: null == isEnd ? _self.isEnd : isEnd // ignore: cast_nullable_to_non_nullable
as bool,sortMode: null == sortMode ? _self.sortMode : sortMode // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
