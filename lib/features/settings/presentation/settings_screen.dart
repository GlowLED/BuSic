import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      body: ListView(
        children: const [
          AppearanceSection(),
          Divider(),
          LanguageSection(),
          Divider(),
          PlaybackSection(),
          Divider(),
          StorageSection(),
          Divider(),
          AccountSection(),
          Divider(),
          DataManagementSection(),
          Divider(),
          AboutSection(),
        ],
      ),
    );
  }
}
