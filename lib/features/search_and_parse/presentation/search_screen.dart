import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/generated/app_localizations.dart';

import '../../../core/utils/formatters.dart';
import '../../comment/presentation/comment_section.dart';
import '../../download/application/download_notifier.dart';
import '../../download/presentation/widgets/quality_select_dialog.dart';
import '../../player/application/player_notifier.dart';
import '../../player/domain/models/audio_track.dart';
import '../../playlist/application/playlist_notifier.dart';
import '../../../shared/widgets/playlist_picker_dialog.dart';
import '../../auth/application/auth_notifier.dart';
import '../application/parse_notifier.dart';
import '../domain/models/bvid_info.dart';
import '../domain/models/page_info.dart';

/// Main search screen with unified input for BV number parsing and keyword search.
///
/// Flow:
/// 1. User enters a BV number/URL → parses the video directly
/// 2. User enters a keyword → searches Bilibili and shows results
/// 3. Tapping a search result → parses that video
/// 4. Parsed video detail shows info, page selection, and "Add to Playlist"
/// 5. Playlist picker lets user choose target playlist
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  List<BvidInfo> _searchResults = [];
  bool _isSearching = false;
  int _currentPage = 1;
  int _totalPages = 1;
  String _currentKeyword = '';
  bool _showComments = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Determine whether input is a BV number or a search keyword.
  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final bvid = Formatters.parseBvid(text);
    if (bvid != null) {
      setState(() => _searchResults = []);
      ref.read(parseNotifierProvider.notifier).parseInput(text);
    } else {
      _currentKeyword = text;
      _performSearch(text, page: 1);
    }
  }

  Future<void> _performSearch(String keyword, {int page = 1}) async {
    ref.read(parseNotifierProvider.notifier).reset();
    setState(() {
      _isSearching = true;
      _currentPage = page;
    });
    final searchResult =
        await ref.read(parseNotifierProvider.notifier).searchVideos(keyword, page: page);
    setState(() {
      _searchResults = searchResult.results;
      _totalPages = searchResult.numPages;
      _isSearching = false;
    });
  }

  void _goToPage(int page) {
    if (_currentKeyword.isNotEmpty && page >= 1 && page <= _totalPages) {
      _performSearch(_currentKeyword, page: page);
    }
  }

  void _onVideoTap(BvidInfo video) {
    ref.read(parseNotifierProvider.notifier).parseInput(video.bvid);
  }

  void _backToResults() {
    ref.read(parseNotifierProvider.notifier).reset();
  }

  /// Play parsed video pages directly without adding to a playlist.
  Future<void> _playParsedVideo(
    BuildContext context,
    BvidInfo videoInfo,
    List<PageInfo> pages,
  ) async {
    final pagesToPlay =
        pages.isNotEmpty ? pages : videoInfo.pages;
    if (pagesToPlay.isEmpty) return;

    // Build AudioTrack list — stream URLs will be resolved by the player
    final tracks = pagesToPlay.map((page) => AudioTrack(
          songId: 0,
          bvid: videoInfo.bvid,
          cid: page.cid,
          title: pagesToPlay.length > 1
              ? page.partTitle
              : videoInfo.title,
          artist: videoInfo.owner,
          coverUrl: videoInfo.coverUrl,
          duration: Duration(seconds: page.duration),
        )).toList();

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

  /// Download parsed video pages with quality selection.
  Future<void> _downloadParsedVideo(
    BuildContext context,
    BvidInfo videoInfo,
    List<PageInfo> pages,
  ) async {
    final pagesToDownload =
        pages.isNotEmpty ? pages : videoInfo.pages;
    if (pagesToDownload.isEmpty) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      // First, ensure songs exist in DB (upsert)
      final songIds = await ref
          .read(parseNotifierProvider.notifier)
          .confirmSelection();

      // re-parse to restore state (confirmSelection resets to idle)
      ref.read(parseNotifierProvider.notifier).parseInput(videoInfo.bvid);

      // Get available qualities from the first page
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

  Future<void> _onPaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      _controller.text = data.text!;
      _handleSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final parseState = ref.watch(parseNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final showVideoDetail = parseState.whenOrNull(
      success: (info) => info,
      selectingPages: (info, _) => info,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.search), centerTitle: false),
      body: Column(
        children: [
          // ── Input bar ──
          _buildInputBar(context, l10n, parseState),

          // ── Error banner ──
          parseState.whenOrNull(
                error: (msg) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: colorScheme.errorContainer,
                  child: Text(msg,
                      style:
                          TextStyle(color: colorScheme.onErrorContainer)),
                ),
              ) ??
              const SizedBox.shrink(),

          // ── Content area ──
          if (parseState.whenOrNull(parsing: () => true) == true)
            const Expanded(
                child: Center(child: CircularProgressIndicator()))
          else if (showVideoDetail != null)
            Expanded(child: _buildVideoDetail(context, l10n, parseState))
          else if (_isSearching)
            const Expanded(
                child: Center(child: CircularProgressIndicator()))
          else if (_searchResults.isNotEmpty)
            Expanded(child: _buildSearchResults(context))
          else
            Expanded(child: _buildEmptyState(context, l10n, colorScheme)),
        ],
      ),
    );
  }

  // ── Input bar ───────────────────────────────────────────────────────

  Widget _buildInputBar(
      BuildContext context, AppLocalizations l10n, ParseState parseState) {
    final isParsing =
        parseState.whenOrNull(parsing: () => true) == true;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: l10n.parseInput,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.content_paste),
                  tooltip: '粘贴',
                  onPressed: _onPaste,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _handleSubmit(),
              enabled: !isParsing,
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: isParsing ? null : _handleSubmit,
            icon: isParsing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.search),
            label: Text(isParsing ? l10n.parsing : l10n.search),
          ),
        ],
      ),
    );
  }

  // ── Search results list ─────────────────────────────────────────────

  Widget _buildSearchResults(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            key: PageStorageKey<String>('search_results_page_$_currentPage'),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final video = _searchResults[index];
              return ListTile(
                leading: video.coverUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          video.coverUrl!,
                          width: 80,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 50,
                            color: colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.video_library),
                          ),
                        ),
                      )
                    : null,
                title: Text(video.title,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  '${video.owner} · ${Formatters.formatDuration(Duration(seconds: video.duration))}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _onVideoTap(video),
              );
            },
          ),
        ),
        // Pagination controls
        _buildPaginationBar(colorScheme),
      ],
    );
  }

  Widget _buildPaginationBar(ColorScheme colorScheme) {
    if (_totalPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous page button
          IconButton(
            icon: const Icon(Icons.chevron_left),
            iconSize: 20,
            visualDensity: VisualDensity.compact,
            onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
            tooltip: '上一页',
          ),
          const SizedBox(width: 4),
          // Dynamic page buttons with ellipsis
          ..._buildPageNumbers(colorScheme),
          const SizedBox(width: 4),
          // Next page button
          IconButton(
            icon: const Icon(Icons.chevron_right),
            iconSize: 20,
            visualDensity: VisualDensity.compact,
            onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
            tooltip: '下一页',
          ),
          const SizedBox(width: 8),
          // Jump to page input
          _buildJumpToPage(colorScheme),
        ],
      ),
    );
  }

  /// Build page number buttons with ellipsis, Google/browser style:
  /// [1] ... [4] [5] [*6*] [7] [8] ... [50]
  List<Widget> _buildPageNumbers(ColorScheme colorScheme) {
    final pages = <Widget>[];
    const int siblings = 2; // pages on each side of current

    final int rangeStart = (_currentPage - siblings).clamp(1, _totalPages);
    final int rangeEnd = (_currentPage + siblings).clamp(1, _totalPages);

    // Always show page 1
    if (rangeStart > 1) {
      pages.add(_buildPageButton(1, colorScheme));
      if (rangeStart > 2) {
        pages.add(_buildEllipsis(colorScheme));
      }
    }

    // Sibling range
    for (int i = rangeStart; i <= rangeEnd; i++) {
      pages.add(_buildPageButton(i, colorScheme));
    }

    // Always show last page
    if (rangeEnd < _totalPages) {
      if (rangeEnd < _totalPages - 1) {
        pages.add(_buildEllipsis(colorScheme));
      }
      pages.add(_buildPageButton(_totalPages, colorScheme));
    }

    return pages;
  }

  Widget _buildEllipsis(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: Text(
            '…',
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJumpToPage(ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 48,
          height: 32,
          child: Center(
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: colorScheme.onSurface, height: 1.0),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                isDense: true,
                hintText: '$_currentPage',
                hintStyle: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSubmitted: (value) {
                final page = int.tryParse(value);
                if (page != null && page >= 1 && page <= _totalPages) {
                  _goToPage(page);
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '/ $_totalPages',
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPageButton(int page, ColorScheme colorScheme) {
    final isActive = page == _currentPage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        width: 32,
        height: 32,
        child: Material(
          color: isActive ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: isActive ? null : () => _goToPage(page),
            child: Center(
              child: Text(
                '$page',
                style: TextStyle(
                  fontSize: 13,
                  color: isActive ? colorScheme.onPrimary : colorScheme.onSurface,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Parsed video detail ─────────────────────────────────────────────

  Widget _buildVideoDetail(
      BuildContext context, AppLocalizations l10n, ParseState parseState) {
    BvidInfo? info;
    List<PageInfo> selectedPages = [];

    parseState.whenOrNull(
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isMultiPage = videoInfo.pages.length > 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          if (_searchResults.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton.icon(
                onPressed: _backToResults,
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('返回搜索结果'),
              ),
            ),

          // ── Video info card ──
          Card(
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
                            style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.schedule,
                                size: 14,
                                color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              Formatters.formatDuration(
                                  Duration(seconds: videoInfo.duration)),
                              style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant),
                            ),
                            if (isMultiPage) ...[
                              const SizedBox(width: 12),
                              Icon(Icons.list,
                                  size: 14, color: colorScheme.primary),
                              const SizedBox(width: 4),
                              Text('${videoInfo.pages.length} 个分P',
                                  style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.primary)),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Page selection for multi-page videos ──
          if (isMultiPage) ...[
            const SizedBox(height: 12),
            _buildPageSelection(
                context, videoInfo, selectedPages, colorScheme),
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
                      : () => _playParsedVideo(context, videoInfo, selectedPages),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('播放'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: (isMultiPage && selectedPages.isEmpty)
                      ? null
                      : () => _downloadParsedVideo(context, videoInfo, selectedPages),
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
                    child: CommentSection(bvid: videoInfo.bvid),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
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

  Widget _buildPageSelection(
    BuildContext context,
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

  // ── Empty state ─────────────────────────────────────────────────────

  Widget _buildEmptyState(
      BuildContext context, AppLocalizations l10n, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 64, color: colorScheme.outlineVariant),
          const SizedBox(height: 16),
          Text(l10n.parseInput,
              style: TextStyle(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Text('搜索关键词或输入BV号',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

