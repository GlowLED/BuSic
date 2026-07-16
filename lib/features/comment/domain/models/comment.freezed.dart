// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Comment {

/// Comment ID (rpid).
 int get rpid;/// Commenter's user ID.
 int get mid;/// Commenter's display name.
 String get username;/// Commenter's avatar URL.
 String get avatarUrl;/// Comment text content.
 String get content;/// Unix timestamp in seconds.
 int get ctime;/// Number of likes.
 int get likeCount;/// Number of replies (child comments).
 int get replyCount;/// Whether the current user has liked this comment.
 bool get isLiked;/// Preview of child replies (usually 0-3 from the main list).
 List<Comment> get replies;/// Images attached to the comment.
 List<CommentImage> get images;
/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentCopyWith<Comment> get copyWith => _$CommentCopyWithImpl<Comment>(this as Comment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Comment&&(identical(other.rpid, rpid) || other.rpid == rpid)&&(identical(other.mid, mid) || other.mid == mid)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.content, content) || other.content == content)&&(identical(other.ctime, ctime) || other.ctime == ctime)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&const DeepCollectionEquality().equals(other.replies, replies)&&const DeepCollectionEquality().equals(other.images, images));
}


@override
int get hashCode => Object.hash(runtimeType,rpid,mid,username,avatarUrl,content,ctime,likeCount,replyCount,isLiked,const DeepCollectionEquality().hash(replies),const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'Comment(rpid: $rpid, mid: $mid, username: $username, avatarUrl: $avatarUrl, content: $content, ctime: $ctime, likeCount: $likeCount, replyCount: $replyCount, isLiked: $isLiked, replies: $replies, images: $images)';
}


}

/// @nodoc
abstract mixin class $CommentCopyWith<$Res>  {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) _then) = _$CommentCopyWithImpl;
@useResult
$Res call({
 int rpid, int mid, String username, String avatarUrl, String content, int ctime, int likeCount, int replyCount, bool isLiked, List<Comment> replies, List<CommentImage> images
});




}
/// @nodoc
class _$CommentCopyWithImpl<$Res>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._self, this._then);

  final Comment _self;
  final $Res Function(Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rpid = null,Object? mid = null,Object? username = null,Object? avatarUrl = null,Object? content = null,Object? ctime = null,Object? likeCount = null,Object? replyCount = null,Object? isLiked = null,Object? replies = null,Object? images = null,}) {
  return _then(_self.copyWith(
rpid: null == rpid ? _self.rpid : rpid // ignore: cast_nullable_to_non_nullable
as int,mid: null == mid ? _self.mid : mid // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,ctime: null == ctime ? _self.ctime : ctime // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<Comment>,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<CommentImage>,
  ));
}

}


/// Adds pattern-matching-related methods to [Comment].
extension CommentPatterns on Comment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Comment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Comment value)  $default,){
final _that = this;
switch (_that) {
case _Comment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Comment value)?  $default,){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rpid,  int mid,  String username,  String avatarUrl,  String content,  int ctime,  int likeCount,  int replyCount,  bool isLiked,  List<Comment> replies,  List<CommentImage> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.rpid,_that.mid,_that.username,_that.avatarUrl,_that.content,_that.ctime,_that.likeCount,_that.replyCount,_that.isLiked,_that.replies,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rpid,  int mid,  String username,  String avatarUrl,  String content,  int ctime,  int likeCount,  int replyCount,  bool isLiked,  List<Comment> replies,  List<CommentImage> images)  $default,) {final _that = this;
switch (_that) {
case _Comment():
return $default(_that.rpid,_that.mid,_that.username,_that.avatarUrl,_that.content,_that.ctime,_that.likeCount,_that.replyCount,_that.isLiked,_that.replies,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rpid,  int mid,  String username,  String avatarUrl,  String content,  int ctime,  int likeCount,  int replyCount,  bool isLiked,  List<Comment> replies,  List<CommentImage> images)?  $default,) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.rpid,_that.mid,_that.username,_that.avatarUrl,_that.content,_that.ctime,_that.likeCount,_that.replyCount,_that.isLiked,_that.replies,_that.images);case _:
  return null;

}
}

}

/// @nodoc


class _Comment implements Comment {
  const _Comment({required this.rpid, required this.mid, required this.username, required this.avatarUrl, required this.content, required this.ctime, required this.likeCount, required this.replyCount, this.isLiked = false, final  List<Comment> replies = const [], final  List<CommentImage> images = const []}): _replies = replies,_images = images;
  

/// Comment ID (rpid).
@override final  int rpid;
/// Commenter's user ID.
@override final  int mid;
/// Commenter's display name.
@override final  String username;
/// Commenter's avatar URL.
@override final  String avatarUrl;
/// Comment text content.
@override final  String content;
/// Unix timestamp in seconds.
@override final  int ctime;
/// Number of likes.
@override final  int likeCount;
/// Number of replies (child comments).
@override final  int replyCount;
/// Whether the current user has liked this comment.
@override@JsonKey() final  bool isLiked;
/// Preview of child replies (usually 0-3 from the main list).
 final  List<Comment> _replies;
/// Preview of child replies (usually 0-3 from the main list).
@override@JsonKey() List<Comment> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}

/// Images attached to the comment.
 final  List<CommentImage> _images;
/// Images attached to the comment.
@override@JsonKey() List<CommentImage> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentCopyWith<_Comment> get copyWith => __$CommentCopyWithImpl<_Comment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Comment&&(identical(other.rpid, rpid) || other.rpid == rpid)&&(identical(other.mid, mid) || other.mid == mid)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.content, content) || other.content == content)&&(identical(other.ctime, ctime) || other.ctime == ctime)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&const DeepCollectionEquality().equals(other._replies, _replies)&&const DeepCollectionEquality().equals(other._images, _images));
}


@override
int get hashCode => Object.hash(runtimeType,rpid,mid,username,avatarUrl,content,ctime,likeCount,replyCount,isLiked,const DeepCollectionEquality().hash(_replies),const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'Comment(rpid: $rpid, mid: $mid, username: $username, avatarUrl: $avatarUrl, content: $content, ctime: $ctime, likeCount: $likeCount, replyCount: $replyCount, isLiked: $isLiked, replies: $replies, images: $images)';
}


}

/// @nodoc
abstract mixin class _$CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$CommentCopyWith(_Comment value, $Res Function(_Comment) _then) = __$CommentCopyWithImpl;
@override @useResult
$Res call({
 int rpid, int mid, String username, String avatarUrl, String content, int ctime, int likeCount, int replyCount, bool isLiked, List<Comment> replies, List<CommentImage> images
});




}
/// @nodoc
class __$CommentCopyWithImpl<$Res>
    implements _$CommentCopyWith<$Res> {
  __$CommentCopyWithImpl(this._self, this._then);

  final _Comment _self;
  final $Res Function(_Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rpid = null,Object? mid = null,Object? username = null,Object? avatarUrl = null,Object? content = null,Object? ctime = null,Object? likeCount = null,Object? replyCount = null,Object? isLiked = null,Object? replies = null,Object? images = null,}) {
  return _then(_Comment(
rpid: null == rpid ? _self.rpid : rpid // ignore: cast_nullable_to_non_nullable
as int,mid: null == mid ? _self.mid : mid // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,ctime: null == ctime ? _self.ctime : ctime // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<Comment>,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<CommentImage>,
  ));
}


}

// dart format on
