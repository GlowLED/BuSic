import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/context_extensions.dart';
import 'widgets/about_section.dart';
import 'widgets/account_section.dart';
import 'widgets/appearance_section.dart';
import 'widgets/data_management_section.dart';
import 'widgets/language_section.dart';
import 'widgets/playback_section.dart';
import 'widgets/storage_section.dart';

/// Settings screen with app configuration options.
///
/// Composed of independent section widgets for appearance, language,
/// playback, storage, account, data management, and about.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.xl,
          ),
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: palette.accentSoft.withValues(alpha: 0.72),
                    borderRadius: context.appRadii.largeRadius,
                    boxShadow: context.appDepth.coverGlowShadow,
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: palette.accentStrong,
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.settings,
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                      SizedBox(height: spacing.xxs),
                      Text(
                        context.l10n.settingsPageSubtitle,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.lg),
            const AppearanceSection(),
            SizedBox(height: spacing.md),
            const LanguageSection(),
            SizedBox(height: spacing.md),
            const PlaybackSection(),
            SizedBox(height: spacing.md),
            const StorageSection(),
            SizedBox(height: spacing.md),
            const AccountSection(),
            SizedBox(height: spacing.md),
            const DataManagementSection(),
            SizedBox(height: spacing.md),
            const AboutSection(),
          ],
        ),
      ),
    );
  }
}
