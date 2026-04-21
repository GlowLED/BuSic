import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/media_cover.dart';
import '../../../shared/widgets/media_row.dart';
import '../../../shared/widgets/song_tile.dart';
import '../../player/application/player_notifier.dart';
import '../../player/domain/models/play_mode.dart';
import '../../share/application/share_notifier.dart';
import '../application/favorite_notifier.dart';
import '../../share/presentation/widgets/share_dialog.dart';
import '../application/playlist_notifier.dart';
import '../domain/models/song_item.dart';
import 'widgets/batch_action_bar.dart';
import 'widgets/cover_selection_dialog.dart';
import 'widgets/download_all_helper.dart';
import 'widgets/song_context_menu.dart';

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
    final favState = ref.watch(favoriteNotifierProvider);
    final l10n = context.l10n;

    // 加载收藏状态
    ref.listen(playlistDetailNotifierProvider(playlistId), (prev, next) {
      next.whenData((songs) {
        if (songs.isNotEmpty) {
          ref
              .read(favoriteNotifierProvider.notifier)
              .loadFavoriteStatus(songs.map((s) => s.id).toList());
        }
      });
    });

    // Find playlist info from the list
    final playlist = playlistAsync.whenOrNull(
      data: (playlists) {
        final match = playlists.where((p) => p.id == playlistId);
        return match.isNotEmpty ? match.first : null;
      },
    );
    final playlistName =
        playlist?.isFavorite == true ? l10n.myFavorites : playlist?.name;

    return Scaffold(
      body: songsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (songs) {
          final playerState = ref.watch(playerNotifierProvider);

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
                        ? l10n.selectedSongCount(
                            _selectedSongIds.length,
                            songs.length,
                          )
                        : _editMode == _EditMode.reorder
                            ? l10n.sortingMode
                            : playlistName ?? l10n.playlists,
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
              if (_editMode == _EditMode.batchSelect &&
                  _selectedSongIds.isNotEmpty)
                SliverToBoxAdapter(
                  child: BatchActionBar(
                    playlistId: playlistId,
                    selectedSongIds: _selectedSongIds,
                    onExitEditMode: _exitEditMode,
                  ),
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
                        .read(
                            playlistDetailNotifierProvider(playlistId).notifier)
                        .reorderSongs(oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    final isCurrentSong =
                        playerState.currentTrack?.songId == song.id &&
                            playerState.isPlaying;

                    return Padding(
                      key: ValueKey(song.id),
                      padding: EdgeInsets.fromLTRB(
                        context.appSpacing.md,
                        index == 0 ? context.appSpacing.md : 0,
                        context.appSpacing.md,
                        context.appSpacing.sm,
                      ),
                      child: _buildReorderSongRow(
                        context: context,
                        song: song,
                        index: index,
                        isCurrentSong: isCurrentSong,
                      ),
                    );
                  },
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final song = songs[index];
                      final isCurrentSong =
                          playerState.currentTrack?.songId == song.id;
                      final isSelected = _selectedSongIds.contains(song.id);
                      return _editMode == _EditMode.batchSelect
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(
                                context.appSpacing.md,
                                index == 0 ? context.appSpacing.md : 0,
                                context.appSpacing.md,
                                context.appSpacing.sm,
                              ),
                              child: _buildBatchSelectSongRow(
                                context: context,
                                song: song,
                                isCurrentSong:
                                    isCurrentSong && playerState.isPlaying,
                                isSelected: isSelected,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.fromLTRB(
                                context.appSpacing.md,
                                index == 0 ? context.appSpacing.md : 0,
                                context.appSpacing.md,
                                context.appSpacing.sm,
                              ),
                              child: SongTile(
                                title: song.displayTitle,
                                artist: song.displayArtist,
                                coverUrl: song.coverUrl,
                                duration: Formatters.formatDuration(
                                  Duration(seconds: song.duration),
                                ),
                                isPlaying:
                                    isCurrentSong && playerState.isPlaying,
                                isCached: song.isCached,
                                qualityLabel:
                                    song.isCached ? song.qualityLabel : null,
                                isFavorited:
                                    favState.value?.contains(song.id) ?? false,
                                onLongPress: () {
                                  setState(() {
                                    _editMode = _EditMode.batchSelect;
                                    _selectedSongIds.add(song.id);
                                  });
                                },
                                onFavoritePressed: () {
                                  ref
                                      .read(
                                        favoriteNotifierProvider.notifier,
                                      )
                                      .toggleFavorite(song.id);
                                },
                                onTap: () {
                                  if (isCurrentSong && playerState.isPlaying) {
                                    ref
                                        .read(
                                          playerNotifierProvider.notifier,
                                        )
                                        .pause();
                                  } else if (isCurrentSong) {
                                    ref
                                        .read(
                                          playerNotifierProvider.notifier,
                                        )
                                        .resume();
                                  } else {
                                    _playSong(
                                      ref,
                                      song,
                                      songs,
                                      playlistName,
                                    );
                                  }
                                },
                                onMorePressed: () {
                                  showSongContextMenu(
                                    context: context,
                                    ref: ref,
                                    song: song,
                                    playlistId: playlistId,
                                  );
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

  Widget _buildReorderSongRow({
    required BuildContext context,
    required SongItem song,
    required int index,
    required bool isCurrentSong,
  }) {
    return MediaRow(
      cover: MediaCover(
        coverUrl: song.coverUrl,
        width: 58,
        height: 58,
      ),
      title: Text(
        song.displayTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.titleSmall,
      ),
      subtitle: Text(
        song.displayArtist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.appPalette.textSecondary,
        ),
      ),
      badges: _buildSongStatusBadges(context, song),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Formatters.formatDuration(Duration(seconds: song.duration)),
            style: context.textTheme.labelMedium?.copyWith(
              color: context.appPalette.textMuted,
            ),
          ),
          SizedBox(width: context.appSpacing.sm),
          ReorderableDragStartListener(
            index: index,
            child: _AccessoryPill(
              icon: Icons.drag_indicator_rounded,
              tooltip: context.l10n.sort,
            ),
          ),
        ],
      ),
      isActive: isCurrentSong,
    );
  }

  Widget _buildBatchSelectSongRow({
    required BuildContext context,
    required SongItem song,
    required bool isCurrentSong,
    required bool isSelected,
  }) {
    return MediaRow(
      cover: MediaCover(
        coverUrl: song.coverUrl,
        width: 58,
        height: 58,
      ),
      title: Text(
        song.displayTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.titleSmall,
      ),
      subtitle: Text(
        song.displayArtist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.appPalette.textSecondary,
        ),
      ),
      badges: _buildSongStatusBadges(context, song),
      leadingAccessory: Checkbox(
        value: isSelected,
        onChanged: (_) => _toggleSongSelection(song.id),
      ),
      trailing: Text(
        Formatters.formatDuration(Duration(seconds: song.duration)),
        style: context.textTheme.labelMedium?.copyWith(
          color: context.appPalette.textMuted,
        ),
      ),
      onTap: () => _toggleSongSelection(song.id),
      isActive: isCurrentSong,
      isSelected: isSelected,
    );
  }

  List<Widget> _buildSongStatusBadges(BuildContext context, SongItem song) {
    if (!song.isCached) return const [];

    final palette = context.appPalette;

    return [
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.appSpacing.xs,
          vertical: context.appSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: palette.successSoft,
          borderRadius: context.appRadii.pillRadius,
          border: Border.all(
            color: palette.success.withValues(alpha: 0.26),
            width: context.appDepth.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download_done_rounded,
              size: 12,
              color: palette.success,
            ),
            SizedBox(width: context.appSpacing.xxs),
            Text(
              song.qualityLabel.isNotEmpty
                  ? song.qualityLabel
                  : context.l10n.cached,
              style: context.textTheme.labelSmall?.copyWith(
                color: palette.success,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildActions(BuildContext context, List<SongItem> songs,
      String? playlistName, dynamic l10n) {
    if (_editMode == _EditMode.batchSelect) {
      final allSelected = _selectedSongIds.length == songs.length;
      return [
        IconButton(
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          tooltip: allSelected ? l10n.deselectAll : l10n.selectAll,
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
          tooltip: l10n.doneSorting,
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
        Consumer(
          builder: (context, ref, _) {
            final playMode = ref.watch(
              playerNotifierProvider.select((s) => s.playMode),
            );
            return IconButton(
              icon: Icon(_playModeIcon(playMode)),
              tooltip: _playModeTooltip(context, playMode),
              onPressed: () {
                const modes = PlayMode.values;
                final next = (playMode.index + 1) % modes.length;
                ref.read(playerNotifierProvider.notifier).setMode(modes[next]);
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: l10n.sharePlaylist,
          onPressed: () => _showShareDialog(context, ref),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          tooltip: l10n.moreActions,
          onSelected: (value) {
            switch (value) {
              case 'reorder':
                _toggleEditMode(_EditMode.reorder);
              case 'batchSelect':
                _toggleEditMode(_EditMode.batchSelect);
              case 'changeCover':
                showDialog(
                  context: context,
                  builder: (_) => CoverSelectionDialog(playlistId: playlistId),
                );
              case 'downloadAll':
                downloadAllUncached(
                  context: context,
                  ref: ref,
                  songs: songs,
                );
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'reorder',
              child: _buildMenuItemContent(
                context,
                icon: Icons.swap_vert,
                label: l10n.sort,
              ),
            ),
            PopupMenuItem(
              value: 'batchSelect',
              child: _buildMenuItemContent(
                context,
                icon: Icons.checklist,
                label: l10n.batchActions,
              ),
            ),
            PopupMenuItem(
              value: 'changeCover',
              child: _buildMenuItemContent(
                context,
                icon: Icons.image_outlined,
                label: l10n.changeCover,
              ),
            ),
            PopupMenuItem(
              value: 'downloadAll',
              child: _buildMenuItemContent(
                context,
                icon: Icons.download,
                label: l10n.downloadAll,
              ),
            ),
          ],
        ),
      ],
    ];
  }

  Widget _buildMenuItemContent(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: context.appPalette.textSecondary,
        ),
        SizedBox(width: context.appSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyMedium,
          ),
        ),
      ],
    );
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

  IconData _playModeIcon(PlayMode mode) {
    switch (mode) {
      case PlayMode.sequential:
        return Icons.arrow_forward;
      case PlayMode.repeatAll:
        return Icons.repeat;
      case PlayMode.repeatOne:
        return Icons.repeat_one;
      case PlayMode.shuffle:
        return Icons.shuffle;
    }
  }

  String _playModeTooltip(BuildContext context, PlayMode mode) {
    final l10n = context.l10n;
    switch (mode) {
      case PlayMode.sequential:
        return l10n.sequential;
      case PlayMode.repeatAll:
        return l10n.repeat;
      case PlayMode.repeatOne:
        return l10n.repeatOne;
      case PlayMode.shuffle:
        return l10n.shuffle;
    }
  }

  /// Play a specific song within the playlist context.
  void _playSong(WidgetRef ref, SongItem song, List<SongItem> songs,
      String? playlistName) {
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
    await ref
        .read(shareNotifierProvider.notifier)
        .exportToClipboard(playlistId);
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
}

class _AccessoryPill extends StatelessWidget {
  const _AccessoryPill({
    required this.icon,
    required this.tooltip,
  });

  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return Tooltip(
      message: tooltip,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: palette.surfaceSecondary.withValues(alpha: 0.9),
          borderRadius: context.appRadii.mediumRadius,
          border: Border.all(
            color: palette.borderSubtle.withValues(alpha: 0.88),
            width: context.appDepth.outline,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: palette.textSecondary,
        ),
      ),
    );
  }
}
