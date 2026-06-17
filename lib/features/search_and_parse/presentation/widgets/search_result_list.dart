import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/media_cover.dart';
import '../../../../shared/widgets/media_row.dart';
import '../../domain/models/bvid_info.dart';

/// Search result list with infinite scrolling.
///
/// Scrolling near the bottom triggers [onLoadMore] to append the next page,
/// while [_MobileLoadMoreFooter] reflects the loading / end / retry state.
class SearchResultList extends StatelessWidget {
  const SearchResultList({
    super.key,
    required this.results,
    required this.currentPage,
    required this.totalPages,
    required this.onVideoTap,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.loadMoreErrorMessage,
    this.onRetryLoadMore,
    this.listStorageKey,
  });

  final List<BvidInfo> results;
  final int currentPage;
  final int totalPages;
  final ValueChanged<BvidInfo> onVideoTap;
  final Future<void> Function()? onLoadMore;
  final bool isLoadingMore;
  final String? loadMoreErrorMessage;
  final Future<void> Function()? onRetryLoadMore;
  final String? listStorageKey;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final hasMore = currentPage < totalPages;

    return _SearchResultsListView(
      results: results,
      currentPage: currentPage,
      bottomPadding: spacing.sm,
      onVideoTap: onVideoTap,
      storageKey: listStorageKey ?? 'search_results_infinite',
      useScrollController: true,
      onLoadMore: hasMore && !isLoadingMore && loadMoreErrorMessage == null
          ? onLoadMore
          : null,
      footer: _MobileLoadMoreFooter(
        isLoading: isLoadingMore,
        isEnd: !hasMore,
        errorMessage: loadMoreErrorMessage,
        onRetry: onRetryLoadMore,
      ),
    );
  }
}

class _SearchResultsListView extends StatefulWidget {
  const _SearchResultsListView({
    required this.results,
    required this.currentPage,
    required this.bottomPadding,
    required this.onVideoTap,
    this.storageKey,
    this.useScrollController = false,
    this.onLoadMore,
    this.footer,
  });

  final List<BvidInfo> results;
  final int currentPage;
  final double bottomPadding;
  final ValueChanged<BvidInfo> onVideoTap;
  final String? storageKey;
  final bool useScrollController;
  final Future<void> Function()? onLoadMore;
  final Widget? footer;

  @override
  State<_SearchResultsListView> createState() => _SearchResultsListViewState();
}

class _SearchResultsListViewState extends State<_SearchResultsListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final onLoadMore = widget.onLoadMore;
    if (onLoadMore == null || !_scrollController.hasClients) return;

    if (_scrollController.position.extentAfter < 200) {
      onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final itemCount = widget.results.length + (widget.footer == null ? 0 : 1);

    return ListView.separated(
      key: PageStorageKey<String>(
        widget.storageKey ?? 'search_results_page_${widget.currentPage}',
      ),
      controller: widget.useScrollController ? _scrollController : null,
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        spacing.md,
        spacing.md,
        widget.bottomPadding,
      ),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        if (index >= widget.results.length) {
          return widget.footer!;
        }

        final video = widget.results[index];

        return MediaRow(
          cover: MediaCover(
            coverUrl: video.coverUrl,
            width: 96,
            height: 58,
            placeholderIcon: Icons.video_library_rounded,
          ),
          title: Text(
            video.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleSmall,
          ),
          subtitle: Text(
            '${video.owner} · '
            '${Formatters.formatDuration(Duration(seconds: video.duration))}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.appPalette.textSecondary,
            ),
          ),
          trailing: _SearchResultTrailing(
            onTap: () => widget.onVideoTap(video),
          ),
          onTap: () => widget.onVideoTap(video),
          embedded: true,
        );
      },
    );
  }
}

class _MobileLoadMoreFooter extends StatelessWidget {
  const _MobileLoadMoreFooter({
    required this.isLoading,
    required this.isEnd,
    required this.errorMessage,
    required this.onRetry,
  });

  final bool isLoading;
  final bool isEnd;
  final String? errorMessage;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final spacing = context.appSpacing;

    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: spacing.sm),
            Text(
              context.l10n.searchLoadingMore,
              style: context.textTheme.labelMedium?.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                errorMessage!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelMedium?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ),
            SizedBox(width: spacing.xs),
            TextButton(
              onPressed: onRetry == null ? null : () => onRetry!.call(),
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      );
    }

    if (isEnd) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.md),
        child: Center(
          child: Text(
            '— ${context.l10n.searchAllResultsLoaded} —',
            style: context.textTheme.labelSmall?.copyWith(
              color: palette.textMuted,
            ),
          ),
        ),
      );
    }

    return SizedBox(height: spacing.md);
  }
}

class _SearchResultTrailing extends StatelessWidget {
  const _SearchResultTrailing({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: palette.surfaceSecondary.withValues(alpha: 0.88),
        borderRadius: context.appRadii.mediumRadius,
        child: InkWell(
          borderRadius: context.appRadii.mediumRadius,
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: context.appRadii.mediumRadius,
              border: Border.all(
                color: palette.borderSubtle.withValues(alpha: 0.88),
                width: context.appDepth.outline,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.chevron_right_rounded,
                color: palette.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
