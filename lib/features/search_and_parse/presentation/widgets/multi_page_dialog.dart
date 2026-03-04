import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';

import '../../application/parse_notifier.dart';
import '../../domain/models/bvid_info.dart';
import '../../domain/models/page_info.dart';
import '../../../../core/utils/formatters.dart';

/// Dialog for selecting specific pages from a multi-page Bilibili video.
class MultiPageDialog extends ConsumerWidget {
  final BvidInfo videoInfo;
  final List<PageInfo> selectedPages;

  const MultiPageDialog({
    super.key,
    required this.videoInfo,
    required this.selectedPages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final parseState = ref.watch(parseNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // Get current selected pages from state
    final currentSelected = parseState.whenOrNull(
          selectingPages: (_, selected) => selected,
        ) ??
        selectedPages;

    final isAllSelected =
        currentSelected.length == videoInfo.pages.length;

    return AlertDialog(
      title: Text(
        videoInfo.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      content: SizedBox(
        width: 400,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header info
            Text(
              '${videoInfo.owner} · ${videoInfo.pages.length}个分P',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            // Select all toggle
            CheckboxListTile(
              title: Text(l10n.selectPages),
              subtitle: Text('已选择 ${currentSelected.length}/${videoInfo.pages.length}'),
              value: isAllSelected,
              tristate: true,
              onChanged: (value) {
                if (value == true) {
                  ref.read(parseNotifierProvider.notifier).selectAllPages();
                } else {
                  ref.read(parseNotifierProvider.notifier).deselectAllPages();
                }
              },
            ),
            const Divider(),
            // Page list
            Expanded(
              child: ListView.builder(
                itemCount: videoInfo.pages.length,
                itemBuilder: (context, index) {
                  final page = videoInfo.pages[index];
                  final isSelected =
                      currentSelected.any((p) => p.cid == page.cid);
                  return CheckboxListTile(
                    value: isSelected,
                    title: Text(
                      'P${page.page} ${page.partTitle}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      Formatters.formatDuration(
                          Duration(seconds: page.duration)),
                    ),
                    dense: true,
                    onChanged: (_) {
                      ref
                          .read(parseNotifierProvider.notifier)
                          .togglePageSelection(page);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(parseNotifierProvider.notifier).reset();
            Navigator.of(context).pop();
          },
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: currentSelected.isEmpty
              ? null
              : () async {
                  final ids = await ref
                      .read(parseNotifierProvider.notifier)
                      .confirmSelection();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('已添加 ${ids.length} 首歌曲'),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16)),
                    );
                  }
                },
          child: Text(l10n.confirmSelection),
        ),
      ],
    );
  }
}
