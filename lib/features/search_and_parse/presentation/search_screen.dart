import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_panel.dart';

import '../application/parse_notifier.dart';
import '../domain/models/bvid_info.dart';
import 'widgets/search_result_list.dart';
import 'widgets/video_detail_view.dart';

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    final searchResult = await ref
        .read(parseNotifierProvider.notifier)
        .searchVideos(keyword, page: page);
    if (!mounted) return;
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
    final spacing = context.appSpacing;

    final showVideoDetail = parseState.whenOrNull(
      success: (info) => info,
      selectingPages: (info, _) => info,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.md,
                spacing.lg,
                spacing.xs,
              ),
              child: _buildInputBar(l10n, parseState),
            ),
            parseState.whenOrNull(
                  error: (msg) => Padding(
                    padding: EdgeInsets.fromLTRB(
                      spacing.lg,
                      spacing.sm,
                      spacing.lg,
                      0,
                    ),
                    child: _SearchErrorBanner(message: msg),
                  ),
                ) ??
                const SizedBox.shrink(),
            SizedBox(height: spacing.sm),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _buildContent(
                  parseState: parseState,
                  showVideoDetail: showVideoDetail,
                  l10n: l10n,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({
    required ParseState parseState,
    required BvidInfo? showVideoDetail,
    required AppLocalizations l10n,
  }) {
    if (parseState.whenOrNull(parsing: () => true) == true) {
      return _SearchLoadingState(
        key: const ValueKey('parsing'),
        label: l10n.parsing,
      );
    }

    if (showVideoDetail != null) {
      return VideoDetailView(
        key: const ValueKey('detail'),
        parseState: parseState,
        showBackButton: _searchResults.isNotEmpty,
        onBack: _backToResults,
      );
    }

    if (_isSearching) {
      return _SearchLoadingState(
        key: const ValueKey('searching'),
        label: l10n.searching,
      );
    }

    if (_searchResults.isNotEmpty) {
      return SearchResultList(
        key: ValueKey('results_$_currentKeyword-$_currentPage'),
        results: _searchResults,
        currentPage: _currentPage,
        totalPages: _totalPages,
        onVideoTap: _onVideoTap,
        onPageChanged: _goToPage,
      );
    }

    return _buildEmptyState(l10n);
  }

  // ── Input bar ───────────────────────────────────────────────────────

  Widget _buildInputBar(AppLocalizations l10n, ParseState parseState) {
    final isParsing = parseState.whenOrNull(parsing: () => true) == true;
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return AppPanel(
      padding: EdgeInsets.all(spacing.sm),
      borderRadius: context.appRadii.largeRadius,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final field = DecoratedBox(
            decoration: BoxDecoration(
              color: palette.surfacePrimary.withValues(alpha: 0.58),
              borderRadius: context.appRadii.largeRadius,
              border: Border.all(
                color: palette.borderSubtle.withValues(alpha: 0.78),
                width: context.appDepth.outline,
              ),
            ),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: l10n.parseInput,
                prefixIcon: Icon(
                  Icons.manage_search_rounded,
                  color: palette.textSecondary,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.content_paste_rounded),
                  tooltip: l10n.pasteFromClipboard,
                  onPressed: isParsing ? null : _onPaste,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
              ),
              onSubmitted: (_) => _handleSubmit(),
              enabled: !isParsing,
            ),
          );

          final submit = FilledButton.icon(
            onPressed: isParsing ? null : _handleSubmit,
            icon: isParsing
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colorScheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.search_rounded),
            label: Text(isParsing ? l10n.parsing : l10n.search),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                field,
                SizedBox(height: spacing.sm),
                SizedBox(width: double.infinity, child: submit),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: field),
                  SizedBox(width: spacing.sm),
                  submit,
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────

  Widget _buildEmptyState(AppLocalizations l10n) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return Center(
      key: const ValueKey('empty'),
      child: AppPanel(
        padding: EdgeInsets.all(spacing.xl),
        borderRadius: context.appRadii.xLargeRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.travel_explore_rounded,
              size: 56,
              color: palette.accentStrong.withValues(alpha: 0.72),
            ),
            SizedBox(height: spacing.md),
            Text(
              l10n.searchEmptyTitle,
              style: context.textTheme.titleMedium?.copyWith(
                color: palette.textPrimary,
              ),
            ),
            SizedBox(height: spacing.xs),
            Text(
              l10n.searchEmptySubtitle,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchErrorBanner extends StatelessWidget {
  const _SearchErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final spacing = context.appSpacing;

    return AppPanel(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      backgroundColor: palette.dangerSoft.withValues(alpha: 0.88),
      borderColor: palette.danger.withValues(alpha: 0.38),
      boxShadow: const [],
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: palette.danger),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: palette.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchLoadingState extends StatelessWidget {
  const _SearchLoadingState({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return Center(
      child: AppPanel(
        padding: EdgeInsets.all(spacing.lg),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: spacing.sm),
            Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
