// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_backup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppBackupImpl _$$AppBackupImplFromJson(Map<String, dynamic> json) =>
    _$AppBackupImpl(
      version: (json['version'] as num?)?.toInt() ?? 1,
      appVersion: json['appVersion'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      playlists: (json['playlists'] as List<dynamic>)
          .map((e) => BackupPlaylist.fromJson(e as Map<String, dynamic>))
          .toList(),
      songs: (json['songs'] as List<dynamic>)
          .map((e) => SharedSong.fromJson(e as Map<String, dynamic>))
          .toList(),
      playlistSongs: (json['playlistSongs'] as List<dynamic>)
          .map((e) => BackupPlaylistSong.fromJson(e as Map<String, dynamic>))
          .toList(),
      preferences: json['preferences'] == null
          ? null
          : BackupPreferences.fromJson(
              json['preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppBackupImplToJson(_$AppBackupImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'appVersion': instance.appVersion,
      'createdAt': instance.createdAt.toIso8601String(),
      'playlists': instance.playlists,
      'songs': instance.songs,
      'playlistSongs': instance.playlistSongs,
      'preferences': instance.preferences,
    };

_$BackupPlaylistImpl _$$BackupPlaylistImplFromJson(Map<String, dynamic> json) =>
    _$BackupPlaylistImpl(
      originalId: (json['originalId'] as num).toInt(),
      name: json['name'] as String,
      coverUrl: json['coverUrl'] as String?,
      sortOrder: (json['sortOrder'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BackupPlaylistImplToJson(
        _$BackupPlaylistImpl instance) =>
    <String, dynamic>{
      'originalId': instance.originalId,
      'name': instance.name,
      'coverUrl': instance.coverUrl,
      'sortOrder': instance.sortOrder,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$BackupPlaylistSongImpl _$$BackupPlaylistSongImplFromJson(
        Map<String, dynamic> json) =>
    _$BackupPlaylistSongImpl(
      playlistId: (json['playlistId'] as num).toInt(),
      bvid: json['bvid'] as String,
      cid: (json['cid'] as num).toInt(),
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$$BackupPlaylistSongImplToJson(
        _$BackupPlaylistSongImpl instance) =>
    <String, dynamic>{
      'playlistId': instance.playlistId,
      'bvid': instance.bvid,
      'cid': instance.cid,
      'sortOrder': instance.sortOrder,
    };

_$BackupPreferencesImpl _$$BackupPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$BackupPreferencesImpl(
      themeMode: json['themeMode'] as String?,
      locale: json['locale'] as String?,
      preferredQuality: (json['preferredQuality'] as num?)?.toInt(),
      cachePath: json['cachePath'] as String?,
    );

Map<String, dynamic> _$$BackupPreferencesImplToJson(
        _$BackupPreferencesImpl instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'locale': instance.locale,
      'preferredQuality': instance.preferredQuality,
      'cachePath': instance.cachePath,
    };
