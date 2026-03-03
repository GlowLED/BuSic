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
      songTitle: json['songTitle'] as String?,
      songArtist: json['songArtist'] as String?,
      coverUrl: json['coverUrl'] as String?,
      totalBytes: (json['totalBytes'] as num?)?.toInt() ?? 0,
      receivedBytes: (json['receivedBytes'] as num?)?.toInt() ?? 0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      fileSize: (json['fileSize'] as num?)?.toInt() ?? 0,
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
      'songTitle': instance.songTitle,
      'songArtist': instance.songArtist,
      'coverUrl': instance.coverUrl,
      'totalBytes': instance.totalBytes,
      'receivedBytes': instance.receivedBytes,
      'speed': instance.speed,
      'fileSize': instance.fileSize,
    };

const _$DownloadStatusEnumMap = {
  DownloadStatus.pending: 'pending',
  DownloadStatus.downloading: 'downloading',
  DownloadStatus.completed: 'completed',
  DownloadStatus.failed: 'failed',
};
