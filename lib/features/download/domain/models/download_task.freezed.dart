// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DownloadTask {

/// Database primary key.
 int get id;/// Associated song database ID.
 int get songId;/// Current download status.
 DownloadStatus get status;/// Download progress from 0.0 to 1.0.
 double get progress;/// Target local file path.
 String? get filePath;/// Error message if status is [DownloadStatus.failed].
 String? get errorMessage;/// Timestamp when the task was created.
 DateTime get createdAt;/// Song title (populated from songs table for display).
 String? get songTitle;/// Song artist (populated from songs table for display).
 String? get songArtist;/// Cover image URL (populated from songs table for display).
 String? get coverUrl;/// Total bytes of the download (runtime only, not persisted).
 int get totalBytes;/// Bytes received so far (runtime only).
 int get receivedBytes;/// Current download speed in bytes/s (runtime only).
 double get speed;/// File size on disk in bytes (for completed downloads).
 int get fileSize;
/// Create a copy of DownloadTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadTaskCopyWith<DownloadTask> get copyWith => _$DownloadTaskCopyWithImpl<DownloadTask>(this as DownloadTask, _$identity);

  /// Serializes this DownloadTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadTask&&(identical(other.id, id) || other.id == id)&&(identical(other.songId, songId) || other.songId == songId)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.songTitle, songTitle) || other.songTitle == songTitle)&&(identical(other.songArtist, songArtist) || other.songArtist == songArtist)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.receivedBytes, receivedBytes) || other.receivedBytes == receivedBytes)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,songId,status,progress,filePath,errorMessage,createdAt,songTitle,songArtist,coverUrl,totalBytes,receivedBytes,speed,fileSize);

@override
String toString() {
  return 'DownloadTask(id: $id, songId: $songId, status: $status, progress: $progress, filePath: $filePath, errorMessage: $errorMessage, createdAt: $createdAt, songTitle: $songTitle, songArtist: $songArtist, coverUrl: $coverUrl, totalBytes: $totalBytes, receivedBytes: $receivedBytes, speed: $speed, fileSize: $fileSize)';
}


}

/// @nodoc
abstract mixin class $DownloadTaskCopyWith<$Res>  {
  factory $DownloadTaskCopyWith(DownloadTask value, $Res Function(DownloadTask) _then) = _$DownloadTaskCopyWithImpl;
@useResult
$Res call({
 int id, int songId, DownloadStatus status, double progress, String? filePath, String? errorMessage, DateTime createdAt, String? songTitle, String? songArtist, String? coverUrl, int totalBytes, int receivedBytes, double speed, int fileSize
});




}
/// @nodoc
class _$DownloadTaskCopyWithImpl<$Res>
    implements $DownloadTaskCopyWith<$Res> {
  _$DownloadTaskCopyWithImpl(this._self, this._then);

  final DownloadTask _self;
  final $Res Function(DownloadTask) _then;

/// Create a copy of DownloadTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? songId = null,Object? status = null,Object? progress = null,Object? filePath = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? songTitle = freezed,Object? songArtist = freezed,Object? coverUrl = freezed,Object? totalBytes = null,Object? receivedBytes = null,Object? speed = null,Object? fileSize = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,songId: null == songId ? _self.songId : songId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,songTitle: freezed == songTitle ? _self.songTitle : songTitle // ignore: cast_nullable_to_non_nullable
as String?,songArtist: freezed == songArtist ? _self.songArtist : songArtist // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,receivedBytes: null == receivedBytes ? _self.receivedBytes : receivedBytes // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadTask].
extension DownloadTaskPatterns on DownloadTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadTask value)  $default,){
final _that = this;
switch (_that) {
case _DownloadTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadTask value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int songId,  DownloadStatus status,  double progress,  String? filePath,  String? errorMessage,  DateTime createdAt,  String? songTitle,  String? songArtist,  String? coverUrl,  int totalBytes,  int receivedBytes,  double speed,  int fileSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadTask() when $default != null:
return $default(_that.id,_that.songId,_that.status,_that.progress,_that.filePath,_that.errorMessage,_that.createdAt,_that.songTitle,_that.songArtist,_that.coverUrl,_that.totalBytes,_that.receivedBytes,_that.speed,_that.fileSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int songId,  DownloadStatus status,  double progress,  String? filePath,  String? errorMessage,  DateTime createdAt,  String? songTitle,  String? songArtist,  String? coverUrl,  int totalBytes,  int receivedBytes,  double speed,  int fileSize)  $default,) {final _that = this;
switch (_that) {
case _DownloadTask():
return $default(_that.id,_that.songId,_that.status,_that.progress,_that.filePath,_that.errorMessage,_that.createdAt,_that.songTitle,_that.songArtist,_that.coverUrl,_that.totalBytes,_that.receivedBytes,_that.speed,_that.fileSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int songId,  DownloadStatus status,  double progress,  String? filePath,  String? errorMessage,  DateTime createdAt,  String? songTitle,  String? songArtist,  String? coverUrl,  int totalBytes,  int receivedBytes,  double speed,  int fileSize)?  $default,) {final _that = this;
switch (_that) {
case _DownloadTask() when $default != null:
return $default(_that.id,_that.songId,_that.status,_that.progress,_that.filePath,_that.errorMessage,_that.createdAt,_that.songTitle,_that.songArtist,_that.coverUrl,_that.totalBytes,_that.receivedBytes,_that.speed,_that.fileSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DownloadTask implements DownloadTask {
  const _DownloadTask({required this.id, required this.songId, required this.status, this.progress = 0.0, this.filePath, this.errorMessage, required this.createdAt, this.songTitle, this.songArtist, this.coverUrl, this.totalBytes = 0, this.receivedBytes = 0, this.speed = 0.0, this.fileSize = 0});
  factory _DownloadTask.fromJson(Map<String, dynamic> json) => _$DownloadTaskFromJson(json);

/// Database primary key.
@override final  int id;
/// Associated song database ID.
@override final  int songId;
/// Current download status.
@override final  DownloadStatus status;
/// Download progress from 0.0 to 1.0.
@override@JsonKey() final  double progress;
/// Target local file path.
@override final  String? filePath;
/// Error message if status is [DownloadStatus.failed].
@override final  String? errorMessage;
/// Timestamp when the task was created.
@override final  DateTime createdAt;
/// Song title (populated from songs table for display).
@override final  String? songTitle;
/// Song artist (populated from songs table for display).
@override final  String? songArtist;
/// Cover image URL (populated from songs table for display).
@override final  String? coverUrl;
/// Total bytes of the download (runtime only, not persisted).
@override@JsonKey() final  int totalBytes;
/// Bytes received so far (runtime only).
@override@JsonKey() final  int receivedBytes;
/// Current download speed in bytes/s (runtime only).
@override@JsonKey() final  double speed;
/// File size on disk in bytes (for completed downloads).
@override@JsonKey() final  int fileSize;

/// Create a copy of DownloadTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadTaskCopyWith<_DownloadTask> get copyWith => __$DownloadTaskCopyWithImpl<_DownloadTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadTask&&(identical(other.id, id) || other.id == id)&&(identical(other.songId, songId) || other.songId == songId)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.songTitle, songTitle) || other.songTitle == songTitle)&&(identical(other.songArtist, songArtist) || other.songArtist == songArtist)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.receivedBytes, receivedBytes) || other.receivedBytes == receivedBytes)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,songId,status,progress,filePath,errorMessage,createdAt,songTitle,songArtist,coverUrl,totalBytes,receivedBytes,speed,fileSize);

@override
String toString() {
  return 'DownloadTask(id: $id, songId: $songId, status: $status, progress: $progress, filePath: $filePath, errorMessage: $errorMessage, createdAt: $createdAt, songTitle: $songTitle, songArtist: $songArtist, coverUrl: $coverUrl, totalBytes: $totalBytes, receivedBytes: $receivedBytes, speed: $speed, fileSize: $fileSize)';
}


}

/// @nodoc
abstract mixin class _$DownloadTaskCopyWith<$Res> implements $DownloadTaskCopyWith<$Res> {
  factory _$DownloadTaskCopyWith(_DownloadTask value, $Res Function(_DownloadTask) _then) = __$DownloadTaskCopyWithImpl;
@override @useResult
$Res call({
 int id, int songId, DownloadStatus status, double progress, String? filePath, String? errorMessage, DateTime createdAt, String? songTitle, String? songArtist, String? coverUrl, int totalBytes, int receivedBytes, double speed, int fileSize
});




}
/// @nodoc
class __$DownloadTaskCopyWithImpl<$Res>
    implements _$DownloadTaskCopyWith<$Res> {
  __$DownloadTaskCopyWithImpl(this._self, this._then);

  final _DownloadTask _self;
  final $Res Function(_DownloadTask) _then;

/// Create a copy of DownloadTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? songId = null,Object? status = null,Object? progress = null,Object? filePath = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? songTitle = freezed,Object? songArtist = freezed,Object? coverUrl = freezed,Object? totalBytes = null,Object? receivedBytes = null,Object? speed = null,Object? fileSize = null,}) {
  return _then(_DownloadTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,songId: null == songId ? _self.songId : songId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,songTitle: freezed == songTitle ? _self.songTitle : songTitle // ignore: cast_nullable_to_non_nullable
as String?,songArtist: freezed == songArtist ? _self.songArtist : songArtist // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,receivedBytes: null == receivedBytes ? _self.receivedBytes : receivedBytes // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
