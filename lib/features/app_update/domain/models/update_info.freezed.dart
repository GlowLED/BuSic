// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateInfo {

/// The latest version available on GitHub.
 AppVersion get latestVersion;/// The currently installed version.
 AppVersion get currentVersion;/// Changelog / release notes text.
 String get changelog;/// Whether this update is mandatory (current version below min_supported).
 bool get isForceUpdate;/// File name of the asset (e.g. `busic-android.apk`).
 String get assetName;/// Optional link to external release notes.
 String? get releaseNotesUrl;/// 各渠道下载 URL
 Map<DownloadChannel, String> get downloadUrls;/// 蓝奏云密码（如有）
 String? get lanzouPassword;
/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateInfoCopyWith<UpdateInfo> get copyWith => _$UpdateInfoCopyWithImpl<UpdateInfo>(this as UpdateInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateInfo&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion)&&(identical(other.currentVersion, currentVersion) || other.currentVersion == currentVersion)&&(identical(other.changelog, changelog) || other.changelog == changelog)&&(identical(other.isForceUpdate, isForceUpdate) || other.isForceUpdate == isForceUpdate)&&(identical(other.assetName, assetName) || other.assetName == assetName)&&(identical(other.releaseNotesUrl, releaseNotesUrl) || other.releaseNotesUrl == releaseNotesUrl)&&const DeepCollectionEquality().equals(other.downloadUrls, downloadUrls)&&(identical(other.lanzouPassword, lanzouPassword) || other.lanzouPassword == lanzouPassword));
}


@override
int get hashCode => Object.hash(runtimeType,latestVersion,currentVersion,changelog,isForceUpdate,assetName,releaseNotesUrl,const DeepCollectionEquality().hash(downloadUrls),lanzouPassword);

@override
String toString() {
  return 'UpdateInfo(latestVersion: $latestVersion, currentVersion: $currentVersion, changelog: $changelog, isForceUpdate: $isForceUpdate, assetName: $assetName, releaseNotesUrl: $releaseNotesUrl, downloadUrls: $downloadUrls, lanzouPassword: $lanzouPassword)';
}


}

/// @nodoc
abstract mixin class $UpdateInfoCopyWith<$Res>  {
  factory $UpdateInfoCopyWith(UpdateInfo value, $Res Function(UpdateInfo) _then) = _$UpdateInfoCopyWithImpl;
@useResult
$Res call({
 AppVersion latestVersion, AppVersion currentVersion, String changelog, bool isForceUpdate, String assetName, String? releaseNotesUrl, Map<DownloadChannel, String> downloadUrls, String? lanzouPassword
});




}
/// @nodoc
class _$UpdateInfoCopyWithImpl<$Res>
    implements $UpdateInfoCopyWith<$Res> {
  _$UpdateInfoCopyWithImpl(this._self, this._then);

  final UpdateInfo _self;
  final $Res Function(UpdateInfo) _then;

/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latestVersion = null,Object? currentVersion = null,Object? changelog = null,Object? isForceUpdate = null,Object? assetName = null,Object? releaseNotesUrl = freezed,Object? downloadUrls = null,Object? lanzouPassword = freezed,}) {
  return _then(_self.copyWith(
latestVersion: null == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as AppVersion,currentVersion: null == currentVersion ? _self.currentVersion : currentVersion // ignore: cast_nullable_to_non_nullable
as AppVersion,changelog: null == changelog ? _self.changelog : changelog // ignore: cast_nullable_to_non_nullable
as String,isForceUpdate: null == isForceUpdate ? _self.isForceUpdate : isForceUpdate // ignore: cast_nullable_to_non_nullable
as bool,assetName: null == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String,releaseNotesUrl: freezed == releaseNotesUrl ? _self.releaseNotesUrl : releaseNotesUrl // ignore: cast_nullable_to_non_nullable
as String?,downloadUrls: null == downloadUrls ? _self.downloadUrls : downloadUrls // ignore: cast_nullable_to_non_nullable
as Map<DownloadChannel, String>,lanzouPassword: freezed == lanzouPassword ? _self.lanzouPassword : lanzouPassword // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateInfo].
extension UpdateInfoPatterns on UpdateInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateInfo value)  $default,){
final _that = this;
switch (_that) {
case _UpdateInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateInfo value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppVersion latestVersion,  AppVersion currentVersion,  String changelog,  bool isForceUpdate,  String assetName,  String? releaseNotesUrl,  Map<DownloadChannel, String> downloadUrls,  String? lanzouPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateInfo() when $default != null:
return $default(_that.latestVersion,_that.currentVersion,_that.changelog,_that.isForceUpdate,_that.assetName,_that.releaseNotesUrl,_that.downloadUrls,_that.lanzouPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppVersion latestVersion,  AppVersion currentVersion,  String changelog,  bool isForceUpdate,  String assetName,  String? releaseNotesUrl,  Map<DownloadChannel, String> downloadUrls,  String? lanzouPassword)  $default,) {final _that = this;
switch (_that) {
case _UpdateInfo():
return $default(_that.latestVersion,_that.currentVersion,_that.changelog,_that.isForceUpdate,_that.assetName,_that.releaseNotesUrl,_that.downloadUrls,_that.lanzouPassword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppVersion latestVersion,  AppVersion currentVersion,  String changelog,  bool isForceUpdate,  String assetName,  String? releaseNotesUrl,  Map<DownloadChannel, String> downloadUrls,  String? lanzouPassword)?  $default,) {final _that = this;
switch (_that) {
case _UpdateInfo() when $default != null:
return $default(_that.latestVersion,_that.currentVersion,_that.changelog,_that.isForceUpdate,_that.assetName,_that.releaseNotesUrl,_that.downloadUrls,_that.lanzouPassword);case _:
  return null;

}
}

}

/// @nodoc


class _UpdateInfo implements UpdateInfo {
  const _UpdateInfo({required this.latestVersion, required this.currentVersion, required this.changelog, required this.isForceUpdate, required this.assetName, this.releaseNotesUrl, required final  Map<DownloadChannel, String> downloadUrls, this.lanzouPassword}): _downloadUrls = downloadUrls;
  

/// The latest version available on GitHub.
@override final  AppVersion latestVersion;
/// The currently installed version.
@override final  AppVersion currentVersion;
/// Changelog / release notes text.
@override final  String changelog;
/// Whether this update is mandatory (current version below min_supported).
@override final  bool isForceUpdate;
/// File name of the asset (e.g. `busic-android.apk`).
@override final  String assetName;
/// Optional link to external release notes.
@override final  String? releaseNotesUrl;
/// 各渠道下载 URL
 final  Map<DownloadChannel, String> _downloadUrls;
/// 各渠道下载 URL
@override Map<DownloadChannel, String> get downloadUrls {
  if (_downloadUrls is EqualUnmodifiableMapView) return _downloadUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_downloadUrls);
}

/// 蓝奏云密码（如有）
@override final  String? lanzouPassword;

/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateInfoCopyWith<_UpdateInfo> get copyWith => __$UpdateInfoCopyWithImpl<_UpdateInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateInfo&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion)&&(identical(other.currentVersion, currentVersion) || other.currentVersion == currentVersion)&&(identical(other.changelog, changelog) || other.changelog == changelog)&&(identical(other.isForceUpdate, isForceUpdate) || other.isForceUpdate == isForceUpdate)&&(identical(other.assetName, assetName) || other.assetName == assetName)&&(identical(other.releaseNotesUrl, releaseNotesUrl) || other.releaseNotesUrl == releaseNotesUrl)&&const DeepCollectionEquality().equals(other._downloadUrls, _downloadUrls)&&(identical(other.lanzouPassword, lanzouPassword) || other.lanzouPassword == lanzouPassword));
}


@override
int get hashCode => Object.hash(runtimeType,latestVersion,currentVersion,changelog,isForceUpdate,assetName,releaseNotesUrl,const DeepCollectionEquality().hash(_downloadUrls),lanzouPassword);

@override
String toString() {
  return 'UpdateInfo(latestVersion: $latestVersion, currentVersion: $currentVersion, changelog: $changelog, isForceUpdate: $isForceUpdate, assetName: $assetName, releaseNotesUrl: $releaseNotesUrl, downloadUrls: $downloadUrls, lanzouPassword: $lanzouPassword)';
}


}

/// @nodoc
abstract mixin class _$UpdateInfoCopyWith<$Res> implements $UpdateInfoCopyWith<$Res> {
  factory _$UpdateInfoCopyWith(_UpdateInfo value, $Res Function(_UpdateInfo) _then) = __$UpdateInfoCopyWithImpl;
@override @useResult
$Res call({
 AppVersion latestVersion, AppVersion currentVersion, String changelog, bool isForceUpdate, String assetName, String? releaseNotesUrl, Map<DownloadChannel, String> downloadUrls, String? lanzouPassword
});




}
/// @nodoc
class __$UpdateInfoCopyWithImpl<$Res>
    implements _$UpdateInfoCopyWith<$Res> {
  __$UpdateInfoCopyWithImpl(this._self, this._then);

  final _UpdateInfo _self;
  final $Res Function(_UpdateInfo) _then;

/// Create a copy of UpdateInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latestVersion = null,Object? currentVersion = null,Object? changelog = null,Object? isForceUpdate = null,Object? assetName = null,Object? releaseNotesUrl = freezed,Object? downloadUrls = null,Object? lanzouPassword = freezed,}) {
  return _then(_UpdateInfo(
latestVersion: null == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as AppVersion,currentVersion: null == currentVersion ? _self.currentVersion : currentVersion // ignore: cast_nullable_to_non_nullable
as AppVersion,changelog: null == changelog ? _self.changelog : changelog // ignore: cast_nullable_to_non_nullable
as String,isForceUpdate: null == isForceUpdate ? _self.isForceUpdate : isForceUpdate // ignore: cast_nullable_to_non_nullable
as bool,assetName: null == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String,releaseNotesUrl: freezed == releaseNotesUrl ? _self.releaseNotesUrl : releaseNotesUrl // ignore: cast_nullable_to_non_nullable
as String?,downloadUrls: null == downloadUrls ? _self._downloadUrls : downloadUrls // ignore: cast_nullable_to_non_nullable
as Map<DownloadChannel, String>,lanzouPassword: freezed == lanzouPassword ? _self.lanzouPassword : lanzouPassword // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
