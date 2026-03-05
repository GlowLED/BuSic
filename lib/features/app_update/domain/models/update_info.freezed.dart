// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UpdateInfo {
  /// The latest version available on GitHub.
  AppVersion get latestVersion => throw _privateConstructorUsedError;

  /// The currently installed version.
  AppVersion get currentVersion => throw _privateConstructorUsedError;

  /// Changelog / release notes text.
  String get changelog => throw _privateConstructorUsedError;

  /// Whether this update is mandatory (current version below min_supported).
  bool get isForceUpdate => throw _privateConstructorUsedError;

  /// File name of the asset (e.g. `busic-android.apk`).
  String get assetName => throw _privateConstructorUsedError;

  /// Optional link to external release notes.
  String? get releaseNotesUrl => throw _privateConstructorUsedError;

  /// 各渠道下载 URL
  Map<DownloadChannel, String> get downloadUrls =>
      throw _privateConstructorUsedError;

  /// 蓝奏云密码（如有）
  String? get lanzouPassword => throw _privateConstructorUsedError;

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateInfoCopyWith<UpdateInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateInfoCopyWith<$Res> {
  factory $UpdateInfoCopyWith(
          UpdateInfo value, $Res Function(UpdateInfo) then) =
      _$UpdateInfoCopyWithImpl<$Res, UpdateInfo>;
  @useResult
  $Res call(
      {AppVersion latestVersion,
      AppVersion currentVersion,
      String changelog,
      bool isForceUpdate,
      String assetName,
      String? releaseNotesUrl,
      Map<DownloadChannel, String> downloadUrls,
      String? lanzouPassword});
}

/// @nodoc
class _$UpdateInfoCopyWithImpl<$Res, $Val extends UpdateInfo>
    implements $UpdateInfoCopyWith<$Res> {
  _$UpdateInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestVersion = null,
    Object? currentVersion = null,
    Object? changelog = null,
    Object? isForceUpdate = null,
    Object? assetName = null,
    Object? releaseNotesUrl = freezed,
    Object? downloadUrls = null,
    Object? lanzouPassword = freezed,
  }) {
    return _then(_value.copyWith(
      latestVersion: null == latestVersion
          ? _value.latestVersion
          : latestVersion // ignore: cast_nullable_to_non_nullable
              as AppVersion,
      currentVersion: null == currentVersion
          ? _value.currentVersion
          : currentVersion // ignore: cast_nullable_to_non_nullable
              as AppVersion,
      changelog: null == changelog
          ? _value.changelog
          : changelog // ignore: cast_nullable_to_non_nullable
              as String,
      isForceUpdate: null == isForceUpdate
          ? _value.isForceUpdate
          : isForceUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      assetName: null == assetName
          ? _value.assetName
          : assetName // ignore: cast_nullable_to_non_nullable
              as String,
      releaseNotesUrl: freezed == releaseNotesUrl
          ? _value.releaseNotesUrl
          : releaseNotesUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadUrls: null == downloadUrls
          ? _value.downloadUrls
          : downloadUrls // ignore: cast_nullable_to_non_nullable
              as Map<DownloadChannel, String>,
      lanzouPassword: freezed == lanzouPassword
          ? _value.lanzouPassword
          : lanzouPassword // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateInfoImplCopyWith<$Res>
    implements $UpdateInfoCopyWith<$Res> {
  factory _$$UpdateInfoImplCopyWith(
          _$UpdateInfoImpl value, $Res Function(_$UpdateInfoImpl) then) =
      __$$UpdateInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AppVersion latestVersion,
      AppVersion currentVersion,
      String changelog,
      bool isForceUpdate,
      String assetName,
      String? releaseNotesUrl,
      Map<DownloadChannel, String> downloadUrls,
      String? lanzouPassword});
}

/// @nodoc
class __$$UpdateInfoImplCopyWithImpl<$Res>
    extends _$UpdateInfoCopyWithImpl<$Res, _$UpdateInfoImpl>
    implements _$$UpdateInfoImplCopyWith<$Res> {
  __$$UpdateInfoImplCopyWithImpl(
      _$UpdateInfoImpl _value, $Res Function(_$UpdateInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestVersion = null,
    Object? currentVersion = null,
    Object? changelog = null,
    Object? isForceUpdate = null,
    Object? assetName = null,
    Object? releaseNotesUrl = freezed,
    Object? downloadUrls = null,
    Object? lanzouPassword = freezed,
  }) {
    return _then(_$UpdateInfoImpl(
      latestVersion: null == latestVersion
          ? _value.latestVersion
          : latestVersion // ignore: cast_nullable_to_non_nullable
              as AppVersion,
      currentVersion: null == currentVersion
          ? _value.currentVersion
          : currentVersion // ignore: cast_nullable_to_non_nullable
              as AppVersion,
      changelog: null == changelog
          ? _value.changelog
          : changelog // ignore: cast_nullable_to_non_nullable
              as String,
      isForceUpdate: null == isForceUpdate
          ? _value.isForceUpdate
          : isForceUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      assetName: null == assetName
          ? _value.assetName
          : assetName // ignore: cast_nullable_to_non_nullable
              as String,
      releaseNotesUrl: freezed == releaseNotesUrl
          ? _value.releaseNotesUrl
          : releaseNotesUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadUrls: null == downloadUrls
          ? _value._downloadUrls
          : downloadUrls // ignore: cast_nullable_to_non_nullable
              as Map<DownloadChannel, String>,
      lanzouPassword: freezed == lanzouPassword
          ? _value.lanzouPassword
          : lanzouPassword // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UpdateInfoImpl implements _UpdateInfo {
  const _$UpdateInfoImpl(
      {required this.latestVersion,
      required this.currentVersion,
      required this.changelog,
      required this.isForceUpdate,
      required this.assetName,
      this.releaseNotesUrl,
      required final Map<DownloadChannel, String> downloadUrls,
      this.lanzouPassword})
      : _downloadUrls = downloadUrls;

  /// The latest version available on GitHub.
  @override
  final AppVersion latestVersion;

  /// The currently installed version.
  @override
  final AppVersion currentVersion;

  /// Changelog / release notes text.
  @override
  final String changelog;

  /// Whether this update is mandatory (current version below min_supported).
  @override
  final bool isForceUpdate;

  /// File name of the asset (e.g. `busic-android.apk`).
  @override
  final String assetName;

  /// Optional link to external release notes.
  @override
  final String? releaseNotesUrl;

  /// 各渠道下载 URL
  final Map<DownloadChannel, String> _downloadUrls;

  /// 各渠道下载 URL
  @override
  Map<DownloadChannel, String> get downloadUrls {
    if (_downloadUrls is EqualUnmodifiableMapView) return _downloadUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_downloadUrls);
  }

  /// 蓝奏云密码（如有）
  @override
  final String? lanzouPassword;

  @override
  String toString() {
    return 'UpdateInfo(latestVersion: $latestVersion, currentVersion: $currentVersion, changelog: $changelog, isForceUpdate: $isForceUpdate, assetName: $assetName, releaseNotesUrl: $releaseNotesUrl, downloadUrls: $downloadUrls, lanzouPassword: $lanzouPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateInfoImpl &&
            (identical(other.latestVersion, latestVersion) ||
                other.latestVersion == latestVersion) &&
            (identical(other.currentVersion, currentVersion) ||
                other.currentVersion == currentVersion) &&
            (identical(other.changelog, changelog) ||
                other.changelog == changelog) &&
            (identical(other.isForceUpdate, isForceUpdate) ||
                other.isForceUpdate == isForceUpdate) &&
            (identical(other.assetName, assetName) ||
                other.assetName == assetName) &&
            (identical(other.releaseNotesUrl, releaseNotesUrl) ||
                other.releaseNotesUrl == releaseNotesUrl) &&
            const DeepCollectionEquality()
                .equals(other._downloadUrls, _downloadUrls) &&
            (identical(other.lanzouPassword, lanzouPassword) ||
                other.lanzouPassword == lanzouPassword));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      latestVersion,
      currentVersion,
      changelog,
      isForceUpdate,
      assetName,
      releaseNotesUrl,
      const DeepCollectionEquality().hash(_downloadUrls),
      lanzouPassword);

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateInfoImplCopyWith<_$UpdateInfoImpl> get copyWith =>
      __$$UpdateInfoImplCopyWithImpl<_$UpdateInfoImpl>(this, _$identity);
}

abstract class _UpdateInfo implements UpdateInfo {
  const factory _UpdateInfo(
      {required final AppVersion latestVersion,
      required final AppVersion currentVersion,
      required final String changelog,
      required final bool isForceUpdate,
      required final String assetName,
      final String? releaseNotesUrl,
      required final Map<DownloadChannel, String> downloadUrls,
      final String? lanzouPassword}) = _$UpdateInfoImpl;

  /// The latest version available on GitHub.
  @override
  AppVersion get latestVersion;

  /// The currently installed version.
  @override
  AppVersion get currentVersion;

  /// Changelog / release notes text.
  @override
  String get changelog;

  /// Whether this update is mandatory (current version below min_supported).
  @override
  bool get isForceUpdate;

  /// File name of the asset (e.g. `busic-android.apk`).
  @override
  String get assetName;

  /// Optional link to external release notes.
  @override
  String? get releaseNotesUrl;

  /// 各渠道下载 URL
  @override
  Map<DownloadChannel, String> get downloadUrls;

  /// 蓝奏云密码（如有）
  @override
  String? get lanzouPassword;

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateInfoImplCopyWith<_$UpdateInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
