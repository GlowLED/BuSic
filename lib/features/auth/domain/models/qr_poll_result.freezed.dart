// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_poll_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QrPollResult _$QrPollResultFromJson(Map<String, dynamic> json) {
  return _QrPollResult.fromJson(json);
}

/// @nodoc
mixin _$QrPollResult {
  /// Status code:
  /// - 0: success
  /// - 86038: QR code expired
  /// - 86090: scanned, waiting for confirmation
  /// - 86101: not yet scanned
  int get code => throw _privateConstructorUsedError;

  /// Human-readable status message.
  String get message => throw _privateConstructorUsedError;

  /// Redirect URL on success (contains cookie params).
  String? get url => throw _privateConstructorUsedError;

  /// Serializes this QrPollResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QrPollResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QrPollResultCopyWith<QrPollResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrPollResultCopyWith<$Res> {
  factory $QrPollResultCopyWith(
          QrPollResult value, $Res Function(QrPollResult) then) =
      _$QrPollResultCopyWithImpl<$Res, QrPollResult>;
  @useResult
  $Res call({int code, String message, String? url});
}

/// @nodoc
class _$QrPollResultCopyWithImpl<$Res, $Val extends QrPollResult>
    implements $QrPollResultCopyWith<$Res> {
  _$QrPollResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QrPollResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QrPollResultImplCopyWith<$Res>
    implements $QrPollResultCopyWith<$Res> {
  factory _$$QrPollResultImplCopyWith(
          _$QrPollResultImpl value, $Res Function(_$QrPollResultImpl) then) =
      __$$QrPollResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int code, String message, String? url});
}

/// @nodoc
class __$$QrPollResultImplCopyWithImpl<$Res>
    extends _$QrPollResultCopyWithImpl<$Res, _$QrPollResultImpl>
    implements _$$QrPollResultImplCopyWith<$Res> {
  __$$QrPollResultImplCopyWithImpl(
      _$QrPollResultImpl _value, $Res Function(_$QrPollResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of QrPollResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? url = freezed,
  }) {
    return _then(_$QrPollResultImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QrPollResultImpl implements _QrPollResult {
  const _$QrPollResultImpl(
      {required this.code, required this.message, this.url});

  factory _$QrPollResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$QrPollResultImplFromJson(json);

  /// Status code:
  /// - 0: success
  /// - 86038: QR code expired
  /// - 86090: scanned, waiting for confirmation
  /// - 86101: not yet scanned
  @override
  final int code;

  /// Human-readable status message.
  @override
  final String message;

  /// Redirect URL on success (contains cookie params).
  @override
  final String? url;

  @override
  String toString() {
    return 'QrPollResult(code: $code, message: $message, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrPollResultImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, message, url);

  /// Create a copy of QrPollResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QrPollResultImplCopyWith<_$QrPollResultImpl> get copyWith =>
      __$$QrPollResultImplCopyWithImpl<_$QrPollResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QrPollResultImplToJson(
      this,
    );
  }
}

abstract class _QrPollResult implements QrPollResult {
  const factory _QrPollResult(
      {required final int code,
      required final String message,
      final String? url}) = _$QrPollResultImpl;

  factory _QrPollResult.fromJson(Map<String, dynamic> json) =
      _$QrPollResultImpl.fromJson;

  /// Status code:
  /// - 0: success
  /// - 86038: QR code expired
  /// - 86090: scanned, waiting for confirmation
  /// - 86101: not yet scanned
  @override
  int get code;

  /// Human-readable status message.
  @override
  String get message;

  /// Redirect URL on success (contains cookie params).
  @override
  String? get url;

  /// Create a copy of QrPollResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QrPollResultImplCopyWith<_$QrPollResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
