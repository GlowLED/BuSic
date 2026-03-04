import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../../shared/extensions/context_extensions.dart';
import '../../auth/application/auth_notifier.dart';
import '../../share/application/sync_notifier.dart';
import '../../share/presentation/widgets/backup_overview_dialog.dart';
import '../application/settings_notifier.dart';

/// Pick a directory using zenity (Linux) or text input fallback.
Future<String?> _pickDirectory({
  String? title,
  String? initialDirectory,
}) async {
  // Try zenity on Linux
  if (Platform.isLinux) {
    try {
      final result = await Process.run('zenity', [
        '--file-selection',
        '--directory',
        if (title != null) '--title=$title',
        if (initialDirectory != null) '--filename=$initialDirectory/',
      ]);
      if (result.exitCode == 0) {
        final path = (result.stdout as String).trim();
        if (path.isNotEmpty) return path;
      }
    } catch (_) {
      // zenity not available, fall through
    }
  }
  return null;
}

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
            subtitle: SegmentedButton<ThemeMode>(
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
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('配色方案'),
            subtitle: Wrap(
              spacing: 8,
              children: [
                for (final entry in const {
                  0xFF4CAF50: '绿色',
                  0xFFE91E63: '粉色',
                  0xFF9C27B0: '紫色',
                  0xFFFBC02D: '黄色',
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

          const Divider(),

          // ── Storage ──
          _SectionHeader(title: l10n.cachePath),
          _CachePathTile(settings: settings, ref: ref),

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
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.go('/login');
                },
              );
            },
          ),

          const Divider(),

          // ── Data Management ──
          _SectionHeader(title: l10n.dataManagement),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(l10n.exportBackup),
            subtitle: Text(l10n.exportBackupDesc),
            onTap: () => _exportBackup(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: Text(l10n.importBackup),
            subtitle: Text(l10n.importBackupDesc),
            onTap: () => _importBackup(context, ref),
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

  /// 导出数据备份
  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final notifier = ref.read(syncNotifierProvider.notifier);
    await notifier.exportToFile();
    final state = ref.read(syncNotifierProvider);
    if (context.mounted) {
      state.whenOrNull(
        exportSuccess: (path) => context.showSnackBar(
          l10n.backupExportedTo(path),
        ),
        error: (msg) => context.showSnackBar(msg),
      );
    }
  }

  /// 导入数据备份
  Future<void> _importBackup(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(syncNotifierProvider.notifier);
    final backup = await notifier.parseFromFile();
    if (backup == null) {
      final state = ref.read(syncNotifierProvider);
      if (context.mounted) {
        state.whenOrNull(
          error: (msg) => context.showSnackBar(msg),
        );
      }
      return;
    }

    if (!context.mounted) return;

    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (_) => BackupOverviewDialog(
        backup: backup,
        onConfirm: (isMerge) async {
          if (isMerge) {
            await notifier.importMerge(backup);
          } else {
            await notifier.importOverwrite(backup);
          }
          final importState = ref.read(syncNotifierProvider);
          if (context.mounted) {
            importState.whenOrNull(
              importSuccess: (result) {
                context.showSnackBar(
                  l10n.backupImportResult(
                    result.playlistsCreated,
                    result.playlistsMerged,
                    result.songsCreated,
                  ),
                );
              },
              error: (msg) => context.showSnackBar(msg),
            );
          }
        },
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

/// Tile showing the cache/download path with ability to edit it.
class _CachePathTile extends StatefulWidget {
  final dynamic settings;
  final WidgetRef ref;

  const _CachePathTile({required this.settings, required this.ref});

  @override
  State<_CachePathTile> createState() => _CachePathTileState();
}

class _CachePathTileState extends State<_CachePathTile> {
  String? _defaultPath;

  @override
  void initState() {
    super.initState();
    _resolveDefaultPath();
  }

  Future<void> _resolveDefaultPath() async {
    final dir = await getApplicationDocumentsDirectory();
    if (mounted) {
      setState(() {
        _defaultPath = '${dir.path}/busic/downloads';
      });
    }
  }

  String get _displayPath =>
      widget.settings.cachePath ?? _defaultPath ?? '...';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      leading: const Icon(Icons.folder),
      title: Text(l10n.cachePath),
      subtitle: Text(
        _displayPath,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.folder_open, size: 20),
            tooltip: '选择目录',
            onPressed: () => _selectDirectory(context),
          ),
          if (widget.settings.cachePath != null)
            IconButton(
              icon: const Icon(Icons.restore, size: 20),
              tooltip: l10n.reset,
              onPressed: () {
                widget.ref
                    .read(settingsNotifierProvider.notifier)
                    .setCachePath(null);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _selectDirectory(BuildContext context) async {
    // Try native directory picker first
    var result = await _pickDirectory(
      title: '选择缓存目录',
      initialDirectory: _displayPath,
    );

    // If zenity is not available, fall back to text input dialog
    if (result == null && context.mounted) {
      bool zenityAvailable = false;
      if (Platform.isLinux) {
        try {
          final which = await Process.run('which', ['zenity']);
          zenityAvailable = which.exitCode == 0;
        } catch (_) {}
      }

      // Only show text input if zenity is not available
      // (if zenity IS available, result==null means user cancelled)
      if (!zenityAvailable && context.mounted) {
        final controller = TextEditingController(text: _displayPath);
        result = await showDialog<String>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('输入缓存路径'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '/home/user/Music',
              ),
              onSubmitted: (v) => Navigator.of(ctx).pop(v),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: Text(context.l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(controller.text),
                child: Text(context.l10n.confirm),
              ),
            ],
          ),
        );
      }
    }

    if (result == null || result.trim().isEmpty) return;
    result = result.trim();

    // Validate directory exists or can be created
    final dir = Directory(result);
    if (!await dir.exists()) {
      try {
        await dir.create(recursive: true);
      } catch (e) {
        if (context.mounted) {
          context.showSnackBar('无法创建目录: $e');
        }
        return;
      }
    }
    widget.ref
        .read(settingsNotifierProvider.notifier)
        .setCachePath(result);
  }
}
