import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../domain/models/version_manifest.dart';

/// 版本选择对话框 — 用于版本回退
class VersionPickerDialog extends StatelessWidget {
  final List<VersionEntry> versions;
  final String currentVersion;

  const VersionPickerDialog({
    super.key,
    required this.versions,
    required this.currentVersion,
  });

  /// 显示版本选择对话框，返回选中的版本号或 null。
  static Future<String?> show(
    BuildContext context, {
    required List<VersionEntry> versions,
    required String currentVersion,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => VersionPickerDialog(
        versions: versions,
        currentVersion: currentVersion,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    // Filter out current version
    final filteredVersions = versions
        .where((v) => v.version != currentVersion)
        .toList();

    return AlertDialog(
      title: Text(l10n.selectTargetVersion),
      content: SizedBox(
        width: double.maxFinite,
        child: filteredVersions.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.noHistoryVersions),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredVersions.length,
                itemBuilder: (context, index) {
                  final entry = filteredVersions[index];
                  return ListTile(
                    title: Text('v${entry.version}'),
                    subtitle: Text(
                      '${entry.date}  ${entry.changelog.isNotEmpty ? entry.changelog : ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => Navigator.pop(context, entry.version),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
