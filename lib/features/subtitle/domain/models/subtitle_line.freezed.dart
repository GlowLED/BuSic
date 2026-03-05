// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subtitle_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubtitleLine _$SubtitleLineFromJson(Map<String, dynamic> json) {
  return _SubtitleLine.fromJson(json);
}

/// @nodoc
mixin _$SubtitleLine {
  /// Start time in seconds.
  double get startTime => throw _privateConstructorUsedError;

  /// End time in seconds.
  double get endTime => throw _privateConstructorUsedError;

  /// Subtitle text content.
  String get content => throw _privateConstructorUsedError;

  /// Music ratio (0.0 = speech, 1.0 = music/lyrics).
  double get musicRatio => throw _privateConstructorUsedError;

  /// Serializes this SubtitleLine to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubtitleLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubtitleLineCopyWith<SubtitleLine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubtitleLineCopyWith<$Res> {
  factory $SubtitleLineCopyWith(
          SubtitleLine value, $Res Function(SubtitleLine) then) =
      _$SubtitleLineCopyWithImpl<$Res, SubtitleLine>;
  @useResult
  $Res call(
      {double startTime, double endTime, String content, double musicRatio});
}

/// @nodoc
class _$SubtitleLineCopyWithImpl<$Res, $Val extends SubtitleLine>
    implements $SubtitleLineCopyWith<$Res> {
  _$SubtitleLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubtitleLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? content = null,
    Object? musicRatio = null,
  }) {
    return _then(_value.copyWith(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as double,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as double,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      musicRatio: null == musicRatio
          ? _value.musicRatio
          : musicRatio // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubtitleLineImplCopyWith<$Res>
    implements $SubtitleLineCopyWith<$Res> {
  factory _$$SubtitleLineImplCopyWith(
          _$SubtitleLineImpl value, $Res Function(_$SubtitleLineImpl) then) =
      __$$SubtitleLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double startTime, double endTime, String content, double musicRatio});
}

/// @nodoc
class __$$SubtitleLineImplCopyWithImpl<$Res>
    extends _$SubtitleLineCopyWithImpl<$Res, _$SubtitleLineImpl>
    implements _$$SubtitleLineImplCopyWith<$Res> {
  __$$SubtitleLineImplCopyWithImpl(
      _$SubtitleLineImpl _value, $Res Function(_$SubtitleLineImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubtitleLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? content = null,
    Object? musicRatio = null,
  }) {
    return _then(_$SubtitleLineImpl(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as double,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as double,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      musicRatio: null == musicRatio
          ? _value.musicRatio
          : musicRatio // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubtitleLineImpl implements _SubtitleLine {
  const _$SubtitleLineImpl(
      {required this.startTime,
      required this.endTime,
      required this.content,
      this.musicRatio = 0.0});

  factory _$SubtitleLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubtitleLineImplFromJson(json);

  /// Start time in seconds.
  @override
  final double startTime;

  /// End time in seconds.
  @override
  final double endTime;

  /// Subtitle text content.
  @override
  final String content;

  /// Music ratio (0.0 = speech, 1.0 = music/lyrics).
  @override
  @JsonKey()
  final double musicRatio;

  @override
  String toString() {
    return 'SubtitleLine(startTime: $startTime, endTime: $endTime, content: $content, musicRatio: $musicRatio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubtitleLineImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.musicRatio, musicRatio) ||
                other.musicRatio == musicRatio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, startTime, endTime, content, musicRatio);

  /// Create a copy of SubtitleLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubtitleLineImplCopyWith<_$SubtitleLineImpl> get copyWith =>
      __$$SubtitleLineImplCopyWithImpl<_$SubtitleLineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubtitleLineImplToJson(
      this,
    );
  }
}

abstract class _SubtitleLine implements SubtitleLine {
  const factory _SubtitleLine(
      {required final double startTime,
      required final double endTime,
      required final String content,
      final double musicRatio}) = _$SubtitleLineImpl;

  factory _SubtitleLine.fromJson(Map<String, dynamic> json) =
      _$SubtitleLineImpl.fromJson;

  /// Start time in seconds.
  @override
  double get startTime;

  /// End time in seconds.
  @override
  double get endTime;

  /// Subtitle text content.
  @override
  String get content;

  /// Music ratio (0.0 = speech, 1.0 = music/lyrics).
  @override
  double get musicRatio;

  /// Create a copy of SubtitleLine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubtitleLineImplCopyWith<_$SubtitleLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
