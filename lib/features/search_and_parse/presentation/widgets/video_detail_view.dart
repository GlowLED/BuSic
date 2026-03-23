import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/generated/app_localizations.dart';
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

/// Displays parsed video detail: info card, page selection, action buttons,
/// and collapsible comment section.
class VideoDetailView extends ConsumerStatefulWidget {
  final ParseState parseState;
  final bool showBackButton;
  final VoidCallback? onBack;

  const VideoDetailView({
    super.key,
    required this.parseState,
    this.showBackButton = false,
    this.onBack,
  });

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
      if (edge == ScrollEdge.top && position.pixels > position.minScrollExtent) {
        _isScrollingOuter = true;
        _scrollController.animateTo(
          position.minScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        ).then((_) => _isScrollingOuter = false);
      } else if (edge == ScrollEdge.bottom && position.pixels < position.maxScrollExtent) {
        _isScrollingOuter = true;
        _scrollController.animateTo(
          position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        ).then((_) => _isScrollingOuter = false);
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
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isMultiPage = videoInfo.pages.length > 1;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          if (widget.showBackButton)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('返回搜索结果'),
              ),
            ),

          // ── Video info card ──
          _buildInfoCard(videoInfo, colorScheme, textTheme, isMultiPage),

          // ── Page selection for multi-page videos ──
          if (isMultiPage) ...[
            const SizedBox(height: 12),
            _buildPageSelection(videoInfo, selectedPages, colorScheme),
          ],

          // ── Add to Playlist button ──
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: (isMultiPage && selectedPages.isEmpty)
                  ? null
                  : () => _addToPlaylist(context),
              icon: const Icon(Icons.playlist_add),
              label: Text(l10n.addToPlaylist),
            ),
          ),

          // ── Play / Download buttons ──
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: (isMultiPage && selectedPages.isEmpty)
                      ? null
                      : () =>
                          _playParsedVideo(context, videoInfo, selectedPages),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('播放'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: (isMultiPage && selectedPages.isEmpty)
                      ? null
                      : () => _downloadParsedVideo(
                          context, videoInfo, selectedPages),
                  icon: const Icon(Icons.download),
                  label: Text(l10n.downloads),
                ),
              ),
            ],
          ),

          // ── Comment Section ──
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.comment),
                  title: const Text('评论区'),
                  trailing: Icon(
                    _showComments
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  onTap: () {
                    setState(() => _showComments = !_showComments);
                  },
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Video info card ─────────────────────────────────────────────────

  Widget _buildInfoCard(
    BvidInfo videoInfo,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isMultiPage,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: videoInfo.coverUrl != null
                  ? Image.network(
                      videoInfo.coverUrl!,
                      width: 160,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _coverPlaceholder(colorScheme),
                    )
                  : _coverPlaceholder(colorScheme),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(videoInfo.title,
                      style: textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text(videoInfo.owner,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule,
                          size: 14, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        Formatters.formatDuration(
                            Duration(seconds: videoInfo.duration)),
                        style: textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      if (isMultiPage) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.list,
                            size: 14, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        Text('${videoInfo.pages.length} 个分P',
                            style: textTheme.bodySmall
                                ?.copyWith(color: colorScheme.primary)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coverPlaceholder(ColorScheme colorScheme) {
    return Container(
      width: 160,
      height: 100,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.video_library, size: 40),
    );
  }

  // ── Page selection ──────────────────────────────────────────────────

  Widget _buildPageSelection(
    BvidInfo videoInfo,
    List<PageInfo> selectedPages,
    ColorScheme colorScheme,
  ) {
    final notifier = ref.read(parseNotifierProvider.notifier);
    final allSelected = selectedPages.length == videoInfo.pages.length;

    return Card(
      child: Column(
        children: [
          CheckboxListTile(
            title: const Text('选择分P'),
            subtitle:
                Text('已选 ${selectedPages.length}/${videoInfo.pages.length}'),
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
          const Divider(height: 1),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: videoInfo.pages.length,
              itemBuilder: (context, index) {
                final page = videoInfo.pages[index];
                final isSelected =
                    selectedPages.any((p) => p.cid == page.cid);
                return CheckboxListTile(
                  value: isSelected,
                  dense: true,
                  title: Text(
                    'P${page.page} ${page.partTitle}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(Formatters.formatDuration(
                      Duration(seconds: page.duration))),
                  onChanged: (_) => notifier.togglePageSelection(page),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Actions ─────────────────────────────────────────────────────────

  Future<void> _playParsedVideo(
    BuildContext context,
    BvidInfo videoInfo,
    List<PageInfo> pages,
  ) async {
    final pagesToPlay = pages.isNotEmpty ? pages : videoInfo.pages;
    if (pagesToPlay.isEmpty) return;

    final tracks = pagesToPlay
        .map((page) => AudioTrack(
              songId: 0,
              bvid: videoInfo.bvid,
              cid: page.cid,
              title: pagesToPlay.length > 1
                  ? page.partTitle
                  : videoInfo.title,
              artist: videoInfo.owner,
              coverUrl: videoInfo.coverUrl,
              duration: Duration(seconds: page.duration),
            ))
        .toList();

    try {
      await ref
          .read(playerNotifierProvider.notifier)
          .playTrackList(tracks, 0, playlistName: videoInfo.title);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('播放失败: $e'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
          ),
        );
      }
    }
  }

  Future<void> _downloadParsedVideo(
    BuildContext context,
    BvidInfo videoInfo,
    List<PageInfo> pages,
  ) async {
    final pagesToDownload = pages.isNotEmpty ? pages : videoInfo.pages;
    if (pagesToDownload.isEmpty) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final songIds = await ref
          .read(parseNotifierProvider.notifier)
          .confirmSelection();

      ref.read(parseNotifierProvider.notifier).parseInput(videoInfo.bvid);

      final qualities = await ref
          .read(downloadNotifierProvider.notifier)
          .getAvailableQualities(
            bvid: videoInfo.bvid,
            cid: pagesToDownload.first.cid,
          );

      if (qualities.isEmpty) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('未获取到可用音质'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
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
            int startedCount = 0;
            for (int i = 0; i < pagesToDownload.length; i++) {
              final page = pagesToDownload[i];
              final songId = i < songIds.length ? songIds[i] : songIds.last;
              final title = pagesToDownload.length > 1
                  ? page.partTitle
                  : videoInfo.title;
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
                content: Text('已开始下载 $startedCount 首歌曲'),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(
                    bottom: 80, left: 16, right: 16),
              ),
            );
          },
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('下载失败: $e'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
    }
  }

  Future<void> _addToPlaylist(BuildContext context) async {
    final selectedPlaylistId = await showDialog<int>(
      context: context,
      builder: (_) => const PlaylistPickerDialog(),
    );
    if (selectedPlaylistId == null || !context.mounted) return;

    final songIds = await ref
        .read(parseNotifierProvider.notifier)
        .confirmSelection(playlistId: selectedPlaylistId);

    if (context.mounted && songIds.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已添加 ${songIds.length} 首歌曲到歌单'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
      ref.invalidate(playlistListNotifierProvider);
      ref.invalidate(playlistDetailNotifierProvider(selectedPlaylistId));
    }
  }
}
