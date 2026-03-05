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
import '../../../app_update/presentation/widgets/download_tile.dart';
import '../../../app_update/presentation/widgets/update_dialog.dart';
import '../../../app_update/presentation/widgets/version_picker_dialog.dart';
import '../../application/settings_notifier.dart';

/// About section: version info, follow us, check for update, download, rollback, reset.
class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Version info
        Consumer(
          builder: (context, ref, _) {
            final info = ref.watch(appInfoProvider).valueOrNull;
            final versionDisplay =
                info != null ? 'v${info.version}+${info.buildNumber}' : '';
            return ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.about),
              subtitle: Text('BuSic $versionDisplay'),
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

        // Follow us
        ListTile(
          leading: const Icon(Icons.people_outline),
          title: Text(l10n.followUs),
          subtitle: Text(l10n.followUsDesc),
          onTap: () => _showFollowUsDialog(context),
        ),

        // Check for update
        Consumer(
          builder: (context, ref, _) {
            final updateState = ref.watch(updateNotifierProvider);
            final isChecking = updateState is UpdateStateChecking;

            ref.listen<UpdateState>(updateNotifierProvider, (prev, next) {
              if (next is UpdateStateAvailable && next.info.isForceUpdate) {
                UpdateDialog.show(context);
              } else if (next is UpdateStateIdle &&
                  prev is UpdateStateChecking) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.upToDate)),
                );
              } else if (next is UpdateStateError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(next.message)),
                );
              }
            });

            return ListTile(
              leading: isChecking
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.system_update),
              title: Text(l10n.checkForUpdate),
              onTap: isChecking
                  ? null
                  : () => ref
                      .read(updateNotifierProvider.notifier)
                      .checkForUpdate(),
            );
          },
        ),

        const Divider(),

        // Download tile (inline progress)
        const DownloadTile(),

        // Rollback to previous version
        ListTile(
          leading: const Icon(Icons.history),
          title: Text(l10n.rollbackVersion),
          onTap: () => _handleRollback(context, ref),
        ),

        const Divider(),

        // Reset
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            icon: const Icon(Icons.restore),
            label: Text(l10n.reset),
            onPressed: () {
              ref.read(settingsNotifierProvider.notifier).resetToDefaults();
            },
          ),
        ),
      ],
    );
  }

  Future<void> _handleRollback(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;

    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.checkForUpdate)),
      );

      final versions = await ref
          .read(updateNotifierProvider.notifier)
          .fetchHistoryVersions();

      if (!context.mounted) return;

      // Get current version
      final appInfo = ref.read(appInfoProvider).valueOrNull;
      final currentVersion = appInfo?.version ?? '';

      final selectedVersion = await VersionPickerDialog.show(
        context,
        versions: versions,
        currentVersion: currentVersion,
      );

      if (selectedVersion == null || !context.mounted) return;

      // Find the selected version entry to get available channels
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
            child:
                Text(MaterialLocalizations.of(context).closeButtonLabel),
          ),
        ],
      ),
    );
  }
}
