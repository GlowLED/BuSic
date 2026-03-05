import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/playlist_notifier.dart';
import '../../domain/models/song_item.dart';

/// Dialog for selecting a custom playlist cover image.
///
/// Supports two modes:
/// - Select a local image file from device storage
/// - Select a song's cover image from the playlist
class CoverSelectionDialog extends ConsumerWidget {
  /// The playlist ID to update cover for.
  final int playlistId;

  const CoverSelectionDialog({
    super.key,
    required this.playlistId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return AlertDialog(
      title: Text(l10n.selectCoverSource),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.image_outlined, color: colorScheme.primary),
            title: Text(l10n.selectLocalImage),
            onTap: () => _pickLocalImage(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.music_note, color: colorScheme.primary),
            title: Text(l10n.selectSongCover),
            onTap: () => _showSongCoverPicker(context, ref),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.image_not_supported_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
            title: Text(l10n.resetCover),
            onTap: () => _resetCover(context, ref),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  /// Pick a local image file using file_picker (cross-platform).
  Future<void> _pickLocalImage(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    Navigator.pop(context);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path != null && path.isNotEmpty) {
        await ref
            .read(playlistListNotifierProvider.notifier)
            .updatePlaylistCover(playlistId, path);
        if (context.mounted) {
          context.showSnackBar(l10n.coverUpdated);
        }
      }
    }
  }

  /// Show a dialog to pick a song's cover from the playlist.
  void _showSongCoverPicker(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (_) => _SongCoverPickerDialog(playlistId: playlistId),
    );
  }

  /// Reset cover to default (null — will fall back to first song cover).
  Future<void> _resetCover(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    Navigator.pop(context);
    await ref
        .read(playlistListNotifierProvider.notifier)
        .updatePlaylistCover(playlistId, null);
    if (context.mounted) {
      context.showSnackBar(l10n.coverReset);
    }
  }
}

/// Dialog listing all songs in a playlist for cover selection.
class _SongCoverPickerDialog extends ConsumerWidget {
  final int playlistId;

  const _SongCoverPickerDialog({required this.playlistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(playlistDetailNotifierProvider(playlistId));
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return AlertDialog(
      title: Text(l10n.selectSongAsCover),
      content: SizedBox(
        width: 360,
        height: 400,
        child: songsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (songs) {
            // Filter songs with cover URLs
            final songsWithCover =
                songs.where((s) => s.coverUrl != null).toList();
            if (songsWithCover.isEmpty) {
              return Center(
                child: Text(
                  l10n.noSongs,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              );
            }
            return ListView.builder(
              itemCount: songsWithCover.length,
              itemBuilder: (context, index) {
                final song = songsWithCover[index];
                return _SongCoverItem(
                  song: song,
                  onTap: () => _selectSongCover(context, ref, song),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  Future<void> _selectSongCover(
    BuildContext context,
    WidgetRef ref,
    SongItem song,
  ) async {
    final l10n = context.l10n;
    Navigator.pop(context);
    if (song.coverUrl != null) {
      await ref
          .read(playlistListNotifierProvider.notifier)
          .updatePlaylistCover(playlistId, song.coverUrl);
      if (context.mounted) {
        context.showSnackBar(l10n.coverUpdated);
      }
    }
  }
}

/// A list item showing a song with its cover for selection.
class _SongCoverItem extends StatelessWidget {
  final SongItem song;
  final VoidCallback onTap;

  const _SongCoverItem({required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 48,
          height: 48,
          child: _buildCoverImage(song.coverUrl, colorScheme),
        ),
      ),
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
      onTap: onTap,
    );
  }

  Widget _buildCoverImage(String? coverUrl, ColorScheme colorScheme) {
    if (coverUrl == null || coverUrl.isEmpty) {
      return Container(
        color: colorScheme.surfaceContainerHighest,
        child: const Icon(Icons.music_note, size: 24),
      );
    }

    final isLocal = coverUrl.startsWith('/') ||
        coverUrl.startsWith('file://') ||
        RegExp(r'^[A-Za-z]:[/\\]').hasMatch(coverUrl);
    if (isLocal) {
      final path = coverUrl.startsWith('file://')
          ? Uri.parse(coverUrl).toFilePath()
          : coverUrl;
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.music_note, size: 24),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: coverUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: colorScheme.surfaceContainerHighest,
        child: const Icon(Icons.music_note, size: 24),
      ),
      errorWidget: (_, __, ___) => Container(
        color: colorScheme.surfaceContainerHighest,
        child: const Icon(Icons.music_note, size: 24),
      ),
    );
  }
}
