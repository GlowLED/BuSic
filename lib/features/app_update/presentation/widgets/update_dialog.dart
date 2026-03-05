import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/update_notifier.dart';

/// Dialog that shows update information and manages the update flow.
class UpdateDialog extends ConsumerWidget {
  const UpdateDialog({super.key});

  /// Show the update dialog. Returns when the dialog is dismissed.
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const UpdateDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(updateNotifierProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return state.when(
      idle: () => const SizedBox.shrink(),
      checking: () => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(l10n.checkForUpdate),
          ],
        ),
      ),
      available: (info) => AlertDialog(
        title: Text(
          '${l10n.updateAvailable} v${info.latestVersion.semver}',
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.updateChangelog,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  info.changelog.isNotEmpty
                      ? info.changelog
                      : '-',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (!info.isForceUpdate) ...[
            TextButton(
              onPressed: () {
                ref
                    .read(updateNotifierProvider.notifier)
                    .skipVersion(info.latestVersion);
                Navigator.of(context).pop();
              },
              child: Text(l10n.skipThisVersion),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.updateLater),
            ),
          ],
          FilledButton(
            onPressed: () {
              ref.read(updateNotifierProvider.notifier).startDownload();
            },
            child: Text(l10n.updateNow),
          ),
        ],
      ),
      downloading: (info, progress, speed) => AlertDialog(
        title: Text(l10n.downloading),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(progress * 100).toStringAsFixed(0)}%'),
                Text(_formatSpeed(speed)),
              ],
            ),
          ],
        ),
        actions: [
          if (!info.isForceUpdate)
            TextButton(
              onPressed: () {
                ref.read(updateNotifierProvider.notifier).cancelDownload();
                Navigator.of(context).pop();
              },
              child: Text(l10n.cancel),
            ),
        ],
      ),
      readyToInstall: (info, localPath) => AlertDialog(
        title: Text(l10n.downloadComplete),
        content: Text(l10n.installing),
        actions: [
          FilledButton(
            onPressed: () {
              ref.read(updateNotifierProvider.notifier).applyUpdate();
            },
            child: Text(l10n.updateNow),
          ),
        ],
      ),
      error: (message) => AlertDialog(
        title: Text(l10n.updateError),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  String _formatSpeed(double bytesPerSec) {
    if (bytesPerSec < 1024) {
      return '${bytesPerSec.toStringAsFixed(0)} B/s';
    } else if (bytesPerSec < 1024 * 1024) {
      return '${(bytesPerSec / 1024).toStringAsFixed(1)} KB/s';
    } else {
      return '${(bytesPerSec / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
  }
}
