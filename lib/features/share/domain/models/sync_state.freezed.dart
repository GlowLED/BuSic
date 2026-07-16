// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncState()';
}


}

/// @nodoc
class $SyncStateCopyWith<$Res>  {
$SyncStateCopyWith(SyncState _, $Res Function(SyncState) __);
}


/// Adds pattern-matching-related methods to [SyncState].
extension SyncStatePatterns on SyncState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SyncIdle value)?  idle,TResult Function( SyncExporting value)?  exporting,TResult Function( SyncExportSuccess value)?  exportSuccess,TResult Function( SyncImporting value)?  importing,TResult Function( SyncPreview value)?  preview,TResult Function( SyncImportSuccess value)?  importSuccess,TResult Function( SyncError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SyncIdle() when idle != null:
return idle(_that);case SyncExporting() when exporting != null:
return exporting(_that);case SyncExportSuccess() when exportSuccess != null:
return exportSuccess(_that);case SyncImporting() when importing != null:
return importing(_that);case SyncPreview() when preview != null:
return preview(_that);case SyncImportSuccess() when importSuccess != null:
return importSuccess(_that);case SyncError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SyncIdle value)  idle,required TResult Function( SyncExporting value)  exporting,required TResult Function( SyncExportSuccess value)  exportSuccess,required TResult Function( SyncImporting value)  importing,required TResult Function( SyncPreview value)  preview,required TResult Function( SyncImportSuccess value)  importSuccess,required TResult Function( SyncError value)  error,}){
final _that = this;
switch (_that) {
case SyncIdle():
return idle(_that);case SyncExporting():
return exporting(_that);case SyncExportSuccess():
return exportSuccess(_that);case SyncImporting():
return importing(_that);case SyncPreview():
return preview(_that);case SyncImportSuccess():
return importSuccess(_that);case SyncError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SyncIdle value)?  idle,TResult? Function( SyncExporting value)?  exporting,TResult? Function( SyncExportSuccess value)?  exportSuccess,TResult? Function( SyncImporting value)?  importing,TResult? Function( SyncPreview value)?  preview,TResult? Function( SyncImportSuccess value)?  importSuccess,TResult? Function( SyncError value)?  error,}){
final _that = this;
switch (_that) {
case SyncIdle() when idle != null:
return idle(_that);case SyncExporting() when exporting != null:
return exporting(_that);case SyncExportSuccess() when exportSuccess != null:
return exportSuccess(_that);case SyncImporting() when importing != null:
return importing(_that);case SyncPreview() when preview != null:
return preview(_that);case SyncImportSuccess() when importSuccess != null:
return importSuccess(_that);case SyncError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  exporting,TResult Function( String filePath)?  exportSuccess,TResult Function()?  importing,TResult Function( AppBackup backup)?  preview,TResult Function( ImportResult result)?  importSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SyncIdle() when idle != null:
return idle();case SyncExporting() when exporting != null:
return exporting();case SyncExportSuccess() when exportSuccess != null:
return exportSuccess(_that.filePath);case SyncImporting() when importing != null:
return importing();case SyncPreview() when preview != null:
return preview(_that.backup);case SyncImportSuccess() when importSuccess != null:
return importSuccess(_that.result);case SyncError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  exporting,required TResult Function( String filePath)  exportSuccess,required TResult Function()  importing,required TResult Function( AppBackup backup)  preview,required TResult Function( ImportResult result)  importSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SyncIdle():
return idle();case SyncExporting():
return exporting();case SyncExportSuccess():
return exportSuccess(_that.filePath);case SyncImporting():
return importing();case SyncPreview():
return preview(_that.backup);case SyncImportSuccess():
return importSuccess(_that.result);case SyncError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  exporting,TResult? Function( String filePath)?  exportSuccess,TResult? Function()?  importing,TResult? Function( AppBackup backup)?  preview,TResult? Function( ImportResult result)?  importSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SyncIdle() when idle != null:
return idle();case SyncExporting() when exporting != null:
return exporting();case SyncExportSuccess() when exportSuccess != null:
return exportSuccess(_that.filePath);case SyncImporting() when importing != null:
return importing();case SyncPreview() when preview != null:
return preview(_that.backup);case SyncImportSuccess() when importSuccess != null:
return importSuccess(_that.result);case SyncError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SyncIdle implements SyncState {
  const SyncIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncState.idle()';
}


}




/// @nodoc


class SyncExporting implements SyncState {
  const SyncExporting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncExporting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncState.exporting()';
}


}




/// @nodoc


class SyncExportSuccess implements SyncState {
  const SyncExportSuccess(this.filePath);
  

 final  String filePath;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncExportSuccessCopyWith<SyncExportSuccess> get copyWith => _$SyncExportSuccessCopyWithImpl<SyncExportSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncExportSuccess&&(identical(other.filePath, filePath) || other.filePath == filePath));
}


@override
int get hashCode => Object.hash(runtimeType,filePath);

@override
String toString() {
  return 'SyncState.exportSuccess(filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class $SyncExportSuccessCopyWith<$Res> implements $SyncStateCopyWith<$Res> {
  factory $SyncExportSuccessCopyWith(SyncExportSuccess value, $Res Function(SyncExportSuccess) _then) = _$SyncExportSuccessCopyWithImpl;
@useResult
$Res call({
 String filePath
});




}
/// @nodoc
class _$SyncExportSuccessCopyWithImpl<$Res>
    implements $SyncExportSuccessCopyWith<$Res> {
  _$SyncExportSuccessCopyWithImpl(this._self, this._then);

  final SyncExportSuccess _self;
  final $Res Function(SyncExportSuccess) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filePath = null,}) {
  return _then(SyncExportSuccess(
null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SyncImporting implements SyncState {
  const SyncImporting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncImporting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncState.importing()';
}


}




/// @nodoc


class SyncPreview implements SyncState {
  const SyncPreview(this.backup);
  

 final  AppBackup backup;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncPreviewCopyWith<SyncPreview> get copyWith => _$SyncPreviewCopyWithImpl<SyncPreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncPreview&&(identical(other.backup, backup) || other.backup == backup));
}


@override
int get hashCode => Object.hash(runtimeType,backup);

@override
String toString() {
  return 'SyncState.preview(backup: $backup)';
}


}

/// @nodoc
abstract mixin class $SyncPreviewCopyWith<$Res> implements $SyncStateCopyWith<$Res> {
  factory $SyncPreviewCopyWith(SyncPreview value, $Res Function(SyncPreview) _then) = _$SyncPreviewCopyWithImpl;
@useResult
$Res call({
 AppBackup backup
});


$AppBackupCopyWith<$Res> get backup;

}
/// @nodoc
class _$SyncPreviewCopyWithImpl<$Res>
    implements $SyncPreviewCopyWith<$Res> {
  _$SyncPreviewCopyWithImpl(this._self, this._then);

  final SyncPreview _self;
  final $Res Function(SyncPreview) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? backup = null,}) {
  return _then(SyncPreview(
null == backup ? _self.backup : backup // ignore: cast_nullable_to_non_nullable
as AppBackup,
  ));
}

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppBackupCopyWith<$Res> get backup {
  
  return $AppBackupCopyWith<$Res>(_self.backup, (value) {
    return _then(_self.copyWith(backup: value));
  });
}
}

/// @nodoc


class SyncImportSuccess implements SyncState {
  const SyncImportSuccess(this.result);
  

 final  ImportResult result;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncImportSuccessCopyWith<SyncImportSuccess> get copyWith => _$SyncImportSuccessCopyWithImpl<SyncImportSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncImportSuccess&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,result);

@override
String toString() {
  return 'SyncState.importSuccess(result: $result)';
}


}

/// @nodoc
abstract mixin class $SyncImportSuccessCopyWith<$Res> implements $SyncStateCopyWith<$Res> {
  factory $SyncImportSuccessCopyWith(SyncImportSuccess value, $Res Function(SyncImportSuccess) _then) = _$SyncImportSuccessCopyWithImpl;
@useResult
$Res call({
 ImportResult result
});


$ImportResultCopyWith<$Res> get result;

}
/// @nodoc
class _$SyncImportSuccessCopyWithImpl<$Res>
    implements $SyncImportSuccessCopyWith<$Res> {
  _$SyncImportSuccessCopyWithImpl(this._self, this._then);

  final SyncImportSuccess _self;
  final $Res Function(SyncImportSuccess) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = null,}) {
  return _then(SyncImportSuccess(
null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ImportResult,
  ));
}

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImportResultCopyWith<$Res> get result {
  
  return $ImportResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

/// @nodoc


class SyncError implements SyncState {
  const SyncError(this.message);
  

 final  String message;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncErrorCopyWith<SyncError> get copyWith => _$SyncErrorCopyWithImpl<SyncError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SyncState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SyncErrorCopyWith<$Res> implements $SyncStateCopyWith<$Res> {
  factory $SyncErrorCopyWith(SyncError value, $Res Function(SyncError) _then) = _$SyncErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SyncErrorCopyWithImpl<$Res>
    implements $SyncErrorCopyWith<$Res> {
  _$SyncErrorCopyWithImpl(this._self, this._then);

  final SyncError _self;
  final $Res Function(SyncError) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SyncError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ImportResult {

/// 新建的歌单数量
 int get playlistsCreated;/// 合并的歌单数量（同名歌单合并歌曲）
 int get playlistsMerged;/// 新建的歌曲数量
 int get songsCreated;/// 跳过的歌曲数量（本地已存在）
 int get songsSkipped;/// 错误数量
 int get errors;/// 告警信息列表
 List<String> get warnings;
/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportResultCopyWith<ImportResult> get copyWith => _$ImportResultCopyWithImpl<ImportResult>(this as ImportResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportResult&&(identical(other.playlistsCreated, playlistsCreated) || other.playlistsCreated == playlistsCreated)&&(identical(other.playlistsMerged, playlistsMerged) || other.playlistsMerged == playlistsMerged)&&(identical(other.songsCreated, songsCreated) || other.songsCreated == songsCreated)&&(identical(other.songsSkipped, songsSkipped) || other.songsSkipped == songsSkipped)&&(identical(other.errors, errors) || other.errors == errors)&&const DeepCollectionEquality().equals(other.warnings, warnings));
}


@override
int get hashCode => Object.hash(runtimeType,playlistsCreated,playlistsMerged,songsCreated,songsSkipped,errors,const DeepCollectionEquality().hash(warnings));

@override
String toString() {
  return 'ImportResult(playlistsCreated: $playlistsCreated, playlistsMerged: $playlistsMerged, songsCreated: $songsCreated, songsSkipped: $songsSkipped, errors: $errors, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class $ImportResultCopyWith<$Res>  {
  factory $ImportResultCopyWith(ImportResult value, $Res Function(ImportResult) _then) = _$ImportResultCopyWithImpl;
@useResult
$Res call({
 int playlistsCreated, int playlistsMerged, int songsCreated, int songsSkipped, int errors, List<String> warnings
});




}
/// @nodoc
class _$ImportResultCopyWithImpl<$Res>
    implements $ImportResultCopyWith<$Res> {
  _$ImportResultCopyWithImpl(this._self, this._then);

  final ImportResult _self;
  final $Res Function(ImportResult) _then;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playlistsCreated = null,Object? playlistsMerged = null,Object? songsCreated = null,Object? songsSkipped = null,Object? errors = null,Object? warnings = null,}) {
  return _then(_self.copyWith(
playlistsCreated: null == playlistsCreated ? _self.playlistsCreated : playlistsCreated // ignore: cast_nullable_to_non_nullable
as int,playlistsMerged: null == playlistsMerged ? _self.playlistsMerged : playlistsMerged // ignore: cast_nullable_to_non_nullable
as int,songsCreated: null == songsCreated ? _self.songsCreated : songsCreated // ignore: cast_nullable_to_non_nullable
as int,songsSkipped: null == songsSkipped ? _self.songsSkipped : songsSkipped // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportResult].
extension ImportResultPatterns on ImportResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportResult value)  $default,){
final _that = this;
switch (_that) {
case _ImportResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportResult value)?  $default,){
final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int playlistsCreated,  int playlistsMerged,  int songsCreated,  int songsSkipped,  int errors,  List<String> warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
return $default(_that.playlistsCreated,_that.playlistsMerged,_that.songsCreated,_that.songsSkipped,_that.errors,_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int playlistsCreated,  int playlistsMerged,  int songsCreated,  int songsSkipped,  int errors,  List<String> warnings)  $default,) {final _that = this;
switch (_that) {
case _ImportResult():
return $default(_that.playlistsCreated,_that.playlistsMerged,_that.songsCreated,_that.songsSkipped,_that.errors,_that.warnings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int playlistsCreated,  int playlistsMerged,  int songsCreated,  int songsSkipped,  int errors,  List<String> warnings)?  $default,) {final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
return $default(_that.playlistsCreated,_that.playlistsMerged,_that.songsCreated,_that.songsSkipped,_that.errors,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc


class _ImportResult implements ImportResult {
  const _ImportResult({required this.playlistsCreated, required this.playlistsMerged, required this.songsCreated, required this.songsSkipped, required this.errors, final  List<String> warnings = const []}): _warnings = warnings;
  

/// 新建的歌单数量
@override final  int playlistsCreated;
/// 合并的歌单数量（同名歌单合并歌曲）
@override final  int playlistsMerged;
/// 新建的歌曲数量
@override final  int songsCreated;
/// 跳过的歌曲数量（本地已存在）
@override final  int songsSkipped;
/// 错误数量
@override final  int errors;
/// 告警信息列表
 final  List<String> _warnings;
/// 告警信息列表
@override@JsonKey() List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}


/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportResultCopyWith<_ImportResult> get copyWith => __$ImportResultCopyWithImpl<_ImportResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportResult&&(identical(other.playlistsCreated, playlistsCreated) || other.playlistsCreated == playlistsCreated)&&(identical(other.playlistsMerged, playlistsMerged) || other.playlistsMerged == playlistsMerged)&&(identical(other.songsCreated, songsCreated) || other.songsCreated == songsCreated)&&(identical(other.songsSkipped, songsSkipped) || other.songsSkipped == songsSkipped)&&(identical(other.errors, errors) || other.errors == errors)&&const DeepCollectionEquality().equals(other._warnings, _warnings));
}


@override
int get hashCode => Object.hash(runtimeType,playlistsCreated,playlistsMerged,songsCreated,songsSkipped,errors,const DeepCollectionEquality().hash(_warnings));

@override
String toString() {
  return 'ImportResult(playlistsCreated: $playlistsCreated, playlistsMerged: $playlistsMerged, songsCreated: $songsCreated, songsSkipped: $songsSkipped, errors: $errors, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$ImportResultCopyWith<$Res> implements $ImportResultCopyWith<$Res> {
  factory _$ImportResultCopyWith(_ImportResult value, $Res Function(_ImportResult) _then) = __$ImportResultCopyWithImpl;
@override @useResult
$Res call({
 int playlistsCreated, int playlistsMerged, int songsCreated, int songsSkipped, int errors, List<String> warnings
});




}
/// @nodoc
class __$ImportResultCopyWithImpl<$Res>
    implements _$ImportResultCopyWith<$Res> {
  __$ImportResultCopyWithImpl(this._self, this._then);

  final _ImportResult _self;
  final $Res Function(_ImportResult) _then;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playlistsCreated = null,Object? playlistsMerged = null,Object? songsCreated = null,Object? songsSkipped = null,Object? errors = null,Object? warnings = null,}) {
  return _then(_ImportResult(
playlistsCreated: null == playlistsCreated ? _self.playlistsCreated : playlistsCreated // ignore: cast_nullable_to_non_nullable
as int,playlistsMerged: null == playlistsMerged ? _self.playlistsMerged : playlistsMerged // ignore: cast_nullable_to_non_nullable
as int,songsCreated: null == songsCreated ? _self.songsCreated : songsCreated // ignore: cast_nullable_to_non_nullable
as int,songsSkipped: null == songsSkipped ? _self.songsSkipped : songsSkipped // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
