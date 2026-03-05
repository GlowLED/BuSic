import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/settings_notifier.dart';
import 'section_header.dart';

/// Pick a directory using zenity (Linux) or text input fallback.
Future<String?> pickDirectory({
  String? title,
  String? initialDirectory,
}) async {
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

/// Storage section: cache path selector.
class StorageSection extends ConsumerWidget {
  const StorageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.cachePath),
        _CachePathTile(settings: settings, ref: ref),
      ],
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
    var result = await pickDirectory(
      title: '选择缓存目录',
      initialDirectory: _displayPath,
    );

    if (result == null && context.mounted) {
      bool zenityAvailable = false;
      if (Platform.isLinux) {
        try {
          final which = await Process.run('which', ['zenity']);
          zenityAvailable = which.exitCode == 0;
        } catch (_) {}
      }

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
