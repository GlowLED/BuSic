// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateState()';
}


}

/// @nodoc
class $UpdateStateCopyWith<$Res>  {
$UpdateStateCopyWith(UpdateState _, $Res Function(UpdateState) __);
}


/// Adds pattern-matching-related methods to [UpdateState].
extension UpdateStatePatterns on UpdateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UpdateStateIdle value)?  idle,TResult Function( UpdateStateChecking value)?  checking,TResult Function( UpdateStateAvailable value)?  available,TResult Function( UpdateStateDownloading value)?  downloading,TResult Function( UpdateStatePaused value)?  paused,TResult Function( UpdateStateReadyToInstall value)?  readyToInstall,TResult Function( UpdateStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UpdateStateIdle() when idle != null:
return idle(_that);case UpdateStateChecking() when checking != null:
return checking(_that);case UpdateStateAvailable() when available != null:
return available(_that);case UpdateStateDownloading() when downloading != null:
return downloading(_that);case UpdateStatePaused() when paused != null:
return paused(_that);case UpdateStateReadyToInstall() when readyToInstall != null:
return readyToInstall(_that);case UpdateStateError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UpdateStateIdle value)  idle,required TResult Function( UpdateStateChecking value)  checking,required TResult Function( UpdateStateAvailable value)  available,required TResult Function( UpdateStateDownloading value)  downloading,required TResult Function( UpdateStatePaused value)  paused,required TResult Function( UpdateStateReadyToInstall value)  readyToInstall,required TResult Function( UpdateStateError value)  error,}){
final _that = this;
switch (_that) {
case UpdateStateIdle():
return idle(_that);case UpdateStateChecking():
return checking(_that);case UpdateStateAvailable():
return available(_that);case UpdateStateDownloading():
return downloading(_that);case UpdateStatePaused():
return paused(_that);case UpdateStateReadyToInstall():
return readyToInstall(_that);case UpdateStateError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UpdateStateIdle value)?  idle,TResult? Function( UpdateStateChecking value)?  checking,TResult? Function( UpdateStateAvailable value)?  available,TResult? Function( UpdateStateDownloading value)?  downloading,TResult? Function( UpdateStatePaused value)?  paused,TResult? Function( UpdateStateReadyToInstall value)?  readyToInstall,TResult? Function( UpdateStateError value)?  error,}){
final _that = this;
switch (_that) {
case UpdateStateIdle() when idle != null:
return idle(_that);case UpdateStateChecking() when checking != null:
return checking(_that);case UpdateStateAvailable() when available != null:
return available(_that);case UpdateStateDownloading() when downloading != null:
return downloading(_that);case UpdateStatePaused() when paused != null:
return paused(_that);case UpdateStateReadyToInstall() when readyToInstall != null:
return readyToInstall(_that);case UpdateStateError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  checking,TResult Function( UpdateInfo info)?  available,TResult Function( UpdateInfo info,  double progress,  double speed,  DownloadChannel channel,  int downloadedBytes,  int totalBytes)?  downloading,TResult Function( UpdateInfo info,  double progress,  DownloadChannel channel,  int downloadedBytes,  int totalBytes,  String localPath)?  paused,TResult Function( UpdateInfo info,  String localPath)?  readyToInstall,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UpdateStateIdle() when idle != null:
return idle();case UpdateStateChecking() when checking != null:
return checking();case UpdateStateAvailable() when available != null:
return available(_that.info);case UpdateStateDownloading() when downloading != null:
return downloading(_that.info,_that.progress,_that.speed,_that.channel,_that.downloadedBytes,_that.totalBytes);case UpdateStatePaused() when paused != null:
return paused(_that.info,_that.progress,_that.channel,_that.downloadedBytes,_that.totalBytes,_that.localPath);case UpdateStateReadyToInstall() when readyToInstall != null:
return readyToInstall(_that.info,_that.localPath);case UpdateStateError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  checking,required TResult Function( UpdateInfo info)  available,required TResult Function( UpdateInfo info,  double progress,  double speed,  DownloadChannel channel,  int downloadedBytes,  int totalBytes)  downloading,required TResult Function( UpdateInfo info,  double progress,  DownloadChannel channel,  int downloadedBytes,  int totalBytes,  String localPath)  paused,required TResult Function( UpdateInfo info,  String localPath)  readyToInstall,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case UpdateStateIdle():
return idle();case UpdateStateChecking():
return checking();case UpdateStateAvailable():
return available(_that.info);case UpdateStateDownloading():
return downloading(_that.info,_that.progress,_that.speed,_that.channel,_that.downloadedBytes,_that.totalBytes);case UpdateStatePaused():
return paused(_that.info,_that.progress,_that.channel,_that.downloadedBytes,_that.totalBytes,_that.localPath);case UpdateStateReadyToInstall():
return readyToInstall(_that.info,_that.localPath);case UpdateStateError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  checking,TResult? Function( UpdateInfo info)?  available,TResult? Function( UpdateInfo info,  double progress,  double speed,  DownloadChannel channel,  int downloadedBytes,  int totalBytes)?  downloading,TResult? Function( UpdateInfo info,  double progress,  DownloadChannel channel,  int downloadedBytes,  int totalBytes,  String localPath)?  paused,TResult? Function( UpdateInfo info,  String localPath)?  readyToInstall,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case UpdateStateIdle() when idle != null:
return idle();case UpdateStateChecking() when checking != null:
return checking();case UpdateStateAvailable() when available != null:
return available(_that.info);case UpdateStateDownloading() when downloading != null:
return downloading(_that.info,_that.progress,_that.speed,_that.channel,_that.downloadedBytes,_that.totalBytes);case UpdateStatePaused() when paused != null:
return paused(_that.info,_that.progress,_that.channel,_that.downloadedBytes,_that.totalBytes,_that.localPath);case UpdateStateReadyToInstall() when readyToInstall != null:
return readyToInstall(_that.info,_that.localPath);case UpdateStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class UpdateStateIdle implements UpdateState {
  const UpdateStateIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStateIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateState.idle()';
}


}




/// @nodoc


class UpdateStateChecking implements UpdateState {
  const UpdateStateChecking();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStateChecking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateState.checking()';
}


}




/// @nodoc


class UpdateStateAvailable implements UpdateState {
  const UpdateStateAvailable(this.info);
  

 final  UpdateInfo info;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateStateAvailableCopyWith<UpdateStateAvailable> get copyWith => _$UpdateStateAvailableCopyWithImpl<UpdateStateAvailable>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStateAvailable&&(identical(other.info, info) || other.info == info));
}


@override
int get hashCode => Object.hash(runtimeType,info);

@override
String toString() {
  return 'UpdateState.available(info: $info)';
}


}

/// @nodoc
abstract mixin class $UpdateStateAvailableCopyWith<$Res> implements $UpdateStateCopyWith<$Res> {
  factory $UpdateStateAvailableCopyWith(UpdateStateAvailable value, $Res Function(UpdateStateAvailable) _then) = _$UpdateStateAvailableCopyWithImpl;
@useResult
$Res call({
 UpdateInfo info
});


$UpdateInfoCopyWith<$Res> get info;

}
/// @nodoc
class _$UpdateStateAvailableCopyWithImpl<$Res>
    implements $UpdateStateAvailableCopyWith<$Res> {
  _$UpdateStateAvailableCopyWithImpl(this._self, this._then);

  final UpdateStateAvailable _self;
  final $Res Function(UpdateStateAvailable) _then;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? info = null,}) {
  return _then(UpdateStateAvailable(
null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as UpdateInfo,
  ));
}

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateInfoCopyWith<$Res> get info {
  
  return $UpdateInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}

/// @nodoc


class UpdateStateDownloading implements UpdateState {
  const UpdateStateDownloading({required this.info, required this.progress, required this.speed, required this.channel, this.downloadedBytes = 0, this.totalBytes = 0});
  

 final  UpdateInfo info;
 final  double progress;
/// Download speed in bytes/second.
 final  double speed;
 final  DownloadChannel channel;
@JsonKey() final  int downloadedBytes;
@JsonKey() final  int totalBytes;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateStateDownloadingCopyWith<UpdateStateDownloading> get copyWith => _$UpdateStateDownloadingCopyWithImpl<UpdateStateDownloading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStateDownloading&&(identical(other.info, info) || other.info == info)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.downloadedBytes, downloadedBytes) || other.downloadedBytes == downloadedBytes)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes));
}


@override
int get hashCode => Object.hash(runtimeType,info,progress,speed,channel,downloadedBytes,totalBytes);

@override
String toString() {
  return 'UpdateState.downloading(info: $info, progress: $progress, speed: $speed, channel: $channel, downloadedBytes: $downloadedBytes, totalBytes: $totalBytes)';
}


}

/// @nodoc
abstract mixin class $UpdateStateDownloadingCopyWith<$Res> implements $UpdateStateCopyWith<$Res> {
  factory $UpdateStateDownloadingCopyWith(UpdateStateDownloading value, $Res Function(UpdateStateDownloading) _then) = _$UpdateStateDownloadingCopyWithImpl;
@useResult
$Res call({
 UpdateInfo info, double progress, double speed, DownloadChannel channel, int downloadedBytes, int totalBytes
});


$UpdateInfoCopyWith<$Res> get info;

}
/// @nodoc
class _$UpdateStateDownloadingCopyWithImpl<$Res>
    implements $UpdateStateDownloadingCopyWith<$Res> {
  _$UpdateStateDownloadingCopyWithImpl(this._self, this._then);

  final UpdateStateDownloading _self;
  final $Res Function(UpdateStateDownloading) _then;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? info = null,Object? progress = null,Object? speed = null,Object? channel = null,Object? downloadedBytes = null,Object? totalBytes = null,}) {
  return _then(UpdateStateDownloading(
info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as UpdateInfo,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as DownloadChannel,downloadedBytes: null == downloadedBytes ? _self.downloadedBytes : downloadedBytes // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateInfoCopyWith<$Res> get info {
  
  return $UpdateInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}

/// @nodoc


class UpdateStatePaused implements UpdateState {
  const UpdateStatePaused({required this.info, required this.progress, required this.channel, required this.downloadedBytes, required this.totalBytes, required this.localPath});
  

 final  UpdateInfo info;
 final  double progress;
 final  DownloadChannel channel;
 final  int downloadedBytes;
 final  int totalBytes;
 final  String localPath;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateStatePausedCopyWith<UpdateStatePaused> get copyWith => _$UpdateStatePausedCopyWithImpl<UpdateStatePaused>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStatePaused&&(identical(other.info, info) || other.info == info)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.downloadedBytes, downloadedBytes) || other.downloadedBytes == downloadedBytes)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.localPath, localPath) || other.localPath == localPath));
}


@override
int get hashCode => Object.hash(runtimeType,info,progress,channel,downloadedBytes,totalBytes,localPath);

@override
String toString() {
  return 'UpdateState.paused(info: $info, progress: $progress, channel: $channel, downloadedBytes: $downloadedBytes, totalBytes: $totalBytes, localPath: $localPath)';
}


}

/// @nodoc
abstract mixin class $UpdateStatePausedCopyWith<$Res> implements $UpdateStateCopyWith<$Res> {
  factory $UpdateStatePausedCopyWith(UpdateStatePaused value, $Res Function(UpdateStatePaused) _then) = _$UpdateStatePausedCopyWithImpl;
@useResult
$Res call({
 UpdateInfo info, double progress, DownloadChannel channel, int downloadedBytes, int totalBytes, String localPath
});


$UpdateInfoCopyWith<$Res> get info;

}
/// @nodoc
class _$UpdateStatePausedCopyWithImpl<$Res>
    implements $UpdateStatePausedCopyWith<$Res> {
  _$UpdateStatePausedCopyWithImpl(this._self, this._then);

  final UpdateStatePaused _self;
  final $Res Function(UpdateStatePaused) _then;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? info = null,Object? progress = null,Object? channel = null,Object? downloadedBytes = null,Object? totalBytes = null,Object? localPath = null,}) {
  return _then(UpdateStatePaused(
info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as UpdateInfo,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as DownloadChannel,downloadedBytes: null == downloadedBytes ? _self.downloadedBytes : downloadedBytes // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,localPath: null == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateInfoCopyWith<$Res> get info {
  
  return $UpdateInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}

/// @nodoc


class UpdateStateReadyToInstall implements UpdateState {
  const UpdateStateReadyToInstall({required this.info, required this.localPath});
  

 final  UpdateInfo info;
 final  String localPath;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateStateReadyToInstallCopyWith<UpdateStateReadyToInstall> get copyWith => _$UpdateStateReadyToInstallCopyWithImpl<UpdateStateReadyToInstall>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStateReadyToInstall&&(identical(other.info, info) || other.info == info)&&(identical(other.localPath, localPath) || other.localPath == localPath));
}


@override
int get hashCode => Object.hash(runtimeType,info,localPath);

@override
String toString() {
  return 'UpdateState.readyToInstall(info: $info, localPath: $localPath)';
}


}

/// @nodoc
abstract mixin class $UpdateStateReadyToInstallCopyWith<$Res> implements $UpdateStateCopyWith<$Res> {
  factory $UpdateStateReadyToInstallCopyWith(UpdateStateReadyToInstall value, $Res Function(UpdateStateReadyToInstall) _then) = _$UpdateStateReadyToInstallCopyWithImpl;
@useResult
$Res call({
 UpdateInfo info, String localPath
});


$UpdateInfoCopyWith<$Res> get info;

}
/// @nodoc
class _$UpdateStateReadyToInstallCopyWithImpl<$Res>
    implements $UpdateStateReadyToInstallCopyWith<$Res> {
  _$UpdateStateReadyToInstallCopyWithImpl(this._self, this._then);

  final UpdateStateReadyToInstall _self;
  final $Res Function(UpdateStateReadyToInstall) _then;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? info = null,Object? localPath = null,}) {
  return _then(UpdateStateReadyToInstall(
info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as UpdateInfo,localPath: null == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateInfoCopyWith<$Res> get info {
  
  return $UpdateInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}

/// @nodoc


class UpdateStateError implements UpdateState {
  const UpdateStateError(this.message);
  

 final  String message;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateStateErrorCopyWith<UpdateStateError> get copyWith => _$UpdateStateErrorCopyWithImpl<UpdateStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UpdateState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $UpdateStateErrorCopyWith<$Res> implements $UpdateStateCopyWith<$Res> {
  factory $UpdateStateErrorCopyWith(UpdateStateError value, $Res Function(UpdateStateError) _then) = _$UpdateStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UpdateStateErrorCopyWithImpl<$Res>
    implements $UpdateStateErrorCopyWith<$Res> {
  _$UpdateStateErrorCopyWithImpl(this._self, this._then);

  final UpdateStateError _self;
  final $Res Function(UpdateStateError) _then;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UpdateStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
