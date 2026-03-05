import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/update_notifier.dart';
import '../../domain/models/download_channel.dart';
import 'channel_picker_sheet.dart';

/// 设置页内嵌的下载进度 Tile — 根据 UpdateState 显示不同 UI。
class DownloadTile extends ConsumerWidget {
  const DownloadTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(updateNotifierProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return state.when(
      idle: () => _buildIdleOrAvailable(context, ref, null),
      checking: () => const ListTile(
        leading: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        title: Text('...'),
      ),
      available: (info) => _buildIdleOrAvailable(context, ref, info),
      downloading: (info, progress, speed, channel, downloadedBytes, totalBytes) =>
          _buildDownloading(context, ref, progress, speed, info.isForceUpdate),
      paused: (info, progress, channel, downloadedBytes, totalBytes, localPath) =>
          _buildPaused(context, ref, progress),
      readyToInstall: (info, localPath) => ListTile(
        leading: Icon(Icons.check_circle, color: theme.colorScheme.primary),
        title: Text(l10n.downloadCompleteReady),
        subtitle: Text('v${info.latestVersion.semver}'),
        trailing: FilledButton(
          onPressed: () =>
              ref.read(updateNotifierProvider.notifier).applyUpdate(),
          child: Text(l10n.installUpdate),
        ),
      ),
      error: (message) => ListTile(
        leading: Icon(Icons.error_outline, color: theme.colorScheme.error),
        title: Text(l10n.updateError),
        subtitle: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: TextButton(
          onPressed: () =>
              ref.read(updateNotifierProvider.notifier).checkForUpdate(),
          child: Text(l10n.retryDownload),
        ),
      ),
    );
  }

  Widget _buildIdleOrAvailable(
    BuildContext context,
    WidgetRef ref,
    dynamic info,
  ) {
    final l10n = context.l10n;

    final title = info != null
        ? '${l10n.updateAvailable} v${info.latestVersion.semver}'
        : l10n.downloadLatestVersion;

    return ListTile(
      leading: const Icon(Icons.download),
      title: Text(title),
      subtitle: info != null ? Text(l10n.selectDownloadChannel) : null,
      onTap: () async {
        if (info == null) {
          // Need to check for update first
          await ref
              .read(updateNotifierProvider.notifier)
              .checkForUpdate();
          return;
        }

        final availableChannels = <DownloadChannel>{};
        final downloadUrls = info.downloadUrls as Map<DownloadChannel, String>;
        availableChannels.addAll(downloadUrls.keys);

        if (!context.mounted) return;

        final channel = await ChannelPickerSheet.show(
          context,
          availableChannels: availableChannels,
        );
        if (channel != null) {
          ref
              .read(updateNotifierProvider.notifier)
              .startDownloadWithChannel(channel);
        }
      },
    );
  }

  Widget _buildDownloading(
    BuildContext context,
    WidgetRef ref,
    double progress,
    double speed,
    bool isForceUpdate,
  ) {
    final l10n = context.l10n;

    return GestureDetector(
      onTap: () =>
          ref.read(updateNotifierProvider.notifier).pauseDownload(),
      onLongPress: () => _showCancelConfirm(context, ref, isForceUpdate),
      child: ListTile(
        leading: const Icon(Icons.downloading),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  _formatSpeed(speed),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        subtitle: Text(
          '${l10n.tapToPause} · ${l10n.longPressToCancel}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _buildPaused(
    BuildContext context,
    WidgetRef ref,
    double progress,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () =>
          ref.read(updateNotifierProvider.notifier).resumeDownload(),
      onLongPress: () => _showCancelConfirm(context, ref, false),
      child: ListTile(
        leading: Icon(Icons.pause_circle_outline,
            color: theme.colorScheme.onSurfaceVariant),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: 0.5,
              child: LinearProgressIndicator(value: progress),
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.downloadPaused} — ${(progress * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        subtitle: Text(
          '${l10n.tapToResume} · ${l10n.longPressToCancel}',
          style: theme.textTheme.bodySmall,
        ),
      ),
    );
  }

  void _showCancelConfirm(
    BuildContext context,
    WidgetRef ref,
    bool isForceUpdate,
  ) {
    if (isForceUpdate) return; // 强制更新不允许取消

    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cancelDownloadConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(updateNotifierProvider.notifier).cancelDownload();
              Navigator.pop(ctx);
            },
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
