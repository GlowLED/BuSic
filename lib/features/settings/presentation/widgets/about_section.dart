import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/app_info.dart';
import '../../../../core/utils/platform_utils.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../app_update/application/update_notifier.dart';
import '../../../app_update/domain/models/download_channel.dart';
import '../../../app_update/domain/models/update_state.dart';
import '../../../app_update/presentation/widgets/channel_picker_sheet.dart';
import '../../../app_update/presentation/widgets/update_dialog.dart';
import '../../../app_update/presentation/widgets/version_picker_dialog.dart';
import '../../application/settings_notifier.dart';
import 'settings_panel.dart';

/// About section: version info, follow us, update, rollback, and reset.
class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final updateState = ref.watch(updateNotifierProvider);
    final isChecking = updateState is UpdateStateChecking;

    ref.listen<UpdateState>(updateNotifierProvider, (prev, next) {
      if (next is UpdateStateAvailable && next.info.isForceUpdate) {
        UpdateDialog.show(context);
      } else if (next is UpdateStateIdle && prev is UpdateStateChecking) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.upToDate)),
        );
      } else if (next is UpdateStateError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    return SettingsSectionPanel(
      title: l10n.aboutSettings,
      icon: Icons.info_rounded,
      children: [
        Consumer(
          builder: (context, ref, _) {
            final info = ref.watch(appInfoProvider).valueOrNull;
            final versionDisplay =
                info != null ? 'v${info.version}+${info.buildNumber}' : '';
            return SettingsTile(
              icon: Icons.info_outline_rounded,
              title: l10n.about,
              subtitle: 'BuSic $versionDisplay',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'BuSic',
                  applicationVersion: versionDisplay,
                  applicationLegalese:
                      'A cross-platform Bilibili music player.',
                );
              },
            );
          },
        ),
        SettingsTile(
          icon: Icons.people_outline_rounded,
          title: l10n.followUs,
          subtitle: l10n.followUsDesc,
          onTap: () => _showFollowUsDialog(context),
        ),
        SettingsTile(
          icon: isChecking ? Icons.sync_rounded : Icons.system_update_rounded,
          title: l10n.checkForUpdate,
          trailing: isChecking
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right_rounded),
          onTap: isChecking
              ? null
              : () =>
                  ref.read(updateNotifierProvider.notifier).checkForUpdate(),
        ),
        const _UpdateDownloadTile(),
        SettingsTile(
          icon: Icons.history_rounded,
          title: l10n.rollbackVersion,
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _handleRollback(context, ref),
        ),
        SettingsTile(
          icon: Icons.restore_rounded,
          title: l10n.reset,
          destructive: true,
          onTap: () {
            ref.read(settingsNotifierProvider.notifier).resetToDefaults();
          },
        ),
      ],
    );
  }

  Future<void> _handleRollback(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.checkForUpdate)),
      );

      final versions = await ref
          .read(updateNotifierProvider.notifier)
          .fetchHistoryVersions();

      if (!context.mounted) return;

      final appInfo = ref.read(appInfoProvider).valueOrNull;
      final currentVersion = appInfo?.version ?? '';

      final selectedVersion = await VersionPickerDialog.show(
        context,
        versions: versions,
        currentVersion: currentVersion,
      );

      if (selectedVersion == null || !context.mounted) return;

      final entry = versions.firstWhere((v) => v.version == selectedVersion);
      final availableChannels = <DownloadChannel>{};
      final platformKey = _currentPlatformKey();
      final platformAssets = entry.assets[platformKey];
      if (platformAssets != null) {
        if (platformAssets.github != null) {
          availableChannels.add(DownloadChannel.github);
        }
        if (platformAssets.lanzou != null) {
          availableChannels.add(DownloadChannel.lanzou);
        }
      }
      if (availableChannels.isEmpty) {
        availableChannels.add(DownloadChannel.github);
      }

      final channel = await ChannelPickerSheet.show(
        context,
        availableChannels: availableChannels,
      );

      if (channel == null) return;

      ref
          .read(updateNotifierProvider.notifier)
          .downloadHistoryVersion(selectedVersion, channel);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String _currentPlatformKey() {
    if (PlatformUtils.isAndroid) return 'android';
    if (PlatformUtils.isWindows) return 'windows';
    if (PlatformUtils.isLinux) return 'linux';
    if (PlatformUtils.isMacOS) return 'macos';
    return 'android';
  }

  void _showFollowUsDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.followUs),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('GitHub'),
              subtitle: const Text('GlowLED/BuSic'),
              onTap: () {
                launchUrl(
                  Uri.parse('https://github.com/GlowLED/BuSic'),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).closeButtonLabel),
          ),
        ],
      ),
    );
  }
}

class _UpdateDownloadTile extends ConsumerWidget {
  const _UpdateDownloadTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(updateNotifierProvider);
    final l10n = context.l10n;

    return state.when(
      idle: () => _buildIdleOrAvailable(context, ref, null),
      checking: () => SettingsTile(
        icon: Icons.sync_rounded,
        title: l10n.checkForUpdate,
        trailing: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      available: (info) => _buildIdleOrAvailable(context, ref, info),
      downloading: (info, progress, speed, channel, downloadedBytes,
              totalBytes) =>
          _buildDownloading(context, ref, progress, speed, info.isForceUpdate),
      paused:
          (info, progress, channel, downloadedBytes, totalBytes, localPath) =>
              _buildPaused(context, ref, progress),
      readyToInstall: (info, localPath) => SettingsTile(
        icon: Icons.check_circle_rounded,
        title: l10n.downloadCompleteReady,
        subtitle: 'v${info.latestVersion.semver}',
        trailing: FilledButton(
          onPressed: () =>
              ref.read(updateNotifierProvider.notifier).applyUpdate(),
          child: Text(l10n.installUpdate),
        ),
      ),
      error: (message) {
        if (message.startsWith('INSTALL_READ_ONLY:')) {
          final url = message.substring('INSTALL_READ_ONLY:'.length);
          return SettingsTile(
            icon: Icons.error_outline_rounded,
            title: l10n.updateError,
            subtitle: l10n.linuxReadOnlyInstallDir,
            trailing: FilledButton(
              onPressed: () => launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              ),
              child: Text(l10n.openDownloadPage),
            ),
          );
        }
        return SettingsTile(
          icon: Icons.error_outline_rounded,
          title: l10n.updateError,
          subtitle: message,
          trailing: TextButton(
            onPressed: () =>
                ref.read(updateNotifierProvider.notifier).checkForUpdate(),
            child: Text(l10n.retryDownload),
          ),
        );
      },
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

    return SettingsTile(
      icon: Icons.download_rounded,
      title: title,
      subtitle: info != null ? l10n.selectDownloadChannel : null,
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () async {
        if (info == null) {
          await ref.read(updateNotifierProvider.notifier).checkForUpdate();
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
          ref.read(updateNotifierProvider.notifier).startDownloadWithChannel(
                channel,
              );
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

    return SettingsTile(
      icon: Icons.downloading_rounded,
      title: l10n.downloading,
      subtitle: '${l10n.tapToPause} · ${l10n.longPressToCancel}',
      body: Column(
        children: [
          LinearProgressIndicator(value: progress),
          SizedBox(height: context.appSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: context.textTheme.bodySmall,
              ),
              Text(
                _formatSpeed(speed),
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
      onTap: () => ref.read(updateNotifierProvider.notifier).pauseDownload(),
      onLongPress: () => _showCancelConfirm(context, ref, isForceUpdate),
    );
  }

  Widget _buildPaused(
    BuildContext context,
    WidgetRef ref,
    double progress,
  ) {
    final l10n = context.l10n;

    return SettingsTile(
      icon: Icons.pause_circle_outline_rounded,
      title: l10n.downloadPaused,
      subtitle: '${l10n.tapToResume} · ${l10n.longPressToCancel}',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: 0.5,
            child: LinearProgressIndicator(value: progress),
          ),
          SizedBox(height: context.appSpacing.xs),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
      onTap: () => ref.read(updateNotifierProvider.notifier).resumeDownload(),
      onLongPress: () => _showCancelConfirm(context, ref, false),
    );
  }

  void _showCancelConfirm(
    BuildContext context,
    WidgetRef ref,
    bool isForceUpdate,
  ) {
    if (isForceUpdate) return;

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
