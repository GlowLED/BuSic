// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DownloadTaskImpl _$$DownloadTaskImplFromJson(Map<String, dynamic> json) =>
    _$DownloadTaskImpl(
      id: (json['id'] as num).toInt(),
      songId: (json['songId'] as num).toInt(),
      status: $enumDecode(_$DownloadStatusEnumMap, json['status']),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      filePath: json['filePath'] as String?,
      errorMessage: json['errorMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$DownloadTaskImplToJson(_$DownloadTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'songId': instance.songId,
      'status': _$DownloadStatusEnumMap[instance.status]!,
      'progress': instance.progress,
      'filePath': instance.filePath,
      'errorMessage': instance.errorMessage,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$DownloadStatusEnumMap = {
  DownloadStatus.pending: 'pending',
  DownloadStatus.downloading: 'downloading',
  DownloadStatus.completed: 'completed',
  DownloadStatus.failed: 'failed',
};
