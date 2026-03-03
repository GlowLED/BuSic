import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/playlist_notifier.dart';
import '../../domain/models/song_item.dart';

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

/// Dialog for editing song metadata (title, artist, cover).
///
/// Shows current values and allows the user to override them.
/// Changes are saved via the playlist notifier.
class MetadataEditDialog extends ConsumerStatefulWidget {
  /// The song whose metadata is being edited.
  final SongItem song;

  /// The playlist this song belongs to (for notifier reference).
  final int playlistId;

  const MetadataEditDialog({
    super.key,
    required this.song,
    required this.playlistId,
  });

  @override
  ConsumerState<MetadataEditDialog> createState() => _MetadataEditDialogState();
}

class _MetadataEditDialogState extends ConsumerState<MetadataEditDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _artistController;
  late final TextEditingController _coverController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.song.customTitle ?? '');
    _artistController =
        TextEditingController(text: widget.song.customArtist ?? '');
    _coverController =
        TextEditingController(text: widget.song.coverUrl ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.editMetadata),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.title,
                hintText: widget.song.originTitle,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _artistController,
              decoration: InputDecoration(
                labelText: l10n.artist,
                hintText: widget.song.originArtist,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _coverController,
              decoration: InputDecoration(
                labelText: l10n.cover,
                hintText: 'https://...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.folder_open),
                  tooltip: '选择本地图片',
                  onPressed: () async {
                    final path = await _pickImageFile(title: '选择歌曲封面');
                    if (path != null && mounted) {
                      _coverController.text = path;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _titleController.clear();
            _artistController.clear();
            _coverController.clear();
          },
          child: Text(l10n.reset),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final title = _titleController.text.trim();
            final artist = _artistController.text.trim();
            final cover = _coverController.text.trim();

            ref
                .read(playlistDetailNotifierProvider(widget.playlistId).notifier)
                .updateMetadata(
                  widget.song.id,
                  title: title.isEmpty ? null : title,
                  artist: artist.isEmpty ? null : artist,
                  coverUrl: cover.isEmpty ? null : cover,
                );

            Navigator.pop(context);
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
