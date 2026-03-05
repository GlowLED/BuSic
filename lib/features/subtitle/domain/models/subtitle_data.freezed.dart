// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subtitle_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubtitleData _$SubtitleDataFromJson(Map<String, dynamic> json) {
  return _SubtitleData.fromJson(json);
}

/// @nodoc
mixin _$SubtitleData {
  /// Subtitle lines sorted by start time.
  List<SubtitleLine> get lines => throw _privateConstructorUsedError;

  /// Source type: 'ai' for AI-generated, 'cc' for community captions.
  String get sourceType => throw _privateConstructorUsedError;

  /// Language code (e.g. 'ai-zh', 'zh-Hans').
  String get language => throw _privateConstructorUsedError;

  /// Serializes this SubtitleData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubtitleData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubtitleDataCopyWith<SubtitleData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubtitleDataCopyWith<$Res> {
  factory $SubtitleDataCopyWith(
          SubtitleData value, $Res Function(SubtitleData) then) =
      _$SubtitleDataCopyWithImpl<$Res, SubtitleData>;
  @useResult
  $Res call({List<SubtitleLine> lines, String sourceType, String language});
}

/// @nodoc
class _$SubtitleDataCopyWithImpl<$Res, $Val extends SubtitleData>
    implements $SubtitleDataCopyWith<$Res> {
  _$SubtitleDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubtitleData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lines = null,
    Object? sourceType = null,
    Object? language = null,
  }) {
    return _then(_value.copyWith(
      lines: null == lines
          ? _value.lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<SubtitleLine>,
      sourceType: null == sourceType
          ? _value.sourceType
          : sourceType // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubtitleDataImplCopyWith<$Res>
    implements $SubtitleDataCopyWith<$Res> {
  factory _$$SubtitleDataImplCopyWith(
          _$SubtitleDataImpl value, $Res Function(_$SubtitleDataImpl) then) =
      __$$SubtitleDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SubtitleLine> lines, String sourceType, String language});
}

/// @nodoc
class __$$SubtitleDataImplCopyWithImpl<$Res>
    extends _$SubtitleDataCopyWithImpl<$Res, _$SubtitleDataImpl>
    implements _$$SubtitleDataImplCopyWith<$Res> {
  __$$SubtitleDataImplCopyWithImpl(
      _$SubtitleDataImpl _value, $Res Function(_$SubtitleDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubtitleData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lines = null,
    Object? sourceType = null,
    Object? language = null,
  }) {
    return _then(_$SubtitleDataImpl(
      lines: null == lines
          ? _value._lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<SubtitleLine>,
      sourceType: null == sourceType
          ? _value.sourceType
          : sourceType // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubtitleDataImpl implements _SubtitleData {
  const _$SubtitleDataImpl(
      {required final List<SubtitleLine> lines,
      required this.sourceType,
      this.language = ''})
      : _lines = lines;

  factory _$SubtitleDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubtitleDataImplFromJson(json);

  /// Subtitle lines sorted by start time.
  final List<SubtitleLine> _lines;

  /// Subtitle lines sorted by start time.
  @override
  List<SubtitleLine> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  /// Source type: 'ai' for AI-generated, 'cc' for community captions.
  @override
  final String sourceType;

  /// Language code (e.g. 'ai-zh', 'zh-Hans').
  @override
  @JsonKey()
  final String language;

  @override
  String toString() {
    return 'SubtitleData(lines: $lines, sourceType: $sourceType, language: $language)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubtitleDataImpl &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            (identical(other.sourceType, sourceType) ||
                other.sourceType == sourceType) &&
            (identical(other.language, language) ||
                other.language == language));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_lines), sourceType, language);

  /// Create a copy of SubtitleData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubtitleDataImplCopyWith<_$SubtitleDataImpl> get copyWith =>
      __$$SubtitleDataImplCopyWithImpl<_$SubtitleDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubtitleDataImplToJson(
      this,
    );
  }
}

abstract class _SubtitleData implements SubtitleData {
  const factory _SubtitleData(
      {required final List<SubtitleLine> lines,
      required final String sourceType,
      final String language}) = _$SubtitleDataImpl;

  factory _SubtitleData.fromJson(Map<String, dynamic> json) =
      _$SubtitleDataImpl.fromJson;

  /// Subtitle lines sorted by start time.
  @override
  List<SubtitleLine> get lines;

  /// Source type: 'ai' for AI-generated, 'cc' for community captions.
  @override
  String get sourceType;

  /// Language code (e.g. 'ai-zh', 'zh-Hans').
  @override
  String get language;

  /// Create a copy of SubtitleData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubtitleDataImplCopyWith<_$SubtitleDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
