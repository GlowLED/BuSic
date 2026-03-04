import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/common_dialogs.dart';
import '../../share/application/share_notifier.dart';
import '../../share/presentation/widgets/import_preview_dialog.dart';
import '../application/playlist_notifier.dart';
import 'widgets/playlist_tile.dart';

Future<String?> _pickImageFile({String? title}) async {
  if (!Platform.isLinux) return null;
  try {
    final result = await Process.run('zenity', [
      '--file-selection',
      '--title=${title ?? '选择封面图片'}',
      '--file-filter=Image files | *.png *.jpg *.jpeg *.webp *.bmp',
      '--file-filter=All files | *',
    ]);
    if (result.exitCode == 0) {
      final path = (result.stdout as String).trim();
      if (path.isNotEmpty) return path;
    }
  } catch (_) {}
  return null;
}

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
    final l10n = context.l10n;

    return Scaffold(
      body: playlistsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
        data: (playlists) {
          if (playlists.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.library_music_outlined,
                    size: 64,
                    color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noPlaylists,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return PlaylistTile(
                playlist: playlist,
                onTap: () {
                  context.go('/playlists/${playlist.id}');
                },
                onLongPress: () {
                  _showPlaylistMenu(context, ref, playlist.id, playlist.name);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'import',
            onPressed: () => _importFromClipboard(context, ref),
            tooltip: context.l10n.importFromClipboard,
            child: const Icon(Icons.paste),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'create',
            onPressed: () => _createPlaylist(context, ref),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<void> _createPlaylist(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final name = await CommonDialogs.showInputDialog(
      context,
      title: l10n.createPlaylist,
      hint: l10n.title,
    );
    if (name != null && name.trim().isNotEmpty) {
      await ref
          .read(playlistListNotifierProvider.notifier)
          .createPlaylist(name.trim());
    }
  }

  /// 从剪贴板导入歌单
  Future<void> _importFromClipboard(BuildContext context, WidgetRef ref) async {
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

    // 显示导入预览弹窗
    showDialog(
      context: context,
      builder: (_) => ImportPreviewDialog(
        playlist: playlist,
        onConfirm: (name) async {
          await notifier.confirmImport(playlist, name: name);
          final state = ref.read(shareNotifierProvider);
          if (context.mounted) {
            state.whenOrNull(
              importSuccess: (result) {
                context.showSnackBar(
                  context.l10n.importResult(
                    result.imported,
                    result.reused,
                    result.failed,
                  ),
                );
              },
              error: (msg) => context.showSnackBar(msg),
            );
          }
        },
      ),
    );
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
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.renamePlaylist),
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
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('修改封面'),
              onTap: () async {
                Navigator.pop(ctx);
                final path = await _pickImageFile(title: '选择歌单封面');
                if (path != null && path.isNotEmpty) {
                  await ref
                      .read(playlistListNotifierProvider.notifier)
                      .updatePlaylistCover(id, path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_not_supported_outlined),
              title: const Text('恢复默认封面'),
              onTap: () async {
                Navigator.pop(ctx);
                await ref
                    .read(playlistListNotifierProvider.notifier)
                    .updatePlaylistCover(id, null);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: context.colorScheme.error),
              title: Text(
                l10n.deletePlaylist,
                style: TextStyle(color: context.colorScheme.error),
              ),
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
    );
  }
}
