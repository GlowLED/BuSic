// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParseState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ParseState()';
}


}

/// @nodoc
class $ParseStateCopyWith<$Res>  {
$ParseStateCopyWith(ParseState _, $Res Function(ParseState) __);
}


/// Adds pattern-matching-related methods to [ParseState].
extension ParseStatePatterns on ParseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Idle value)?  idle,TResult Function( _Parsing value)?  parsing,TResult Function( _Success value)?  success,TResult Function( _SelectingPages value)?  selectingPages,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _Parsing() when parsing != null:
return parsing(_that);case _Success() when success != null:
return success(_that);case _SelectingPages() when selectingPages != null:
return selectingPages(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Idle value)  idle,required TResult Function( _Parsing value)  parsing,required TResult Function( _Success value)  success,required TResult Function( _SelectingPages value)  selectingPages,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Idle():
return idle(_that);case _Parsing():
return parsing(_that);case _Success():
return success(_that);case _SelectingPages():
return selectingPages(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Idle value)?  idle,TResult? Function( _Parsing value)?  parsing,TResult? Function( _Success value)?  success,TResult? Function( _SelectingPages value)?  selectingPages,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _Parsing() when parsing != null:
return parsing(_that);case _Success() when success != null:
return success(_that);case _SelectingPages() when selectingPages != null:
return selectingPages(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  parsing,TResult Function( BvidInfo info)?  success,TResult Function( BvidInfo info,  List<PageInfo> selectedPages)?  selectingPages,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _Parsing() when parsing != null:
return parsing();case _Success() when success != null:
return success(_that.info);case _SelectingPages() when selectingPages != null:
return selectingPages(_that.info,_that.selectedPages);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  parsing,required TResult Function( BvidInfo info)  success,required TResult Function( BvidInfo info,  List<PageInfo> selectedPages)  selectingPages,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Idle():
return idle();case _Parsing():
return parsing();case _Success():
return success(_that.info);case _SelectingPages():
return selectingPages(_that.info,_that.selectedPages);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  parsing,TResult? Function( BvidInfo info)?  success,TResult? Function( BvidInfo info,  List<PageInfo> selectedPages)?  selectingPages,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _Parsing() when parsing != null:
return parsing();case _Success() when success != null:
return success(_that.info);case _SelectingPages() when selectingPages != null:
return selectingPages(_that.info,_that.selectedPages);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Idle implements ParseState {
  const _Idle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Idle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ParseState.idle()';
}


}




/// @nodoc


class _Parsing implements ParseState {
  const _Parsing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Parsing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ParseState.parsing()';
}


}




/// @nodoc


class _Success implements ParseState {
  const _Success(this.info);
  

 final  BvidInfo info;

/// Create a copy of ParseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.info, info) || other.info == info));
}


@override
int get hashCode => Object.hash(runtimeType,info);

@override
String toString() {
  return 'ParseState.success(info: $info)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $ParseStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 BvidInfo info
});


$BvidInfoCopyWith<$Res> get info;

}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of ParseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? info = null,}) {
  return _then(_Success(
null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as BvidInfo,
  ));
}

/// Create a copy of ParseState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BvidInfoCopyWith<$Res> get info {
  
  return $BvidInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}

/// @nodoc


class _SelectingPages implements ParseState {
  const _SelectingPages(this.info, final  List<PageInfo> selectedPages): _selectedPages = selectedPages;
  

 final  BvidInfo info;
 final  List<PageInfo> _selectedPages;
 List<PageInfo> get selectedPages {
  if (_selectedPages is EqualUnmodifiableListView) return _selectedPages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedPages);
}


/// Create a copy of ParseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectingPagesCopyWith<_SelectingPages> get copyWith => __$SelectingPagesCopyWithImpl<_SelectingPages>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectingPages&&(identical(other.info, info) || other.info == info)&&const DeepCollectionEquality().equals(other._selectedPages, _selectedPages));
}


@override
int get hashCode => Object.hash(runtimeType,info,const DeepCollectionEquality().hash(_selectedPages));

@override
String toString() {
  return 'ParseState.selectingPages(info: $info, selectedPages: $selectedPages)';
}


}

/// @nodoc
abstract mixin class _$SelectingPagesCopyWith<$Res> implements $ParseStateCopyWith<$Res> {
  factory _$SelectingPagesCopyWith(_SelectingPages value, $Res Function(_SelectingPages) _then) = __$SelectingPagesCopyWithImpl;
@useResult
$Res call({
 BvidInfo info, List<PageInfo> selectedPages
});


$BvidInfoCopyWith<$Res> get info;

}
/// @nodoc
class __$SelectingPagesCopyWithImpl<$Res>
    implements _$SelectingPagesCopyWith<$Res> {
  __$SelectingPagesCopyWithImpl(this._self, this._then);

  final _SelectingPages _self;
  final $Res Function(_SelectingPages) _then;

/// Create a copy of ParseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? info = null,Object? selectedPages = null,}) {
  return _then(_SelectingPages(
null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as BvidInfo,null == selectedPages ? _self._selectedPages : selectedPages // ignore: cast_nullable_to_non_nullable
as List<PageInfo>,
  ));
}

/// Create a copy of ParseState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BvidInfoCopyWith<$Res> get info {
  
  return $BvidInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}

/// @nodoc


class _Error implements ParseState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of ParseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ParseState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ParseStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ParseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
