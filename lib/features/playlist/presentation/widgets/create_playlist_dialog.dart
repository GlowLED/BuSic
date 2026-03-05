import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';

/// 创建歌单方式选择对话框。
///
/// 返回 `'manual'`（手动创建）或 `'biliFav'`（B 站收藏夹导入）。
class CreatePlaylistDialog extends StatelessWidget {
  const CreatePlaylistDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.createPlaylist),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_note),
            title: Text(l10n.createPlaylistManual),
            subtitle: Text(l10n.createPlaylistManualDesc),
            onTap: () => Navigator.of(context).pop('manual'),
          ),
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: Text(l10n.importFromBiliFav),
            subtitle: Text(l10n.importFromBiliFavDesc),
            onTap: () => Navigator.of(context).pop('biliFav'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
