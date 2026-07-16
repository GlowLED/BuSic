// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommentPage {

/// Total number of comments.
 int get totalCount;/// Cursor for the next page (used in `/x/v2/reply/main`).
 int get next;/// Whether this is the last page.
 bool get isEnd;/// Comments in this page.
 List<Comment> get replies;
/// Create a copy of CommentPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentPageCopyWith<CommentPage> get copyWith => _$CommentPageCopyWithImpl<CommentPage>(this as CommentPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentPage&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.next, next) || other.next == next)&&(identical(other.isEnd, isEnd) || other.isEnd == isEnd)&&const DeepCollectionEquality().equals(other.replies, replies));
}


@override
int get hashCode => Object.hash(runtimeType,totalCount,next,isEnd,const DeepCollectionEquality().hash(replies));

@override
String toString() {
  return 'CommentPage(totalCount: $totalCount, next: $next, isEnd: $isEnd, replies: $replies)';
}


}

/// @nodoc
abstract mixin class $CommentPageCopyWith<$Res>  {
  factory $CommentPageCopyWith(CommentPage value, $Res Function(CommentPage) _then) = _$CommentPageCopyWithImpl;
@useResult
$Res call({
 int totalCount, int next, bool isEnd, List<Comment> replies
});




}
/// @nodoc
class _$CommentPageCopyWithImpl<$Res>
    implements $CommentPageCopyWith<$Res> {
  _$CommentPageCopyWithImpl(this._self, this._then);

  final CommentPage _self;
  final $Res Function(CommentPage) _then;

/// Create a copy of CommentPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCount = null,Object? next = null,Object? isEnd = null,Object? replies = null,}) {
  return _then(_self.copyWith(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as int,isEnd: null == isEnd ? _self.isEnd : isEnd // ignore: cast_nullable_to_non_nullable
as bool,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<Comment>,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentPage].
extension CommentPagePatterns on CommentPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentPage value)  $default,){
final _that = this;
switch (_that) {
case _CommentPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentPage value)?  $default,){
final _that = this;
switch (_that) {
case _CommentPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalCount,  int next,  bool isEnd,  List<Comment> replies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentPage() when $default != null:
return $default(_that.totalCount,_that.next,_that.isEnd,_that.replies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalCount,  int next,  bool isEnd,  List<Comment> replies)  $default,) {final _that = this;
switch (_that) {
case _CommentPage():
return $default(_that.totalCount,_that.next,_that.isEnd,_that.replies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalCount,  int next,  bool isEnd,  List<Comment> replies)?  $default,) {final _that = this;
switch (_that) {
case _CommentPage() when $default != null:
return $default(_that.totalCount,_that.next,_that.isEnd,_that.replies);case _:
  return null;

}
}

}

/// @nodoc


class _CommentPage implements CommentPage {
  const _CommentPage({required this.totalCount, required this.next, required this.isEnd, required final  List<Comment> replies}): _replies = replies;
  

/// Total number of comments.
@override final  int totalCount;
/// Cursor for the next page (used in `/x/v2/reply/main`).
@override final  int next;
/// Whether this is the last page.
@override final  bool isEnd;
/// Comments in this page.
 final  List<Comment> _replies;
/// Comments in this page.
@override List<Comment> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}


/// Create a copy of CommentPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentPageCopyWith<_CommentPage> get copyWith => __$CommentPageCopyWithImpl<_CommentPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentPage&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.next, next) || other.next == next)&&(identical(other.isEnd, isEnd) || other.isEnd == isEnd)&&const DeepCollectionEquality().equals(other._replies, _replies));
}


@override
int get hashCode => Object.hash(runtimeType,totalCount,next,isEnd,const DeepCollectionEquality().hash(_replies));

@override
String toString() {
  return 'CommentPage(totalCount: $totalCount, next: $next, isEnd: $isEnd, replies: $replies)';
}


}

/// @nodoc
abstract mixin class _$CommentPageCopyWith<$Res> implements $CommentPageCopyWith<$Res> {
  factory _$CommentPageCopyWith(_CommentPage value, $Res Function(_CommentPage) _then) = __$CommentPageCopyWithImpl;
@override @useResult
$Res call({
 int totalCount, int next, bool isEnd, List<Comment> replies
});




}
/// @nodoc
class __$CommentPageCopyWithImpl<$Res>
    implements _$CommentPageCopyWith<$Res> {
  __$CommentPageCopyWithImpl(this._self, this._then);

  final _CommentPage _self;
  final $Res Function(_CommentPage) _then;

/// Create a copy of CommentPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCount = null,Object? next = null,Object? isEnd = null,Object? replies = null,}) {
  return _then(_CommentPage(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as int,isEnd: null == isEnd ? _self.isEnd : isEnd // ignore: cast_nullable_to_non_nullable
as bool,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<Comment>,
  ));
}


}

// dart format on
