// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_interaction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoInteractionState {

/// Whether the current user has liked the video.
 bool get isLiked;/// Whether the current user has added the video to a favorite folder.
 bool get isFavorited;/// Number of coins the current user has given to the video.
 int get coinsGiven;/// Whether an interaction request is in progress.
 bool get isBusy;/// Last interaction error for presentation feedback.
 String? get lastError;
/// Create a copy of VideoInteractionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoInteractionStateCopyWith<VideoInteractionState> get copyWith => _$VideoInteractionStateCopyWithImpl<VideoInteractionState>(this as VideoInteractionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoInteractionState&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited)&&(identical(other.coinsGiven, coinsGiven) || other.coinsGiven == coinsGiven)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}


@override
int get hashCode => Object.hash(runtimeType,isLiked,isFavorited,coinsGiven,isBusy,lastError);

@override
String toString() {
  return 'VideoInteractionState(isLiked: $isLiked, isFavorited: $isFavorited, coinsGiven: $coinsGiven, isBusy: $isBusy, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class $VideoInteractionStateCopyWith<$Res>  {
  factory $VideoInteractionStateCopyWith(VideoInteractionState value, $Res Function(VideoInteractionState) _then) = _$VideoInteractionStateCopyWithImpl;
@useResult
$Res call({
 bool isLiked, bool isFavorited, int coinsGiven, bool isBusy, String? lastError
});




}
/// @nodoc
class _$VideoInteractionStateCopyWithImpl<$Res>
    implements $VideoInteractionStateCopyWith<$Res> {
  _$VideoInteractionStateCopyWithImpl(this._self, this._then);

  final VideoInteractionState _self;
  final $Res Function(VideoInteractionState) _then;

/// Create a copy of VideoInteractionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLiked = null,Object? isFavorited = null,Object? coinsGiven = null,Object? isBusy = null,Object? lastError = freezed,}) {
  return _then(_self.copyWith(
isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isFavorited: null == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool,coinsGiven: null == coinsGiven ? _self.coinsGiven : coinsGiven // ignore: cast_nullable_to_non_nullable
as int,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoInteractionState].
extension VideoInteractionStatePatterns on VideoInteractionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoInteractionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoInteractionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoInteractionState value)  $default,){
final _that = this;
switch (_that) {
case _VideoInteractionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoInteractionState value)?  $default,){
final _that = this;
switch (_that) {
case _VideoInteractionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLiked,  bool isFavorited,  int coinsGiven,  bool isBusy,  String? lastError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoInteractionState() when $default != null:
return $default(_that.isLiked,_that.isFavorited,_that.coinsGiven,_that.isBusy,_that.lastError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLiked,  bool isFavorited,  int coinsGiven,  bool isBusy,  String? lastError)  $default,) {final _that = this;
switch (_that) {
case _VideoInteractionState():
return $default(_that.isLiked,_that.isFavorited,_that.coinsGiven,_that.isBusy,_that.lastError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLiked,  bool isFavorited,  int coinsGiven,  bool isBusy,  String? lastError)?  $default,) {final _that = this;
switch (_that) {
case _VideoInteractionState() when $default != null:
return $default(_that.isLiked,_that.isFavorited,_that.coinsGiven,_that.isBusy,_that.lastError);case _:
  return null;

}
}

}

/// @nodoc


class _VideoInteractionState implements VideoInteractionState {
  const _VideoInteractionState({this.isLiked = false, this.isFavorited = false, this.coinsGiven = 0, this.isBusy = false, this.lastError});
  

/// Whether the current user has liked the video.
@override@JsonKey() final  bool isLiked;
/// Whether the current user has added the video to a favorite folder.
@override@JsonKey() final  bool isFavorited;
/// Number of coins the current user has given to the video.
@override@JsonKey() final  int coinsGiven;
/// Whether an interaction request is in progress.
@override@JsonKey() final  bool isBusy;
/// Last interaction error for presentation feedback.
@override final  String? lastError;

/// Create a copy of VideoInteractionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoInteractionStateCopyWith<_VideoInteractionState> get copyWith => __$VideoInteractionStateCopyWithImpl<_VideoInteractionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoInteractionState&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited)&&(identical(other.coinsGiven, coinsGiven) || other.coinsGiven == coinsGiven)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}


@override
int get hashCode => Object.hash(runtimeType,isLiked,isFavorited,coinsGiven,isBusy,lastError);

@override
String toString() {
  return 'VideoInteractionState(isLiked: $isLiked, isFavorited: $isFavorited, coinsGiven: $coinsGiven, isBusy: $isBusy, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class _$VideoInteractionStateCopyWith<$Res> implements $VideoInteractionStateCopyWith<$Res> {
  factory _$VideoInteractionStateCopyWith(_VideoInteractionState value, $Res Function(_VideoInteractionState) _then) = __$VideoInteractionStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLiked, bool isFavorited, int coinsGiven, bool isBusy, String? lastError
});




}
/// @nodoc
class __$VideoInteractionStateCopyWithImpl<$Res>
    implements _$VideoInteractionStateCopyWith<$Res> {
  __$VideoInteractionStateCopyWithImpl(this._self, this._then);

  final _VideoInteractionState _self;
  final $Res Function(_VideoInteractionState) _then;

/// Create a copy of VideoInteractionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLiked = null,Object? isFavorited = null,Object? coinsGiven = null,Object? isBusy = null,Object? lastError = freezed,}) {
  return _then(_VideoInteractionState(
isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isFavorited: null == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool,coinsGiven: null == coinsGiven ? _self.coinsGiven : coinsGiven // ignore: cast_nullable_to_non_nullable
as int,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
