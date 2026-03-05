import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../search_and_parse/domain/models/bili_fav_folder.dart';
import '../../../search_and_parse/domain/models/bili_fav_item.dart';
import '../../application/bili_fav_import_notifier.dart';
import 'bili_fav_error_view.dart';
import 'bili_fav_folder_list.dart';
import 'bili_fav_preview.dart';
import 'bili_fav_progress.dart';

/// B 站收藏夹导入一体化对话框。
///
/// 内部管理三个阶段：
/// 1. 收藏夹列表选择
/// 2. 歌曲预览 + 勾选
/// 3. 导入进度 / 结果
///
/// 全部在同一个 Dialog 内完成，避免多层 Dialog 嵌套导致的 context 失效问题。
class BiliFavImportDialog extends ConsumerStatefulWidget {
  const BiliFavImportDialog({super.key});

  @override
  ConsumerState<BiliFavImportDialog> createState() =>
      _BiliFavImportDialogState();
}

/// 对话框所处的阶段
enum _Phase {
  /// 加载 / 显示收藏夹列表
  folderList,

  /// 加载收藏夹内容
  loadingItems,

  /// 显示歌曲预览列表，等待用户确认导入
  preview,

  /// 正在导入
  importing,

  /// 导入完成
  completed,

  /// 出错（可重试）
  error,
}

class _BiliFavImportDialogState extends ConsumerState<BiliFavImportDialog> {
  _Phase _phase = _Phase.folderList;

  // ── 收藏夹列表阶段 ──
  List<BiliFavFolder>? _folders;
  bool _foldersLoading = true;
  String? _foldersError;

  // ── 加载内容阶段 ──
  String _currentFolderName = '';
  int _fetchedCount = 0;
  int _totalCount = 0;

  // ── 预览阶段 ──
  List<BiliFavItem> _items = [];
  late List<bool> _selected;
  late TextEditingController _nameController;

  // ── 导入阶段 ──
  int _importCurrent = 0;
  int _importTotal = 0;

  // ── 完成阶段 ──
  int _resultPlaylistId = 0;
  int _resultImported = 0;
  int _resultReused = 0;
  int _resultFailed = 0;

  // ── 错误阶段 ──
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    // 初始化时加载收藏夹列表
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFolders());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ── 业务方法 ──────────────────────────────────────────────────────────

  Future<void> _loadFolders() async {
    AppLogger.info('开始加载收藏夹列表', tag: 'BiliFavUI');
    setState(() {
      _phase = _Phase.folderList;
      _foldersLoading = true;
      _foldersError = null;
    });

    try {
      final notifier = ref.read(biliFavImportNotifierProvider.notifier);
      await notifier.loadFolders();
      final state = ref.read(biliFavImportNotifierProvider);

      state.when(
        idle: () {},
        loadingFolders: () {},
        foldersLoaded: (folders) {
          AppLogger.info(
            '收藏夹列表加载完成，共 ${folders.length} 个',
            tag: 'BiliFavUI',
          );
          if (!mounted) return;
          setState(() {
            _folders = folders;
            _foldersLoading = false;
          });
        },
        loadingItems: (_, __, ___) {},
        itemsLoaded: (_, __) {},
        importing: (_, __) {},
        completed: (_, __, ___, ____, _____) {},
        error: (msg) {
          AppLogger.error('收藏夹列表加载失败: $msg', tag: 'BiliFavUI');
          if (!mounted) return;
          setState(() {
            _foldersLoading = false;
            _foldersError = msg;
          });
        },
      );
    } catch (e) {
      AppLogger.error('收藏夹列表加载异常', tag: 'BiliFavUI', error: e);
      if (!mounted) return;
      setState(() {
        _foldersLoading = false;
        _foldersError = e.toString();
      });
    }
  }

  Future<void> _onFolderTapped(BiliFavFolder folder) async {
    AppLogger.info(
      '选择收藏夹: "${folder.title}" (id=${folder.id}, count=${folder.mediaCount})',
      tag: 'BiliFavUI',
    );
    setState(() {
      _phase = _Phase.loadingItems;
      _currentFolderName = folder.title;
      _fetchedCount = 0;
      _totalCount = folder.mediaCount;
    });

    try {
      final notifier = ref.read(biliFavImportNotifierProvider.notifier);
      final items = await notifier.loadFolderItems(folder);

      if (!mounted) return;

      if (items == null || items.isEmpty) {
        AppLogger.warning(
          '收藏夹 "${folder.title}" 内容为空或加载失败',
          tag: 'BiliFavUI',
        );
        setState(() {
          _phase = _Phase.error;
          _errorMessage = context.l10n.favFolderEmpty;
        });
        return;
      }

      AppLogger.info(
        '收藏夹内容加载完成，共 ${items.length} 首有效视频',
        tag: 'BiliFavUI',
      );
      setState(() {
        _phase = _Phase.preview;
        _items = items;
        _selected = List.filled(items.length, true);
        _nameController.text = folder.title;
      });
    } catch (e) {
      AppLogger.error('加载收藏夹内容异常', tag: 'BiliFavUI', error: e);
      if (!mounted) return;
      setState(() {
        _phase = _Phase.error;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _startImport() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final selectedItems = <BiliFavItem>[];
    for (int i = 0; i < _items.length; i++) {
      if (_selected[i]) {
        selectedItems.add(_items[i]);
      }
    }

    if (selectedItems.isEmpty) return;

    AppLogger.info(
      '开始导入: 歌单名="$name", 已选 ${selectedItems.length}/${_items.length} 首',
      tag: 'BiliFavUI',
    );
    setState(() {
      _phase = _Phase.importing;
      _importCurrent = 0;
      _importTotal = selectedItems.length;
    });

    try {
      final notifier = ref.read(biliFavImportNotifierProvider.notifier);
      await notifier.importToPlaylist(
        playlistName: name,
        items: selectedItems,
      );

      if (!mounted) return;

      final state = ref.read(biliFavImportNotifierProvider);
      state.when(
        idle: () {},
        loadingFolders: () {},
        foldersLoaded: (_) {},
        loadingItems: (_, __, ___) {},
        itemsLoaded: (_, __) {},
        importing: (current, total) {
          setState(() {
            _importCurrent = current;
            _importTotal = total;
          });
        },
        completed: (playlistId, imported, reused, failed, failedBvids) {
          AppLogger.info(
            '导入完成: playlist=$playlistId, imported=$imported, reused=$reused, failed=$failed',
            tag: 'BiliFavUI',
          );
          if (failedBvids.isNotEmpty) {
            AppLogger.warning(
              '失败的 bvid: ${failedBvids.join(", ")}',
              tag: 'BiliFavUI',
            );
          }
          setState(() {
            _phase = _Phase.completed;
            _resultPlaylistId = playlistId;
            _resultImported = imported;
            _resultReused = reused;
            _resultFailed = failed;
          });
        },
        error: (msg) {
          AppLogger.error('导入失败: $msg', tag: 'BiliFavUI');
          setState(() {
            _phase = _Phase.error;
            _errorMessage = msg;
          });
        },
      );
    } catch (e) {
      AppLogger.error('导入异常', tag: 'BiliFavUI', error: e);
      if (!mounted) return;
      setState(() {
        _phase = _Phase.error;
        _errorMessage = e.toString();
      });
    }
  }

  // ── 辅助 ──────────────────────────────────────────────────────────────

  int get _selectedCount => _selected.where((s) => s).length;
  bool get _allSelected => _selected.every((s) => s);

  void _toggleAll() {
    final newVal = !_allSelected;
    setState(() {
      for (int i = 0; i < _selected.length; i++) {
        _selected[i] = newVal;
      }
    });
  }

  // ── 监听 notifier 的导入进度 ──────────────────────────────────────────

  void _listenImportProgress() {
    final state = ref.read(biliFavImportNotifierProvider);
    state.whenOrNull(
      importing: (current, total) {
        if (mounted && _phase == _Phase.importing) {
          setState(() {
            _importCurrent = current;
            _importTotal = total;
          });
        }
      },
      loadingItems: (folderName, fetched, total) {
        if (mounted && _phase == _Phase.loadingItems) {
          setState(() {
            _fetchedCount = fetched;
            _totalCount = total;
          });
        }
      },
    );
  }

  // ── UI 构建 ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // 监听 notifier 状态变更以更新进度
    ref.listen(biliFavImportNotifierProvider, (_, __) {
      _listenImportProgress();
    });

    final l10n = context.l10n;

    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 480,
          maxHeight: 560,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAppBar(context, l10n),
            Flexible(child: _buildBody(context, l10n)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, dynamic l10n) {
    String title;
    Widget? leading;

    switch (_phase) {
      case _Phase.folderList:
      case _Phase.loadingItems:
        title = l10n.selectFavFolder;
      case _Phase.preview:
        title = l10n.importPreviewTitle;
        leading = IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppLogger.info('返回收藏夹列表', tag: 'BiliFavUI');
            setState(() {
              _phase = _Phase.folderList;
            });
          },
        );
      case _Phase.importing:
        title = l10n.importFromBiliFav;
      case _Phase.completed:
        title = l10n.importFromBiliFav;
      case _Phase.error:
        title = l10n.importFromBiliFav;
    }

    return Container(
      padding: EdgeInsets.only(
        left: leading != null ? 4 : 16,
        right: 4,
        top: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          if (leading != null) leading,
          Expanded(
            child: Text(
              title,
              style: context.textTheme.titleMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, dynamic l10n) {
    switch (_phase) {
      case _Phase.folderList:
        return BiliFavFolderListView(
          folders: _folders,
          isLoading: _foldersLoading,
          errorMessage: _foldersError,
          onFolderTapped: _onFolderTapped,
          onRetry: _loadFolders,
        );
      case _Phase.loadingItems:
        return _buildLoadingItems(context, l10n);
      case _Phase.preview:
        return BiliFavPreviewView(
          items: _items,
          selected: _selected,
          nameController: _nameController,
          selectedCount: _selectedCount,
          allSelected: _allSelected,
          onToggleAll: _toggleAll,
          onToggleItem: (index, val) =>
              setState(() => _selected[index] = val),
          onStartImport: _selectedCount > 0 ? _startImport : null,
          onCancel: () => Navigator.of(context).pop(),
        );
      case _Phase.importing:
        return BiliFavProgressView.importing(
          importCurrent: _importCurrent,
          importTotal: _importTotal,
        );
      case _Phase.completed:
        return BiliFavProgressView.completed(
          resultImported: _resultImported,
          resultReused: _resultReused,
          resultFailed: _resultFailed,
          onConfirm: () => Navigator.of(context).pop(_resultPlaylistId),
        );
      case _Phase.error:
        return BiliFavErrorView(
          message: _errorMessage,
          onRetry: () {
            AppLogger.info('用户点击重试，返回收藏夹列表', tag: 'BiliFavUI');
            _loadFolders();
          },
        );
    }
  }

  // ── Phase 1.5: 加载收藏夹内容 ──────────────────────────────────────────

  Widget _buildLoadingItems(BuildContext context, dynamic l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              l10n.loadingFavItems(_fetchedCount, _totalCount),
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _currentFolderName,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
