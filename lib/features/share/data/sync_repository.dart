import '../domain/models/app_backup.dart';
import '../domain/models/sync_state.dart';

/// 离线数据同步 Repository 抽象接口
///
/// 负责完整数据的导出（生成 AppBackup）和导入（合并/覆盖模式）。
abstract class SyncRepository {
  /// 导出完整数据备份
  Future<AppBackup> exportFullBackup();

  /// 导入数据备份（合并模式）
  ///
  /// 保留现有数据，仅添加新内容：
  /// - 同 bvid+cid 的歌曲跳过
  /// - 同名歌单合并歌曲
  /// - 不存在的歌单/歌曲新建
  Future<ImportResult> importBackupMerge(AppBackup backup);

  /// 导入数据备份（覆盖模式）
  ///
  /// 清空歌单和关联关系后重建，保留 Songs 表（避免丢失本地缓存）。
  Future<ImportResult> importBackupOverwrite(AppBackup backup);
}
