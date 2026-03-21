import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../playlist/application/playlist_notifier.dart';
import '../../application/settings_notifier.dart';
import 'section_header.dart';

/// 极简模式设置区域。
///
/// 提供开关切换极简模式，以及从本地歌单列表中选择指定歌单。
class MinimalModeSection extends ConsumerStatefulWidget {
  const MinimalModeSection({super.key});

  @override
  ConsumerState<MinimalModeSection> createState() => _MinimalModeSectionState();
}

class _MinimalModeSectionState extends ConsumerState<MinimalModeSection> {
  bool _isMinimalMode = false;
  int? _selectedPlaylistId;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final isMinimal = await notifier.getMinimalMode();
    final playlistId = await notifier.getMinimalPlaylistId();
    if (!mounted) return;
    setState(() {
      _isMinimalMode = isMinimal;
      _selectedPlaylistId = playlistId;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();

    // 复用已有的 PlaylistListNotifier 获取本地歌单列表
    final playlistsAsync = ref.watch(playlistListNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '极简模式'),
        SwitchListTile(
          secondary: const Icon(Icons.music_note),
          title: const Text('极简模式'),
          subtitle: const Text('启动后直接随机播放一首歌'),
          value: _isMinimalMode,
          onChanged: (value) async {
            setState(() => _isMinimalMode = value);
            await ref
                .read(settingsNotifierProvider.notifier)
                .setMinimalMode(value);
          },
        ),
        ListTile(
          leading: const Icon(Icons.playlist_play),
          title: const Text('指定播放歌单'),
          subtitle: playlistsAsync.when(
            data: (playlists) {
              if (_selectedPlaylistId != null) {
                final match = playlists
                    .where((p) => p.id == _selectedPlaylistId)
                    .toList();
                if (match.isNotEmpty) {
                  return Text(
                      '当前: ${match.first.name}（${match.first.songCount} 首）');
                }
              }
              return const Text('未设置（将随机搜索音乐）');
            },
            loading: () => const Text('加载中...'),
            error: (_, __) => const Text('加载歌单失败'),
          ),
          trailing: const Icon(Icons.arrow_drop_down),
          onTap: () => _showPlaylistPicker(playlistsAsync),
        ),
      ],
    );
  }

  /// 弹窗选择本地歌单
  Future<void> _showPlaylistPicker(AsyncValue playlistsAsync) async {
    final playlists = playlistsAsync.valueOrNull;
    if (playlists == null || playlists.isEmpty) return;

    // 构建选项列表："不指定" + 所有本地歌单
    final result = await showDialog<int?>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('选择播放歌单'),
        children: [
          // 清除选择项
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, -1),
            child: const ListTile(
              leading: Icon(Icons.shuffle),
              title: Text('不指定（随机搜索）'),
              dense: true,
            ),
          ),
          const Divider(height: 1),
          // 本地歌单列表
          ...playlists.map((p) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, p.id),
                child: ListTile(
                  leading: const Icon(Icons.queue_music),
                  title: Text(p.name),
                  subtitle: Text('${p.songCount} 首'),
                  trailing: _selectedPlaylistId == p.id
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  dense: true,
                ),
              )),
        ],
      ),
    );

    if (result == null) return; // 用户取消

    final newId = result == -1 ? null : result;
    await ref
        .read(settingsNotifierProvider.notifier)
        .setMinimalPlaylistId(newId);
    if (!mounted) return;
    setState(() => _selectedPlaylistId = newId);
  }
}
