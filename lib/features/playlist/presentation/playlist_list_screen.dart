import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_panel.dart';
import '../../../shared/widgets/common_dialogs.dart';
import '../../auth/application/auth_notifier.dart';
import '../../share/application/share_notifier.dart';
import '../../share/domain/models/shared_playlist.dart';
import '../../share/presentation/widgets/import_preview_dialog.dart';
import '../application/playlist_notifier.dart';
import '../domain/models/playlist.dart';
import 'widgets/bili_fav_import_dialog.dart';
import 'widgets/cover_selection_dialog.dart';
import 'widgets/create_playlist_dialog.dart';
import 'widgets/playlist_tile.dart';

/// Screen displaying all user playlists.
///
/// Features:
/// - Grid or list view of playlists with cover art
/// - "Create playlist" floating action button
/// - Long press for rename/delete context menu
class PlaylistListScreen extends ConsumerWidget {
  const PlaylistListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistListNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: playlistsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(error.toString()),
          ),
          data: (playlists) => _PlaylistHomeContent(
            playlists: playlists,
            onCreatePlaylist: () => _createPlaylist(context, ref),
            onOpenPlaylist: (playlist) {
              context.go('/playlists/${playlist.id}');
            },
            onShowPlaylistMenu: (playlist) {
              if (playlist.isFavorite) return;
              _showPlaylistMenu(context, ref, playlist.id, playlist.name);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _createPlaylist(BuildContext context, WidgetRef ref) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (_) => const CreatePlaylistDialog(),
    );

    if (choice == null || !context.mounted) return;

    if (choice == 'manual') {
      final l10n = context.l10n;
      final name = await CommonDialogs.showInputDialog(
        context,
        title: l10n.createPlaylist,
        hint: l10n.title,
      );
      if (name != null && name.trim().isNotEmpty && context.mounted) {
        await ref
            .read(playlistListNotifierProvider.notifier)
            .createPlaylist(name.trim());
      }
    } else if (choice == 'biliFav') {
      await _importFromBiliFav(context, ref);
    } else if (choice == 'clipboard') {
      await _importFromClipboard(context, ref);
    }
  }

  /// 从 B 站收藏夹导入
  Future<void> _importFromBiliFav(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // 检查登录状态
    final user = await ref.read(authNotifierProvider.future);
    if (user == null) {
      if (context.mounted) {
        context.showSnackBar(context.l10n.pleaseLoginFirst);
      }
      return;
    }
    if (!context.mounted) return;

    // 弹出一体化导入对话框，内部管理全部流程
    final resultPlaylistId = await showDialog<int>(
      context: context,
      builder: (_) => const BiliFavImportDialog(),
    );

    // 如果导入成功，跳转到新歌单详情页
    if (resultPlaylistId != null && context.mounted) {
      context.go('/playlists/$resultPlaylistId');
    }
  }

  /// 从剪贴板导入歌单
  Future<void> _importFromClipboard(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final notifier = ref.read(shareNotifierProvider.notifier);
    final playlist = await notifier.parseFromClipboard();

    if (playlist == null) {
      // 解析失败，状态已在 notifier 中设置为 error
      final state = ref.read(shareNotifierProvider);
      if (context.mounted) {
        state.whenOrNull(
          error: (msg) => context.showSnackBar(msg),
        );
      }
      return;
    }

    if (!context.mounted) return;

    // 显示加载弹窗，预取元数据
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Flexible(child: Text(l10n.fetchingMetadata)),
          ],
        ),
      ),
    );

    final metadata = await notifier.prefetchSongMetadata(playlist);

    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop(); // 关闭加载弹窗

    if (metadata == null) {
      context.showSnackBar(l10n.fetchMetadataError);
      return;
    }

    // 显示带选择框的导入预览弹窗，等待用户操作结果
    final selection = await showDialog<(String, List<SharedSong>)>(
      context: context,
      builder: (_) => ImportPreviewDialog(
        playlist: playlist,
        songsMetadata: metadata,
      ),
    );

    if (selection == null || !context.mounted) return;

    final (name, selectedSongs) = selection;
    final filteredPlaylist = SharedPlaylist(
      name: name,
      songs: selectedSongs,
    );

    // 显示导入进度弹窗
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Flexible(child: Text(l10n.importingPlaylist)),
          ],
        ),
      ),
    );

    try {
      // 重新获取 notifier，确保未被 AutoDispose 回收
      final importNotifier = ref.read(shareNotifierProvider.notifier);
      await importNotifier.confirmImport(filteredPlaylist, name: name);

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // 关闭导入进度弹窗

      final state = ref.read(shareNotifierProvider);
      state.whenOrNull(
        importSuccess: (result) {
          context.showSnackBar(
            l10n.importResult(
              result.imported,
              result.reused,
              result.failed,
            ),
          );
        },
        error: (msg) => context.showSnackBar(msg),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // 关闭导入进度弹窗
        context.showSnackBar(l10n.importFailed);
      }
    }
  }

  void _showPlaylistMenu(
    BuildContext context,
    WidgetRef ref,
    int id,
    String currentName,
  ) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.appSpacing.md),
          child: AppPanel(
            padding: EdgeInsets.all(context.appSpacing.sm),
            borderRadius: context.appRadii.xLargeRadius,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PlaylistMenuAction(
                  icon: Icons.edit_rounded,
                  title: l10n.renamePlaylist,
                  onTap: () async {
                    Navigator.pop(ctx);
                    final newName = await CommonDialogs.showInputDialog(
                      context,
                      title: l10n.renamePlaylist,
                      hint: l10n.title,
                      initialValue: currentName,
                    );
                    if (newName != null && newName.trim().isNotEmpty) {
                      await ref
                          .read(playlistListNotifierProvider.notifier)
                          .renamePlaylist(id, newName.trim());
                    }
                  },
                ),
                _PlaylistMenuAction(
                  icon: Icons.image_outlined,
                  title: l10n.changeCover,
                  onTap: () {
                    Navigator.pop(ctx);
                    showDialog(
                      context: context,
                      builder: (_) => CoverSelectionDialog(playlistId: id),
                    );
                  },
                ),
                _PlaylistMenuAction(
                  icon: Icons.delete_rounded,
                  title: l10n.deletePlaylist,
                  destructive: true,
                  onTap: () async {
                    Navigator.pop(ctx);
                    final confirmed = await CommonDialogs.showConfirmDialog(
                      context,
                      title: l10n.deletePlaylist,
                      message: '${l10n.deletePlaylist}?',
                    );
                    if (confirmed == true) {
                      await ref
                          .read(playlistListNotifierProvider.notifier)
                          .deletePlaylist(id);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistHomeContent extends StatelessWidget {
  const _PlaylistHomeContent({
    required this.playlists,
    required this.onCreatePlaylist,
    required this.onOpenPlaylist,
    required this.onShowPlaylistMenu,
  });

  final List<Playlist> playlists;
  final VoidCallback onCreatePlaylist;
  final ValueChanged<Playlist> onOpenPlaylist;
  final ValueChanged<Playlist> onShowPlaylistMenu;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.md,
            spacing.lg,
            spacing.sm,
          ),
          sliver: SliverToBoxAdapter(
            child: _PlaylistSectionHeader(
              count: playlists.length,
              onCreatePlaylist: onCreatePlaylist,
            ),
          ),
        ),
        if (playlists.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                0,
                spacing.lg,
                spacing.xl,
              ),
              child: const _PlaylistEmptyState(),
            ),
          )
        else ...[
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              spacing.lg,
              spacing.sm,
              spacing.lg,
              spacing.xl,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.82,
                crossAxisSpacing: spacing.md,
                mainAxisSpacing: spacing.md,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final playlist = playlists[index];
                  return PlaylistTile(
                    playlist: playlist.isFavorite
                        ? playlist.copyWith(name: context.l10n.myFavorites)
                        : playlist,
                    onTap: () => onOpenPlaylist(playlist),
                    onLongPress: () => onShowPlaylistMenu(playlist),
                  );
                },
                childCount: playlists.length,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PlaylistSectionHeader extends StatelessWidget {
  const _PlaylistSectionHeader({
    required this.count,
    required this.onCreatePlaylist,
  });

  final int count;
  final VoidCallback onCreatePlaylist;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.playlistSectionTitle,
                style: context.textTheme.titleMedium?.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: spacing.xxs),
              Text(
                context.l10n.playlistLibraryCount(count),
                style: context.textTheme.labelMedium?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: spacing.xs,
          children: [
            _PlaylistToolbarButton(
              icon: Icons.add_rounded,
              tooltip: context.l10n.createPlaylist,
              onTap: onCreatePlaylist,
            ),
          ],
        ),
      ],
    );
  }
}

class _PlaylistToolbarButton extends StatelessWidget {
  const _PlaylistToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 38,
        height: 38,
        child: Material(
          color: palette.surfaceSecondary.withValues(alpha: 0.72),
          borderRadius: context.appRadii.mediumRadius,
          child: InkWell(
            borderRadius: context.appRadii.mediumRadius,
            onTap: onTap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: context.appRadii.mediumRadius,
                border: Border.all(
                  color: palette.borderSubtle.withValues(alpha: 0.78),
                  width: context.appDepth.outline,
                ),
              ),
              child: Icon(icon, size: 20, color: palette.accentStrong),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistEmptyState extends StatelessWidget {
  const _PlaylistEmptyState();

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return Center(
      child: AppPanel(
        padding: EdgeInsets.all(spacing.xl),
        borderRadius: context.appRadii.xLargeRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.library_music_outlined,
              size: 54,
              color: palette.accentStrong.withValues(alpha: 0.72),
            ),
            SizedBox(height: spacing.md),
            Text(
              context.l10n.noPlaylists,
              style: context.textTheme.titleMedium?.copyWith(
                color: palette.textPrimary,
              ),
            ),
            SizedBox(height: spacing.xs),
            Text(
              context.l10n.noPlaylistsHint,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaylistMenuAction extends StatelessWidget {
  const _PlaylistMenuAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;
    final color = destructive ? palette.danger : palette.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: context.appRadii.largeRadius,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
