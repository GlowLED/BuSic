// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_stream_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AudioStreamInfo _$AudioStreamInfoFromJson(Map<String, dynamic> json) {
  return _AudioStreamInfo.fromJson(json);
}

/// @nodoc
mixin _$AudioStreamInfo {
  /// Direct audio stream URL (m4s format).
  String get url => throw _privateConstructorUsedError;

  /// Audio quality identifier:
  /// - 30216: 64kbps
  /// - 30232: 132kbps
  /// - 30280: 192kbps (login required)
  /// - 30250: Dolby Atmos (login + SVIP)
  /// - 30251: Hi-Res (login + SVIP)
  int get quality => throw _privateConstructorUsedError;

  /// MIME type (typically "audio/mp4").
  String? get mimeType => throw _privateConstructorUsedError;

  /// Stream bandwidth in bits per second.
  int? get bandwidth => throw _privateConstructorUsedError;

  /// URL expiration timestamp.
  DateTime? get expireTime => throw _privateConstructorUsedError;

  /// Backup URLs in case the primary fails.
  List<String> get backupUrls => throw _privateConstructorUsedError;

  /// Serializes this AudioStreamInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AudioStreamInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioStreamInfoCopyWith<AudioStreamInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioStreamInfoCopyWith<$Res> {
  factory $AudioStreamInfoCopyWith(
          AudioStreamInfo value, $Res Function(AudioStreamInfo) then) =
      _$AudioStreamInfoCopyWithImpl<$Res, AudioStreamInfo>;
  @useResult
  $Res call(
      {String url,
      int quality,
      String? mimeType,
      int? bandwidth,
      DateTime? expireTime,
      List<String> backupUrls});
}

/// @nodoc
class _$AudioStreamInfoCopyWithImpl<$Res, $Val extends AudioStreamInfo>
    implements $AudioStreamInfoCopyWith<$Res> {
  _$AudioStreamInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioStreamInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? quality = null,
    Object? mimeType = freezed,
    Object? bandwidth = freezed,
    Object? expireTime = freezed,
    Object? backupUrls = null,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      bandwidth: freezed == bandwidth
          ? _value.bandwidth
          : bandwidth // ignore: cast_nullable_to_non_nullable
              as int?,
      expireTime: freezed == expireTime
          ? _value.expireTime
          : expireTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      backupUrls: null == backupUrls
          ? _value.backupUrls
          : backupUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AudioStreamInfoImplCopyWith<$Res>
    implements $AudioStreamInfoCopyWith<$Res> {
  factory _$$AudioStreamInfoImplCopyWith(_$AudioStreamInfoImpl value,
          $Res Function(_$AudioStreamInfoImpl) then) =
      __$$AudioStreamInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url,
      int quality,
      String? mimeType,
      int? bandwidth,
      DateTime? expireTime,
      List<String> backupUrls});
}

/// @nodoc
class __$$AudioStreamInfoImplCopyWithImpl<$Res>
    extends _$AudioStreamInfoCopyWithImpl<$Res, _$AudioStreamInfoImpl>
    implements _$$AudioStreamInfoImplCopyWith<$Res> {
  __$$AudioStreamInfoImplCopyWithImpl(
      _$AudioStreamInfoImpl _value, $Res Function(_$AudioStreamInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AudioStreamInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? quality = null,
    Object? mimeType = freezed,
    Object? bandwidth = freezed,
    Object? expireTime = freezed,
    Object? backupUrls = null,
  }) {
    return _then(_$AudioStreamInfoImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      bandwidth: freezed == bandwidth
          ? _value.bandwidth
          : bandwidth // ignore: cast_nullable_to_non_nullable
              as int?,
      expireTime: freezed == expireTime
          ? _value.expireTime
          : expireTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      backupUrls: null == backupUrls
          ? _value._backupUrls
          : backupUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioStreamInfoImpl implements _AudioStreamInfo {
  const _$AudioStreamInfoImpl(
      {required this.url,
      required this.quality,
      this.mimeType,
      this.bandwidth,
      this.expireTime,
      final List<String> backupUrls = const []})
      : _backupUrls = backupUrls;

  factory _$AudioStreamInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioStreamInfoImplFromJson(json);

  /// Direct audio stream URL (m4s format).
  @override
  final String url;

  /// Audio quality identifier:
  /// - 30216: 64kbps
  /// - 30232: 132kbps
  /// - 30280: 192kbps (login required)
  /// - 30250: Dolby Atmos (login + SVIP)
  /// - 30251: Hi-Res (login + SVIP)
  @override
  final int quality;

  /// MIME type (typically "audio/mp4").
  @override
  final String? mimeType;

  /// Stream bandwidth in bits per second.
  @override
  final int? bandwidth;

  /// URL expiration timestamp.
  @override
  final DateTime? expireTime;

  /// Backup URLs in case the primary fails.
  final List<String> _backupUrls;

  /// Backup URLs in case the primary fails.
  @override
  @JsonKey()
  List<String> get backupUrls {
    if (_backupUrls is EqualUnmodifiableListView) return _backupUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_backupUrls);
  }

  @override
  String toString() {
    return 'AudioStreamInfo(url: $url, quality: $quality, mimeType: $mimeType, bandwidth: $bandwidth, expireTime: $expireTime, backupUrls: $backupUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioStreamInfoImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.bandwidth, bandwidth) ||
                other.bandwidth == bandwidth) &&
            (identical(other.expireTime, expireTime) ||
                other.expireTime == expireTime) &&
            const DeepCollectionEquality()
                .equals(other._backupUrls, _backupUrls));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, quality, mimeType,
      bandwidth, expireTime, const DeepCollectionEquality().hash(_backupUrls));

  /// Create a copy of AudioStreamInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioStreamInfoImplCopyWith<_$AudioStreamInfoImpl> get copyWith =>
      __$$AudioStreamInfoImplCopyWithImpl<_$AudioStreamInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioStreamInfoImplToJson(
      this,
    );
  }
}

abstract class _AudioStreamInfo implements AudioStreamInfo {
  const factory _AudioStreamInfo(
      {required final String url,
      required final int quality,
      final String? mimeType,
      final int? bandwidth,
      final DateTime? expireTime,
      final List<String> backupUrls}) = _$AudioStreamInfoImpl;

  factory _AudioStreamInfo.fromJson(Map<String, dynamic> json) =
      _$AudioStreamInfoImpl.fromJson;

  /// Direct audio stream URL (m4s format).
  @override
  String get url;

  /// Audio quality identifier:
  /// - 30216: 64kbps
  /// - 30232: 132kbps
  /// - 30280: 192kbps (login required)
  /// - 30250: Dolby Atmos (login + SVIP)
  /// - 30251: Hi-Res (login + SVIP)
  @override
  int get quality;

  /// MIME type (typically "audio/mp4").
  @override
  String? get mimeType;

  /// Stream bandwidth in bits per second.
  @override
  int? get bandwidth;

  /// URL expiration timestamp.
  @override
  DateTime? get expireTime;

  /// Backup URLs in case the primary fails.
  @override
  List<String> get backupUrls;

  /// Create a copy of AudioStreamInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioStreamInfoImplCopyWith<_$AudioStreamInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
