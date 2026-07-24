import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/settings_notifier.dart';
import 'settings_panel.dart';

/// Playback behavior and quality settings section.
class PlaybackSection extends ConsumerWidget {
  const PlaybackSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final l10n = context.l10n;

    return SettingsSectionPanel(
      title: l10n.playbackSettings,
      icon: Icons.graphic_eq_rounded,
      children: [
        SettingsTile(
          icon: Icons.high_quality_rounded,
          title: l10n.preferredQuality,
          trailing: DropdownButton<int>(
            value: settings.preferredQuality,
            underline: const SizedBox.shrink(),
            items: const [
              DropdownMenuItem(value: 0, child: Text('Auto')),
              DropdownMenuItem(value: 30216, child: Text('64kbps')),
              DropdownMenuItem(value: 30232, child: Text('132kbps')),
              DropdownMenuItem(value: 30280, child: Text('192kbps')),
              DropdownMenuItem(value: 30250, child: Text('Dolby')),
              DropdownMenuItem(value: 30251, child: Text('Hi-Res')),
            ],
            onChanged: (quality) {
              if (quality != null) {
                ref
                    .read(settingsNotifierProvider.notifier)
                    .setPreferredQuality(quality);
              }
            },
          ),
        ),
        SettingsTile(
          icon: Icons.multiline_chart_rounded,
          title: l10n.playbackFade,
          subtitle: l10n.playbackFadeDescription,
          trailing: Switch(
            value: settings.playbackFadeEnabled,
            onChanged: (enabled) {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .setPlaybackFadeEnabled(enabled);
            },
          ),
        ),
        SettingsTile(
          icon: Icons.timer_outlined,
          title: l10n.playbackFadeDuration,
          enabled: settings.playbackFadeEnabled,
          trailing: DropdownButton<int>(
            value: settings.playbackFadeDurationMs,
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(value: 500, child: Text(l10n.halfSecond)),
              DropdownMenuItem(value: 1000, child: Text(l10n.oneSecond)),
              DropdownMenuItem(value: 2000, child: Text(l10n.twoSeconds)),
            ],
            onChanged: settings.playbackFadeEnabled
                ? (durationMs) {
                    if (durationMs != null) {
                      ref
                          .read(settingsNotifierProvider.notifier)
                          .setPlaybackFadeDurationMs(durationMs);
                    }
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
