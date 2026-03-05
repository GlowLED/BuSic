import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/settings_notifier.dart';
import 'section_header.dart';

/// Appearance settings section: theme mode and colour scheme.
class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.themeMode),
        ListTile(
          leading: const Icon(Icons.brightness_6),
          title: Text(l10n.themeMode),
          subtitle: SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(value: ThemeMode.system, label: Text(l10n.system)),
              ButtonSegment(value: ThemeMode.light, label: Text(l10n.light)),
              ButtonSegment(value: ThemeMode.dark, label: Text(l10n.dark)),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (modes) {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .setThemeMode(modes.first);
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(l10n.colorScheme),
          subtitle: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final entry in {
                0xFF4CAF50: l10n.colorGreen,
                0xFF2196F3: l10n.colorBlue,
                0xFF009688: l10n.colorTeal,
                0xFFE91E63: l10n.colorPink,
                0xFF9C27B0: l10n.colorPurple,
                0xFF3F51B5: l10n.colorIndigo,
                0xFFFBC02D: l10n.colorYellow,
                0xFFFF9800: l10n.colorOrange,
                0xFFF44336: l10n.colorRed,
                0xFF00BCD4: l10n.colorCyan,
              }.entries)
                ChoiceChip(
                  label: Text(entry.value),
                  selected: settings.themeSeedColor == entry.key,
                  onSelected: (_) {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .setThemeSeedColor(entry.key);
                  },
                  avatar: CircleAvatar(
                    backgroundColor: Color(entry.key),
                    radius: 8,
                  ),
                  selectedColor: Color(entry.key).withValues(alpha: 0.3),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
