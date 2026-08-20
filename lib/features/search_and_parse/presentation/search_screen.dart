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
const _centeredSearchMaxWidth = 720.0;
const _dockedSearchBarHeight = 56.0;
const _searchInputHeight = 48.0;
const _submitIconHoverDuration = Duration(milliseconds: 180);

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
      final searchResult = await ref
          .read(parseNotifierProvider.notifier)
          .searchVideos(keyword, page: nextPage, updateStateOnError: false);
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
            ? _buildSearchLayout(parseState: parseState, l10n: l10n)
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
        final inputBar = _SearchInputHost(
          docked: !mobileLayout && inputDocked,
          maxWidth: constraints.maxWidth,
          child: _buildInputBar(l10n, parseState),
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
                  alignment: inputDocked
                      ? Alignment.topCenter
                      : Alignment.center,
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

  Widget _buildInputBar(AppLocalizations l10n, ParseState parseState) {
    final isParsing = parseState.whenOrNull(parsing: () => true) == true;
    final spacing = context.appSpacing;
    final radii = context.appRadii;
    final showClearButton = _hasSubmittedInput && _hasInputText;

    final field = SizedBox(
      height: _searchInputHeight,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: l10n.parseInput,
          filled: false,
          fillColor: Colors.transparent,
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
              _SearchSubmitIconButton(
                isParsing: isParsing,
                enabled: _hasInputText && !isParsing,
                onPressed: _handleSubmit,
                tooltip: l10n.search,
              ),
            ],
          ),
          suffixIconConstraints: const BoxConstraints(
            minHeight: _searchInputHeight,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: spacing.sm),
        ),
        textInputAction: TextInputAction.search,
        onEditingComplete: () {},
        onSubmitted: (_) => _handleSubmit(),
        enabled: !isParsing,
      ),
    );

    return AppPanel(
      key: const ValueKey('search_bar_surface'),
      padding: EdgeInsets.all(spacing.xs),
      borderRadius: radii.largeRadius,
      child: field,
    );
  }
}

class _SearchSubmitIconButton extends StatefulWidget {
  const _SearchSubmitIconButton({
    required this.isParsing,
    required this.enabled,
    required this.onPressed,
    required this.tooltip,
  });

  final bool isParsing;
  final bool enabled;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  State<_SearchSubmitIconButton> createState() =>
      _SearchSubmitIconButtonState();
}

class _SearchSubmitIconButtonState extends State<_SearchSubmitIconButton> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value || !widget.enabled) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final radii = context.appRadii;
    final enabled = widget.enabled;
    final baseColor = enabled ? palette.textSecondary : palette.textMuted;
    final targetColor = enabled && _hovered
        ? context.colorScheme.primary
        : baseColor;

    final icon = widget.isParsing
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: context.colorScheme.primary,
            ),
          )
        : TweenAnimationBuilder<Color?>(
            duration: _submitIconHoverDuration,
            curve: Curves.easeOutCubic,
            tween: ColorTween(begin: baseColor, end: targetColor),
            builder: (context, color, _) {
              return Icon(
                Icons.search_rounded,
                color: color ?? baseColor,
              );
            },
          );

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: enabled ? (_) => _setHovered(true) : null,
      onHover: enabled ? (_) => _setHovered(true) : null,
      onExit: enabled ? (_) => _setHovered(false) : null,
      child: IconButton(
        onPressed: enabled ? widget.onPressed : null,
        tooltip: widget.tooltip,
        icon: icon,
        style: IconButton.styleFrom(
          foregroundColor: baseColor,
          disabledForegroundColor: palette.textMuted,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          minimumSize: const Size.square(40),
          shape: RoundedRectangleBorder(
            borderRadius: radii.mediumRadius,
          ),
        ),
      ),
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
    final availableWidth = (maxWidth - spacing.lg * 2)
        .clamp(0.0, maxWidth)
        .toDouble();
    final centeredWidth = availableWidth
        .clamp(0.0, _centeredSearchMaxWidth)
        .toDouble();

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
  const _SearchLoadingState({super.key, required this.label});

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
