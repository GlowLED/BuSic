import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_panel.dart';

import '../application/parse_notifier.dart';
import '../domain/models/bvid_info.dart';
import 'widgets/search_result_list.dart';
import 'widgets/video_detail_view.dart';

const _searchBarAnimationDuration = Duration(milliseconds: 260);
const _contentSwitchDuration = Duration(milliseconds: 180);
const _compactSearchBreakpoint = 560.0;
const _centeredSearchMaxWidth = 720.0;
const _dockedSearchBarHeight = 56.0;

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
  final _focusNode = FocusNode();
  List<BvidInfo> _searchResults = [];
  bool _isSearching = false;
  bool _isLoadingMore = false;
  String? _loadMoreErrorMessage;
  int _currentPage = 1;
  int _totalPages = 1;
  String _currentKeyword = '';
  bool _hasSubmittedInput = false;
  bool _hasInputText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleInputTextChanged);
    _focusNode.addListener(_handleInputFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleInputFocusChanged);
    _controller.removeListener(_handleInputTextChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleInputTextChanged() {
    final hasInputText = _controller.text.trim().isNotEmpty;
    if (_hasInputText == hasInputText) return;

    setState(() {
      _hasInputText = hasInputText;
      if (!hasInputText) {
        _hasSubmittedInput = false;
      }
    });
  }

  void _handleInputFocusChanged() {
    if (_focusNode.hasFocus || _controller.text.trim().isNotEmpty) return;

    _resetSearchSession(clearText: false);
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _hasSubmittedInput = true);

    final bvid = Formatters.parseBvid(text);
    if (bvid != null) {
      setState(() {
        _currentKeyword = '';
        _searchResults = [];
        _isLoadingMore = false;
        _loadMoreErrorMessage = null;
      });
      ref.read(parseNotifierProvider.notifier).parseInput(text);
    } else {
      _currentKeyword = text;
      _performSearch(text, page: 1);
    }
  }

  void _handleClearSearchInput() {
    FocusScope.of(context).unfocus();
    _resetSearchSession(clearText: true);
  }

  void _resetSearchSession({required bool clearText}) {
    if (clearText) {
      _controller.clear();
    }

    ref.read(parseNotifierProvider.notifier).reset();

    setState(() {
      _currentKeyword = '';
      _currentPage = 1;
      _totalPages = 1;
      _searchResults = [];
      _isSearching = false;
      _isLoadingMore = false;
      _loadMoreErrorMessage = null;
      _hasSubmittedInput = false;
      _hasInputText = false;
    });
  }

  Future<void> _performSearch(String keyword, {int page = 1}) async {
    ref.read(parseNotifierProvider.notifier).reset();
    setState(() {
      _isSearching = true;
      _isLoadingMore = false;
      _loadMoreErrorMessage = null;
      _currentPage = page;
      _searchResults = [];
    });
    final searchResult = await ref
        .read(parseNotifierProvider.notifier)
        .searchVideos(keyword, page: page);
    if (!mounted || keyword != _currentKeyword) return;
    setState(() {
      _searchResults = searchResult.results;
      _totalPages = searchResult.numPages;
      _isSearching = false;
    });
  }

  Future<void> _loadNextSearchPage() async {
    if (_currentKeyword.isEmpty ||
        _isSearching ||
        _isLoadingMore ||
        _currentPage >= _totalPages) {
      return;
    }

    final nextPage = _currentPage + 1;
    final keyword = _currentKeyword;
    setState(() {
      _isLoadingMore = true;
      _loadMoreErrorMessage = null;
    });

    try {
      final searchResult =
          await ref.read(parseNotifierProvider.notifier).searchVideos(
                keyword,
                page: nextPage,
                updateStateOnError: false,
              );
      if (!mounted || keyword != _currentKeyword) return;
      setState(() {
        _searchResults = [..._searchResults, ...searchResult.results];
        _currentPage = nextPage;
        _totalPages = searchResult.numPages;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted || keyword != _currentKeyword) return;
      setState(() {
        _isLoadingMore = false;
        _loadMoreErrorMessage = context.l10n.searchLoadMoreFailed;
      });
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

    final showVideoDetail = parseState.whenOrNull(
      success: (info) => info,
      selectingPages: (info, _) => info,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: showVideoDetail == null
            ? _buildSearchLayout(
                parseState: parseState,
                l10n: l10n,
              )
            : SizedBox.expand(
                child: AnimatedSwitcher(
                  duration: _contentSwitchDuration,
                  child: _buildContent(
                    parseState: parseState,
                    showVideoDetail: showVideoDetail,
                    l10n: l10n,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSearchLayout({
    required ParseState parseState,
    required AppLocalizations l10n,
  }) {
    final spacing = context.appSpacing;
    final inputDocked = _shouldDockInput(parseState);

    return LayoutBuilder(
      builder: (context, constraints) {
        final mobileLayout = constraints.maxWidth < AppTheme.desktopBreakpoint;
        final compact = constraints.maxWidth < _compactSearchBreakpoint;
        final inputBar = _SearchInputHost(
          docked: !mobileLayout && inputDocked,
          maxWidth: constraints.maxWidth,
          child: _buildInputBar(
            l10n,
            parseState,
            docked: inputDocked,
            compact: compact,
            showSubmitButton: !mobileLayout,
          ),
        );

        if (mobileLayout) {
          final dockedTopPadding = spacing.xs;
          final reservedInputHeight =
              dockedTopPadding + _dockedSearchBarHeight + spacing.xs;

          return Stack(
            children: [
              Positioned.fill(
                child: AnimatedPadding(
                  duration: _searchBarAnimationDuration,
                  curve: Curves.easeInOutCubic,
                  padding: EdgeInsets.only(
                    top: inputDocked ? reservedInputHeight : 0,
                  ),
                  child: AnimatedSwitcher(
                    duration: _contentSwitchDuration,
                    child: _buildContent(
                      parseState: parseState,
                      showVideoDetail: null,
                      l10n: l10n,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: AnimatedAlign(
                  duration: _searchBarAnimationDuration,
                  curve: Curves.easeInOutCubic,
                  alignment:
                      inputDocked ? Alignment.topCenter : Alignment.center,
                  child: AnimatedPadding(
                    duration: _searchBarAnimationDuration,
                    curve: Curves.easeInOutCubic,
                    padding: EdgeInsets.fromLTRB(
                      spacing.md,
                      inputDocked ? dockedTopPadding : 0,
                      spacing.md,
                      0,
                    ),
                    child: inputBar,
                  ),
                ),
              ),
            ],
          );
        }

        final dockedTopPadding = spacing.sm;
        final reservedInputHeight =
            dockedTopPadding + _dockedSearchBarHeight + spacing.xs;

        return Stack(
          children: [
            Positioned.fill(
              child: AnimatedPadding(
                duration: _searchBarAnimationDuration,
                curve: Curves.easeInOutCubic,
                padding: EdgeInsets.only(
                  top: inputDocked ? reservedInputHeight : 0,
                ),
                child: AnimatedSwitcher(
                  duration: _contentSwitchDuration,
                  child: _buildContent(
                    parseState: parseState,
                    showVideoDetail: null,
                    l10n: l10n,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedAlign(
                duration: _searchBarAnimationDuration,
                curve: Curves.easeInOutCubic,
                alignment: inputDocked ? Alignment.topCenter : Alignment.center,
                child: AnimatedPadding(
                  duration: _searchBarAnimationDuration,
                  curve: Curves.easeInOutCubic,
                  padding: EdgeInsets.fromLTRB(
                    spacing.lg,
                    inputDocked ? dockedTopPadding : 0,
                    spacing.lg,
                    0,
                  ),
                  child: inputBar,
                ),
              ),
            ),
          ],
        );
      },
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
        showBackButton: true,
        onBack: _backToResults,
      );
    }

    if (_isSearching) {
      return _SearchLoadingState(
        key: const ValueKey('searching'),
        label: l10n.searching,
      );
    }

    final errorMessage = parseState.whenOrNull(error: (msg) => msg);
    if (errorMessage != null) {
      return Padding(
        key: const ValueKey('search_error'),
        padding: EdgeInsets.symmetric(horizontal: context.appSpacing.lg),
        child: Align(
          alignment: Alignment.topCenter,
          child: _SearchErrorBanner(message: errorMessage),
        ),
      );
    }

    if (_searchResults.isNotEmpty) {
      return SearchResultList(
        key: ValueKey('results_$_currentKeyword'),
        results: _searchResults,
        currentPage: _currentPage,
        totalPages: _totalPages,
        onVideoTap: _onVideoTap,
        onLoadMore: _loadNextSearchPage,
        isLoadingMore: _isLoadingMore,
        loadMoreErrorMessage: _loadMoreErrorMessage,
        onRetryLoadMore: _loadNextSearchPage,
        listStorageKey: 'search_results_$_currentKeyword',
      );
    }

    if (_hasSubmittedInput && _currentKeyword.isNotEmpty) {
      return _SearchEmptyResultState(
        key: const ValueKey('empty_search_result'),
        title: l10n.searchNoResultsTitle,
        subtitle: l10n.searchNoResultsSubtitle,
      );
    }

    return const SizedBox.shrink(key: ValueKey('empty_search_content'));
  }

  bool _shouldDockInput(ParseState parseState) {
    final hasActiveParseState = parseState.when(
      idle: () => false,
      parsing: () => true,
      success: (_) => true,
      selectingPages: (_, __) => true,
      error: (_) => true,
    );

    return _isSearching ||
        _searchResults.isNotEmpty ||
        hasActiveParseState ||
        (_focusNode.hasFocus && _currentKeyword.isNotEmpty) ||
        (_hasSubmittedInput && _hasInputText);
  }

  // ── Input bar ───────────────────────────────────────────────────────

  Widget _buildInputBar(
    AppLocalizations l10n,
    ParseState parseState, {
    required bool docked,
    required bool compact,
    required bool showSubmitButton,
  }) {
    final isParsing = parseState.whenOrNull(parsing: () => true) == true;
    final spacing = context.appSpacing;
    final palette = context.appPalette;
    final radii = context.appRadii;
    final depth = context.appDepth;
    final showClearButton = _hasSubmittedInput && _hasInputText;

    final field = DecoratedBox(
      key: const ValueKey('search_input_surface'),
      decoration: BoxDecoration(
        color: palette.surfacePrimary.withValues(alpha: 0.58),
        borderRadius: radii.largeRadius,
        border: Border.all(
          color: palette.borderSubtle.withValues(alpha: 0.78),
          width: depth.outline,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: l10n.parseInput,
          filled: false,
          prefixIcon: Icon(
            Icons.manage_search_rounded,
            color: palette.textSecondary,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showClearButton)
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: l10n.clearSearchInput,
                  onPressed: isParsing ? null : _handleClearSearchInput,
                ),
              IconButton(
                icon: const Icon(Icons.content_paste_rounded),
                tooltip: l10n.pasteFromClipboard,
                onPressed: isParsing ? null : _onPaste,
              ),
            ],
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
        textInputAction: TextInputAction.search,
        onEditingComplete: () {},
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

    final content = !showSubmitButton
        ? field
        : compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  field,
                  SizedBox(height: spacing.sm),
                  SizedBox(width: double.infinity, child: submit),
                ],
              )
            : Row(
                children: [
                  Expanded(child: field),
                  SizedBox(width: spacing.sm),
                  submit,
                ],
              );

    return AppPanel(
      key: const ValueKey('search_bar_surface'),
      padding: EdgeInsets.all(docked ? spacing.xxs : spacing.sm),
      borderRadius: radii.largeRadius,
      child: content,
    );
  }
}

class _SearchEmptyResultState extends StatelessWidget {
  const _SearchEmptyResultState({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: AppPanel(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.manage_search_rounded,
                size: 36,
                color: palette.textMuted,
              ),
              SizedBox(height: spacing.sm),
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchInputHost extends StatelessWidget {
  const _SearchInputHost({
    required this.docked,
    required this.maxWidth,
    required this.child,
  });

  final bool docked;
  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final availableWidth =
        (maxWidth - spacing.lg * 2).clamp(0.0, maxWidth).toDouble();
    final centeredWidth =
        availableWidth.clamp(0.0, _centeredSearchMaxWidth).toDouble();

    return AnimatedContainer(
      duration: _searchBarAnimationDuration,
      curve: Curves.easeInOutCubic,
      width: docked ? availableWidth : centeredWidth,
      child: child,
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
