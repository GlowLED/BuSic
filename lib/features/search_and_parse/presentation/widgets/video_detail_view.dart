import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_panel.dart';
import '../../../../shared/widgets/media_cover.dart';
import '../../../../shared/widgets/playlist_picker_dialog.dart';
import '../../../auth/application/auth_notifier.dart';
import '../../../comment/presentation/comment_section.dart';
import '../../../download/application/download_notifier.dart';
import '../../../download/presentation/widgets/quality_select_dialog.dart';
import '../../../player/application/player_notifier.dart';
import '../../../player/domain/models/audio_track.dart';
import '../../../playlist/application/playlist_notifier.dart';
import '../../application/parse_notifier.dart';
import '../../domain/models/bvid_info.dart';
import '../../domain/models/page_info.dart';

/// Displays parsed video detail, page selection, actions, and comments.
class VideoDetailView extends ConsumerStatefulWidget {
  const VideoDetailView({
    super.key,
    required this.parseState,
    this.showBackButton = false,
    this.onBack,
  });

  final ParseState parseState;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  ConsumerState<VideoDetailView> createState() => _VideoDetailViewState();
}

class _VideoDetailViewState extends ConsumerState<VideoDetailView> {
  bool _showComments = false;
  final _scrollController = ScrollController();
  bool _isScrollingOuter = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onCommentScrollToEdge(ScrollEdge edge) {
    if (_isScrollingOuter) return;
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted) return;
      final position = _scrollController.position;
      if (edge == ScrollEdge.top &&
          position.pixels > position.minScrollExtent) {
        _isScrollingOuter = true;
        _scrollController
            .animateTo(
              position.minScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            )
            .then((_) => _isScrollingOuter = false);
      } else if (edge == ScrollEdge.bottom &&
          position.pixels < position.maxScrollExtent) {
        _isScrollingOuter = true;
        _scrollController
            .animateTo(
              position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            )
            .then((_) => _isScrollingOuter = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    BvidInfo? info;
    List<PageInfo> selectedPages = [];

    widget.parseState.whenOrNull(
      success: (i) {
        info = i;
        selectedPages = i.pages;
      },
      selectingPages: (i, pages) {
        info = i;
        selectedPages = pages;
      },
    );
    if (info == null) return const SizedBox.shrink();

    final videoInfo = info!;
    final l10n = context.l10n;
    final spacing = context.appSpacing;
    final isMultiPage = videoInfo.pages.length > 1;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showBackButton)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(l10n.backToSearchResults),
              ),
            ),
          _buildInfoCard(videoInfo, isMultiPage),
          if (isMultiPage) ...[
            SizedBox(height: spacing.md),
            _buildPageSelection(videoInfo, selectedPages),
          ],
          SizedBox(height: spacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: (isMultiPage && selectedPages.isEmpty)
                  ? null
                  : () => _addToPlaylist(context),
              icon: const Icon(Icons.playlist_add_rounded),
              label: Text(l10n.addToPlaylist),
            ),
          ),
          SizedBox(height: spacing.sm),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: (isMultiPage && selectedPages.isEmpty)
                      ? null
                      : () =>
                          _playParsedVideo(context, videoInfo, selectedPages),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l10n.play),
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: (isMultiPage && selectedPages.isEmpty)
                      ? null
                      : () => _downloadParsedVideo(
                            context,
                            videoInfo,
                            selectedPages,
                          ),
                  icon: const Icon(Icons.download_rounded),
                  label: Text(l10n.downloads),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          AppPanel(
            padding: EdgeInsets.zero,
            borderRadius: context.appRadii.xLargeRadius,
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: context.appRadii.xLargeRadius,
                    onTap: () {
                      setState(() => _showComments = !_showComments);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(spacing.md),
                      child: Row(
                        children: [
                          Icon(
                            Icons.comment_rounded,
                            color: context.appPalette.accentStrong,
                          ),
                          SizedBox(width: spacing.sm),
                          Expanded(
                            child: Text(
                              l10n.commentSection,
                              style: context.textTheme.titleSmall?.copyWith(
                                color: context.appPalette.textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            _showComments
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: context.appPalette.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_showComments)
                  SizedBox(
                    height: 400,
                    child: CommentSection(
                      bvid: videoInfo.bvid,
                      onScrollToEdge: _onCommentScrollToEdge,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: spacing.md),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BvidInfo videoInfo, bool isMultiPage) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return AppPanel(
      padding: EdgeInsets.all(spacing.md),
      borderRadius: context.appRadii.xLargeRadius,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final cover = DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: context.appRadii.largeRadius,
              boxShadow: context.appDepth.coverGlowShadow,
            ),
            child: MediaCover(
              coverUrl: videoInfo.coverUrl,
              width: compact ? double.infinity : 168,
              height: compact ? null : 104,
              aspectRatio: compact ? 16 / 9 : null,
              borderRadius: context.appRadii.largeRadius,
              placeholderIcon: Icons.video_library_rounded,
            ),
          );

          final meta = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                videoInfo.title,
                style: context.textTheme.titleLarge?.copyWith(
                  color: palette.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing.sm),
              Text(
                videoInfo.owner,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              SizedBox(height: spacing.sm),
              Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.xs,
                children: [
                  _VideoBadge(
                    icon: Icons.schedule_rounded,
                    label: Formatters.formatDuration(
                      Duration(seconds: videoInfo.duration),
                    ),
                  ),
                  if (isMultiPage)
                    _VideoBadge(
                      icon: Icons.queue_music_rounded,
                      label: context.l10n.pagesCount(videoInfo.pages.length),
                      emphasized: true,
                    ),
                ],
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cover,
                SizedBox(height: spacing.md),
                meta,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cover,
              SizedBox(width: spacing.md),
              Expanded(child: meta),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPageSelection(
    BvidInfo videoInfo,
    List<PageInfo> selectedPages,
  ) {
    final notifier = ref.read(parseNotifierProvider.notifier);
    final allSelected = selectedPages.length == videoInfo.pages.length;
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return AppPanel(
      padding: EdgeInsets.all(spacing.md),
      borderRadius: context.appRadii.xLargeRadius,
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: allSelected
                    ? true
                    : selectedPages.isEmpty
                        ? false
                        : null,
                tristate: true,
                onChanged: (value) {
                  if (value == true) {
                    notifier.selectAllPages();
                  } else {
                    notifier.deselectAllPages();
                  }
                },
              ),
              SizedBox(width: spacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.selectPages,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    SizedBox(height: spacing.xxs),
                    Text(
                      context.l10n.selectedPagesCount(
                        selectedPages.length,
                        videoInfo.pages.length,
                      ),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: videoInfo.pages.length,
              separatorBuilder: (_, __) => SizedBox(height: spacing.xs),
              itemBuilder: (context, index) {
                final page = videoInfo.pages[index];
                final isSelected = selectedPages.any((p) => p.cid == page.cid);
                return _PageSelectionRow(
                  page: page,
                  isSelected: isSelected,
                  onTap: () => notifier.togglePageSelection(page),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _playParsedVideo(
    BuildContext context,
    BvidInfo videoInfo,
    List<PageInfo> pages,
  ) async {
    final l10n = context.l10n;
    final pagesToPlay = pages.isNotEmpty ? pages : videoInfo.pages;
    if (pagesToPlay.isEmpty) return;

    final tracks = pagesToPlay
        .map(
          (page) => AudioTrack(
            songId: 0,
            bvid: videoInfo.bvid,
            cid: page.cid,
            title: pagesToPlay.length > 1 ? page.partTitle : videoInfo.title,
            artist: videoInfo.owner,
            coverUrl: videoInfo.coverUrl,
            duration: Duration(seconds: page.duration),
          ),
        )
        .toList();

    try {
      await ref
          .read(playerNotifierProvider.notifier)
          .playTrackList(tracks, 0, playlistName: videoInfo.title);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.playFailedWithError(e.toString())),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
    }
  }

  Future<void> _downloadParsedVideo(
    BuildContext context,
    BvidInfo videoInfo,
    List<PageInfo> pages,
  ) async {
    final l10n = context.l10n;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final pagesToDownload = pages.isNotEmpty ? pages : videoInfo.pages;
    if (pagesToDownload.isEmpty) return;

    try {
      final songIds =
          await ref.read(parseNotifierProvider.notifier).confirmSelection();

      ref.read(parseNotifierProvider.notifier).parseInput(videoInfo.bvid);

      final qualities = await ref
          .read(downloadNotifierProvider.notifier)
          .getAvailableQualities(
            bvid: videoInfo.bvid,
            cid: pagesToDownload.first.cid,
          );

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
            var startedCount = 0;
            for (var i = 0; i < pagesToDownload.length; i++) {
              final page = pagesToDownload[i];
              final songId = i < songIds.length ? songIds[i] : songIds.last;
              final title =
                  pagesToDownload.length > 1 ? page.partTitle : videoInfo.title;
              final started = await ref
                  .read(downloadNotifierProvider.notifier)
                  .downloadSongWithQuality(
                    songId: songId,
                    bvid: videoInfo.bvid,
                    cid: page.cid,
                    quality: selected.quality,
                    title: title,
                  );
              if (started) startedCount++;
            }
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(l10n.downloadStartedCount(startedCount)),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(
                  bottom: 80,
                  left: 16,
                  right: 16,
                ),
              ),
            );
          },
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.downloadFailedWithError(e.toString())),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
    }
  }

  Future<void> _addToPlaylist(BuildContext context) async {
    final l10n = context.l10n;
    final selectedPlaylistId = await showDialog<int>(
      context: context,
      builder: (_) => const PlaylistPickerDialog(),
    );
    if (selectedPlaylistId == null || !context.mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final songIds = await ref
        .read(parseNotifierProvider.notifier)
        .confirmSelection(playlistId: selectedPlaylistId);

    if (context.mounted && songIds.isNotEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.addedSongsToPlaylist(songIds.length)),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
      ref.invalidate(playlistListNotifierProvider);
      ref.invalidate(playlistDetailNotifierProvider(selectedPlaylistId));
    }
  }
}

class _VideoBadge extends StatelessWidget {
  const _VideoBadge({
    required this.icon,
    required this.label,
    this.emphasized = false,
  });

  final IconData icon;
  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final color = emphasized ? palette.accentStrong : palette.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.appSpacing.sm,
        vertical: context.appSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: emphasized
            ? palette.accentSoft.withValues(alpha: 0.66)
            : palette.surfaceSecondary.withValues(alpha: 0.72),
        borderRadius: context.appRadii.pillRadius,
        border: Border.all(
          color: color.withValues(alpha: 0.22),
          width: context.appDepth.outline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: context.appSpacing.xxs),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _PageSelectionRow extends StatelessWidget {
  const _PageSelectionRow({
    required this.page,
    required this.isSelected,
    required this.onTap,
  });

  final PageInfo page;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return Material(
      color: isSelected
          ? palette.accentSoft.withValues(alpha: 0.5)
          : palette.surfacePrimary.withValues(alpha: 0.42),
      borderRadius: context.appRadii.largeRadius,
      child: InkWell(
        borderRadius: context.appRadii.largeRadius,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: context.appRadii.largeRadius,
            border: Border.all(
              color: isSelected
                  ? palette.accentStrong.withValues(alpha: 0.42)
                  : palette.borderSubtle.withValues(alpha: 0.72),
              width: context.appDepth.outline,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.xs,
            ),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onTap(),
                ),
                SizedBox(width: spacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'P${page.page} ${page.partTitle}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                      SizedBox(height: spacing.xxs),
                      Text(
                        Formatters.formatDuration(
                          Duration(seconds: page.duration),
                        ),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
