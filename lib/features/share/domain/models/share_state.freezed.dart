// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShareState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String data) exported,
    required TResult Function(int current, int total) importing,
    required TResult Function(SharedPlaylistPreview preview) preview,
    required TResult Function(ShareImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String data)? exported,
    TResult? Function(int current, int total)? importing,
    TResult? Function(SharedPlaylistPreview preview)? preview,
    TResult? Function(ShareImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String data)? exported,
    TResult Function(int current, int total)? importing,
    TResult Function(SharedPlaylistPreview preview)? preview,
    TResult Function(ShareImportResult result)? importSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShareIdle value) idle,
    required TResult Function(ShareExporting value) exporting,
    required TResult Function(ShareExported value) exported,
    required TResult Function(ShareImporting value) importing,
    required TResult Function(SharePreview value) preview,
    required TResult Function(ShareImportSuccess value) importSuccess,
    required TResult Function(ShareError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShareIdle value)? idle,
    TResult? Function(ShareExporting value)? exporting,
    TResult? Function(ShareExported value)? exported,
    TResult? Function(ShareImporting value)? importing,
    TResult? Function(SharePreview value)? preview,
    TResult? Function(ShareImportSuccess value)? importSuccess,
    TResult? Function(ShareError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShareIdle value)? idle,
    TResult Function(ShareExporting value)? exporting,
    TResult Function(ShareExported value)? exported,
    TResult Function(ShareImporting value)? importing,
    TResult Function(SharePreview value)? preview,
    TResult Function(ShareImportSuccess value)? importSuccess,
    TResult Function(ShareError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareStateCopyWith<$Res> {
  factory $ShareStateCopyWith(
          ShareState value, $Res Function(ShareState) then) =
      _$ShareStateCopyWithImpl<$Res, ShareState>;
}

/// @nodoc
class _$ShareStateCopyWithImpl<$Res, $Val extends ShareState>
    implements $ShareStateCopyWith<$Res> {
  _$ShareStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ShareIdleImplCopyWith<$Res> {
  factory _$$ShareIdleImplCopyWith(
          _$ShareIdleImpl value, $Res Function(_$ShareIdleImpl) then) =
      __$$ShareIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ShareIdleImplCopyWithImpl<$Res>
    extends _$ShareStateCopyWithImpl<$Res, _$ShareIdleImpl>
    implements _$$ShareIdleImplCopyWith<$Res> {
  __$$ShareIdleImplCopyWithImpl(
      _$ShareIdleImpl _value, $Res Function(_$ShareIdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ShareIdleImpl implements ShareIdle {
  const _$ShareIdleImpl();

  @override
  String toString() {
    return 'ShareState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ShareIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String data) exported,
    required TResult Function(int current, int total) importing,
    required TResult Function(SharedPlaylistPreview preview) preview,
    required TResult Function(ShareImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String data)? exported,
    TResult? Function(int current, int total)? importing,
    TResult? Function(SharedPlaylistPreview preview)? preview,
    TResult? Function(ShareImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String data)? exported,
    TResult Function(int current, int total)? importing,
    TResult Function(SharedPlaylistPreview preview)? preview,
    TResult Function(ShareImportResult result)? importSuccess,
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
    required TResult Function(ShareIdle value) idle,
    required TResult Function(ShareExporting value) exporting,
    required TResult Function(ShareExported value) exported,
    required TResult Function(ShareImporting value) importing,
    required TResult Function(SharePreview value) preview,
    required TResult Function(ShareImportSuccess value) importSuccess,
    required TResult Function(ShareError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShareIdle value)? idle,
    TResult? Function(ShareExporting value)? exporting,
    TResult? Function(ShareExported value)? exported,
    TResult? Function(ShareImporting value)? importing,
    TResult? Function(SharePreview value)? preview,
    TResult? Function(ShareImportSuccess value)? importSuccess,
    TResult? Function(ShareError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShareIdle value)? idle,
    TResult Function(ShareExporting value)? exporting,
    TResult Function(ShareExported value)? exported,
    TResult Function(ShareImporting value)? importing,
    TResult Function(SharePreview value)? preview,
    TResult Function(ShareImportSuccess value)? importSuccess,
    TResult Function(ShareError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class ShareIdle implements ShareState {
  const factory ShareIdle() = _$ShareIdleImpl;
}

/// @nodoc
abstract class _$$ShareExportingImplCopyWith<$Res> {
  factory _$$ShareExportingImplCopyWith(_$ShareExportingImpl value,
          $Res Function(_$ShareExportingImpl) then) =
      __$$ShareExportingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ShareExportingImplCopyWithImpl<$Res>
    extends _$ShareStateCopyWithImpl<$Res, _$ShareExportingImpl>
    implements _$$ShareExportingImplCopyWith<$Res> {
  __$$ShareExportingImplCopyWithImpl(
      _$ShareExportingImpl _value, $Res Function(_$ShareExportingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ShareExportingImpl implements ShareExporting {
  const _$ShareExportingImpl();

  @override
  String toString() {
    return 'ShareState.exporting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ShareExportingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String data) exported,
    required TResult Function(int current, int total) importing,
    required TResult Function(SharedPlaylistPreview preview) preview,
    required TResult Function(ShareImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return exporting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String data)? exported,
    TResult? Function(int current, int total)? importing,
    TResult? Function(SharedPlaylistPreview preview)? preview,
    TResult? Function(ShareImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return exporting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String data)? exported,
    TResult Function(int current, int total)? importing,
    TResult Function(SharedPlaylistPreview preview)? preview,
    TResult Function(ShareImportResult result)? importSuccess,
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
    required TResult Function(ShareIdle value) idle,
    required TResult Function(ShareExporting value) exporting,
    required TResult Function(ShareExported value) exported,
    required TResult Function(ShareImporting value) importing,
    required TResult Function(SharePreview value) preview,
    required TResult Function(ShareImportSuccess value) importSuccess,
    required TResult Function(ShareError value) error,
  }) {
    return exporting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShareIdle value)? idle,
    TResult? Function(ShareExporting value)? exporting,
    TResult? Function(ShareExported value)? exported,
    TResult? Function(ShareImporting value)? importing,
    TResult? Function(SharePreview value)? preview,
    TResult? Function(ShareImportSuccess value)? importSuccess,
    TResult? Function(ShareError value)? error,
  }) {
    return exporting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShareIdle value)? idle,
    TResult Function(ShareExporting value)? exporting,
    TResult Function(ShareExported value)? exported,
    TResult Function(ShareImporting value)? importing,
    TResult Function(SharePreview value)? preview,
    TResult Function(ShareImportSuccess value)? importSuccess,
    TResult Function(ShareError value)? error,
    required TResult orElse(),
  }) {
    if (exporting != null) {
      return exporting(this);
    }
    return orElse();
  }
}

abstract class ShareExporting implements ShareState {
  const factory ShareExporting() = _$ShareExportingImpl;
}

/// @nodoc
abstract class _$$ShareExportedImplCopyWith<$Res> {
  factory _$$ShareExportedImplCopyWith(
          _$ShareExportedImpl value, $Res Function(_$ShareExportedImpl) then) =
      __$$ShareExportedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String data});
}

/// @nodoc
class __$$ShareExportedImplCopyWithImpl<$Res>
    extends _$ShareStateCopyWithImpl<$Res, _$ShareExportedImpl>
    implements _$$ShareExportedImplCopyWith<$Res> {
  __$$ShareExportedImplCopyWithImpl(
      _$ShareExportedImpl _value, $Res Function(_$ShareExportedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$ShareExportedImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ShareExportedImpl implements ShareExported {
  const _$ShareExportedImpl(this.data);

  @override
  final String data;

  @override
  String toString() {
    return 'ShareState.exported(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareExportedImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareExportedImplCopyWith<_$ShareExportedImpl> get copyWith =>
      __$$ShareExportedImplCopyWithImpl<_$ShareExportedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String data) exported,
    required TResult Function(int current, int total) importing,
    required TResult Function(SharedPlaylistPreview preview) preview,
    required TResult Function(ShareImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return exported(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String data)? exported,
    TResult? Function(int current, int total)? importing,
    TResult? Function(SharedPlaylistPreview preview)? preview,
    TResult? Function(ShareImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return exported?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String data)? exported,
    TResult Function(int current, int total)? importing,
    TResult Function(SharedPlaylistPreview preview)? preview,
    TResult Function(ShareImportResult result)? importSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (exported != null) {
      return exported(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShareIdle value) idle,
    required TResult Function(ShareExporting value) exporting,
    required TResult Function(ShareExported value) exported,
    required TResult Function(ShareImporting value) importing,
    required TResult Function(SharePreview value) preview,
    required TResult Function(ShareImportSuccess value) importSuccess,
    required TResult Function(ShareError value) error,
  }) {
    return exported(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShareIdle value)? idle,
    TResult? Function(ShareExporting value)? exporting,
    TResult? Function(ShareExported value)? exported,
    TResult? Function(ShareImporting value)? importing,
    TResult? Function(SharePreview value)? preview,
    TResult? Function(ShareImportSuccess value)? importSuccess,
    TResult? Function(ShareError value)? error,
  }) {
    return exported?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShareIdle value)? idle,
    TResult Function(ShareExporting value)? exporting,
    TResult Function(ShareExported value)? exported,
    TResult Function(ShareImporting value)? importing,
    TResult Function(SharePreview value)? preview,
    TResult Function(ShareImportSuccess value)? importSuccess,
    TResult Function(ShareError value)? error,
    required TResult orElse(),
  }) {
    if (exported != null) {
      return exported(this);
    }
    return orElse();
  }
}

abstract class ShareExported implements ShareState {
  const factory ShareExported(final String data) = _$ShareExportedImpl;

  String get data;

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareExportedImplCopyWith<_$ShareExportedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ShareImportingImplCopyWith<$Res> {
  factory _$$ShareImportingImplCopyWith(_$ShareImportingImpl value,
          $Res Function(_$ShareImportingImpl) then) =
      __$$ShareImportingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int current, int total});
}

/// @nodoc
class __$$ShareImportingImplCopyWithImpl<$Res>
    extends _$ShareStateCopyWithImpl<$Res, _$ShareImportingImpl>
    implements _$$ShareImportingImplCopyWith<$Res> {
  __$$ShareImportingImplCopyWithImpl(
      _$ShareImportingImpl _value, $Res Function(_$ShareImportingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? total = null,
  }) {
    return _then(_$ShareImportingImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ShareImportingImpl implements ShareImporting {
  const _$ShareImportingImpl({this.current = 0, this.total = 0});

  @override
  @JsonKey()
  final int current;
  @override
  @JsonKey()
  final int total;

  @override
  String toString() {
    return 'ShareState.importing(current: $current, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareImportingImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(runtimeType, current, total);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareImportingImplCopyWith<_$ShareImportingImpl> get copyWith =>
      __$$ShareImportingImplCopyWithImpl<_$ShareImportingImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String data) exported,
    required TResult Function(int current, int total) importing,
    required TResult Function(SharedPlaylistPreview preview) preview,
    required TResult Function(ShareImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return importing(current, total);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String data)? exported,
    TResult? Function(int current, int total)? importing,
    TResult? Function(SharedPlaylistPreview preview)? preview,
    TResult? Function(ShareImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return importing?.call(current, total);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String data)? exported,
    TResult Function(int current, int total)? importing,
    TResult Function(SharedPlaylistPreview preview)? preview,
    TResult Function(ShareImportResult result)? importSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (importing != null) {
      return importing(current, total);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShareIdle value) idle,
    required TResult Function(ShareExporting value) exporting,
    required TResult Function(ShareExported value) exported,
    required TResult Function(ShareImporting value) importing,
    required TResult Function(SharePreview value) preview,
    required TResult Function(ShareImportSuccess value) importSuccess,
    required TResult Function(ShareError value) error,
  }) {
    return importing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShareIdle value)? idle,
    TResult? Function(ShareExporting value)? exporting,
    TResult? Function(ShareExported value)? exported,
    TResult? Function(ShareImporting value)? importing,
    TResult? Function(SharePreview value)? preview,
    TResult? Function(ShareImportSuccess value)? importSuccess,
    TResult? Function(ShareError value)? error,
  }) {
    return importing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShareIdle value)? idle,
    TResult Function(ShareExporting value)? exporting,
    TResult Function(ShareExported value)? exported,
    TResult Function(ShareImporting value)? importing,
    TResult Function(SharePreview value)? preview,
    TResult Function(ShareImportSuccess value)? importSuccess,
    TResult Function(ShareError value)? error,
    required TResult orElse(),
  }) {
    if (importing != null) {
      return importing(this);
    }
    return orElse();
  }
}

abstract class ShareImporting implements ShareState {
  const factory ShareImporting({final int current, final int total}) =
      _$ShareImportingImpl;

  int get current;
  int get total;

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareImportingImplCopyWith<_$ShareImportingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SharePreviewImplCopyWith<$Res> {
  factory _$$SharePreviewImplCopyWith(
          _$SharePreviewImpl value, $Res Function(_$SharePreviewImpl) then) =
      __$$SharePreviewImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SharedPlaylistPreview preview});

  $SharedPlaylistPreviewCopyWith<$Res> get preview;
}

/// @nodoc
class __$$SharePreviewImplCopyWithImpl<$Res>
    extends _$ShareStateCopyWithImpl<$Res, _$SharePreviewImpl>
    implements _$$SharePreviewImplCopyWith<$Res> {
  __$$SharePreviewImplCopyWithImpl(
      _$SharePreviewImpl _value, $Res Function(_$SharePreviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preview = null,
  }) {
    return _then(_$SharePreviewImpl(
      null == preview
          ? _value.preview
          : preview // ignore: cast_nullable_to_non_nullable
              as SharedPlaylistPreview,
    ));
  }

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SharedPlaylistPreviewCopyWith<$Res> get preview {
    return $SharedPlaylistPreviewCopyWith<$Res>(_value.preview, (value) {
      return _then(_value.copyWith(preview: value));
    });
  }
}

/// @nodoc

class _$SharePreviewImpl implements SharePreview {
  const _$SharePreviewImpl(this.preview);

  @override
  final SharedPlaylistPreview preview;

  @override
  String toString() {
    return 'ShareState.preview(preview: $preview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharePreviewImpl &&
            (identical(other.preview, preview) || other.preview == preview));
  }

  @override
  int get hashCode => Object.hash(runtimeType, preview);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharePreviewImplCopyWith<_$SharePreviewImpl> get copyWith =>
      __$$SharePreviewImplCopyWithImpl<_$SharePreviewImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String data) exported,
    required TResult Function(int current, int total) importing,
    required TResult Function(SharedPlaylistPreview preview) preview,
    required TResult Function(ShareImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return preview(this.preview);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String data)? exported,
    TResult? Function(int current, int total)? importing,
    TResult? Function(SharedPlaylistPreview preview)? preview,
    TResult? Function(ShareImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return preview?.call(this.preview);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String data)? exported,
    TResult Function(int current, int total)? importing,
    TResult Function(SharedPlaylistPreview preview)? preview,
    TResult Function(ShareImportResult result)? importSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (preview != null) {
      return preview(this.preview);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShareIdle value) idle,
    required TResult Function(ShareExporting value) exporting,
    required TResult Function(ShareExported value) exported,
    required TResult Function(ShareImporting value) importing,
    required TResult Function(SharePreview value) preview,
    required TResult Function(ShareImportSuccess value) importSuccess,
    required TResult Function(ShareError value) error,
  }) {
    return preview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShareIdle value)? idle,
    TResult? Function(ShareExporting value)? exporting,
    TResult? Function(ShareExported value)? exported,
    TResult? Function(ShareImporting value)? importing,
    TResult? Function(SharePreview value)? preview,
    TResult? Function(ShareImportSuccess value)? importSuccess,
    TResult? Function(ShareError value)? error,
  }) {
    return preview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShareIdle value)? idle,
    TResult Function(ShareExporting value)? exporting,
    TResult Function(ShareExported value)? exported,
    TResult Function(ShareImporting value)? importing,
    TResult Function(SharePreview value)? preview,
    TResult Function(ShareImportSuccess value)? importSuccess,
    TResult Function(ShareError value)? error,
    required TResult orElse(),
  }) {
    if (preview != null) {
      return preview(this);
    }
    return orElse();
  }
}

abstract class SharePreview implements ShareState {
  const factory SharePreview(final SharedPlaylistPreview preview) =
      _$SharePreviewImpl;

  SharedPlaylistPreview get preview;

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharePreviewImplCopyWith<_$SharePreviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ShareImportSuccessImplCopyWith<$Res> {
  factory _$$ShareImportSuccessImplCopyWith(_$ShareImportSuccessImpl value,
          $Res Function(_$ShareImportSuccessImpl) then) =
      __$$ShareImportSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ShareImportResult result});

  $ShareImportResultCopyWith<$Res> get result;
}

/// @nodoc
class __$$ShareImportSuccessImplCopyWithImpl<$Res>
    extends _$ShareStateCopyWithImpl<$Res, _$ShareImportSuccessImpl>
    implements _$$ShareImportSuccessImplCopyWith<$Res> {
  __$$ShareImportSuccessImplCopyWithImpl(_$ShareImportSuccessImpl _value,
      $Res Function(_$ShareImportSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
  }) {
    return _then(_$ShareImportSuccessImpl(
      null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as ShareImportResult,
    ));
  }

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShareImportResultCopyWith<$Res> get result {
    return $ShareImportResultCopyWith<$Res>(_value.result, (value) {
      return _then(_value.copyWith(result: value));
    });
  }
}

/// @nodoc

class _$ShareImportSuccessImpl implements ShareImportSuccess {
  const _$ShareImportSuccessImpl(this.result);

  @override
  final ShareImportResult result;

  @override
  String toString() {
    return 'ShareState.importSuccess(result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareImportSuccessImpl &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareImportSuccessImplCopyWith<_$ShareImportSuccessImpl> get copyWith =>
      __$$ShareImportSuccessImplCopyWithImpl<_$ShareImportSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String data) exported,
    required TResult Function(int current, int total) importing,
    required TResult Function(SharedPlaylistPreview preview) preview,
    required TResult Function(ShareImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return importSuccess(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String data)? exported,
    TResult? Function(int current, int total)? importing,
    TResult? Function(SharedPlaylistPreview preview)? preview,
    TResult? Function(ShareImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return importSuccess?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String data)? exported,
    TResult Function(int current, int total)? importing,
    TResult Function(SharedPlaylistPreview preview)? preview,
    TResult Function(ShareImportResult result)? importSuccess,
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
    required TResult Function(ShareIdle value) idle,
    required TResult Function(ShareExporting value) exporting,
    required TResult Function(ShareExported value) exported,
    required TResult Function(ShareImporting value) importing,
    required TResult Function(SharePreview value) preview,
    required TResult Function(ShareImportSuccess value) importSuccess,
    required TResult Function(ShareError value) error,
  }) {
    return importSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShareIdle value)? idle,
    TResult? Function(ShareExporting value)? exporting,
    TResult? Function(ShareExported value)? exported,
    TResult? Function(ShareImporting value)? importing,
    TResult? Function(SharePreview value)? preview,
    TResult? Function(ShareImportSuccess value)? importSuccess,
    TResult? Function(ShareError value)? error,
  }) {
    return importSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShareIdle value)? idle,
    TResult Function(ShareExporting value)? exporting,
    TResult Function(ShareExported value)? exported,
    TResult Function(ShareImporting value)? importing,
    TResult Function(SharePreview value)? preview,
    TResult Function(ShareImportSuccess value)? importSuccess,
    TResult Function(ShareError value)? error,
    required TResult orElse(),
  }) {
    if (importSuccess != null) {
      return importSuccess(this);
    }
    return orElse();
  }
}

abstract class ShareImportSuccess implements ShareState {
  const factory ShareImportSuccess(final ShareImportResult result) =
      _$ShareImportSuccessImpl;

  ShareImportResult get result;

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareImportSuccessImplCopyWith<_$ShareImportSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ShareErrorImplCopyWith<$Res> {
  factory _$$ShareErrorImplCopyWith(
          _$ShareErrorImpl value, $Res Function(_$ShareErrorImpl) then) =
      __$$ShareErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ShareErrorImplCopyWithImpl<$Res>
    extends _$ShareStateCopyWithImpl<$Res, _$ShareErrorImpl>
    implements _$$ShareErrorImplCopyWith<$Res> {
  __$$ShareErrorImplCopyWithImpl(
      _$ShareErrorImpl _value, $Res Function(_$ShareErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ShareErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ShareErrorImpl implements ShareError {
  const _$ShareErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ShareState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareErrorImplCopyWith<_$ShareErrorImpl> get copyWith =>
      __$$ShareErrorImplCopyWithImpl<_$ShareErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() exporting,
    required TResult Function(String data) exported,
    required TResult Function(int current, int total) importing,
    required TResult Function(SharedPlaylistPreview preview) preview,
    required TResult Function(ShareImportResult result) importSuccess,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? exporting,
    TResult? Function(String data)? exported,
    TResult? Function(int current, int total)? importing,
    TResult? Function(SharedPlaylistPreview preview)? preview,
    TResult? Function(ShareImportResult result)? importSuccess,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? exporting,
    TResult Function(String data)? exported,
    TResult Function(int current, int total)? importing,
    TResult Function(SharedPlaylistPreview preview)? preview,
    TResult Function(ShareImportResult result)? importSuccess,
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
    required TResult Function(ShareIdle value) idle,
    required TResult Function(ShareExporting value) exporting,
    required TResult Function(ShareExported value) exported,
    required TResult Function(ShareImporting value) importing,
    required TResult Function(SharePreview value) preview,
    required TResult Function(ShareImportSuccess value) importSuccess,
    required TResult Function(ShareError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShareIdle value)? idle,
    TResult? Function(ShareExporting value)? exporting,
    TResult? Function(ShareExported value)? exported,
    TResult? Function(ShareImporting value)? importing,
    TResult? Function(SharePreview value)? preview,
    TResult? Function(ShareImportSuccess value)? importSuccess,
    TResult? Function(ShareError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShareIdle value)? idle,
    TResult Function(ShareExporting value)? exporting,
    TResult Function(ShareExported value)? exported,
    TResult Function(ShareImporting value)? importing,
    TResult Function(SharePreview value)? preview,
    TResult Function(ShareImportSuccess value)? importSuccess,
    TResult Function(ShareError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ShareError implements ShareState {
  const factory ShareError(final String message) = _$ShareErrorImpl;

  String get message;

  /// Create a copy of ShareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareErrorImplCopyWith<_$ShareErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShareImportResult {
  /// 新建歌单 ID
  int get playlistId => throw _privateConstructorUsedError;

  /// 成功导入的歌曲数
  int get imported => throw _privateConstructorUsedError;

  /// 本地已存在的歌曲数（直接复用）
  int get reused => throw _privateConstructorUsedError;

  /// 拉取元数据失败的歌曲数
  int get failed => throw _privateConstructorUsedError;

  /// 失败的 bvid 列表（供用户排查）
  List<String> get failedBvids => throw _privateConstructorUsedError;

  /// Create a copy of ShareImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShareImportResultCopyWith<ShareImportResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareImportResultCopyWith<$Res> {
  factory $ShareImportResultCopyWith(
          ShareImportResult value, $Res Function(ShareImportResult) then) =
      _$ShareImportResultCopyWithImpl<$Res, ShareImportResult>;
  @useResult
  $Res call(
      {int playlistId,
      int imported,
      int reused,
      int failed,
      List<String> failedBvids});
}

/// @nodoc
class _$ShareImportResultCopyWithImpl<$Res, $Val extends ShareImportResult>
    implements $ShareImportResultCopyWith<$Res> {
  _$ShareImportResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShareImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlistId = null,
    Object? imported = null,
    Object? reused = null,
    Object? failed = null,
    Object? failedBvids = null,
  }) {
    return _then(_value.copyWith(
      playlistId: null == playlistId
          ? _value.playlistId
          : playlistId // ignore: cast_nullable_to_non_nullable
              as int,
      imported: null == imported
          ? _value.imported
          : imported // ignore: cast_nullable_to_non_nullable
              as int,
      reused: null == reused
          ? _value.reused
          : reused // ignore: cast_nullable_to_non_nullable
              as int,
      failed: null == failed
          ? _value.failed
          : failed // ignore: cast_nullable_to_non_nullable
              as int,
      failedBvids: null == failedBvids
          ? _value.failedBvids
          : failedBvids // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShareImportResultImplCopyWith<$Res>
    implements $ShareImportResultCopyWith<$Res> {
  factory _$$ShareImportResultImplCopyWith(_$ShareImportResultImpl value,
          $Res Function(_$ShareImportResultImpl) then) =
      __$$ShareImportResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int playlistId,
      int imported,
      int reused,
      int failed,
      List<String> failedBvids});
}

/// @nodoc
class __$$ShareImportResultImplCopyWithImpl<$Res>
    extends _$ShareImportResultCopyWithImpl<$Res, _$ShareImportResultImpl>
    implements _$$ShareImportResultImplCopyWith<$Res> {
  __$$ShareImportResultImplCopyWithImpl(_$ShareImportResultImpl _value,
      $Res Function(_$ShareImportResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlistId = null,
    Object? imported = null,
    Object? reused = null,
    Object? failed = null,
    Object? failedBvids = null,
  }) {
    return _then(_$ShareImportResultImpl(
      playlistId: null == playlistId
          ? _value.playlistId
          : playlistId // ignore: cast_nullable_to_non_nullable
              as int,
      imported: null == imported
          ? _value.imported
          : imported // ignore: cast_nullable_to_non_nullable
              as int,
      reused: null == reused
          ? _value.reused
          : reused // ignore: cast_nullable_to_non_nullable
              as int,
      failed: null == failed
          ? _value.failed
          : failed // ignore: cast_nullable_to_non_nullable
              as int,
      failedBvids: null == failedBvids
          ? _value._failedBvids
          : failedBvids // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$ShareImportResultImpl implements _ShareImportResult {
  const _$ShareImportResultImpl(
      {required this.playlistId,
      required this.imported,
      required this.reused,
      required this.failed,
      final List<String> failedBvids = const []})
      : _failedBvids = failedBvids;

  /// 新建歌单 ID
  @override
  final int playlistId;

  /// 成功导入的歌曲数
  @override
  final int imported;

  /// 本地已存在的歌曲数（直接复用）
  @override
  final int reused;

  /// 拉取元数据失败的歌曲数
  @override
  final int failed;

  /// 失败的 bvid 列表（供用户排查）
  final List<String> _failedBvids;

  /// 失败的 bvid 列表（供用户排查）
  @override
  @JsonKey()
  List<String> get failedBvids {
    if (_failedBvids is EqualUnmodifiableListView) return _failedBvids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedBvids);
  }

  @override
  String toString() {
    return 'ShareImportResult(playlistId: $playlistId, imported: $imported, reused: $reused, failed: $failed, failedBvids: $failedBvids)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareImportResultImpl &&
            (identical(other.playlistId, playlistId) ||
                other.playlistId == playlistId) &&
            (identical(other.imported, imported) ||
                other.imported == imported) &&
            (identical(other.reused, reused) || other.reused == reused) &&
            (identical(other.failed, failed) || other.failed == failed) &&
            const DeepCollectionEquality()
                .equals(other._failedBvids, _failedBvids));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playlistId, imported, reused,
      failed, const DeepCollectionEquality().hash(_failedBvids));

  /// Create a copy of ShareImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareImportResultImplCopyWith<_$ShareImportResultImpl> get copyWith =>
      __$$ShareImportResultImplCopyWithImpl<_$ShareImportResultImpl>(
          this, _$identity);
}

abstract class _ShareImportResult implements ShareImportResult {
  const factory _ShareImportResult(
      {required final int playlistId,
      required final int imported,
      required final int reused,
      required final int failed,
      final List<String> failedBvids}) = _$ShareImportResultImpl;

  /// 新建歌单 ID
  @override
  int get playlistId;

  /// 成功导入的歌曲数
  @override
  int get imported;

  /// 本地已存在的歌曲数（直接复用）
  @override
  int get reused;

  /// 拉取元数据失败的歌曲数
  @override
  int get failed;

  /// 失败的 bvid 列表（供用户排查）
  @override
  List<String> get failedBvids;

  /// Create a copy of ShareImportResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareImportResultImplCopyWith<_$ShareImportResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SharedPlaylistPreview {
  /// 歌单名称
  String get name => throw _privateConstructorUsedError;

  /// 歌曲数量
  int get songCount => throw _privateConstructorUsedError;

  /// BV 号列表（预览用）
  List<String> get bvids => throw _privateConstructorUsedError;

  /// Create a copy of SharedPlaylistPreview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SharedPlaylistPreviewCopyWith<SharedPlaylistPreview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedPlaylistPreviewCopyWith<$Res> {
  factory $SharedPlaylistPreviewCopyWith(SharedPlaylistPreview value,
          $Res Function(SharedPlaylistPreview) then) =
      _$SharedPlaylistPreviewCopyWithImpl<$Res, SharedPlaylistPreview>;
  @useResult
  $Res call({String name, int songCount, List<String> bvids});
}

/// @nodoc
class _$SharedPlaylistPreviewCopyWithImpl<$Res,
        $Val extends SharedPlaylistPreview>
    implements $SharedPlaylistPreviewCopyWith<$Res> {
  _$SharedPlaylistPreviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SharedPlaylistPreview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? songCount = null,
    Object? bvids = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      songCount: null == songCount
          ? _value.songCount
          : songCount // ignore: cast_nullable_to_non_nullable
              as int,
      bvids: null == bvids
          ? _value.bvids
          : bvids // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedPlaylistPreviewImplCopyWith<$Res>
    implements $SharedPlaylistPreviewCopyWith<$Res> {
  factory _$$SharedPlaylistPreviewImplCopyWith(
          _$SharedPlaylistPreviewImpl value,
          $Res Function(_$SharedPlaylistPreviewImpl) then) =
      __$$SharedPlaylistPreviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int songCount, List<String> bvids});
}

/// @nodoc
class __$$SharedPlaylistPreviewImplCopyWithImpl<$Res>
    extends _$SharedPlaylistPreviewCopyWithImpl<$Res,
        _$SharedPlaylistPreviewImpl>
    implements _$$SharedPlaylistPreviewImplCopyWith<$Res> {
  __$$SharedPlaylistPreviewImplCopyWithImpl(_$SharedPlaylistPreviewImpl _value,
      $Res Function(_$SharedPlaylistPreviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of SharedPlaylistPreview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? songCount = null,
    Object? bvids = null,
  }) {
    return _then(_$SharedPlaylistPreviewImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      songCount: null == songCount
          ? _value.songCount
          : songCount // ignore: cast_nullable_to_non_nullable
              as int,
      bvids: null == bvids
          ? _value._bvids
          : bvids // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$SharedPlaylistPreviewImpl implements _SharedPlaylistPreview {
  const _$SharedPlaylistPreviewImpl(
      {required this.name,
      required this.songCount,
      required final List<String> bvids})
      : _bvids = bvids;

  /// 歌单名称
  @override
  final String name;

  /// 歌曲数量
  @override
  final int songCount;

  /// BV 号列表（预览用）
  final List<String> _bvids;

  /// BV 号列表（预览用）
  @override
  List<String> get bvids {
    if (_bvids is EqualUnmodifiableListView) return _bvids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bvids);
  }

  @override
  String toString() {
    return 'SharedPlaylistPreview(name: $name, songCount: $songCount, bvids: $bvids)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedPlaylistPreviewImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.songCount, songCount) ||
                other.songCount == songCount) &&
            const DeepCollectionEquality().equals(other._bvids, _bvids));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, songCount,
      const DeepCollectionEquality().hash(_bvids));

  /// Create a copy of SharedPlaylistPreview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedPlaylistPreviewImplCopyWith<_$SharedPlaylistPreviewImpl>
      get copyWith => __$$SharedPlaylistPreviewImplCopyWithImpl<
          _$SharedPlaylistPreviewImpl>(this, _$identity);
}

abstract class _SharedPlaylistPreview implements SharedPlaylistPreview {
  const factory _SharedPlaylistPreview(
      {required final String name,
      required final int songCount,
      required final List<String> bvids}) = _$SharedPlaylistPreviewImpl;

  /// 歌单名称
  @override
  String get name;

  /// 歌曲数量
  @override
  int get songCount;

  /// BV 号列表（预览用）
  @override
  List<String> get bvids;

  /// Create a copy of SharedPlaylistPreview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharedPlaylistPreviewImplCopyWith<_$SharedPlaylistPreviewImpl>
      get copyWith => throw _privateConstructorUsedError;
}
