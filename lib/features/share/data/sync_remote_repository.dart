import '../domain/models/app_backup.dart';

/// 在线数据同步服务接口
///
/// 后续可对接 Firebase / Supabase / 自建服务。
/// 当前仅定义接口，暂不实现。
abstract class SyncRemoteRepository {
  /// 上传完整备份到云端
  Future<void> uploadBackup(AppBackup backup);

  /// 从云端下载最新备份
  Future<AppBackup?> downloadLatestBackup();

  /// 获取云端备份的元信息（不下载完整数据）
  Future<SyncMetadata?> getRemoteSyncMetadata();
}

/// 同步元信息
class SyncMetadata {
  final DateTime lastSyncAt;
  final int playlistCount;
  final int songCount;
  final String deviceName;

  const SyncMetadata({
    required this.lastSyncAt,
    required this.playlistCount,
    required this.songCount,
    required this.deviceName,
  });
}
