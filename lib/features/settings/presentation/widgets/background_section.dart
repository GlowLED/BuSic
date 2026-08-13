import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../../core/utils/platform_utils.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../application/settings_notifier.dart';
import 'settings_panel.dart';

/// Background image settings section: pick an app-wide background image
/// and adjust its opacity and blur.
class BackgroundSection extends ConsumerWidget {
  const BackgroundSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final l10n = context.l10n;
    final hasBackground = settings.backgroundImagePath != null &&
        settings.backgroundImagePath!.isNotEmpty;

    return SettingsSectionPanel(
      title: l10n.backgroundSettings,
      icon: Icons.wallpaper_rounded,
      children: [
        SettingsTile(
          icon: Icons.image_outlined,
          title: l10n.backgroundImage,
          subtitle: hasBackground
              ? settings.backgroundImagePath
              : l10n.backgroundImageDescription,
          trailing: hasBackground
              ? IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  tooltip: l10n.removeBackgroundImage,
                  onPressed: () => _removeBackgroundImage(
                    context,
                    ref,
                    settings.backgroundImagePath!,
                  ),
                )
              : null,
          onTap: () => _pickBackgroundImage(context, ref),
        ),
        SettingsTile(
          icon: Icons.opacity_rounded,
          title: l10n.backgroundOpacity,
          enabled: hasBackground,
          trailing: Text(
            '${(settings.backgroundImageOpacity * 100).round()}%',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          body: Slider(
            value: settings.backgroundImageOpacity,
            min: 0,
            max: 1,
            divisions: 20,
            label: '${(settings.backgroundImageOpacity * 100).round()}%',
            onChanged: hasBackground
                ? (value) {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .setBackgroundImageOpacity(value);
                  }
                : null,
          ),
        ),
        SettingsTile(
          icon: Icons.blur_on_rounded,
          title: l10n.backgroundBlur,
          enabled: hasBackground,
          trailing: Text(
            settings.backgroundImageBlur.round().toString(),
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          body: Slider(
            value: settings.backgroundImageBlur,
            min: 0,
            max: 60,
            divisions: 60,
            label: settings.backgroundImageBlur.round().toString(),
            onChanged: hasBackground
                ? (value) {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .setBackgroundImageBlur(value);
                  }
                : null,
          ),
        ),
      ],
    );
  }

  Future<void> _pickBackgroundImage(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final currentPath = ref.read(settingsNotifierProvider).backgroundImagePath;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final sourcePath = result.files.single.path;
    if (sourcePath == null || sourcePath.isEmpty) return;

    try {
      final dataPath = await PlatformUtils.getDataPath();
      final backgroundsDir = Directory(p.join(dataPath, 'backgrounds'));
      await backgroundsDir.create(recursive: true);

      final extension = p.extension(sourcePath);
      final destination = p.join(
        backgroundsDir.path,
        'background_${DateTime.now().millisecondsSinceEpoch}$extension',
      );
      await File(sourcePath).copy(destination);

      await ref
          .read(settingsNotifierProvider.notifier)
          .setBackgroundImagePath(destination);

      // Remove the previous copy (unless it is the same file we just copied).
      if (currentPath != null &&
          currentPath.isNotEmpty &&
          currentPath != destination) {
        _deleteQuietly(currentPath);
      }

      if (context.mounted) {
        context.showSnackBar(l10n.backgroundImageUpdated);
      }
    } catch (_) {
      if (context.mounted) {
        context.showSnackBar(l10n.backgroundImageFailed);
      }
    }
  }

  Future<void> _removeBackgroundImage(
    BuildContext context,
    WidgetRef ref,
    String currentPath,
  ) async {
    final l10n = context.l10n;
    await ref
        .read(settingsNotifierProvider.notifier)
        .setBackgroundImagePath(null);
    _deleteQuietly(currentPath);
    if (context.mounted) {
      context.showSnackBar(l10n.backgroundImageRemoved);
    }
  }

  void _deleteQuietly(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (_) {
      // Removing the copy must not block the settings change.
    }
  }
}
