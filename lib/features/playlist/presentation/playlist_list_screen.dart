import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/common_dialogs.dart';
import '../../../shared/widgets/masonry_grid.dart';
import '../../auth/application/auth_notifier.dart';
import '../../share/application/share_notifier.dart';
import '../../share/domain/models/share_state.dart';
import '../../share/domain/models/shared_playlist.dart';
import '../../share/presentation/widgets/import_preview_dialog.dart';
import '../application/playlist_notifier.dart';
import '../domain/models/playlist.dart';
import '../domain/playlist_activity.dart';
import 'widgets/bili_fav_import_dialog.dart';
import 'widgets/cover_selection_dialog.dart';
import 'widgets/create_playlist_dialog.dart';
import 'widgets/playlist_tile.dart';

const _playlistTileMaxExtent = 216.0;
const _playlistPrimaryActionSize = 48.0;
const _playlistFeaturedExtentRatio = 0.7;
const _playlistCompactExtentRatio = 0.72;

/// Screen displaying all user playlists.
///
/// Features:
/// - Responsive cover-first playlist grid
/// - Header entry for creating or importing playlists
/// - Visible and long-press access to playlist management actions
class PlaylistListScreen extends ConsumerWidget {
  const PlaylistListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistListNotifierProvider);
    final spacing = context.appSpacing;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding =
                constraints.maxWidth >= AppTheme.compactBreakpoint
                ? spacing.lg
                : spacing.md;

            return Column(
              children: [
                _PlaylistPageActions(
                  horizontalPadding: horizontalPadding,
                  onCreatePlaylist: () => _createPlaylist(context, ref),
                ),
                Expanded(
                  child: playlistsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text(error.toString())),
                    data: (playlists) => _PlaylistHomeContent(
                      playlists: playlists,
                      horizontalPadding: horizontalPadding,
                      onOpenPlaylist: (playlist) {
                        context.go('/playlists/${playlist.id}');
                      },
                      onShowPlaylistMenu: (playlist) {
                        if (playlist.isFavorite) return;
                        _showPlaylistMenu(
                          context,
                          ref,
                          playlist.id,
                          playlist.name,
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
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
  Future<void> _importFromBiliFav(BuildContext context, WidgetRef ref) async {
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
        if (state case ShareError(:final message)) {
          context.showSnackBar(message);
        }
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
      builder: (_) =>
          ImportPreviewDialog(playlist: playlist, songsMetadata: metadata),
    );

    if (selection == null || !context.mounted) return;

    final (name, selectedSongs) = selection;
    final filteredPlaylist = SharedPlaylist(name: name, songs: selectedSongs);

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
      switch (state) {
        case ShareImportSuccess(:final result):
          context.showSnackBar(
            l10n.importResult(result.imported, result.reused, result.failed),
          );
        case ShareError(:final message):
          context.showSnackBar(message);
        default:
          break;
      }
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
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            ctx.appSpacing.sm,
            0,
            ctx.appSpacing.sm,
            ctx.appSpacing.sm,
          ),
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
    );
  }
}

class _PlaylistHomeContent extends StatelessWidget {
  const _PlaylistHomeContent({
    required this.playlists,
    required this.horizontalPadding,
    required this.onOpenPlaylist,
    required this.onShowPlaylistMenu,
  });

  final List<Playlist> playlists;
  final double horizontalPadding;
  final ValueChanged<Playlist> onOpenPlaylist;
  final ValueChanged<Playlist> onShowPlaylistMenu;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final sorted = PlaylistActivity.sortByActivity(playlists);
    final tiers = sorted
        .map((playlist) => PlaylistActivity.tierFor(playlist, sorted))
        .toList(growable: false);

    return CustomScrollView(
      // Pre-build ~a screen of tiles ahead of the viewport so scrolling into
      // them doesn't jank on first paint.
      scrollCacheExtent: const ScrollCacheExtent.pixels(800),
      slivers: [
        if (playlists.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                spacing.xl,
              ),
              child: const _PlaylistEmptyState(),
            ),
          )
        else ...[
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              spacing.xs,
              horizontalPadding,
              spacing.xl,
            ),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                return SliverGrid(
                  gridDelegate: MasonryGridDelegate(
                    childCount: sorted.length,
                    mainAxisSpacing: spacing.md,
                    crossAxisSpacing: spacing.md,
                    maxCrossAxisExtent: _playlistTileMaxExtent + spacing.md,
                    itemExtentResolver: (index) {
                      return switch (tiers[index]) {
                        PlaylistTier.featured => (
                            span: 2,
                            extentRatio: _playlistFeaturedExtentRatio,
                          ),
                        PlaylistTier.compact => (
                            span: 1,
                            extentRatio: _playlistCompactExtentRatio,
                          ),
                        PlaylistTier.standard => (span: 1, extentRatio: 1),
                      };
                    },
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final playlist = sorted[index];
                    return PlaylistTile(
                      playlist: playlist.isFavorite
                          ? playlist.copyWith(name: context.l10n.myFavorites)
                          : playlist,
                      tier: tiers[index],
                      onTap: () => onOpenPlaylist(playlist),
                      onLongPress: playlist.isFavorite
                          ? null
                          : () => onShowPlaylistMenu(playlist),
                      onMorePressed: playlist.isFavorite
                          ? null
                          : () => onShowPlaylistMenu(playlist),
                    );
                  }, childCount: sorted.length),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _PlaylistPageActions extends StatelessWidget {
  const _PlaylistPageActions({
    required this.horizontalPadding,
    required this.onCreatePlaylist,
  });

  final double horizontalPadding;
  final VoidCallback onCreatePlaylist;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        spacing.sm,
        horizontalPadding,
        spacing.xs,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: _CreatePlaylistButton(onTap: onCreatePlaylist),
      ),
    );
  }
}

class _CreatePlaylistButton extends StatelessWidget {
  const _CreatePlaylistButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return Tooltip(
      message: context.l10n.createPlaylist,
      child: Semantics(
        button: true,
        label: context.l10n.createPlaylist,
        child: SizedBox.square(
          dimension: _playlistPrimaryActionSize,
          child: Material(
            color: palette.accentStrong,
            borderRadius: context.appRadii.mediumRadius,
            elevation: 0,
            child: InkWell(
              borderRadius: context.appRadii.mediumRadius,
              onTap: onTap,
              child: Icon(
                Icons.add_rounded,
                size: 24,
                color: context.colorScheme.onPrimary,
              ),
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

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.library_music_outlined,
              size: 48,
              color: context.appPalette.textMuted,
            ),
            SizedBox(height: spacing.md),
            Text(
              context.l10n.noPlaylists,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.appPalette.textPrimary,
              ),
            ),
            SizedBox(height: spacing.xs),
            Text(
              context.l10n.noPlaylistsHint,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.appPalette.textSecondary,
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
