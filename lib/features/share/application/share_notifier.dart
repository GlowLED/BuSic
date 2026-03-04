import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/utils/logger.dart';
import '../../auth/application/auth_notifier.dart';
import '../../playlist/application/playlist_notifier.dart';
import '../../search_and_parse/data/parse_repository_impl.dart';
import '../data/share_repository.dart';
import '../data/share_repository_impl.dart';
import '../domain/models/share_state.dart';
import '../domain/models/shared_playlist.dart';

part 'share_notifier.g.dart';

/// 歌单分享功能的状态管理 Notifier
///
/// 管理歌单的导出（到剪贴板）和导入（从剪贴板）流程。
@riverpod
class ShareNotifier extends _$ShareNotifier {
  late final ShareRepository _shareRepo;

  @override
  ShareState build() {
    final db = ref.read(databaseProvider);
    final parseRepo = ParseRepositoryImpl(biliDio: BiliDio());
    _shareRepo = ShareRepositoryImpl(db: db, parseRepo: parseRepo);
    return const ShareState.idle();
  }

  /// 离线分享：导出歌单到剪贴板
  Future<void> exportToClipboard(int playlistId) async {
    state = const ShareState.exporting();
    try {
      final playlist = await _shareRepo.exportPlaylist(playlistId);
      final encoded = _shareRepo.encodeForClipboard(playlist);
      await Clipboard.setData(ClipboardData(text: encoded));
      state = ShareState.exported(encoded);
      AppLogger.info('歌单导出到剪贴板成功: ${playlist.name}', tag: 'Share');
    } catch (e) {
      AppLogger.error('导出歌单失败', tag: 'Share', error: e);
      state = ShareState.error('导出失败: $e');
    }
  }

  /// 离线分享：从剪贴板解析歌单数据
  ///
  /// 成功后进入 preview 状态，等待用户确认导入。
  Future<SharedPlaylist?> parseFromClipboard() async {
    try {
      final clipData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipData?.text == null || clipData!.text!.isEmpty) {
        state = const ShareState.error('剪贴板中没有内容');
        return null;
      }

      final playlist = _shareRepo.decodeFromClipboard(clipData.text!);
      state = ShareState.preview(SharedPlaylistPreview(
        name: playlist.name,
        songCount: playlist.songs.length,
        bvids: playlist.songs.map((s) => s.bvid).toList(),
      ));
      return playlist;
    } on FormatException catch (e) {
      state = ShareState.error(e.message);
      return null;
    } catch (e) {
      AppLogger.error('解析剪贴板数据失败', tag: 'Share', error: e);
      state = ShareState.error('解析失败: $e');
      return null;
    }
  }

  /// 确认导入歌单
  ///
  /// [playlist] 为解析后的分享数据，[name] 可选覆盖歌单名称。
  Future<void> confirmImport(
    SharedPlaylist playlist, {
    String? name,
  }) async {
    state = ShareState.importing(total: playlist.songs.length);
    try {
      final result = await _shareRepo.importPlaylist(
        playlist,
        overrideName: name,
        onProgress: (current, total) {
          state = ShareState.importing(current: current, total: total);
        },
      );
      state = ShareState.importSuccess(result);
      // 刷新歌单列表
      ref.invalidate(playlistListNotifierProvider);
      AppLogger.info(
        '歌单导入成功: 导入${result.imported}首, 复用${result.reused}首, 失败${result.failed}首',
        tag: 'Share',
      );
    } catch (e) {
      AppLogger.error('导入歌单失败', tag: 'Share', error: e);
      state = ShareState.error('导入失败: $e');
    }
  }

  /// 重置为空闲状态
  void reset() {
    state = const ShareState.idle();
  }
}
