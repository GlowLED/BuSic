import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/common_dialogs.dart';
import '../../../shared/widgets/song_tile.dart';
import '../../auth/application/auth_notifier.dart';
import '../../download/application/download_notifier.dart';
import '../../download/presentation/widgets/quality_select_dialog.dart';
import '../../player/application/player_notifier.dart';
import '../../player/domain/models/audio_track.dart';
import '../../player/domain/models/play_mode.dart';
import '../../share/application/share_notifier.dart';
import '../../share/presentation/widgets/share_dialog.dart';
import '../application/playlist_notifier.dart';
import '../domain/models/song_item.dart';
import 'widgets/metadata_edit_dialog.dart';

/// Editing mode for the playlist detail screen.
enum _EditMode {
  /// Normal browsing mode.
  none,
  /// Reorder mode — drag handle visible, drag to reorder.
  reorder,
  /// Batch selection mode — checkboxes visible, batch actions available.
  batchSelect,
}

/// Screen displaying songs within a specific playlist.
///
/// Features:
/// - Playlist header with name, cover, song count
/// - Scrollable list of songs (using SongTile)
/// - Toggle reorder mode (drag handle appears)
/// - Long press to enter batch selection mode
/// - "Play all" / "Shuffle" buttons
/// - Context menu per song: edit metadata, remove, add to queue
class PlaylistDetailScreen extends ConsumerStatefulWidget {
  /// The playlist database ID.
  final int playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  ConsumerState<PlaylistDetailScreen> createState() =>
      _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends ConsumerState<PlaylistDetailScreen> {
  int get playlistId => widget.playlistId;

  _EditMode _editMode = _EditMode.none;
  final Set<int> _selectedSongIds = {};

  void _toggleEditMode(_EditMode mode) {
    setState(() {
      if (_editMode == mode) {
        _editMode = _EditMode.none;
        _selectedSongIds.clear();
      } else {
        _editMode = mode;
        _selectedSongIds.clear();
      }
    });
  }

  void _exitEditMode() {
    setState(() {
      _editMode = _EditMode.none;
      _selectedSongIds.clear();
    });
  }

  void _toggleSongSelection(int songId) {
    setState(() {
      if (_selectedSongIds.contains(songId)) {
        _selectedSongIds.remove(songId);
        if (_selectedSongIds.isEmpty) {
          _editMode = _EditMode.none;
        }
      } else {
        _selectedSongIds.add(songId);
      }
    });
  }

  void _selectAll(List<SongItem> songs) {
    setState(() {
      _selectedSongIds.addAll(songs.map((s) => s.id));
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedSongIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final songsAsync = ref.watch(playlistDetailNotifierProvider(playlistId));
    final playlistAsync = ref.watch(playlistListNotifierProvider);
    final l10n = context.l10n;

    // Find playlist info from the list
    final playlistName = playlistAsync.whenOrNull(
      data: (playlists) {
        final match = playlists.where((p) => p.id == playlistId);
        return match.isNotEmpty ? match.first.name : null;
      },
    );

    return Scaffold(
      body: songsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (songs) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 160,
                leading: _editMode != _EditMode.none
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _exitEditMode,
                      )
                    : IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.go('/'),
                      ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    _editMode == _EditMode.batchSelect
                        ? '已选 ${_selectedSongIds.length} 首'
                        : _editMode == _EditMode.reorder
                            ? '排序模式'
                            : playlistName ?? 'Playlist',
                    style: context.textTheme.titleMedium,
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.colorScheme.primaryContainer,
                          context.colorScheme.surface,
                        ],
                      ),
                    ),
                  ),
                ),
                actions: _buildActions(context, songs, playlistName, l10n),
              ),
              // Batch action bar
              if (_editMode == _EditMode.batchSelect && _selectedSongIds.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildBatchActionBar(context, songs),
                ),
              if (songs.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      l10n.noSongs,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else if (_editMode == _EditMode.reorder)
                SliverReorderableList(
                  itemCount: songs.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    ref
                        .read(playlistDetailNotifierProvider(playlistId)
                            .notifier)
                        .reorderSongs(oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ReorderableDragStartListener(
                      key: ValueKey(song.id),
                      index: index,
                      child: ListTile(
                        leading: const Icon(Icons.drag_handle),
                        title: Text(
                          song.displayTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          song.displayArtist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final song = songs[index];
                      final playerState = ref.watch(playerNotifierProvider);
                      final isCurrentSong =
                          playerState.currentTrack?.songId == song.id;
                      final isSelected = _selectedSongIds.contains(song.id);
                      return _editMode == _EditMode.batchSelect
                          ? CheckboxListTile(
                              value: isSelected,
                              onChanged: (_) => _toggleSongSelection(song.id),
                              title: Text(
                                song.displayTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                song.displayArtist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              secondary: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: song.coverUrl != null
                                      ? Image.network(
                                          song.coverUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            color: context.colorScheme
                                                .surfaceContainerHighest,
                                            child: const Icon(
                                                Icons.music_note, size: 24),
                                          ),
                                        )
                                      : Container(
                                          color: context.colorScheme
                                              .surfaceContainerHighest,
                                          child: const Icon(
                                              Icons.music_note, size: 24),
                                        ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onLongPress: () {
                                // Enter batch select mode on long press
                                setState(() {
                                  _editMode = _EditMode.batchSelect;
                                  _selectedSongIds.add(song.id);
                                });
                              },
                              child: SongTile(
                                title: song.displayTitle,
                                artist: song.displayArtist,
                                coverUrl: song.coverUrl,
                                duration: Formatters.formatDuration(
                                    Duration(seconds: song.duration)),
                                isPlaying:
                                    isCurrentSong && playerState.isPlaying,
                                isCached: song.isCached,
                                qualityLabel:
                                    song.isCached ? song.qualityLabel : null,
                                onTap: () {
                                  if (isCurrentSong &&
                                      playerState.isPlaying) {
                                    ref
                                        .read(
                                            playerNotifierProvider.notifier)
                                        .pause();
                                  } else if (isCurrentSong) {
                                    ref
                                        .read(
                                            playerNotifierProvider.notifier)
                                        .resume();
                                  } else {
                                    _playSong(
                                        ref, song, songs, playlistName);
                                  }
                                },
                                onMorePressed: () {
                                  _showSongMenu(context, ref, song);
                                },
                              ),
                            );
                    },
                    childCount: songs.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, List<SongItem> songs,
      String? playlistName, dynamic l10n) {
    if (_editMode == _EditMode.batchSelect) {
      final allSelected = _selectedSongIds.length == songs.length;
      return [
        IconButton(
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          tooltip: allSelected ? '取消全选' : '全选',
          onPressed: () {
            if (allSelected) {
              _deselectAll();
            } else {
              _selectAll(songs);
            }
          },
        ),
      ];
    }
    if (_editMode == _EditMode.reorder) {
      return [
        IconButton(
          icon: const Icon(Icons.done),
          tooltip: '完成排序',
          onPressed: _exitEditMode,
        ),
      ];
    }
    return [
      if (songs.isNotEmpty) ...[
        IconButton(
          icon: const Icon(Icons.play_arrow),
          tooltip: l10n.play,
          onPressed: () => _playAll(ref, songs, playlistName),
        ),
        IconButton(
          icon: const Icon(Icons.shuffle),
          tooltip: l10n.shuffle,
          onPressed: () => _shufflePlay(ref, songs, playlistName),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: l10n.sharePlaylist,
          onPressed: () => _showShareDialog(context, ref),
        ),
        PopupMenuButton<_EditMode>(
          icon: const Icon(Icons.more_vert),
          tooltip: '更多',
          onSelected: _toggleEditMode,
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: _EditMode.reorder,
              child: ListTile(
                leading: Icon(Icons.swap_vert),
                title: Text('排序'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: _EditMode.batchSelect,
              child: ListTile(
                leading: Icon(Icons.checklist),
                title: Text('批量操作'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    ];
  }

  Widget _buildBatchActionBar(BuildContext context, List<SongItem> songs) {
    final colorScheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Text(
            '已选 ${_selectedSongIds.length} 首',
            style: context.textTheme.bodyMedium,
          ),
          const Spacer(),
          TextButton.icon(
            icon: const Icon(Icons.playlist_add, size: 18),
            label: const Text('加入歌单'),
            onPressed: () async {
              final targetPlaylistId = await showDialog<int>(
                context: context,
                builder: (_) => _PlaylistPickerDialog(excludePlaylistId: playlistId),
              );
              if (targetPlaylistId == null || !context.mounted) return;
              final selectedSongIds = _selectedSongIds.toList();
              final notifier = ref.read(
                  playlistDetailNotifierProvider(targetPlaylistId).notifier);
              for (final songId in selectedSongIds) {
                await notifier.addSong(songId);
              }
              if (context.mounted) {
                context.showSnackBar('已添加 ${selectedSongIds.length} 首歌曲到歌单');
              }
              _exitEditMode();
            },
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            icon: Icon(Icons.delete_outline, size: 18, color: colorScheme.error),
            label: Text('删除', style: TextStyle(color: colorScheme.error)),
            onPressed: () async {
              final count = _selectedSongIds.length;
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('确认删除'),
                  content: Text('确定从歌单中移除 $count 首歌曲？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text('删除',
                          style: TextStyle(color: colorScheme.error)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                for (final songId in _selectedSongIds.toList()) {
                  await ref
                      .read(playlistDetailNotifierProvider(playlistId).notifier)
                      .removeSong(songId);
                }
                if (context.mounted) {
                  context.showSnackBar('已移除 $count 首歌曲');
                }
                _exitEditMode();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showSongMenu(
    BuildContext context,
    WidgetRef ref,
    SongItem song,
  ) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.editMetadata),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder: (_) => MetadataEditDialog(
                    song: song,
                    playlistId: playlistId,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: Text(l10n.removeFromPlaylist),
              onTap: () {
                Navigator.pop(ctx);
                ref
                    .read(playlistDetailNotifierProvider(playlistId).notifier)
                    .removeSong(song.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.queue_music),
              title: Text(l10n.addToPlaylist),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(playerNotifierProvider.notifier).addToQueue(
                  _songToTrack(song),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('已添加到播放队列'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                song.isCached ? Icons.download_done : Icons.download,
              ),
              title: Text(song.isCached
                  ? '${l10n.cached} (${song.qualityLabel})'
                  : l10n.downloadSong),
              onTap: song.isCached
                  ? null
                  : () {
                      Navigator.pop(ctx);
                      _showQualityDialog(context, ref, song);
                    },
            ),
          ],
        ),
      ),
    );
  }

  /// Show quality selection dialog and start download.
  void _showQualityDialog(
    BuildContext context,
    WidgetRef ref,
    SongItem song,
  ) async {
    final l10n = context.l10n;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final qualities = await ref
          .read(downloadNotifierProvider.notifier)
          .getAvailableQualities(bvid: song.bvid, cid: song.cid);

      if (qualities.isEmpty) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.noQualities),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
          ),
        );
        return;
      }

      if (!context.mounted) return;

      final isLoggedIn = ref.read(authNotifierProvider).value != null;

      showDialog(
        context: context,
        builder: (_) => QualitySelectDialog(
          qualities: qualities,
          isLoggedIn: isLoggedIn,
          onSelect: (selected) async {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(l10n.downloadStarted),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
              ),
            );
            await ref
                .read(downloadNotifierProvider.notifier)
                .downloadSongWithQuality(
                  songId: song.id,
                  bvid: song.bvid,
                  cid: song.cid,
                  quality: selected.quality,
                  title: song.displayTitle,
                );
          },
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('获取音质列表失败: $e\n$stackTrace');
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('获取音质列表失败: $e'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
    }
  }

  /// Play all songs sequentially from the first track.
  void _playAll(WidgetRef ref, List<SongItem> songs, String? playlistName) {
    if (songs.isEmpty) return;
    ref.read(playerNotifierProvider.notifier).setMode(PlayMode.sequential);
    ref.read(playerNotifierProvider.notifier).playSongFromPlaylist(
      song: songs.first,
      songs: songs,
      playlistId: playlistId,
      playlistName: playlistName,
    );
  }

  /// Shuffle play all songs.
  void _shufflePlay(WidgetRef ref, List<SongItem> songs, String? playlistName) {
    if (songs.isEmpty) return;
    final shuffled = List<SongItem>.from(songs)..shuffle();
    ref.read(playerNotifierProvider.notifier).setMode(PlayMode.shuffle);
    ref.read(playerNotifierProvider.notifier).playSongFromPlaylist(
      song: shuffled.first,
      songs: shuffled,
      playlistId: playlistId,
      playlistName: playlistName,
    );
  }

  /// Play a specific song within the playlist context.
  void _playSong(WidgetRef ref, SongItem song, List<SongItem> songs, String? playlistName) {
    ref.read(playerNotifierProvider.notifier).playSongFromPlaylist(
      song: song,
      songs: songs,
      playlistId: playlistId,
      playlistName: playlistName,
    );
  }

  /// 显示分享方式选择弹窗
  void _showShareDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => ShareDialog(
        onSelected: (method) {
          if (method == ShareMethod.clipboard) {
            _exportToClipboard(context, ref);
          }
        },
      ),
    );
  }

  /// 导出歌单到剪贴板
  void _exportToClipboard(BuildContext context, WidgetRef ref) async {
    await ref.read(shareNotifierProvider.notifier).exportToClipboard(playlistId);
    final state = ref.read(shareNotifierProvider);
    if (context.mounted) {
      state.when(
        idle: () {},
        exporting: () {},
        exported: (_) => context.showSnackBar(context.l10n.copiedToClipboard),
        importing: (_, __) {},
        preview: (_) {},
        importSuccess: (_) {},
        error: (msg) => context.showSnackBar(msg),
      );
    }
  }

  /// Convert a SongItem to an AudioTrack (without stream URL — for queue only).
  AudioTrack _songToTrack(SongItem song) {
    return AudioTrack(
      songId: song.id,
      bvid: song.bvid,
      cid: song.cid,
      title: song.displayTitle,
      artist: song.displayArtist,
      coverUrl: song.coverUrl,
      duration: Duration(seconds: song.duration),
      localPath: song.localPath,
    );
  }
}

/// Dialog for selecting a target playlist (excludes the current one).
class _PlaylistPickerDialog extends ConsumerWidget {
  final int excludePlaylistId;
  const _PlaylistPickerDialog({required this.excludePlaylistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistListNotifierProvider);
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return AlertDialog(
      title: Text(l10n.addToPlaylist),
      content: SizedBox(
        width: 320,
        height: 400,
        child: playlistsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (playlists) {
            final filtered =
                playlists.where((p) => p.id != excludePlaylistId).toList();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.add_circle_outline,
                      color: colorScheme.primary),
                  title: Text(l10n.createPlaylist),
                  onTap: () => _createAndSelect(context, ref, l10n),
                ),
                const Divider(),
                if (filtered.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(l10n.noPlaylists,
                          style: TextStyle(
                              color: colorScheme.onSurfaceVariant)),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final playlist = filtered[index];
                        return ListTile(
                          leading: const Icon(Icons.library_music),
                          title: Text(playlist.name),
                          subtitle: Text('${playlist.songCount} 首歌曲'),
                          onTap: () =>
                              Navigator.of(context).pop(playlist.id),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  Future<void> _createAndSelect(
      BuildContext context, WidgetRef ref, dynamic l10n) async {
    final name = await CommonDialogs.showInputDialog(
      context,
      title: l10n.createPlaylist,
      hint: l10n.title,
    );
    if (name != null && name.trim().isNotEmpty && context.mounted) {
      final playlist = await ref
          .read(playlistListNotifierProvider.notifier)
          .createPlaylist(name.trim());
      if (context.mounted) {
        Navigator.of(context).pop(playlist.id);
      }
    }
  }
}
