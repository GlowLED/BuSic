import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../share/application/sync_notifier.dart';
import '../../../share/presentation/widgets/backup_overview_dialog.dart';
import 'section_header.dart';

/// Data management section: export/import backup.
class DataManagementSection extends ConsumerWidget {
  const DataManagementSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.dataManagement),
        ListTile(
          leading: const Icon(Icons.upload_file),
          title: Text(l10n.exportBackup),
          subtitle: Text(l10n.exportBackupDesc),
          onTap: () => _exportBackup(context, ref),
        ),
        ListTile(
          leading: const Icon(Icons.download),
          title: Text(l10n.importBackup),
          subtitle: Text(l10n.importBackupDesc),
          onTap: () => _importBackup(context, ref),
        ),
      ],
    );
  }

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final notifier = ref.read(syncNotifierProvider.notifier);
    await notifier.exportToFile();
    final state = ref.read(syncNotifierProvider);
    if (context.mounted) {
      state.whenOrNull(
        exportSuccess: (path) => context.showSnackBar(
          l10n.backupExportedTo(path),
        ),
        error: (msg) => context.showSnackBar(msg),
      );
    }
  }

  Future<void> _importBackup(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(syncNotifierProvider.notifier);
    final backup = await notifier.parseFromFile();
    if (backup == null) {
      final state = ref.read(syncNotifierProvider);
      if (context.mounted) {
        state.whenOrNull(
          error: (msg) => context.showSnackBar(msg),
        );
      }
      return;
    }

    if (!context.mounted) return;

    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (_) => BackupOverviewDialog(
        backup: backup,
        onConfirm: (isMerge) async {
          if (isMerge) {
            await notifier.importMerge(backup);
          } else {
            await notifier.importOverwrite(backup);
          }
          final importState = ref.read(syncNotifierProvider);
          if (context.mounted) {
            importState.whenOrNull(
              importSuccess: (result) {
                context.showSnackBar(
                  l10n.backupImportResult(
                    result.playlistsCreated,
                    result.playlistsMerged,
                    result.songsCreated,
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
}
