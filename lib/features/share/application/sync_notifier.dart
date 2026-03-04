import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/logger.dart';
import '../../auth/application/auth_notifier.dart';
import '../../playlist/application/playlist_notifier.dart';
import '../data/sync_repository.dart';
import '../data/sync_repository_impl.dart';
import '../domain/models/app_backup.dart';
import '../domain/models/sync_state.dart';

part 'sync_notifier.g.dart';

/// 数据同步功能的状态管理 Notifier
///
/// 管理完整数据的文件导出和导入流程。
@riverpod
class SyncNotifier extends _$SyncNotifier {
  late final SyncRepository _syncRepo;

  @override
  SyncState build() {
    final db = ref.read(databaseProvider);
    _syncRepo = SyncRepositoryImpl(db: db);
    return const SyncState.idle();
  }

  /// 导出数据到文件
  ///
  /// 弹出文件保存对话框，将完整备份写入 JSON 文件。
  Future<void> exportToFile() async {
    state = const SyncState.exporting();
    try {
      final backup = await _syncRepo.exportFullBackup();
      final jsonStr = const JsonEncoder.withIndent('  ').convert(backup.toJson());
      final bytes = Uint8List.fromList(utf8.encode(jsonStr));

      // 生成文件名
      final now = DateTime.now();
      final timestamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
          '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
      final fileName = 'busic_backup_$timestamp.json';

      // 弹出文件保存对话框
      // Android/iOS 必须传递 bytes 参数，桌面端可选但传递也无害
      final path = await FilePicker.platform.saveFile(
        dialogTitle: '导出备份',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: bytes,
      );

      if (path == null) {
        // 用户取消
        state = const SyncState.idle();
        return;
      }

      // 桌面端 saveFile 只返回路径不写入内容，需手动写入
      // Android/iOS 已通过 bytes 参数直接写入，但重复写入也无影响
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        final file = File(path);
        await file.writeAsString(jsonStr, flush: true);
      }

      state = SyncState.exportSuccess(path);
      AppLogger.info('数据备份导出成功: $path', tag: 'Sync');
    } catch (e) {
      AppLogger.error('导出数据失败', tag: 'Sync', error: e);
      state = SyncState.error('导出失败: $e');
    }
  }

  /// 从文件解析备份数据
  ///
  /// 弹出文件选择对话框，读取并解析 JSON 文件。
  /// 成功后进入 preview 状态。
  Future<AppBackup?> parseFromFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: '导入备份',
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final filePath = result.files.single.path;
      if (filePath == null) {
        state = const SyncState.error('无法读取文件');
        return null;
      }

      final file = File(filePath);
      final jsonStr = await file.readAsString();
      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;

      // 版本兼容性检查
      final version = jsonMap['version'] as int? ?? 1;
      if (version > 1) {
        state = const SyncState.error('请升级 BuSic 后再导入此备份');
        return null;
      }

      final backup = AppBackup.fromJson(jsonMap);
      state = SyncState.preview(backup);
      return backup;
    } on FormatException catch (e) {
      state = SyncState.error('数据格式错误: ${e.message}');
      return null;
    } catch (e) {
      AppLogger.error('解析备份文件失败', tag: 'Sync', error: e);
      state = SyncState.error('解析失败: $e');
      return null;
    }
  }

  /// 执行合并导入
  Future<void> importMerge(AppBackup backup) async {
    state = const SyncState.importing();
    try {
      final result = await _syncRepo.importBackupMerge(backup);
      state = SyncState.importSuccess(result);
      // 刷新歌单列表
      ref.invalidate(playlistListNotifierProvider);
      AppLogger.info(
        '合并导入完成: 新建歌单${result.playlistsCreated}, 合并${result.playlistsMerged}, '
        '新建歌曲${result.songsCreated}, 跳过${result.songsSkipped}',
        tag: 'Sync',
      );
    } catch (e) {
      AppLogger.error('合并导入失败', tag: 'Sync', error: e);
      state = SyncState.error('导入失败: $e');
    }
  }

  /// 执行覆盖导入
  Future<void> importOverwrite(AppBackup backup) async {
    state = const SyncState.importing();
    try {
      final result = await _syncRepo.importBackupOverwrite(backup);
      state = SyncState.importSuccess(result);
      // 刷新歌单列表
      ref.invalidate(playlistListNotifierProvider);
      AppLogger.info(
        '覆盖导入完成: 新建歌单${result.playlistsCreated}, '
        '新建歌曲${result.songsCreated}, 跳过${result.songsSkipped}',
        tag: 'Sync',
      );
    } catch (e) {
      AppLogger.error('覆盖导入失败', tag: 'Sync', error: e);
      state = SyncState.error('导入失败: $e');
    }
  }

  /// 重置为空闲状态
  void reset() {
    state = const SyncState.idle();
  }
}
