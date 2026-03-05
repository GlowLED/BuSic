import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../search_and_parse/domain/models/bili_fav_item.dart';

/// 歌曲预览列表视图（Phase 2）。
///
/// 展示已选歌曲列表，支持勾选/取消和歌单名称编辑。
class BiliFavPreviewView extends StatelessWidget {
  const BiliFavPreviewView({
    super.key,
    required this.items,
    required this.selected,
    required this.nameController,
    required this.selectedCount,
    required this.allSelected,
    required this.onToggleAll,
    required this.onToggleItem,
    required this.onStartImport,
    required this.onCancel,
  });

  final List<BiliFavItem> items;
  final List<bool> selected;
  final TextEditingController nameController;
  final int selectedCount;
  final bool allSelected;
  final VoidCallback onToggleAll;
  final void Function(int index, bool value) onToggleItem;
  final VoidCallback? onStartImport;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 歌单名称输入
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: l10n.playlistName,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),

        // 选择控制行
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text(
                l10n.selectedSongCount(selectedCount, items.length),
                style: context.textTheme.bodySmall,
              ),
              const Spacer(),
              TextButton(
                onPressed: onToggleAll,
                child: Text(allSelected ? l10n.deselectAll : l10n.selectAll),
              ),
            ],
          ),
        ),

        // 歌曲列表
        Flexible(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return CheckboxListTile(
                value: selected[index],
                onChanged: (val) {
                  if (val != null) onToggleItem(index, val);
                },
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  '${item.upper}  ${Formatters.formatDuration(Duration(seconds: item.duration))}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          ),
        ),

        // 底部操作栏
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onCancel,
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: onStartImport,
                child: Text(l10n.confirmImport),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
