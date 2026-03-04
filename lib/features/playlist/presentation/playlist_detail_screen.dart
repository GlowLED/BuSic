import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/extensions/context_extensions.dart';
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

/// Screen displaying songs within a specific playlist.
///
/// Features:
/// - Playlist header with name, cover, song count
/// - Scrollable list of songs (using SongTile)
/// - Drag to reorder
/// - "Play all" / "Shuffle" buttons
/// - Context menu per song: edit metadata, remove, add to queue
class PlaylistDetailScreen extends ConsumerWidget {
  /// The playlist database ID.
  final int playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    playlistName ?? 'Playlist',
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
                actions: [
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
                  ],
                ],
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
              else
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
                    final playerState = ref.watch(playerNotifierProvider);
                    final isCurrentSong = playerState.currentTrack?.songId == song.id;
                    return ReorderableDragStartListener(
                      key: ValueKey(song.id),
                      index: index,
                      child: SongTile(
                        title: song.displayTitle,
                        artist: song.displayArtist,
                        coverUrl: song.coverUrl,
                        duration: Formatters.formatDuration(Duration(seconds: song.duration)),
                        isPlaying: isCurrentSong && playerState.isPlaying,
                        isCached: song.isCached,
                        qualityLabel: song.isCached ? song.qualityLabel : null,
                        onTap: () {
                          if (isCurrentSong && playerState.isPlaying) {
                            ref.read(playerNotifierProvider.notifier).pause();
                          } else if (isCurrentSong) {
                            ref.read(playerNotifierProvider.notifier).resume();
                          } else {
                            _playSong(ref, song, songs, playlistName);
                          }
                        },
                        onMorePressed: () {
                          _showSongMenu(context, ref, song);
                        },
                      ),
                    );
                  },
                ),
            ],
          );
        },
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
