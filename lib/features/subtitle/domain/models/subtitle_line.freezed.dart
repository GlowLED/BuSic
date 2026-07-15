// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subtitle_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubtitleLine {

/// Start time in seconds.
 double get startTime;/// End time in seconds.
 double get endTime;/// Subtitle text content.
 String get content;/// Music ratio (0.0 = speech, 1.0 = music/lyrics).
 double get musicRatio;
/// Create a copy of SubtitleLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubtitleLineCopyWith<SubtitleLine> get copyWith => _$SubtitleLineCopyWithImpl<SubtitleLine>(this as SubtitleLine, _$identity);

  /// Serializes this SubtitleLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubtitleLine&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.content, content) || other.content == content)&&(identical(other.musicRatio, musicRatio) || other.musicRatio == musicRatio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,content,musicRatio);

@override
String toString() {
  return 'SubtitleLine(startTime: $startTime, endTime: $endTime, content: $content, musicRatio: $musicRatio)';
}


}

/// @nodoc
abstract mixin class $SubtitleLineCopyWith<$Res>  {
  factory $SubtitleLineCopyWith(SubtitleLine value, $Res Function(SubtitleLine) _then) = _$SubtitleLineCopyWithImpl;
@useResult
$Res call({
 double startTime, double endTime, String content, double musicRatio
});




}
/// @nodoc
class _$SubtitleLineCopyWithImpl<$Res>
    implements $SubtitleLineCopyWith<$Res> {
  _$SubtitleLineCopyWithImpl(this._self, this._then);

  final SubtitleLine _self;
  final $Res Function(SubtitleLine) _then;

/// Create a copy of SubtitleLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startTime = null,Object? endTime = null,Object? content = null,Object? musicRatio = null,}) {
  return _then(_self.copyWith(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as double,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as double,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,musicRatio: null == musicRatio ? _self.musicRatio : musicRatio // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SubtitleLine].
extension SubtitleLinePatterns on SubtitleLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubtitleLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubtitleLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubtitleLine value)  $default,){
final _that = this;
switch (_that) {
case _SubtitleLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubtitleLine value)?  $default,){
final _that = this;
switch (_that) {
case _SubtitleLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double startTime,  double endTime,  String content,  double musicRatio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubtitleLine() when $default != null:
return $default(_that.startTime,_that.endTime,_that.content,_that.musicRatio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double startTime,  double endTime,  String content,  double musicRatio)  $default,) {final _that = this;
switch (_that) {
case _SubtitleLine():
return $default(_that.startTime,_that.endTime,_that.content,_that.musicRatio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double startTime,  double endTime,  String content,  double musicRatio)?  $default,) {final _that = this;
switch (_that) {
case _SubtitleLine() when $default != null:
return $default(_that.startTime,_that.endTime,_that.content,_that.musicRatio);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubtitleLine implements SubtitleLine {
  const _SubtitleLine({required this.startTime, required this.endTime, required this.content, this.musicRatio = 0.0});
  factory _SubtitleLine.fromJson(Map<String, dynamic> json) => _$SubtitleLineFromJson(json);

/// Start time in seconds.
@override final  double startTime;
/// End time in seconds.
@override final  double endTime;
/// Subtitle text content.
@override final  String content;
/// Music ratio (0.0 = speech, 1.0 = music/lyrics).
@override@JsonKey() final  double musicRatio;

/// Create a copy of SubtitleLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubtitleLineCopyWith<_SubtitleLine> get copyWith => __$SubtitleLineCopyWithImpl<_SubtitleLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubtitleLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubtitleLine&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.content, content) || other.content == content)&&(identical(other.musicRatio, musicRatio) || other.musicRatio == musicRatio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,content,musicRatio);

@override
String toString() {
  return 'SubtitleLine(startTime: $startTime, endTime: $endTime, content: $content, musicRatio: $musicRatio)';
}


}

/// @nodoc
abstract mixin class _$SubtitleLineCopyWith<$Res> implements $SubtitleLineCopyWith<$Res> {
  factory _$SubtitleLineCopyWith(_SubtitleLine value, $Res Function(_SubtitleLine) _then) = __$SubtitleLineCopyWithImpl;
@override @useResult
$Res call({
 double startTime, double endTime, String content, double musicRatio
});




}
/// @nodoc
class __$SubtitleLineCopyWithImpl<$Res>
    implements _$SubtitleLineCopyWith<$Res> {
  __$SubtitleLineCopyWithImpl(this._self, this._then);

  final _SubtitleLine _self;
  final $Res Function(_SubtitleLine) _then;

/// Create a copy of SubtitleLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startTime = null,Object? endTime = null,Object? content = null,Object? musicRatio = null,}) {
  return _then(_SubtitleLine(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as double,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as double,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,musicRatio: null == musicRatio ? _self.musicRatio : musicRatio // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
