import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/settings_notifier.dart';
import 'section_header.dart';

/// Playback quality settings section.
class PlaybackSection extends ConsumerWidget {
  const PlaybackSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.preferredQuality),
        ListTile(
          leading: const Icon(Icons.high_quality),
          title: Text(l10n.preferredQuality),
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
      ],
    );
  }
}
