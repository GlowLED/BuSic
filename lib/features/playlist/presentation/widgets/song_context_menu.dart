import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../comment/presentation/comment_section.dart';
import '../../../download/application/download_notifier.dart';
import '../../../download/presentation/widgets/quality_select_dialog.dart';
import '../../../player/application/player_notifier.dart';
import '../../../player/domain/models/audio_track.dart';
import '../../application/favorite_notifier.dart';
import '../../application/playlist_notifier.dart';
import '../../domain/models/song_item.dart';
import '../../../auth/application/auth_notifier.dart';
import 'metadata_edit_dialog.dart';

/// Shows a bottom-sheet context menu for a single song in a playlist.
void showSongContextMenu({
  required BuildContext context,
  required WidgetRef ref,
  required SongItem song,
  required int playlistId,
}) {
  final l10n = context.l10n;
  final favState = ref.read(favoriteNotifierProvider);
  final isFav = favState.value?.contains(song.id) ?? false;
  showModalBottomSheet(
    context: context,
    builder: (ctx) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.redAccent : null,
            ),
            title: Text(isFav ? l10n.removeFromFavorites : l10n.addToFavorites),
            onTap: () {
              Navigator.pop(ctx);
              ref
                  .read(favoriteNotifierProvider.notifier)
                  .toggleFavorite(song.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(l10n.editMetadata),
            onTap: () {
              Navigator.pop(ctx);
              showDialog(
                context: context,
                builder: (_) =>
                    MetadataEditDialog(song: song, playlistId: playlistId),
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
              ref
                  .read(playerNotifierProvider.notifier)
                  .addToQueue(
                    AudioTrack(
                      songId: song.id,
                      bvid: song.bvid,
                      cid: song.cid,
                      title: song.displayTitle,
                      artist: song.displayArtist,
                      coverUrl: song.coverUrl,
                      duration: Duration(seconds: song.duration),
                      localPath: song.localPath,
                    ),
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
            leading: Icon(song.isCached ? Icons.download_done : Icons.download),
            title: Text(
              song.isCached
                  ? '${l10n.cached} (${song.qualityLabel})'
                  : l10n.downloadSong,
            ),
            onTap: song.isCached
                ? null
                : () {
                    Navigator.pop(ctx);
                    _showQualityDialog(context, ref, song);
                  },
          ),
          ListTile(
            leading: const Icon(Icons.comment_outlined),
            title: Text(l10n.commentSection),
            onTap: () {
              Navigator.pop(ctx);
              _showCommentSheet(context, song.bvid);
            },
          ),
        ],
      ),
    ),
  );
}

void _showCommentSheet(BuildContext context, String bvid) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, _) => CommentSection(bvid: bvid),
    ),
  );
}

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
