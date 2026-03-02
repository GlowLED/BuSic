import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/context_extensions.dart';
import '../../auth/application/auth_notifier.dart';
import '../application/settings_notifier.dart';

/// Settings screen with app configuration options.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final l10n = context.l10n;

    return Scaffold(
      body: ListView(
        children: [
          // ── Appearance ──
          _SectionHeader(title: l10n.themeMode),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(l10n.themeMode),
            trailing: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.system),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.light),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.dark),
                ),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (modes) {
                ref
                    .read(settingsNotifierProvider.notifier)
                    .setThemeMode(modes.first);
              },
            ),
          ),

          const Divider(),

          // ── Language ──
          _SectionHeader(title: l10n.language),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            trailing: DropdownButton<String?>(
              value: settings.locale,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.system),
                ),
                const DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                const DropdownMenuItem(
                  value: 'zh',
                  child: Text('中文'),
                ),
              ],
              onChanged: (locale) {
                ref
                    .read(settingsNotifierProvider.notifier)
                    .setLocale(locale);
              },
            ),
          ),

          const Divider(),

          // ── Playback ──
          _SectionHeader(title: l10n.preferredQuality),
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
          SwitchListTile(
            secondary: const Icon(Icons.cached),
            title: Text(l10n.autoCache),
            value: settings.autoCache,
            onChanged: (value) {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .setAutoCache(value);
            },
          ),

          const Divider(),

          // ── Storage ──
          _SectionHeader(title: l10n.cachePath),
          ListTile(
            leading: const Icon(Icons.folder),
            title: Text(l10n.cachePath),
            subtitle: Text(settings.cachePath ?? 'Default'),
          ),

          const Divider(),

          // ── Account ──
          authState.when(
            loading: () => const ListTile(
              leading: CircularProgressIndicator(),
              title: Text('...'),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (user) {
              if (user != null) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user.nickname),
                  subtitle: Text('UID: ${user.userId}'),
                  trailing: TextButton(
                    onPressed: () {
                      ref.read(authNotifierProvider.notifier).logout();
                    },
                    child: Text(l10n.logout),
                  ),
                );
              }
              return ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(l10n.login),
                onTap: () {
                  // Navigate to login
                },
              );
            },
          ),

          const Divider(),

          // ── About ──
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            subtitle: const Text('BuSic v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'BuSic',
                applicationVersion: '1.0.0',
                applicationLegalese: 'A cross-platform Bilibili music player.',
              );
            },
          ),

          // ── Reset ──
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
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
