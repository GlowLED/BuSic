import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_state.freezed.dart';

/// 歌单分享功能状态
@freezed
class ShareState with _$ShareState {
  /// 空闲状态
  const factory ShareState.idle() = ShareIdle;

  /// 正在导出
  const factory ShareState.exporting() = ShareExporting;

  /// 导出完成，[data] 为编码后的字符串
  const factory ShareState.exported(String data) = ShareExported;

  /// 正在导入（含进度信息）
  const factory ShareState.importing({
    @Default(0) int current,
    @Default(0) int total,
  }) = ShareImporting;

  /// 预览待导入的歌单
  const factory ShareState.preview(SharedPlaylistPreview preview) = SharePreview;

  /// 导入成功
  const factory ShareState.importSuccess(ShareImportResult result) = ShareImportSuccess;

  /// 出错
  const factory ShareState.error(String message) = ShareError;
}

/// 分享导入结果
@freezed
class ShareImportResult with _$ShareImportResult {
  const factory ShareImportResult({
    /// 新建歌单 ID
    required int playlistId,

    /// 成功导入的歌曲数
    required int imported,

    /// 本地已存在的歌曲数（直接复用）
    required int reused,

    /// 拉取元数据失败的歌曲数
    required int failed,

    /// 失败的 bvid 列表（供用户排查）
    @Default([]) List<String> failedBvids,
  }) = _ShareImportResult;
}

/// 分享歌单预览信息（用于导入确认弹窗）
@freezed
class SharedPlaylistPreview with _$SharedPlaylistPreview {
  const factory SharedPlaylistPreview({
    /// 歌单名称
    required String name,

    /// 歌曲数量
    required int songCount,

    /// BV 号列表（预览用）
    required List<String> bvids,
  }) = _SharedPlaylistPreview;
}
