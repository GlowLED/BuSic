import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/update_notifier.dart';
import '../../domain/models/download_channel.dart';

/// Dialog that shows update information (passive notification).
///
/// V2: Simplified to pure notification — download happens in settings page.
/// Force updates still provide in-dialog download.
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
          if (info.isForceUpdate)
            // Force update: download directly in dialog
            FilledButton(
              onPressed: () {
                ref
                    .read(updateNotifierProvider.notifier)
                    .startDownloadWithChannel(DownloadChannel.github);
              },
              child: Text(l10n.updateNow),
            )
          else
            // Normal update: navigate to settings
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to settings — caller handles this
              },
              child: Text(l10n.goToSettings),
            ),
        ],
      ),
      downloading: (info, progress, speed, channel, downloadedBytes, totalBytes) =>
          AlertDialog(
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
      paused: (info, progress, channel, downloadedBytes, totalBytes, localPath) =>
          AlertDialog(
        title: Text(l10n.downloadPaused),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.5,
              child: LinearProgressIndicator(value: progress),
            ),
            const SizedBox(height: 8),
            Text('${(progress * 100).toStringAsFixed(0)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(updateNotifierProvider.notifier).resumeDownload();
            },
            child: Text(l10n.tapToResume),
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
            child: Text(l10n.installUpdate),
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
