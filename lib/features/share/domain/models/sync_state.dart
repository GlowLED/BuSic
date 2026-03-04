import 'package:freezed_annotation/freezed_annotation.dart';
import 'app_backup.dart';

part 'sync_state.freezed.dart';

/// 数据同步功能状态
@freezed
class SyncState with _$SyncState {
  /// 空闲状态
  const factory SyncState.idle() = SyncIdle;

  /// 正在导出
  const factory SyncState.exporting() = SyncExporting;

  /// 导出成功，[filePath] 为导出的文件路径
  const factory SyncState.exportSuccess(String filePath) = SyncExportSuccess;

  /// 正在导入
  const factory SyncState.importing() = SyncImporting;

  /// 预览待导入的备份
  const factory SyncState.preview(AppBackup backup) = SyncPreview;

  /// 导入成功
  const factory SyncState.importSuccess(ImportResult result) = SyncImportSuccess;

  /// 出错
  const factory SyncState.error(String message) = SyncError;
}

/// 数据导入结果统计
@freezed
class ImportResult with _$ImportResult {
  const factory ImportResult({
    /// 新建的歌单数量
    required int playlistsCreated,

    /// 合并的歌单数量（同名歌单合并歌曲）
    required int playlistsMerged,

    /// 新建的歌曲数量
    required int songsCreated,

    /// 跳过的歌曲数量（本地已存在）
    required int songsSkipped,

    /// 错误数量
    required int errors,

    /// 告警信息列表
    @Default([]) List<String> warnings,
  }) = _ImportResult;
}
