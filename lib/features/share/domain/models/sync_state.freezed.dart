// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SyncState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String filePath) exportSuccess,
    required TResult Function() importing,
    required TResult Function(AppBackup backup) preview,
    required TResult Function(ImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exportSuccess,
    TResult? Function()? importing,
    TResult? Function(AppBackup backup)? preview,
    TResult? Function(ImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String filePath)? exportSuccess,
    TResult Function()? importing,
    TResult Function(AppBackup backup)? preview,
    TResult Function(ImportResult result)? importSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncExporting value) exporting,
    required TResult Function(SyncExportSuccess value) exportSuccess,
    required TResult Function(SyncImporting value) importing,
    required TResult Function(SyncPreview value) preview,
    required TResult Function(SyncImportSuccess value) importSuccess,
    required TResult Function(SyncError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncExporting value)? exporting,
    TResult? Function(SyncExportSuccess value)? exportSuccess,
    TResult? Function(SyncImporting value)? importing,
    TResult? Function(SyncPreview value)? preview,
    TResult? Function(SyncImportSuccess value)? importSuccess,
    TResult? Function(SyncError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncExporting value)? exporting,
    TResult Function(SyncExportSuccess value)? exportSuccess,
    TResult Function(SyncImporting value)? importing,
    TResult Function(SyncPreview value)? preview,
    TResult Function(SyncImportSuccess value)? importSuccess,
    TResult Function(SyncError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStateCopyWith<$Res> {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) then) =
      _$SyncStateCopyWithImpl<$Res, SyncState>;
}

/// @nodoc
class _$SyncStateCopyWithImpl<$Res, $Val extends SyncState>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SyncIdleImplCopyWith<$Res> {
  factory _$$SyncIdleImplCopyWith(
          _$SyncIdleImpl value, $Res Function(_$SyncIdleImpl) then) =
      __$$SyncIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncIdleImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncIdleImpl>
    implements _$$SyncIdleImplCopyWith<$Res> {
  __$$SyncIdleImplCopyWithImpl(
      _$SyncIdleImpl _value, $Res Function(_$SyncIdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncIdleImpl implements SyncIdle {
  const _$SyncIdleImpl();

  @override
  String toString() {
    return 'SyncState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String filePath) exportSuccess,
    required TResult Function() importing,
    required TResult Function(AppBackup backup) preview,
    required TResult Function(ImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exportSuccess,
    TResult? Function()? importing,
    TResult? Function(AppBackup backup)? preview,
    TResult? Function(ImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String filePath)? exportSuccess,
    TResult Function()? importing,
    TResult Function(AppBackup backup)? preview,
    TResult Function(ImportResult result)? importSuccess,
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
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncExporting value) exporting,
    required TResult Function(SyncExportSuccess value) exportSuccess,
    required TResult Function(SyncImporting value) importing,
    required TResult Function(SyncPreview value) preview,
    required TResult Function(SyncImportSuccess value) importSuccess,
    required TResult Function(SyncError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncExporting value)? exporting,
    TResult? Function(SyncExportSuccess value)? exportSuccess,
    TResult? Function(SyncImporting value)? importing,
    TResult? Function(SyncPreview value)? preview,
    TResult? Function(SyncImportSuccess value)? importSuccess,
    TResult? Function(SyncError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncExporting value)? exporting,
    TResult Function(SyncExportSuccess value)? exportSuccess,
    TResult Function(SyncImporting value)? importing,
    TResult Function(SyncPreview value)? preview,
    TResult Function(SyncImportSuccess value)? importSuccess,
    TResult Function(SyncError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class SyncIdle implements SyncState {
  const factory SyncIdle() = _$SyncIdleImpl;
}

/// @nodoc
abstract class _$$SyncExportingImplCopyWith<$Res> {
  factory _$$SyncExportingImplCopyWith(
          _$SyncExportingImpl value, $Res Function(_$SyncExportingImpl) then) =
      __$$SyncExportingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncExportingImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncExportingImpl>
    implements _$$SyncExportingImplCopyWith<$Res> {
  __$$SyncExportingImplCopyWithImpl(
      _$SyncExportingImpl _value, $Res Function(_$SyncExportingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncExportingImpl implements SyncExporting {
  const _$SyncExportingImpl();

  @override
  String toString() {
    return 'SyncState.exporting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncExportingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String filePath) exportSuccess,
    required TResult Function() importing,
    required TResult Function(AppBackup backup) preview,
    required TResult Function(ImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return exporting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exportSuccess,
    TResult? Function()? importing,
    TResult? Function(AppBackup backup)? preview,
    TResult? Function(ImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return exporting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String filePath)? exportSuccess,
    TResult Function()? importing,
    TResult Function(AppBackup backup)? preview,
    TResult Function(ImportResult result)? importSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (exporting != null) {
      return exporting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncExporting value) exporting,
    required TResult Function(SyncExportSuccess value) exportSuccess,
    required TResult Function(SyncImporting value) importing,
    required TResult Function(SyncPreview value) preview,
    required TResult Function(SyncImportSuccess value) importSuccess,
    required TResult Function(SyncError value) error,
  }) {
    return exporting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncExporting value)? exporting,
    TResult? Function(SyncExportSuccess value)? exportSuccess,
    TResult? Function(SyncImporting value)? importing,
    TResult? Function(SyncPreview value)? preview,
    TResult? Function(SyncImportSuccess value)? importSuccess,
    TResult? Function(SyncError value)? error,
  }) {
    return exporting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncExporting value)? exporting,
    TResult Function(SyncExportSuccess value)? exportSuccess,
    TResult Function(SyncImporting value)? importing,
    TResult Function(SyncPreview value)? preview,
    TResult Function(SyncImportSuccess value)? importSuccess,
    TResult Function(SyncError value)? error,
    required TResult orElse(),
  }) {
    if (exporting != null) {
      return exporting(this);
    }
    return orElse();
  }
}

abstract class SyncExporting implements SyncState {
  const factory SyncExporting() = _$SyncExportingImpl;
}

/// @nodoc
abstract class _$$SyncExportSuccessImplCopyWith<$Res> {
  factory _$$SyncExportSuccessImplCopyWith(_$SyncExportSuccessImpl value,
          $Res Function(_$SyncExportSuccessImpl) then) =
      __$$SyncExportSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String filePath});
}

/// @nodoc
class __$$SyncExportSuccessImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncExportSuccessImpl>
    implements _$$SyncExportSuccessImplCopyWith<$Res> {
  __$$SyncExportSuccessImplCopyWithImpl(_$SyncExportSuccessImpl _value,
      $Res Function(_$SyncExportSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filePath = null,
  }) {
    return _then(_$SyncExportSuccessImpl(
      null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SyncExportSuccessImpl implements SyncExportSuccess {
  const _$SyncExportSuccessImpl(this.filePath);

  @override
  final String filePath;

  @override
  String toString() {
    return 'SyncState.exportSuccess(filePath: $filePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncExportSuccessImpl &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filePath);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncExportSuccessImplCopyWith<_$SyncExportSuccessImpl> get copyWith =>
      __$$SyncExportSuccessImplCopyWithImpl<_$SyncExportSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String filePath) exportSuccess,
    required TResult Function() importing,
    required TResult Function(AppBackup backup) preview,
    required TResult Function(ImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return exportSuccess(filePath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exportSuccess,
    TResult? Function()? importing,
    TResult? Function(AppBackup backup)? preview,
    TResult? Function(ImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return exportSuccess?.call(filePath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String filePath)? exportSuccess,
    TResult Function()? importing,
    TResult Function(AppBackup backup)? preview,
    TResult Function(ImportResult result)? importSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (exportSuccess != null) {
      return exportSuccess(filePath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncExporting value) exporting,
    required TResult Function(SyncExportSuccess value) exportSuccess,
    required TResult Function(SyncImporting value) importing,
    required TResult Function(SyncPreview value) preview,
    required TResult Function(SyncImportSuccess value) importSuccess,
    required TResult Function(SyncError value) error,
  }) {
    return exportSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncExporting value)? exporting,
    TResult? Function(SyncExportSuccess value)? exportSuccess,
    TResult? Function(SyncImporting value)? importing,
    TResult? Function(SyncPreview value)? preview,
    TResult? Function(SyncImportSuccess value)? importSuccess,
    TResult? Function(SyncError value)? error,
  }) {
    return exportSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncExporting value)? exporting,
    TResult Function(SyncExportSuccess value)? exportSuccess,
    TResult Function(SyncImporting value)? importing,
    TResult Function(SyncPreview value)? preview,
    TResult Function(SyncImportSuccess value)? importSuccess,
    TResult Function(SyncError value)? error,
    required TResult orElse(),
  }) {
    if (exportSuccess != null) {
      return exportSuccess(this);
    }
    return orElse();
  }
}

abstract class SyncExportSuccess implements SyncState {
  const factory SyncExportSuccess(final String filePath) =
      _$SyncExportSuccessImpl;

  String get filePath;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncExportSuccessImplCopyWith<_$SyncExportSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncImportingImplCopyWith<$Res> {
  factory _$$SyncImportingImplCopyWith(
          _$SyncImportingImpl value, $Res Function(_$SyncImportingImpl) then) =
      __$$SyncImportingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncImportingImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncImportingImpl>
    implements _$$SyncImportingImplCopyWith<$Res> {
  __$$SyncImportingImplCopyWithImpl(
      _$SyncImportingImpl _value, $Res Function(_$SyncImportingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncImportingImpl implements SyncImporting {
  const _$SyncImportingImpl();

  @override
  String toString() {
    return 'SyncState.importing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncImportingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String filePath) exportSuccess,
    required TResult Function() importing,
    required TResult Function(AppBackup backup) preview,
    required TResult Function(ImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return importing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exportSuccess,
    TResult? Function()? importing,
    TResult? Function(AppBackup backup)? preview,
    TResult? Function(ImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return importing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String filePath)? exportSuccess,
    TResult Function()? importing,
    TResult Function(AppBackup backup)? preview,
    TResult Function(ImportResult result)? importSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (importing != null) {
      return importing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncExporting value) exporting,
    required TResult Function(SyncExportSuccess value) exportSuccess,
    required TResult Function(SyncImporting value) importing,
    required TResult Function(SyncPreview value) preview,
    required TResult Function(SyncImportSuccess value) importSuccess,
    required TResult Function(SyncError value) error,
  }) {
    return importing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncExporting value)? exporting,
    TResult? Function(SyncExportSuccess value)? exportSuccess,
    TResult? Function(SyncImporting value)? importing,
    TResult? Function(SyncPreview value)? preview,
    TResult? Function(SyncImportSuccess value)? importSuccess,
    TResult? Function(SyncError value)? error,
  }) {
    return importing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncExporting value)? exporting,
    TResult Function(SyncExportSuccess value)? exportSuccess,
    TResult Function(SyncImporting value)? importing,
    TResult Function(SyncPreview value)? preview,
    TResult Function(SyncImportSuccess value)? importSuccess,
    TResult Function(SyncError value)? error,
    required TResult orElse(),
  }) {
    if (importing != null) {
      return importing(this);
    }
    return orElse();
  }
}

abstract class SyncImporting implements SyncState {
  const factory SyncImporting() = _$SyncImportingImpl;
}

/// @nodoc
abstract class _$$SyncPreviewImplCopyWith<$Res> {
  factory _$$SyncPreviewImplCopyWith(
          _$SyncPreviewImpl value, $Res Function(_$SyncPreviewImpl) then) =
      __$$SyncPreviewImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AppBackup backup});

  $AppBackupCopyWith<$Res> get backup;
}

/// @nodoc
class __$$SyncPreviewImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncPreviewImpl>
    implements _$$SyncPreviewImplCopyWith<$Res> {
  __$$SyncPreviewImplCopyWithImpl(
      _$SyncPreviewImpl _value, $Res Function(_$SyncPreviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backup = null,
  }) {
    return _then(_$SyncPreviewImpl(
      null == backup
          ? _value.backup
          : backup // ignore: cast_nullable_to_non_nullable
              as AppBackup,
    ));
  }

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppBackupCopyWith<$Res> get backup {
    return $AppBackupCopyWith<$Res>(_value.backup, (value) {
      return _then(_value.copyWith(backup: value));
    });
  }
}

/// @nodoc

class _$SyncPreviewImpl implements SyncPreview {
  const _$SyncPreviewImpl(this.backup);

  @override
  final AppBackup backup;

  @override
  String toString() {
    return 'SyncState.preview(backup: $backup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncPreviewImpl &&
            (identical(other.backup, backup) || other.backup == backup));
  }

  @override
  int get hashCode => Object.hash(runtimeType, backup);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncPreviewImplCopyWith<_$SyncPreviewImpl> get copyWith =>
      __$$SyncPreviewImplCopyWithImpl<_$SyncPreviewImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String filePath) exportSuccess,
    required TResult Function() importing,
    required TResult Function(AppBackup backup) preview,
    required TResult Function(ImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return preview(backup);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exportSuccess,
    TResult? Function()? importing,
    TResult? Function(AppBackup backup)? preview,
    TResult? Function(ImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return preview?.call(backup);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String filePath)? exportSuccess,
    TResult Function()? importing,
    TResult Function(AppBackup backup)? preview,
    TResult Function(ImportResult result)? importSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (preview != null) {
      return preview(backup);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncExporting value) exporting,
    required TResult Function(SyncExportSuccess value) exportSuccess,
    required TResult Function(SyncImporting value) importing,
    required TResult Function(SyncPreview value) preview,
    required TResult Function(SyncImportSuccess value) importSuccess,
    required TResult Function(SyncError value) error,
  }) {
    return preview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncExporting value)? exporting,
    TResult? Function(SyncExportSuccess value)? exportSuccess,
    TResult? Function(SyncImporting value)? importing,
    TResult? Function(SyncPreview value)? preview,
    TResult? Function(SyncImportSuccess value)? importSuccess,
    TResult? Function(SyncError value)? error,
  }) {
    return preview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncExporting value)? exporting,
    TResult Function(SyncExportSuccess value)? exportSuccess,
    TResult Function(SyncImporting value)? importing,
    TResult Function(SyncPreview value)? preview,
    TResult Function(SyncImportSuccess value)? importSuccess,
    TResult Function(SyncError value)? error,
    required TResult orElse(),
  }) {
    if (preview != null) {
      return preview(this);
    }
    return orElse();
  }
}

abstract class SyncPreview implements SyncState {
  const factory SyncPreview(final AppBackup backup) = _$SyncPreviewImpl;

  AppBackup get backup;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncPreviewImplCopyWith<_$SyncPreviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncImportSuccessImplCopyWith<$Res> {
  factory _$$SyncImportSuccessImplCopyWith(_$SyncImportSuccessImpl value,
          $Res Function(_$SyncImportSuccessImpl) then) =
      __$$SyncImportSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ImportResult result});

  $ImportResultCopyWith<$Res> get result;
}

/// @nodoc
class __$$SyncImportSuccessImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncImportSuccessImpl>
    implements _$$SyncImportSuccessImplCopyWith<$Res> {
  __$$SyncImportSuccessImplCopyWithImpl(_$SyncImportSuccessImpl _value,
      $Res Function(_$SyncImportSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
  }) {
    return _then(_$SyncImportSuccessImpl(
      null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as ImportResult,
    ));
  }

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImportResultCopyWith<$Res> get result {
    return $ImportResultCopyWith<$Res>(_value.result, (value) {
      return _then(_value.copyWith(result: value));
    });
  }
}

/// @nodoc

class _$SyncImportSuccessImpl implements SyncImportSuccess {
  const _$SyncImportSuccessImpl(this.result);

  @override
  final ImportResult result;

  @override
  String toString() {
    return 'SyncState.importSuccess(result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncImportSuccessImpl &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncImportSuccessImplCopyWith<_$SyncImportSuccessImpl> get copyWith =>
      __$$SyncImportSuccessImplCopyWithImpl<_$SyncImportSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String filePath) exportSuccess,
    required TResult Function() importing,
    required TResult Function(AppBackup backup) preview,
    required TResult Function(ImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return importSuccess(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exportSuccess,
    TResult? Function()? importing,
    TResult? Function(AppBackup backup)? preview,
    TResult? Function(ImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return importSuccess?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String filePath)? exportSuccess,
    TResult Function()? importing,
    TResult Function(AppBackup backup)? preview,
    TResult Function(ImportResult result)? importSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (importSuccess != null) {
      return importSuccess(result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncExporting value) exporting,
    required TResult Function(SyncExportSuccess value) exportSuccess,
    required TResult Function(SyncImporting value) importing,
    required TResult Function(SyncPreview value) preview,
    required TResult Function(SyncImportSuccess value) importSuccess,
    required TResult Function(SyncError value) error,
  }) {
    return importSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncExporting value)? exporting,
    TResult? Function(SyncExportSuccess value)? exportSuccess,
    TResult? Function(SyncImporting value)? importing,
    TResult? Function(SyncPreview value)? preview,
    TResult? Function(SyncImportSuccess value)? importSuccess,
    TResult? Function(SyncError value)? error,
  }) {
    return importSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncExporting value)? exporting,
    TResult Function(SyncExportSuccess value)? exportSuccess,
    TResult Function(SyncImporting value)? importing,
    TResult Function(SyncPreview value)? preview,
    TResult Function(SyncImportSuccess value)? importSuccess,
    TResult Function(SyncError value)? error,
    required TResult orElse(),
  }) {
    if (importSuccess != null) {
      return importSuccess(this);
    }
    return orElse();
  }
}

abstract class SyncImportSuccess implements SyncState {
  const factory SyncImportSuccess(final ImportResult result) =
      _$SyncImportSuccessImpl;

  ImportResult get result;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncImportSuccessImplCopyWith<_$SyncImportSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncErrorImplCopyWith<$Res> {
  factory _$$SyncErrorImplCopyWith(
          _$SyncErrorImpl value, $Res Function(_$SyncErrorImpl) then) =
      __$$SyncErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SyncErrorImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncErrorImpl>
    implements _$$SyncErrorImplCopyWith<$Res> {
  __$$SyncErrorImplCopyWithImpl(
      _$SyncErrorImpl _value, $Res Function(_$SyncErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SyncErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SyncErrorImpl implements SyncError {
  const _$SyncErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SyncState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncErrorImplCopyWith<_$SyncErrorImpl> get copyWith =>
      __$$SyncErrorImplCopyWithImpl<_$SyncErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String filePath) exportSuccess,
    required TResult Function() importing,
    required TResult Function(AppBackup backup) preview,
    required TResult Function(ImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String filePath)? exportSuccess,
    TResult? Function()? importing,
    TResult? Function(AppBackup backup)? preview,
    TResult? Function(ImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String filePath)? exportSuccess,
    TResult Function()? importing,
    TResult Function(AppBackup backup)? preview,
    TResult Function(ImportResult result)? importSuccess,
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
    required TResult Function(SyncIdle value) idle,
    required TResult Function(SyncExporting value) exporting,
    required TResult Function(SyncExportSuccess value) exportSuccess,
    required TResult Function(SyncImporting value) importing,
    required TResult Function(SyncPreview value) preview,
    required TResult Function(SyncImportSuccess value) importSuccess,
    required TResult Function(SyncError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncIdle value)? idle,
    TResult? Function(SyncExporting value)? exporting,
    TResult? Function(SyncExportSuccess value)? exportSuccess,
    TResult? Function(SyncImporting value)? importing,
    TResult? Function(SyncPreview value)? preview,
    TResult? Function(SyncImportSuccess value)? importSuccess,
    TResult? Function(SyncError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncIdle value)? idle,
    TResult Function(SyncExporting value)? exporting,
    TResult Function(SyncExportSuccess value)? exportSuccess,
    TResult Function(SyncImporting value)? importing,
    TResult Function(SyncPreview value)? preview,
    TResult Function(SyncImportSuccess value)? importSuccess,
    TResult Function(SyncError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SyncError implements SyncState {
  const factory SyncError(final String message) = _$SyncErrorImpl;

  String get message;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncErrorImplCopyWith<_$SyncErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ImportResult {
  /// 新建的歌单数量
  int get playlistsCreated => throw _privateConstructorUsedError;

  /// 合并的歌单数量（同名歌单合并歌曲）
  int get playlistsMerged => throw _privateConstructorUsedError;

  /// 新建的歌曲数量
  int get songsCreated => throw _privateConstructorUsedError;

  /// 跳过的歌曲数量（本地已存在）
  int get songsSkipped => throw _privateConstructorUsedError;

  /// 错误数量
  int get errors => throw _privateConstructorUsedError;

  /// 告警信息列表
  List<String> get warnings => throw _privateConstructorUsedError;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImportResultCopyWith<ImportResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportResultCopyWith<$Res> {
  factory $ImportResultCopyWith(
          ImportResult value, $Res Function(ImportResult) then) =
      _$ImportResultCopyWithImpl<$Res, ImportResult>;
  @useResult
  $Res call(
      {int playlistsCreated,
      int playlistsMerged,
      int songsCreated,
      int songsSkipped,
      int errors,
      List<String> warnings});
}

/// @nodoc
class _$ImportResultCopyWithImpl<$Res, $Val extends ImportResult>
    implements $ImportResultCopyWith<$Res> {
  _$ImportResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlistsCreated = null,
    Object? playlistsMerged = null,
    Object? songsCreated = null,
    Object? songsSkipped = null,
    Object? errors = null,
    Object? warnings = null,
  }) {
    return _then(_value.copyWith(
      playlistsCreated: null == playlistsCreated
          ? _value.playlistsCreated
          : playlistsCreated // ignore: cast_nullable_to_non_nullable
              as int,
      playlistsMerged: null == playlistsMerged
          ? _value.playlistsMerged
          : playlistsMerged // ignore: cast_nullable_to_non_nullable
              as int,
      songsCreated: null == songsCreated
          ? _value.songsCreated
          : songsCreated // ignore: cast_nullable_to_non_nullable
              as int,
      songsSkipped: null == songsSkipped
          ? _value.songsSkipped
          : songsSkipped // ignore: cast_nullable_to_non_nullable
              as int,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as int,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImportResultImplCopyWith<$Res>
    implements $ImportResultCopyWith<$Res> {
  factory _$$ImportResultImplCopyWith(
          _$ImportResultImpl value, $Res Function(_$ImportResultImpl) then) =
      __$$ImportResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int playlistsCreated,
      int playlistsMerged,
      int songsCreated,
      int songsSkipped,
      int errors,
      List<String> warnings});
}

/// @nodoc
class __$$ImportResultImplCopyWithImpl<$Res>
    extends _$ImportResultCopyWithImpl<$Res, _$ImportResultImpl>
    implements _$$ImportResultImplCopyWith<$Res> {
  __$$ImportResultImplCopyWithImpl(
      _$ImportResultImpl _value, $Res Function(_$ImportResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlistsCreated = null,
    Object? playlistsMerged = null,
    Object? songsCreated = null,
    Object? songsSkipped = null,
    Object? errors = null,
    Object? warnings = null,
  }) {
    return _then(_$ImportResultImpl(
      playlistsCreated: null == playlistsCreated
          ? _value.playlistsCreated
          : playlistsCreated // ignore: cast_nullable_to_non_nullable
              as int,
      playlistsMerged: null == playlistsMerged
          ? _value.playlistsMerged
          : playlistsMerged // ignore: cast_nullable_to_non_nullable
              as int,
      songsCreated: null == songsCreated
          ? _value.songsCreated
          : songsCreated // ignore: cast_nullable_to_non_nullable
              as int,
      songsSkipped: null == songsSkipped
          ? _value.songsSkipped
          : songsSkipped // ignore: cast_nullable_to_non_nullable
              as int,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as int,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$ImportResultImpl implements _ImportResult {
  const _$ImportResultImpl(
      {required this.playlistsCreated,
      required this.playlistsMerged,
      required this.songsCreated,
      required this.songsSkipped,
      required this.errors,
      final List<String> warnings = const []})
      : _warnings = warnings;

  /// 新建的歌单数量
  @override
  final int playlistsCreated;

  /// 合并的歌单数量（同名歌单合并歌曲）
  @override
  final int playlistsMerged;

  /// 新建的歌曲数量
  @override
  final int songsCreated;

  /// 跳过的歌曲数量（本地已存在）
  @override
  final int songsSkipped;

  /// 错误数量
  @override
  final int errors;

  /// 告警信息列表
  final List<String> _warnings;

  /// 告警信息列表
  @override
  @JsonKey()
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  @override
  String toString() {
    return 'ImportResult(playlistsCreated: $playlistsCreated, playlistsMerged: $playlistsMerged, songsCreated: $songsCreated, songsSkipped: $songsSkipped, errors: $errors, warnings: $warnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportResultImpl &&
            (identical(other.playlistsCreated, playlistsCreated) ||
                other.playlistsCreated == playlistsCreated) &&
            (identical(other.playlistsMerged, playlistsMerged) ||
                other.playlistsMerged == playlistsMerged) &&
            (identical(other.songsCreated, songsCreated) ||
                other.songsCreated == songsCreated) &&
            (identical(other.songsSkipped, songsSkipped) ||
                other.songsSkipped == songsSkipped) &&
            (identical(other.errors, errors) || other.errors == errors) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      playlistsCreated,
      playlistsMerged,
      songsCreated,
      songsSkipped,
      errors,
      const DeepCollectionEquality().hash(_warnings));

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportResultImplCopyWith<_$ImportResultImpl> get copyWith =>
      __$$ImportResultImplCopyWithImpl<_$ImportResultImpl>(this, _$identity);
}

abstract class _ImportResult implements ImportResult {
  const factory _ImportResult(
      {required final int playlistsCreated,
      required final int playlistsMerged,
      required final int songsCreated,
      required final int songsSkipped,
      required final int errors,
      final List<String> warnings}) = _$ImportResultImpl;

  /// 新建的歌单数量
  @override
  int get playlistsCreated;

  /// 合并的歌单数量（同名歌单合并歌曲）
  @override
  int get playlistsMerged;

  /// 新建的歌曲数量
  @override
  int get songsCreated;

  /// 跳过的歌曲数量（本地已存在）
  @override
  int get songsSkipped;

  /// 错误数量
  @override
  int get errors;

  /// 告警信息列表
  @override
  List<String> get warnings;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImportResultImplCopyWith<_$ImportResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
