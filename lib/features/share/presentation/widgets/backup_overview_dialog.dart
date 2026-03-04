import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../domain/models/app_backup.dart';

/// 备份概览弹窗
///
/// 显示备份的基本信息（时间、版本、歌单数、歌曲数），
/// 让用户选择导入策略（合并/覆盖）后确认导入。
class BackupOverviewDialog extends StatefulWidget {
  /// 解析后的备份数据
  final AppBackup backup;

  /// 确认导入回调，[isMerge] 为 true 表示合并，false 表示覆盖
  final void Function(bool isMerge) onConfirm;

  const BackupOverviewDialog({
    super.key,
    required this.backup,
    required this.onConfirm,
  });

  @override
  State<BackupOverviewDialog> createState() => _BackupOverviewDialogState();
}

class _BackupOverviewDialogState extends State<BackupOverviewDialog> {
  bool _isMerge = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final backup = widget.backup;
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return AlertDialog(
      title: Text(l10n.importDataBackup),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 备份信息
            _InfoRow(
              label: l10n.backupTime,
              value: dateFormat.format(backup.createdAt),
            ),
            _InfoRow(
              label: l10n.appVersionLabel,
              value: backup.appVersion,
            ),
            _InfoRow(
              label: l10n.playlistCount,
              value: '${backup.playlists.length}',
            ),
            _InfoRow(
              label: l10n.songCount,
              value: '${backup.songs.length}',
            ),
            const SizedBox(height: 16),

            // 导入策略选择
            Text(
              l10n.importStrategy,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            RadioListTile<bool>(
              title: Text(l10n.mergeStrategy),
              subtitle: Text(l10n.mergeStrategyDesc),
              value: true,
              groupValue: _isMerge,
              onChanged: (value) {
                if (value != null) setState(() => _isMerge = value);
              },
            ),
            RadioListTile<bool>(
              title: Text(l10n.overwriteStrategy),
              subtitle: Text(l10n.overwriteStrategyDesc),
              value: false,
              groupValue: _isMerge,
              onChanged: (value) {
                if (value != null) setState(() => _isMerge = value);
              },
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
            Navigator.of(context).pop();
            if (!_isMerge) {
              // 覆盖模式需二次确认
              _showOverwriteConfirm(context);
            } else {
              widget.onConfirm(true);
            }
          },
          child: Text(l10n.confirmImport),
        ),
      ],
    );
  }

  void _showOverwriteConfirm(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.warning_amber, color: context.colorScheme.error),
        title: Text(l10n.overwriteConfirmTitle),
        content: Text(l10n.overwriteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onConfirm(false);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(value, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
