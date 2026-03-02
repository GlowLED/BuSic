// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DownloadTask _$DownloadTaskFromJson(Map<String, dynamic> json) {
  return _DownloadTask.fromJson(json);
}

/// @nodoc
mixin _$DownloadTask {
  /// Database primary key.
  int get id => throw _privateConstructorUsedError;

  /// Associated song database ID.
  int get songId => throw _privateConstructorUsedError;

  /// Current download status.
  DownloadStatus get status => throw _privateConstructorUsedError;

  /// Download progress from 0.0 to 1.0.
  double get progress => throw _privateConstructorUsedError;

  /// Target local file path.
  String? get filePath => throw _privateConstructorUsedError;

  /// Error message if status is [DownloadStatus.failed].
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Timestamp when the task was created.
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DownloadTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DownloadTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DownloadTaskCopyWith<DownloadTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadTaskCopyWith<$Res> {
  factory $DownloadTaskCopyWith(
          DownloadTask value, $Res Function(DownloadTask) then) =
      _$DownloadTaskCopyWithImpl<$Res, DownloadTask>;
  @useResult
  $Res call(
      {int id,
      int songId,
      DownloadStatus status,
      double progress,
      String? filePath,
      String? errorMessage,
      DateTime createdAt});
}

/// @nodoc
class _$DownloadTaskCopyWithImpl<$Res, $Val extends DownloadTask>
    implements $DownloadTaskCopyWith<$Res> {
  _$DownloadTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DownloadTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? songId = null,
    Object? status = null,
    Object? progress = null,
    Object? filePath = freezed,
    Object? errorMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      songId: null == songId
          ? _value.songId
          : songId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DownloadStatus,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DownloadTaskImplCopyWith<$Res>
    implements $DownloadTaskCopyWith<$Res> {
  factory _$$DownloadTaskImplCopyWith(
          _$DownloadTaskImpl value, $Res Function(_$DownloadTaskImpl) then) =
      __$$DownloadTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int songId,
      DownloadStatus status,
      double progress,
      String? filePath,
      String? errorMessage,
      DateTime createdAt});
}

/// @nodoc
class __$$DownloadTaskImplCopyWithImpl<$Res>
    extends _$DownloadTaskCopyWithImpl<$Res, _$DownloadTaskImpl>
    implements _$$DownloadTaskImplCopyWith<$Res> {
  __$$DownloadTaskImplCopyWithImpl(
      _$DownloadTaskImpl _value, $Res Function(_$DownloadTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of DownloadTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? songId = null,
    Object? status = null,
    Object? progress = null,
    Object? filePath = freezed,
    Object? errorMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$DownloadTaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      songId: null == songId
          ? _value.songId
          : songId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DownloadStatus,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DownloadTaskImpl implements _DownloadTask {
  const _$DownloadTaskImpl(
      {required this.id,
      required this.songId,
      required this.status,
      this.progress = 0.0,
      this.filePath,
      this.errorMessage,
      required this.createdAt});

  factory _$DownloadTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$DownloadTaskImplFromJson(json);

  /// Database primary key.
  @override
  final int id;

  /// Associated song database ID.
  @override
  final int songId;

  /// Current download status.
  @override
  final DownloadStatus status;

  /// Download progress from 0.0 to 1.0.
  @override
  @JsonKey()
  final double progress;

  /// Target local file path.
  @override
  final String? filePath;

  /// Error message if status is [DownloadStatus.failed].
  @override
  final String? errorMessage;

  /// Timestamp when the task was created.
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'DownloadTask(id: $id, songId: $songId, status: $status, progress: $progress, filePath: $filePath, errorMessage: $errorMessage, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.songId, songId) || other.songId == songId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, songId, status, progress,
      filePath, errorMessage, createdAt);

  /// Create a copy of DownloadTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadTaskImplCopyWith<_$DownloadTaskImpl> get copyWith =>
      __$$DownloadTaskImplCopyWithImpl<_$DownloadTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DownloadTaskImplToJson(
      this,
    );
  }
}

abstract class _DownloadTask implements DownloadTask {
  const factory _DownloadTask(
      {required final int id,
      required final int songId,
      required final DownloadStatus status,
      final double progress,
      final String? filePath,
      final String? errorMessage,
      required final DateTime createdAt}) = _$DownloadTaskImpl;

  factory _DownloadTask.fromJson(Map<String, dynamic> json) =
      _$DownloadTaskImpl.fromJson;

  /// Database primary key.
  @override
  int get id;

  /// Associated song database ID.
  @override
  int get songId;

  /// Current download status.
  @override
  DownloadStatus get status;

  /// Download progress from 0.0 to 1.0.
  @override
  double get progress;

  /// Target local file path.
  @override
  String? get filePath;

  /// Error message if status is [DownloadStatus.failed].
  @override
  String? get errorMessage;

  /// Timestamp when the task was created.
  @override
  DateTime get createdAt;

  /// Create a copy of DownloadTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DownloadTaskImplCopyWith<_$DownloadTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
