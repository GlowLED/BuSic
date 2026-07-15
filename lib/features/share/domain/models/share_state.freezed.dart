// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShareState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShareState()';
}


}

/// @nodoc
class $ShareStateCopyWith<$Res>  {
$ShareStateCopyWith(ShareState _, $Res Function(ShareState) __);
}


/// Adds pattern-matching-related methods to [ShareState].
extension ShareStatePatterns on ShareState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ShareIdle value)?  idle,TResult Function( ShareExporting value)?  exporting,TResult Function( ShareExported value)?  exported,TResult Function( ShareImporting value)?  importing,TResult Function( SharePreview value)?  preview,TResult Function( ShareImportSuccess value)?  importSuccess,TResult Function( ShareError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ShareIdle() when idle != null:
return idle(_that);case ShareExporting() when exporting != null:
return exporting(_that);case ShareExported() when exported != null:
return exported(_that);case ShareImporting() when importing != null:
return importing(_that);case SharePreview() when preview != null:
return preview(_that);case ShareImportSuccess() when importSuccess != null:
return importSuccess(_that);case ShareError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ShareIdle value)  idle,required TResult Function( ShareExporting value)  exporting,required TResult Function( ShareExported value)  exported,required TResult Function( ShareImporting value)  importing,required TResult Function( SharePreview value)  preview,required TResult Function( ShareImportSuccess value)  importSuccess,required TResult Function( ShareError value)  error,}){
final _that = this;
switch (_that) {
case ShareIdle():
return idle(_that);case ShareExporting():
return exporting(_that);case ShareExported():
return exported(_that);case ShareImporting():
return importing(_that);case SharePreview():
return preview(_that);case ShareImportSuccess():
return importSuccess(_that);case ShareError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ShareIdle value)?  idle,TResult? Function( ShareExporting value)?  exporting,TResult? Function( ShareExported value)?  exported,TResult? Function( ShareImporting value)?  importing,TResult? Function( SharePreview value)?  preview,TResult? Function( ShareImportSuccess value)?  importSuccess,TResult? Function( ShareError value)?  error,}){
final _that = this;
switch (_that) {
case ShareIdle() when idle != null:
return idle(_that);case ShareExporting() when exporting != null:
return exporting(_that);case ShareExported() when exported != null:
return exported(_that);case ShareImporting() when importing != null:
return importing(_that);case SharePreview() when preview != null:
return preview(_that);case ShareImportSuccess() when importSuccess != null:
return importSuccess(_that);case ShareError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  exporting,TResult Function( String data)?  exported,TResult Function( int current,  int total)?  importing,TResult Function( SharedPlaylistPreview preview)?  preview,TResult Function( ShareImportResult result)?  importSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ShareIdle() when idle != null:
return idle();case ShareExporting() when exporting != null:
return exporting();case ShareExported() when exported != null:
return exported(_that.data);case ShareImporting() when importing != null:
return importing(_that.current,_that.total);case SharePreview() when preview != null:
return preview(_that.preview);case ShareImportSuccess() when importSuccess != null:
return importSuccess(_that.result);case ShareError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  exporting,required TResult Function( String data)  exported,required TResult Function( int current,  int total)  importing,required TResult Function( SharedPlaylistPreview preview)  preview,required TResult Function( ShareImportResult result)  importSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ShareIdle():
return idle();case ShareExporting():
return exporting();case ShareExported():
return exported(_that.data);case ShareImporting():
return importing(_that.current,_that.total);case SharePreview():
return preview(_that.preview);case ShareImportSuccess():
return importSuccess(_that.result);case ShareError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  exporting,TResult? Function( String data)?  exported,TResult? Function( int current,  int total)?  importing,TResult? Function( SharedPlaylistPreview preview)?  preview,TResult? Function( ShareImportResult result)?  importSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ShareIdle() when idle != null:
return idle();case ShareExporting() when exporting != null:
return exporting();case ShareExported() when exported != null:
return exported(_that.data);case ShareImporting() when importing != null:
return importing(_that.current,_that.total);case SharePreview() when preview != null:
return preview(_that.preview);case ShareImportSuccess() when importSuccess != null:
return importSuccess(_that.result);case ShareError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ShareIdle implements ShareState {
  const ShareIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShareState.idle()';
}


}




/// @nodoc


class ShareExporting implements ShareState {
  const ShareExporting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareExporting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShareState.exporting()';
}


}




/// @nodoc


class ShareExported implements ShareState {
  const ShareExported(this.data);
  

 final  String data;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareExportedCopyWith<ShareExported> get copyWith => _$ShareExportedCopyWithImpl<ShareExported>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareExported&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ShareState.exported(data: $data)';
}


}

/// @nodoc
abstract mixin class $ShareExportedCopyWith<$Res> implements $ShareStateCopyWith<$Res> {
  factory $ShareExportedCopyWith(ShareExported value, $Res Function(ShareExported) _then) = _$ShareExportedCopyWithImpl;
@useResult
$Res call({
 String data
});




}
/// @nodoc
class _$ShareExportedCopyWithImpl<$Res>
    implements $ShareExportedCopyWith<$Res> {
  _$ShareExportedCopyWithImpl(this._self, this._then);

  final ShareExported _self;
  final $Res Function(ShareExported) _then;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(ShareExported(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ShareImporting implements ShareState {
  const ShareImporting({this.current = 0, this.total = 0});
  

@JsonKey() final  int current;
@JsonKey() final  int total;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareImportingCopyWith<ShareImporting> get copyWith => _$ShareImportingCopyWithImpl<ShareImporting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareImporting&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,current,total);

@override
String toString() {
  return 'ShareState.importing(current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class $ShareImportingCopyWith<$Res> implements $ShareStateCopyWith<$Res> {
  factory $ShareImportingCopyWith(ShareImporting value, $Res Function(ShareImporting) _then) = _$ShareImportingCopyWithImpl;
@useResult
$Res call({
 int current, int total
});




}
/// @nodoc
class _$ShareImportingCopyWithImpl<$Res>
    implements $ShareImportingCopyWith<$Res> {
  _$ShareImportingCopyWithImpl(this._self, this._then);

  final ShareImporting _self;
  final $Res Function(ShareImporting) _then;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? current = null,Object? total = null,}) {
  return _then(ShareImporting(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SharePreview implements ShareState {
  const SharePreview(this.preview);
  

 final  SharedPlaylistPreview preview;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharePreviewCopyWith<SharePreview> get copyWith => _$SharePreviewCopyWithImpl<SharePreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharePreview&&(identical(other.preview, preview) || other.preview == preview));
}


@override
int get hashCode => Object.hash(runtimeType,preview);

@override
String toString() {
  return 'ShareState.preview(preview: $preview)';
}


}

/// @nodoc
abstract mixin class $SharePreviewCopyWith<$Res> implements $ShareStateCopyWith<$Res> {
  factory $SharePreviewCopyWith(SharePreview value, $Res Function(SharePreview) _then) = _$SharePreviewCopyWithImpl;
@useResult
$Res call({
 SharedPlaylistPreview preview
});


$SharedPlaylistPreviewCopyWith<$Res> get preview;

}
/// @nodoc
class _$SharePreviewCopyWithImpl<$Res>
    implements $SharePreviewCopyWith<$Res> {
  _$SharePreviewCopyWithImpl(this._self, this._then);

  final SharePreview _self;
  final $Res Function(SharePreview) _then;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? preview = null,}) {
  return _then(SharePreview(
null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as SharedPlaylistPreview,
  ));
}

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SharedPlaylistPreviewCopyWith<$Res> get preview {
  
  return $SharedPlaylistPreviewCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}

/// @nodoc


class ShareImportSuccess implements ShareState {
  const ShareImportSuccess(this.result);
  

 final  ShareImportResult result;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareImportSuccessCopyWith<ShareImportSuccess> get copyWith => _$ShareImportSuccessCopyWithImpl<ShareImportSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareImportSuccess&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,result);

@override
String toString() {
  return 'ShareState.importSuccess(result: $result)';
}


}

/// @nodoc
abstract mixin class $ShareImportSuccessCopyWith<$Res> implements $ShareStateCopyWith<$Res> {
  factory $ShareImportSuccessCopyWith(ShareImportSuccess value, $Res Function(ShareImportSuccess) _then) = _$ShareImportSuccessCopyWithImpl;
@useResult
$Res call({
 ShareImportResult result
});


$ShareImportResultCopyWith<$Res> get result;

}
/// @nodoc
class _$ShareImportSuccessCopyWithImpl<$Res>
    implements $ShareImportSuccessCopyWith<$Res> {
  _$ShareImportSuccessCopyWithImpl(this._self, this._then);

  final ShareImportSuccess _self;
  final $Res Function(ShareImportSuccess) _then;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = null,}) {
  return _then(ShareImportSuccess(
null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ShareImportResult,
  ));
}

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShareImportResultCopyWith<$Res> get result {
  
  return $ShareImportResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

/// @nodoc


class ShareError implements ShareState {
  const ShareError(this.message);
  

 final  String message;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareErrorCopyWith<ShareError> get copyWith => _$ShareErrorCopyWithImpl<ShareError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ShareState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ShareErrorCopyWith<$Res> implements $ShareStateCopyWith<$Res> {
  factory $ShareErrorCopyWith(ShareError value, $Res Function(ShareError) _then) = _$ShareErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ShareErrorCopyWithImpl<$Res>
    implements $ShareErrorCopyWith<$Res> {
  _$ShareErrorCopyWithImpl(this._self, this._then);

  final ShareError _self;
  final $Res Function(ShareError) _then;

/// Create a copy of ShareState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ShareError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ShareImportResult {

/// 新建歌单 ID
 int get playlistId;/// 成功导入的歌曲数
 int get imported;/// 本地已存在的歌曲数（直接复用）
 int get reused;/// 拉取元数据失败的歌曲数
 int get failed;/// 失败的 bvid 列表（供用户排查）
 List<String> get failedBvids;
/// Create a copy of ShareImportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareImportResultCopyWith<ShareImportResult> get copyWith => _$ShareImportResultCopyWithImpl<ShareImportResult>(this as ShareImportResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareImportResult&&(identical(other.playlistId, playlistId) || other.playlistId == playlistId)&&(identical(other.imported, imported) || other.imported == imported)&&(identical(other.reused, reused) || other.reused == reused)&&(identical(other.failed, failed) || other.failed == failed)&&const DeepCollectionEquality().equals(other.failedBvids, failedBvids));
}


@override
int get hashCode => Object.hash(runtimeType,playlistId,imported,reused,failed,const DeepCollectionEquality().hash(failedBvids));

@override
String toString() {
  return 'ShareImportResult(playlistId: $playlistId, imported: $imported, reused: $reused, failed: $failed, failedBvids: $failedBvids)';
}


}

/// @nodoc
abstract mixin class $ShareImportResultCopyWith<$Res>  {
  factory $ShareImportResultCopyWith(ShareImportResult value, $Res Function(ShareImportResult) _then) = _$ShareImportResultCopyWithImpl;
@useResult
$Res call({
 int playlistId, int imported, int reused, int failed, List<String> failedBvids
});




}
/// @nodoc
class _$ShareImportResultCopyWithImpl<$Res>
    implements $ShareImportResultCopyWith<$Res> {
  _$ShareImportResultCopyWithImpl(this._self, this._then);

  final ShareImportResult _self;
  final $Res Function(ShareImportResult) _then;

/// Create a copy of ShareImportResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playlistId = null,Object? imported = null,Object? reused = null,Object? failed = null,Object? failedBvids = null,}) {
  return _then(_self.copyWith(
playlistId: null == playlistId ? _self.playlistId : playlistId // ignore: cast_nullable_to_non_nullable
as int,imported: null == imported ? _self.imported : imported // ignore: cast_nullable_to_non_nullable
as int,reused: null == reused ? _self.reused : reused // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,failedBvids: null == failedBvids ? _self.failedBvids : failedBvids // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShareImportResult].
extension ShareImportResultPatterns on ShareImportResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShareImportResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShareImportResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShareImportResult value)  $default,){
final _that = this;
switch (_that) {
case _ShareImportResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShareImportResult value)?  $default,){
final _that = this;
switch (_that) {
case _ShareImportResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int playlistId,  int imported,  int reused,  int failed,  List<String> failedBvids)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShareImportResult() when $default != null:
return $default(_that.playlistId,_that.imported,_that.reused,_that.failed,_that.failedBvids);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int playlistId,  int imported,  int reused,  int failed,  List<String> failedBvids)  $default,) {final _that = this;
switch (_that) {
case _ShareImportResult():
return $default(_that.playlistId,_that.imported,_that.reused,_that.failed,_that.failedBvids);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int playlistId,  int imported,  int reused,  int failed,  List<String> failedBvids)?  $default,) {final _that = this;
switch (_that) {
case _ShareImportResult() when $default != null:
return $default(_that.playlistId,_that.imported,_that.reused,_that.failed,_that.failedBvids);case _:
  return null;

}
}

}

/// @nodoc


class _ShareImportResult implements ShareImportResult {
  const _ShareImportResult({required this.playlistId, required this.imported, required this.reused, required this.failed, final  List<String> failedBvids = const []}): _failedBvids = failedBvids;
  

/// 新建歌单 ID
@override final  int playlistId;
/// 成功导入的歌曲数
@override final  int imported;
/// 本地已存在的歌曲数（直接复用）
@override final  int reused;
/// 拉取元数据失败的歌曲数
@override final  int failed;
/// 失败的 bvid 列表（供用户排查）
 final  List<String> _failedBvids;
/// 失败的 bvid 列表（供用户排查）
@override@JsonKey() List<String> get failedBvids {
  if (_failedBvids is EqualUnmodifiableListView) return _failedBvids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedBvids);
}


/// Create a copy of ShareImportResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShareImportResultCopyWith<_ShareImportResult> get copyWith => __$ShareImportResultCopyWithImpl<_ShareImportResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShareImportResult&&(identical(other.playlistId, playlistId) || other.playlistId == playlistId)&&(identical(other.imported, imported) || other.imported == imported)&&(identical(other.reused, reused) || other.reused == reused)&&(identical(other.failed, failed) || other.failed == failed)&&const DeepCollectionEquality().equals(other._failedBvids, _failedBvids));
}


@override
int get hashCode => Object.hash(runtimeType,playlistId,imported,reused,failed,const DeepCollectionEquality().hash(_failedBvids));

@override
String toString() {
  return 'ShareImportResult(playlistId: $playlistId, imported: $imported, reused: $reused, failed: $failed, failedBvids: $failedBvids)';
}


}

/// @nodoc
abstract mixin class _$ShareImportResultCopyWith<$Res> implements $ShareImportResultCopyWith<$Res> {
  factory _$ShareImportResultCopyWith(_ShareImportResult value, $Res Function(_ShareImportResult) _then) = __$ShareImportResultCopyWithImpl;
@override @useResult
$Res call({
 int playlistId, int imported, int reused, int failed, List<String> failedBvids
});




}
/// @nodoc
class __$ShareImportResultCopyWithImpl<$Res>
    implements _$ShareImportResultCopyWith<$Res> {
  __$ShareImportResultCopyWithImpl(this._self, this._then);

  final _ShareImportResult _self;
  final $Res Function(_ShareImportResult) _then;

/// Create a copy of ShareImportResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playlistId = null,Object? imported = null,Object? reused = null,Object? failed = null,Object? failedBvids = null,}) {
  return _then(_ShareImportResult(
playlistId: null == playlistId ? _self.playlistId : playlistId // ignore: cast_nullable_to_non_nullable
as int,imported: null == imported ? _self.imported : imported // ignore: cast_nullable_to_non_nullable
as int,reused: null == reused ? _self.reused : reused // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,failedBvids: null == failedBvids ? _self._failedBvids : failedBvids // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$SharedPlaylistPreview {

/// 歌单名称
 String get name;/// 歌曲数量
 int get songCount;/// BV 号列表（预览用）
 List<String> get bvids;
/// Create a copy of SharedPlaylistPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedPlaylistPreviewCopyWith<SharedPlaylistPreview> get copyWith => _$SharedPlaylistPreviewCopyWithImpl<SharedPlaylistPreview>(this as SharedPlaylistPreview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedPlaylistPreview&&(identical(other.name, name) || other.name == name)&&(identical(other.songCount, songCount) || other.songCount == songCount)&&const DeepCollectionEquality().equals(other.bvids, bvids));
}


@override
int get hashCode => Object.hash(runtimeType,name,songCount,const DeepCollectionEquality().hash(bvids));

@override
String toString() {
  return 'SharedPlaylistPreview(name: $name, songCount: $songCount, bvids: $bvids)';
}


}

/// @nodoc
abstract mixin class $SharedPlaylistPreviewCopyWith<$Res>  {
  factory $SharedPlaylistPreviewCopyWith(SharedPlaylistPreview value, $Res Function(SharedPlaylistPreview) _then) = _$SharedPlaylistPreviewCopyWithImpl;
@useResult
$Res call({
 String name, int songCount, List<String> bvids
});




}
/// @nodoc
class _$SharedPlaylistPreviewCopyWithImpl<$Res>
    implements $SharedPlaylistPreviewCopyWith<$Res> {
  _$SharedPlaylistPreviewCopyWithImpl(this._self, this._then);

  final SharedPlaylistPreview _self;
  final $Res Function(SharedPlaylistPreview) _then;

/// Create a copy of SharedPlaylistPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? songCount = null,Object? bvids = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,songCount: null == songCount ? _self.songCount : songCount // ignore: cast_nullable_to_non_nullable
as int,bvids: null == bvids ? _self.bvids : bvids // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedPlaylistPreview].
extension SharedPlaylistPreviewPatterns on SharedPlaylistPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedPlaylistPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedPlaylistPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedPlaylistPreview value)  $default,){
final _that = this;
switch (_that) {
case _SharedPlaylistPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedPlaylistPreview value)?  $default,){
final _that = this;
switch (_that) {
case _SharedPlaylistPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int songCount,  List<String> bvids)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedPlaylistPreview() when $default != null:
return $default(_that.name,_that.songCount,_that.bvids);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int songCount,  List<String> bvids)  $default,) {final _that = this;
switch (_that) {
case _SharedPlaylistPreview():
return $default(_that.name,_that.songCount,_that.bvids);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int songCount,  List<String> bvids)?  $default,) {final _that = this;
switch (_that) {
case _SharedPlaylistPreview() when $default != null:
return $default(_that.name,_that.songCount,_that.bvids);case _:
  return null;

}
}

}

/// @nodoc


class _SharedPlaylistPreview implements SharedPlaylistPreview {
  const _SharedPlaylistPreview({required this.name, required this.songCount, required final  List<String> bvids}): _bvids = bvids;
  

/// 歌单名称
@override final  String name;
/// 歌曲数量
@override final  int songCount;
/// BV 号列表（预览用）
 final  List<String> _bvids;
/// BV 号列表（预览用）
@override List<String> get bvids {
  if (_bvids is EqualUnmodifiableListView) return _bvids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bvids);
}


/// Create a copy of SharedPlaylistPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedPlaylistPreviewCopyWith<_SharedPlaylistPreview> get copyWith => __$SharedPlaylistPreviewCopyWithImpl<_SharedPlaylistPreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedPlaylistPreview&&(identical(other.name, name) || other.name == name)&&(identical(other.songCount, songCount) || other.songCount == songCount)&&const DeepCollectionEquality().equals(other._bvids, _bvids));
}


@override
int get hashCode => Object.hash(runtimeType,name,songCount,const DeepCollectionEquality().hash(_bvids));

@override
String toString() {
  return 'SharedPlaylistPreview(name: $name, songCount: $songCount, bvids: $bvids)';
}


}

/// @nodoc
abstract mixin class _$SharedPlaylistPreviewCopyWith<$Res> implements $SharedPlaylistPreviewCopyWith<$Res> {
  factory _$SharedPlaylistPreviewCopyWith(_SharedPlaylistPreview value, $Res Function(_SharedPlaylistPreview) _then) = __$SharedPlaylistPreviewCopyWithImpl;
@override @useResult
$Res call({
 String name, int songCount, List<String> bvids
});




}
/// @nodoc
class __$SharedPlaylistPreviewCopyWithImpl<$Res>
    implements _$SharedPlaylistPreviewCopyWith<$Res> {
  __$SharedPlaylistPreviewCopyWithImpl(this._self, this._then);

  final _SharedPlaylistPreview _self;
  final $Res Function(_SharedPlaylistPreview) _then;

/// Create a copy of SharedPlaylistPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? songCount = null,Object? bvids = null,}) {
  return _then(_SharedPlaylistPreview(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,songCount: null == songCount ? _self.songCount : songCount // ignore: cast_nullable_to_non_nullable
as int,bvids: null == bvids ? _self._bvids : bvids // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
