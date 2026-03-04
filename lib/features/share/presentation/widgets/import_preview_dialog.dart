import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../domain/models/shared_playlist.dart';

/// 导入预览确认弹窗
///
/// 显示歌单名称、歌曲数量、BV 号列表预览，
/// 用户可修改歌单名后确认导入。
class ImportPreviewDialog extends StatefulWidget {
  /// 解析后的分享歌单数据
  final SharedPlaylist playlist;

  /// 确认导入回调
  final void Function(String name) onConfirm;

  const ImportPreviewDialog({
    super.key,
    required this.playlist,
    required this.onConfirm,
  });

  @override
  State<ImportPreviewDialog> createState() => _ImportPreviewDialogState();
}

class _ImportPreviewDialogState extends State<ImportPreviewDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.playlist.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final songs = widget.playlist.songs;

    return AlertDialog(
      title: Text(l10n.importPlaylistPreview),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 歌单名称输入
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.playlistName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // 歌曲数量
            Text(
              '${l10n.songCount}: ${songs.length}',
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),

            // 歌曲列表预览
            Text(
              l10n.songList,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '${index + 1}. ${song.customTitle ?? song.bvid}'
                      '${song.customArtist != null ? ' - ${song.customArtist}' : ''}',
                      style: context.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isNotEmpty) {
              Navigator.of(context).pop();
              widget.onConfirm(name);
            }
          },
          child: Text(l10n.confirmImport),
        ),
      ],
    );
  }
}
