import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/common_dialogs.dart';
import '../../playlist/application/playlist_notifier.dart';
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
      _performSearch(text);
    }
  }

  Future<void> _performSearch(String keyword) async {
    ref.read(parseNotifierProvider.notifier).reset();
    setState(() => _isSearching = true);
    final results =
        await ref.read(parseNotifierProvider.notifier).searchVideos(keyword);
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _onVideoTap(BvidInfo video) {
    ref.read(parseNotifierProvider.notifier).parseInput(video.bvid);
  }

  void _backToResults() {
    ref.read(parseNotifierProvider.notifier).reset();
  }

  Future<void> _addToPlaylist(BuildContext context) async {
    final selectedPlaylistId = await showDialog<int>(
      context: context,
      builder: (_) => const _PlaylistPickerDialog(),
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
    return ListView.builder(
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

// ══════════════════════════════════════════════════════════════════════
// Playlist picker dialog
// ══════════════════════════════════════════════════════════════════════

/// Dialog for selecting a target playlist to add songs to.
class _PlaylistPickerDialog extends ConsumerWidget {
  const _PlaylistPickerDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistListNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(l10n.addToPlaylist),
      content: SizedBox(
        width: 320,
        height: 400,
        child: playlistsAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (playlists) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.add_circle_outline,
                    color: colorScheme.primary),
                title: Text(l10n.createPlaylist),
                onTap: () => _createAndSelect(context, ref, l10n),
              ),
              const Divider(),
              if (playlists.isEmpty)
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
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlists[index];
                      return ListTile(
                        leading: const Icon(Icons.library_music),
                        title: Text(playlist.name),
                        subtitle:
                            Text('${playlist.songCount} 首歌曲'),
                        onTap: () =>
                            Navigator.of(context).pop(playlist.id),
                      );
                    },
                  ),
                ),
            ],
          ),
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
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
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
