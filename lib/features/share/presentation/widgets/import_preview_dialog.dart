import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../domain/models/shared_playlist.dart';
import '../../domain/models/song_metadata_preview.dart';

/// 导入预览确认弹窗（带歌曲选择功能）
///
/// 显示歌单名称、预取的歌曲元数据（实际歌名），
/// 用户可通过复选框选择要导入的歌曲。
class ImportPreviewDialog extends StatefulWidget {
  /// 解析后的分享歌单数据
  final SharedPlaylist playlist;

  /// 预取后的歌曲元数据列表
  final List<SongMetadataPreview> songsMetadata;

  const ImportPreviewDialog({
    super.key,
    required this.playlist,
    required this.songsMetadata,
  });

  @override
  State<ImportPreviewDialog> createState() => _ImportPreviewDialogState();
}

class _ImportPreviewDialogState extends State<ImportPreviewDialog> {
  late final TextEditingController _nameController;
  late final List<bool> _selected;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.playlist.name);
    _selected = List.filled(widget.songsMetadata.length, true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  int get _selectedCount => _selected.where((s) => s).length;
  bool get _allSelected => _selected.every((s) => s);

  void _toggleAll() {
    setState(() {
      final newValue = !_allSelected;
      for (int i = 0; i < _selected.length; i++) {
        _selected[i] = newValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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

            // 选择控制行
            Row(
              children: [
                Text(
                  l10n.selectedSongCount(_selectedCount, widget.songsMetadata.length),
                  style: context.textTheme.bodyMedium,
                ),
                const Spacer(),
                TextButton(
                  onPressed: _toggleAll,
                  child: Text(_allSelected ? l10n.deselectAll : l10n.selectAll),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // 歌曲列表（带选择框）
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.songsMetadata.length,
                  itemBuilder: (context, index) {
                    final meta = widget.songsMetadata[index];
                    return CheckboxListTile(
                      value: _selected[index],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selected[index] = value);
                        }
                      },
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        meta.displayTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        meta.displayArtist.isNotEmpty
                            ? meta.displayArtist
                            : meta.song.bvid,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      secondary: _buildStatusIcon(context, meta),
                    );
                  },
                ),
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
          onPressed: _selectedCount > 0
              ? () {
                  final name = _nameController.text.trim();
                  if (name.isEmpty) return;

                  final selectedSongs = <SharedSong>[];
                  for (int i = 0; i < widget.songsMetadata.length; i++) {
                    if (_selected[i]) {
                      selectedSongs.add(widget.songsMetadata[i].song);
                    }
                  }

                  Navigator.of(context).pop((name, selectedSongs));
                }
              : null,
          child: Text(l10n.confirmImport),
        ),
      ],
    );
  }

  Widget? _buildStatusIcon(BuildContext context, SongMetadataPreview meta) {
    if (meta.existsLocally) {
      return Tooltip(
        message: context.l10n.existsLocallyLabel,
        child: Icon(
          Icons.check_circle_outline,
          size: 18,
          color: context.colorScheme.primary,
        ),
      );
    }
    if (meta.fetchFailed) {
      return Tooltip(
        message: context.l10n.metadataFetchFailed,
        child: Icon(
          Icons.warning_amber,
          size: 18,
          color: context.colorScheme.error,
        ),
      );
    }
    return null;
  }
}
