// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UpdateState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() checking,
    required TResult Function(UpdateInfo info) available,
    required TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)
        downloading,
    required TResult Function(
            UpdateInfo info,
            double progress,
            DownloadChannel channel,
            int downloadedBytes,
            int totalBytes,
            String localPath)
        paused,
    required TResult Function(UpdateInfo info, String localPath) readyToInstall,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? checking,
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult? Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult? Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? checking,
    TResult Function(UpdateInfo info)? available,
    TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateStateIdle value) idle,
    required TResult Function(UpdateStateChecking value) checking,
    required TResult Function(UpdateStateAvailable value) available,
    required TResult Function(UpdateStateDownloading value) downloading,
    required TResult Function(UpdateStatePaused value) paused,
    required TResult Function(UpdateStateReadyToInstall value) readyToInstall,
    required TResult Function(UpdateStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateStateIdle value)? idle,
    TResult? Function(UpdateStateChecking value)? checking,
    TResult? Function(UpdateStateAvailable value)? available,
    TResult? Function(UpdateStateDownloading value)? downloading,
    TResult? Function(UpdateStatePaused value)? paused,
    TResult? Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult? Function(UpdateStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateStateIdle value)? idle,
    TResult Function(UpdateStateChecking value)? checking,
    TResult Function(UpdateStateAvailable value)? available,
    TResult Function(UpdateStateDownloading value)? downloading,
    TResult Function(UpdateStatePaused value)? paused,
    TResult Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult Function(UpdateStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateStateCopyWith<$Res> {
  factory $UpdateStateCopyWith(
          UpdateState value, $Res Function(UpdateState) then) =
      _$UpdateStateCopyWithImpl<$Res, UpdateState>;
}

/// @nodoc
class _$UpdateStateCopyWithImpl<$Res, $Val extends UpdateState>
    implements $UpdateStateCopyWith<$Res> {
  _$UpdateStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UpdateStateIdleImplCopyWith<$Res> {
  factory _$$UpdateStateIdleImplCopyWith(_$UpdateStateIdleImpl value,
          $Res Function(_$UpdateStateIdleImpl) then) =
      __$$UpdateStateIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpdateStateIdleImplCopyWithImpl<$Res>
    extends _$UpdateStateCopyWithImpl<$Res, _$UpdateStateIdleImpl>
    implements _$$UpdateStateIdleImplCopyWith<$Res> {
  __$$UpdateStateIdleImplCopyWithImpl(
      _$UpdateStateIdleImpl _value, $Res Function(_$UpdateStateIdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UpdateStateIdleImpl implements UpdateStateIdle {
  const _$UpdateStateIdleImpl();

  @override
  String toString() {
    return 'UpdateState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UpdateStateIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() checking,
    required TResult Function(UpdateInfo info) available,
    required TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)
        downloading,
    required TResult Function(
            UpdateInfo info,
            double progress,
            DownloadChannel channel,
            int downloadedBytes,
            int totalBytes,
            String localPath)
        paused,
    required TResult Function(UpdateInfo info, String localPath) readyToInstall,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? checking,
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult? Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult? Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? checking,
    TResult Function(UpdateInfo info)? available,
    TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateStateIdle value) idle,
    required TResult Function(UpdateStateChecking value) checking,
    required TResult Function(UpdateStateAvailable value) available,
    required TResult Function(UpdateStateDownloading value) downloading,
    required TResult Function(UpdateStatePaused value) paused,
    required TResult Function(UpdateStateReadyToInstall value) readyToInstall,
    required TResult Function(UpdateStateError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateStateIdle value)? idle,
    TResult? Function(UpdateStateChecking value)? checking,
    TResult? Function(UpdateStateAvailable value)? available,
    TResult? Function(UpdateStateDownloading value)? downloading,
    TResult? Function(UpdateStatePaused value)? paused,
    TResult? Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult? Function(UpdateStateError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateStateIdle value)? idle,
    TResult Function(UpdateStateChecking value)? checking,
    TResult Function(UpdateStateAvailable value)? available,
    TResult Function(UpdateStateDownloading value)? downloading,
    TResult Function(UpdateStatePaused value)? paused,
    TResult Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult Function(UpdateStateError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class UpdateStateIdle implements UpdateState {
  const factory UpdateStateIdle() = _$UpdateStateIdleImpl;
}

/// @nodoc
abstract class _$$UpdateStateCheckingImplCopyWith<$Res> {
  factory _$$UpdateStateCheckingImplCopyWith(_$UpdateStateCheckingImpl value,
          $Res Function(_$UpdateStateCheckingImpl) then) =
      __$$UpdateStateCheckingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpdateStateCheckingImplCopyWithImpl<$Res>
    extends _$UpdateStateCopyWithImpl<$Res, _$UpdateStateCheckingImpl>
    implements _$$UpdateStateCheckingImplCopyWith<$Res> {
  __$$UpdateStateCheckingImplCopyWithImpl(_$UpdateStateCheckingImpl _value,
      $Res Function(_$UpdateStateCheckingImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UpdateStateCheckingImpl implements UpdateStateChecking {
  const _$UpdateStateCheckingImpl();

  @override
  String toString() {
    return 'UpdateState.checking()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStateCheckingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() checking,
    required TResult Function(UpdateInfo info) available,
    required TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)
        downloading,
    required TResult Function(
            UpdateInfo info,
            double progress,
            DownloadChannel channel,
            int downloadedBytes,
            int totalBytes,
            String localPath)
        paused,
    required TResult Function(UpdateInfo info, String localPath) readyToInstall,
    required TResult Function(String message) error,
  }) {
    return checking();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? checking,
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult? Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult? Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult? Function(String message)? error,
  }) {
    return checking?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? checking,
    TResult Function(UpdateInfo info)? available,
    TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (checking != null) {
      return checking();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateStateIdle value) idle,
    required TResult Function(UpdateStateChecking value) checking,
    required TResult Function(UpdateStateAvailable value) available,
    required TResult Function(UpdateStateDownloading value) downloading,
    required TResult Function(UpdateStatePaused value) paused,
    required TResult Function(UpdateStateReadyToInstall value) readyToInstall,
    required TResult Function(UpdateStateError value) error,
  }) {
    return checking(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateStateIdle value)? idle,
    TResult? Function(UpdateStateChecking value)? checking,
    TResult? Function(UpdateStateAvailable value)? available,
    TResult? Function(UpdateStateDownloading value)? downloading,
    TResult? Function(UpdateStatePaused value)? paused,
    TResult? Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult? Function(UpdateStateError value)? error,
  }) {
    return checking?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateStateIdle value)? idle,
    TResult Function(UpdateStateChecking value)? checking,
    TResult Function(UpdateStateAvailable value)? available,
    TResult Function(UpdateStateDownloading value)? downloading,
    TResult Function(UpdateStatePaused value)? paused,
    TResult Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult Function(UpdateStateError value)? error,
    required TResult orElse(),
  }) {
    if (checking != null) {
      return checking(this);
    }
    return orElse();
  }
}

abstract class UpdateStateChecking implements UpdateState {
  const factory UpdateStateChecking() = _$UpdateStateCheckingImpl;
}

/// @nodoc
abstract class _$$UpdateStateAvailableImplCopyWith<$Res> {
  factory _$$UpdateStateAvailableImplCopyWith(_$UpdateStateAvailableImpl value,
          $Res Function(_$UpdateStateAvailableImpl) then) =
      __$$UpdateStateAvailableImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UpdateInfo info});

  $UpdateInfoCopyWith<$Res> get info;
}

/// @nodoc
class __$$UpdateStateAvailableImplCopyWithImpl<$Res>
    extends _$UpdateStateCopyWithImpl<$Res, _$UpdateStateAvailableImpl>
    implements _$$UpdateStateAvailableImplCopyWith<$Res> {
  __$$UpdateStateAvailableImplCopyWithImpl(_$UpdateStateAvailableImpl _value,
      $Res Function(_$UpdateStateAvailableImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = null,
  }) {
    return _then(_$UpdateStateAvailableImpl(
      null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as UpdateInfo,
    ));
  }

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateInfoCopyWith<$Res> get info {
    return $UpdateInfoCopyWith<$Res>(_value.info, (value) {
      return _then(_value.copyWith(info: value));
    });
  }
}

/// @nodoc

class _$UpdateStateAvailableImpl implements UpdateStateAvailable {
  const _$UpdateStateAvailableImpl(this.info);

  @override
  final UpdateInfo info;

  @override
  String toString() {
    return 'UpdateState.available(info: $info)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStateAvailableImpl &&
            (identical(other.info, info) || other.info == info));
  }

  @override
  int get hashCode => Object.hash(runtimeType, info);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStateAvailableImplCopyWith<_$UpdateStateAvailableImpl>
      get copyWith =>
          __$$UpdateStateAvailableImplCopyWithImpl<_$UpdateStateAvailableImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() checking,
    required TResult Function(UpdateInfo info) available,
    required TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)
        downloading,
    required TResult Function(
            UpdateInfo info,
            double progress,
            DownloadChannel channel,
            int downloadedBytes,
            int totalBytes,
            String localPath)
        paused,
    required TResult Function(UpdateInfo info, String localPath) readyToInstall,
    required TResult Function(String message) error,
  }) {
    return available(info);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? checking,
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult? Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult? Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult? Function(String message)? error,
  }) {
    return available?.call(info);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? checking,
    TResult Function(UpdateInfo info)? available,
    TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (available != null) {
      return available(info);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateStateIdle value) idle,
    required TResult Function(UpdateStateChecking value) checking,
    required TResult Function(UpdateStateAvailable value) available,
    required TResult Function(UpdateStateDownloading value) downloading,
    required TResult Function(UpdateStatePaused value) paused,
    required TResult Function(UpdateStateReadyToInstall value) readyToInstall,
    required TResult Function(UpdateStateError value) error,
  }) {
    return available(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateStateIdle value)? idle,
    TResult? Function(UpdateStateChecking value)? checking,
    TResult? Function(UpdateStateAvailable value)? available,
    TResult? Function(UpdateStateDownloading value)? downloading,
    TResult? Function(UpdateStatePaused value)? paused,
    TResult? Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult? Function(UpdateStateError value)? error,
  }) {
    return available?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateStateIdle value)? idle,
    TResult Function(UpdateStateChecking value)? checking,
    TResult Function(UpdateStateAvailable value)? available,
    TResult Function(UpdateStateDownloading value)? downloading,
    TResult Function(UpdateStatePaused value)? paused,
    TResult Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult Function(UpdateStateError value)? error,
    required TResult orElse(),
  }) {
    if (available != null) {
      return available(this);
    }
    return orElse();
  }
}

abstract class UpdateStateAvailable implements UpdateState {
  const factory UpdateStateAvailable(final UpdateInfo info) =
      _$UpdateStateAvailableImpl;

  UpdateInfo get info;

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateStateAvailableImplCopyWith<_$UpdateStateAvailableImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateStateDownloadingImplCopyWith<$Res> {
  factory _$$UpdateStateDownloadingImplCopyWith(
          _$UpdateStateDownloadingImpl value,
          $Res Function(_$UpdateStateDownloadingImpl) then) =
      __$$UpdateStateDownloadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {UpdateInfo info,
      double progress,
      double speed,
      DownloadChannel channel,
      int downloadedBytes,
      int totalBytes});

  $UpdateInfoCopyWith<$Res> get info;
}

/// @nodoc
class __$$UpdateStateDownloadingImplCopyWithImpl<$Res>
    extends _$UpdateStateCopyWithImpl<$Res, _$UpdateStateDownloadingImpl>
    implements _$$UpdateStateDownloadingImplCopyWith<$Res> {
  __$$UpdateStateDownloadingImplCopyWithImpl(
      _$UpdateStateDownloadingImpl _value,
      $Res Function(_$UpdateStateDownloadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = null,
    Object? progress = null,
    Object? speed = null,
    Object? channel = null,
    Object? downloadedBytes = null,
    Object? totalBytes = null,
  }) {
    return _then(_$UpdateStateDownloadingImpl(
      info: null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as UpdateInfo,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as DownloadChannel,
      downloadedBytes: null == downloadedBytes
          ? _value.downloadedBytes
          : downloadedBytes // ignore: cast_nullable_to_non_nullable
              as int,
      totalBytes: null == totalBytes
          ? _value.totalBytes
          : totalBytes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateInfoCopyWith<$Res> get info {
    return $UpdateInfoCopyWith<$Res>(_value.info, (value) {
      return _then(_value.copyWith(info: value));
    });
  }
}

/// @nodoc

class _$UpdateStateDownloadingImpl implements UpdateStateDownloading {
  const _$UpdateStateDownloadingImpl(
      {required this.info,
      required this.progress,
      required this.speed,
      required this.channel,
      this.downloadedBytes = 0,
      this.totalBytes = 0});

  @override
  final UpdateInfo info;
  @override
  final double progress;

  /// Download speed in bytes/second.
  @override
  final double speed;
  @override
  final DownloadChannel channel;
  @override
  @JsonKey()
  final int downloadedBytes;
  @override
  @JsonKey()
  final int totalBytes;

  @override
  String toString() {
    return 'UpdateState.downloading(info: $info, progress: $progress, speed: $speed, channel: $channel, downloadedBytes: $downloadedBytes, totalBytes: $totalBytes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStateDownloadingImpl &&
            (identical(other.info, info) || other.info == info) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.downloadedBytes, downloadedBytes) ||
                other.downloadedBytes == downloadedBytes) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, info, progress, speed, channel, downloadedBytes, totalBytes);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStateDownloadingImplCopyWith<_$UpdateStateDownloadingImpl>
      get copyWith => __$$UpdateStateDownloadingImplCopyWithImpl<
          _$UpdateStateDownloadingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() checking,
    required TResult Function(UpdateInfo info) available,
    required TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)
        downloading,
    required TResult Function(
            UpdateInfo info,
            double progress,
            DownloadChannel channel,
            int downloadedBytes,
            int totalBytes,
            String localPath)
        paused,
    required TResult Function(UpdateInfo info, String localPath) readyToInstall,
    required TResult Function(String message) error,
  }) {
    return downloading(
        info, progress, speed, channel, downloadedBytes, totalBytes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? checking,
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult? Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult? Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult? Function(String message)? error,
  }) {
    return downloading?.call(
        info, progress, speed, channel, downloadedBytes, totalBytes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? checking,
    TResult Function(UpdateInfo info)? available,
    TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (downloading != null) {
      return downloading(
          info, progress, speed, channel, downloadedBytes, totalBytes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateStateIdle value) idle,
    required TResult Function(UpdateStateChecking value) checking,
    required TResult Function(UpdateStateAvailable value) available,
    required TResult Function(UpdateStateDownloading value) downloading,
    required TResult Function(UpdateStatePaused value) paused,
    required TResult Function(UpdateStateReadyToInstall value) readyToInstall,
    required TResult Function(UpdateStateError value) error,
  }) {
    return downloading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateStateIdle value)? idle,
    TResult? Function(UpdateStateChecking value)? checking,
    TResult? Function(UpdateStateAvailable value)? available,
    TResult? Function(UpdateStateDownloading value)? downloading,
    TResult? Function(UpdateStatePaused value)? paused,
    TResult? Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult? Function(UpdateStateError value)? error,
  }) {
    return downloading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateStateIdle value)? idle,
    TResult Function(UpdateStateChecking value)? checking,
    TResult Function(UpdateStateAvailable value)? available,
    TResult Function(UpdateStateDownloading value)? downloading,
    TResult Function(UpdateStatePaused value)? paused,
    TResult Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult Function(UpdateStateError value)? error,
    required TResult orElse(),
  }) {
    if (downloading != null) {
      return downloading(this);
    }
    return orElse();
  }
}

abstract class UpdateStateDownloading implements UpdateState {
  const factory UpdateStateDownloading(
      {required final UpdateInfo info,
      required final double progress,
      required final double speed,
      required final DownloadChannel channel,
      final int downloadedBytes,
      final int totalBytes}) = _$UpdateStateDownloadingImpl;

  UpdateInfo get info;
  double get progress;

  /// Download speed in bytes/second.
  double get speed;
  DownloadChannel get channel;
  int get downloadedBytes;
  int get totalBytes;

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateStateDownloadingImplCopyWith<_$UpdateStateDownloadingImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateStatePausedImplCopyWith<$Res> {
  factory _$$UpdateStatePausedImplCopyWith(_$UpdateStatePausedImpl value,
          $Res Function(_$UpdateStatePausedImpl) then) =
      __$$UpdateStatePausedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {UpdateInfo info,
      double progress,
      DownloadChannel channel,
      int downloadedBytes,
      int totalBytes,
      String localPath});

  $UpdateInfoCopyWith<$Res> get info;
}

/// @nodoc
class __$$UpdateStatePausedImplCopyWithImpl<$Res>
    extends _$UpdateStateCopyWithImpl<$Res, _$UpdateStatePausedImpl>
    implements _$$UpdateStatePausedImplCopyWith<$Res> {
  __$$UpdateStatePausedImplCopyWithImpl(_$UpdateStatePausedImpl _value,
      $Res Function(_$UpdateStatePausedImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = null,
    Object? progress = null,
    Object? channel = null,
    Object? downloadedBytes = null,
    Object? totalBytes = null,
    Object? localPath = null,
  }) {
    return _then(_$UpdateStatePausedImpl(
      info: null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as UpdateInfo,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as DownloadChannel,
      downloadedBytes: null == downloadedBytes
          ? _value.downloadedBytes
          : downloadedBytes // ignore: cast_nullable_to_non_nullable
              as int,
      totalBytes: null == totalBytes
          ? _value.totalBytes
          : totalBytes // ignore: cast_nullable_to_non_nullable
              as int,
      localPath: null == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateInfoCopyWith<$Res> get info {
    return $UpdateInfoCopyWith<$Res>(_value.info, (value) {
      return _then(_value.copyWith(info: value));
    });
  }
}

/// @nodoc

class _$UpdateStatePausedImpl implements UpdateStatePaused {
  const _$UpdateStatePausedImpl(
      {required this.info,
      required this.progress,
      required this.channel,
      required this.downloadedBytes,
      required this.totalBytes,
      required this.localPath});

  @override
  final UpdateInfo info;
  @override
  final double progress;
  @override
  final DownloadChannel channel;
  @override
  final int downloadedBytes;
  @override
  final int totalBytes;
  @override
  final String localPath;

  @override
  String toString() {
    return 'UpdateState.paused(info: $info, progress: $progress, channel: $channel, downloadedBytes: $downloadedBytes, totalBytes: $totalBytes, localPath: $localPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStatePausedImpl &&
            (identical(other.info, info) || other.info == info) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.downloadedBytes, downloadedBytes) ||
                other.downloadedBytes == downloadedBytes) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, info, progress, channel,
      downloadedBytes, totalBytes, localPath);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStatePausedImplCopyWith<_$UpdateStatePausedImpl> get copyWith =>
      __$$UpdateStatePausedImplCopyWithImpl<_$UpdateStatePausedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() checking,
    required TResult Function(UpdateInfo info) available,
    required TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)
        downloading,
    required TResult Function(
            UpdateInfo info,
            double progress,
            DownloadChannel channel,
            int downloadedBytes,
            int totalBytes,
            String localPath)
        paused,
    required TResult Function(UpdateInfo info, String localPath) readyToInstall,
    required TResult Function(String message) error,
  }) {
    return paused(
        info, progress, channel, downloadedBytes, totalBytes, localPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? checking,
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult? Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult? Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult? Function(String message)? error,
  }) {
    return paused?.call(
        info, progress, channel, downloadedBytes, totalBytes, localPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? checking,
    TResult Function(UpdateInfo info)? available,
    TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(
          info, progress, channel, downloadedBytes, totalBytes, localPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateStateIdle value) idle,
    required TResult Function(UpdateStateChecking value) checking,
    required TResult Function(UpdateStateAvailable value) available,
    required TResult Function(UpdateStateDownloading value) downloading,
    required TResult Function(UpdateStatePaused value) paused,
    required TResult Function(UpdateStateReadyToInstall value) readyToInstall,
    required TResult Function(UpdateStateError value) error,
  }) {
    return paused(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateStateIdle value)? idle,
    TResult? Function(UpdateStateChecking value)? checking,
    TResult? Function(UpdateStateAvailable value)? available,
    TResult? Function(UpdateStateDownloading value)? downloading,
    TResult? Function(UpdateStatePaused value)? paused,
    TResult? Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult? Function(UpdateStateError value)? error,
  }) {
    return paused?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateStateIdle value)? idle,
    TResult Function(UpdateStateChecking value)? checking,
    TResult Function(UpdateStateAvailable value)? available,
    TResult Function(UpdateStateDownloading value)? downloading,
    TResult Function(UpdateStatePaused value)? paused,
    TResult Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult Function(UpdateStateError value)? error,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(this);
    }
    return orElse();
  }
}

abstract class UpdateStatePaused implements UpdateState {
  const factory UpdateStatePaused(
      {required final UpdateInfo info,
      required final double progress,
      required final DownloadChannel channel,
      required final int downloadedBytes,
      required final int totalBytes,
      required final String localPath}) = _$UpdateStatePausedImpl;

  UpdateInfo get info;
  double get progress;
  DownloadChannel get channel;
  int get downloadedBytes;
  int get totalBytes;
  String get localPath;

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateStatePausedImplCopyWith<_$UpdateStatePausedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateStateReadyToInstallImplCopyWith<$Res> {
  factory _$$UpdateStateReadyToInstallImplCopyWith(
          _$UpdateStateReadyToInstallImpl value,
          $Res Function(_$UpdateStateReadyToInstallImpl) then) =
      __$$UpdateStateReadyToInstallImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UpdateInfo info, String localPath});

  $UpdateInfoCopyWith<$Res> get info;
}

/// @nodoc
class __$$UpdateStateReadyToInstallImplCopyWithImpl<$Res>
    extends _$UpdateStateCopyWithImpl<$Res, _$UpdateStateReadyToInstallImpl>
    implements _$$UpdateStateReadyToInstallImplCopyWith<$Res> {
  __$$UpdateStateReadyToInstallImplCopyWithImpl(
      _$UpdateStateReadyToInstallImpl _value,
      $Res Function(_$UpdateStateReadyToInstallImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = null,
    Object? localPath = null,
  }) {
    return _then(_$UpdateStateReadyToInstallImpl(
      info: null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as UpdateInfo,
      localPath: null == localPath
          ? _value.localPath
          : localPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateInfoCopyWith<$Res> get info {
    return $UpdateInfoCopyWith<$Res>(_value.info, (value) {
      return _then(_value.copyWith(info: value));
    });
  }
}

/// @nodoc

class _$UpdateStateReadyToInstallImpl implements UpdateStateReadyToInstall {
  const _$UpdateStateReadyToInstallImpl(
      {required this.info, required this.localPath});

  @override
  final UpdateInfo info;
  @override
  final String localPath;

  @override
  String toString() {
    return 'UpdateState.readyToInstall(info: $info, localPath: $localPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStateReadyToInstallImpl &&
            (identical(other.info, info) || other.info == info) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, info, localPath);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStateReadyToInstallImplCopyWith<_$UpdateStateReadyToInstallImpl>
      get copyWith => __$$UpdateStateReadyToInstallImplCopyWithImpl<
          _$UpdateStateReadyToInstallImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() checking,
    required TResult Function(UpdateInfo info) available,
    required TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)
        downloading,
    required TResult Function(
            UpdateInfo info,
            double progress,
            DownloadChannel channel,
            int downloadedBytes,
            int totalBytes,
            String localPath)
        paused,
    required TResult Function(UpdateInfo info, String localPath) readyToInstall,
    required TResult Function(String message) error,
  }) {
    return readyToInstall(info, localPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? checking,
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult? Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult? Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult? Function(String message)? error,
  }) {
    return readyToInstall?.call(info, localPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? checking,
    TResult Function(UpdateInfo info)? available,
    TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (readyToInstall != null) {
      return readyToInstall(info, localPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateStateIdle value) idle,
    required TResult Function(UpdateStateChecking value) checking,
    required TResult Function(UpdateStateAvailable value) available,
    required TResult Function(UpdateStateDownloading value) downloading,
    required TResult Function(UpdateStatePaused value) paused,
    required TResult Function(UpdateStateReadyToInstall value) readyToInstall,
    required TResult Function(UpdateStateError value) error,
  }) {
    return readyToInstall(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateStateIdle value)? idle,
    TResult? Function(UpdateStateChecking value)? checking,
    TResult? Function(UpdateStateAvailable value)? available,
    TResult? Function(UpdateStateDownloading value)? downloading,
    TResult? Function(UpdateStatePaused value)? paused,
    TResult? Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult? Function(UpdateStateError value)? error,
  }) {
    return readyToInstall?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateStateIdle value)? idle,
    TResult Function(UpdateStateChecking value)? checking,
    TResult Function(UpdateStateAvailable value)? available,
    TResult Function(UpdateStateDownloading value)? downloading,
    TResult Function(UpdateStatePaused value)? paused,
    TResult Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult Function(UpdateStateError value)? error,
    required TResult orElse(),
  }) {
    if (readyToInstall != null) {
      return readyToInstall(this);
    }
    return orElse();
  }
}

abstract class UpdateStateReadyToInstall implements UpdateState {
  const factory UpdateStateReadyToInstall(
      {required final UpdateInfo info,
      required final String localPath}) = _$UpdateStateReadyToInstallImpl;

  UpdateInfo get info;
  String get localPath;

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateStateReadyToInstallImplCopyWith<_$UpdateStateReadyToInstallImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateStateErrorImplCopyWith<$Res> {
  factory _$$UpdateStateErrorImplCopyWith(_$UpdateStateErrorImpl value,
          $Res Function(_$UpdateStateErrorImpl) then) =
      __$$UpdateStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UpdateStateErrorImplCopyWithImpl<$Res>
    extends _$UpdateStateCopyWithImpl<$Res, _$UpdateStateErrorImpl>
    implements _$$UpdateStateErrorImplCopyWith<$Res> {
  __$$UpdateStateErrorImplCopyWithImpl(_$UpdateStateErrorImpl _value,
      $Res Function(_$UpdateStateErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$UpdateStateErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UpdateStateErrorImpl implements UpdateStateError {
  const _$UpdateStateErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'UpdateState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStateErrorImplCopyWith<_$UpdateStateErrorImpl> get copyWith =>
      __$$UpdateStateErrorImplCopyWithImpl<_$UpdateStateErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() checking,
    required TResult Function(UpdateInfo info) available,
    required TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)
        downloading,
    required TResult Function(
            UpdateInfo info,
            double progress,
            DownloadChannel channel,
            int downloadedBytes,
            int totalBytes,
            String localPath)
        paused,
    required TResult Function(UpdateInfo info, String localPath) readyToInstall,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? checking,
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult? Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult? Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? checking,
    TResult Function(UpdateInfo info)? available,
    TResult Function(UpdateInfo info, double progress, double speed,
            DownloadChannel channel, int downloadedBytes, int totalBytes)?
        downloading,
    TResult Function(UpdateInfo info, double progress, DownloadChannel channel,
            int downloadedBytes, int totalBytes, String localPath)?
        paused,
    TResult Function(UpdateInfo info, String localPath)? readyToInstall,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateStateIdle value) idle,
    required TResult Function(UpdateStateChecking value) checking,
    required TResult Function(UpdateStateAvailable value) available,
    required TResult Function(UpdateStateDownloading value) downloading,
    required TResult Function(UpdateStatePaused value) paused,
    required TResult Function(UpdateStateReadyToInstall value) readyToInstall,
    required TResult Function(UpdateStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateStateIdle value)? idle,
    TResult? Function(UpdateStateChecking value)? checking,
    TResult? Function(UpdateStateAvailable value)? available,
    TResult? Function(UpdateStateDownloading value)? downloading,
    TResult? Function(UpdateStatePaused value)? paused,
    TResult? Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult? Function(UpdateStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateStateIdle value)? idle,
    TResult Function(UpdateStateChecking value)? checking,
    TResult Function(UpdateStateAvailable value)? available,
    TResult Function(UpdateStateDownloading value)? downloading,
    TResult Function(UpdateStatePaused value)? paused,
    TResult Function(UpdateStateReadyToInstall value)? readyToInstall,
    TResult Function(UpdateStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class UpdateStateError implements UpdateState {
  const factory UpdateStateError(final String message) = _$UpdateStateErrorImpl;

  String get message;

  /// Create a copy of UpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateStateErrorImplCopyWith<_$UpdateStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
