import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../domain/models/download_channel.dart';

/// 渠道选择 BottomSheet
class ChannelPickerSheet extends StatelessWidget {
  final Set<DownloadChannel> availableChannels;

  const ChannelPickerSheet({
    super.key,
    required this.availableChannels,
  });

  /// 显示渠道选择 BottomSheet，返回选中的渠道或 null。
  static Future<DownloadChannel?> show(
    BuildContext context, {
    required Set<DownloadChannel> availableChannels,
  }) {
    return showModalBottomSheet<DownloadChannel>(
      context: context,
      builder: (_) => ChannelPickerSheet(
        availableChannels: availableChannels,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.selectDownloadChannel,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.channelGithub),
              subtitle: Text(l10n.channelGithubDesc),
              enabled: availableChannels.contains(DownloadChannel.github),
              onTap: () => Navigator.pop(context, DownloadChannel.github),
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: Text(l10n.channelLanzou),
              subtitle: Text(
                availableChannels.contains(DownloadChannel.lanzou)
                    ? l10n.channelLanzouDesc
                    : l10n.channelNotAvailable,
              ),
              enabled: availableChannels.contains(DownloadChannel.lanzou),
              onTap: availableChannels.contains(DownloadChannel.lanzou)
                  ? () => Navigator.pop(context, DownloadChannel.lanzou)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
