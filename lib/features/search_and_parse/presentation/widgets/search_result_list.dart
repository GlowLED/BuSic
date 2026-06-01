import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/media_cover.dart';
import '../../../../shared/widgets/media_row.dart';
import '../../domain/models/bvid_info.dart';

/// Search result list with pagination controls.
class SearchResultList extends StatelessWidget {
  const SearchResultList({
    super.key,
    required this.results,
    required this.currentPage,
    required this.totalPages,
    required this.onVideoTap,
    required this.onPageChanged,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.loadMoreErrorMessage,
    this.onRetryLoadMore,
    this.useInfiniteScroll = false,
    this.listStorageKey,
  });

  final List<BvidInfo> results;
  final int currentPage;
  final int totalPages;
  final ValueChanged<BvidInfo> onVideoTap;
  final ValueChanged<int> onPageChanged;
  final Future<void> Function()? onLoadMore;
  final bool isLoadingMore;
  final String? loadMoreErrorMessage;
  final Future<void> Function()? onRetryLoadMore;
  final bool useInfiniteScroll;
  final String? listStorageKey;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;

    if (!useInfiniteScroll) {
      return Column(
        children: [
          Expanded(
            child: _SearchResultsListView(
              results: results,
              currentPage: currentPage,
              bottomPadding: spacing.sm,
              onVideoTap: onVideoTap,
            ),
          ),
          _PaginationBar(
            currentPage: currentPage,
            totalPages: totalPages,
            onPageChanged: onPageChanged,
          ),
        ],
      );
    }

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

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final spacing = context.appSpacing;

    return Padding(
      key: const ValueKey('search_pagination_bar'),
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        0,
        spacing.md,
        spacing.md,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Row(
          children: [
            _PaginationIconButton(
              icon: Icons.chevron_left_rounded,
              tooltip: context.l10n.previousPage,
              onTap:
                  currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
            ),
            SizedBox(width: spacing.xs),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageNumbers(context),
                ),
              ),
            ),
            SizedBox(width: spacing.xs),
            _PaginationIconButton(
              icon: Icons.chevron_right_rounded,
              tooltip: context.l10n.nextPage,
              onTap: currentPage < totalPages
                  ? () => onPageChanged(currentPage + 1)
                  : null,
            ),
            SizedBox(width: spacing.sm),
            if (context.isDesktop)
              _DesktopJumpField(
                currentPage: currentPage,
                totalPages: totalPages,
                onPageChanged: onPageChanged,
              )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context) {
    final pages = <Widget>[];
    const siblings = 2;

    final rangeStart = (currentPage - siblings).clamp(1, totalPages);
    final rangeEnd = (currentPage + siblings).clamp(1, totalPages);

    if (rangeStart > 1) {
      pages.add(_PageButton(
        page: 1,
        isActive: currentPage == 1,
        onTap: currentPage == 1 ? null : () => onPageChanged(1),
      ));
      if (rangeStart > 2) {
        pages.add(const _EllipsisDot());
      }
    }

    for (var page = rangeStart; page <= rangeEnd; page++) {
      pages.add(_PageButton(
        page: page,
        isActive: currentPage == page,
        onTap: currentPage == page ? null : () => onPageChanged(page),
      ));
    }

    if (rangeEnd < totalPages) {
      if (rangeEnd < totalPages - 1) {
        pages.add(const _EllipsisDot());
      }
      pages.add(_PageButton(
        page: totalPages,
        isActive: currentPage == totalPages,
        onTap:
            currentPage == totalPages ? null : () => onPageChanged(totalPages),
      ));
    }

    return pages;
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

class _PaginationIconButton extends StatelessWidget {
  const _PaginationIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final enabled = onTap != null;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Material(
          color: enabled
              ? palette.surfaceSecondary.withValues(alpha: 0.88)
              : palette.accentMuted,
          borderRadius: context.appRadii.mediumRadius,
          child: InkWell(
            borderRadius: context.appRadii.mediumRadius,
            onTap: onTap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: context.appRadii.mediumRadius,
                border: Border.all(
                  color: enabled
                      ? palette.borderSubtle.withValues(alpha: 0.88)
                      : palette.borderSubtle,
                  width: context.appDepth.outline,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: enabled ? palette.textPrimary : palette.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.page,
    required this.isActive,
    required this.onTap,
  });

  final int page;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        width: 36,
        height: 36,
        child: Material(
          color: isActive
              ? palette.accentStrong
              : palette.surfaceSecondary.withValues(alpha: 0.88),
          borderRadius: context.appRadii.mediumRadius,
          child: InkWell(
            borderRadius: context.appRadii.mediumRadius,
            onTap: onTap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: context.appRadii.mediumRadius,
                border: Border.all(
                  color: isActive
                      ? palette.accentStrong.withValues(alpha: 0.72)
                      : palette.borderSubtle.withValues(alpha: 0.86),
                  width: context.appDepth.outline,
                ),
              ),
              child: Center(
                child: Text(
                  '$page',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: isActive
                        ? context.colorScheme.onPrimary
                        : palette.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EllipsisDot extends StatelessWidget {
  const _EllipsisDot();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: Text(
          '…',
          style: context.textTheme.labelLarge?.copyWith(
            color: context.appPalette.textMuted,
          ),
        ),
      ),
    );
  }
}

class _DesktopJumpField extends StatelessWidget {
  const _DesktopJumpField({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 56,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: palette.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: '$currentPage',
              hintStyle: context.textTheme.bodySmall?.copyWith(
                color: palette.textMuted,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 8,
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: (value) {
              final page = int.tryParse(value);
              if (page != null && page >= 1 && page <= totalPages) {
                onPageChanged(page);
              }
            },
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '/ $totalPages',
          style: context.textTheme.labelMedium?.copyWith(
            color: palette.textSecondary,
          ),
        ),
      ],
    );
  }
}
