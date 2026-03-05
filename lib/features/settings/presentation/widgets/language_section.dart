import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/settings_notifier.dart';
import 'section_header.dart';

/// Language settings section.
class LanguageSection extends ConsumerWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.language),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l10n.language),
          trailing: DropdownButton<String?>(
            value: settings.locale,
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.system)),
              const DropdownMenuItem(value: 'en', child: Text('English')),
              const DropdownMenuItem(value: 'zh', child: Text('中文')),
            ],
            onChanged: (locale) {
              ref.read(settingsNotifierProvider.notifier).setLocale(locale);
            },
          ),
        ),
      ],
    );
  }
}
