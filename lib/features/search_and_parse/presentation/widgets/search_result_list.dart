import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_panel.dart';
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
  });

  final List<BvidInfo> results;
  final int currentPage;
  final int totalPages;
  final ValueChanged<BvidInfo> onVideoTap;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            key: PageStorageKey<String>('search_results_page_$currentPage'),
            padding: EdgeInsets.fromLTRB(
              spacing.md,
              spacing.md,
              spacing.md,
              spacing.sm,
            ),
            itemCount: results.length,
            separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
            itemBuilder: (context, index) {
              final video = results[index];

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
                  onTap: () => onVideoTap(video),
                ),
                onTap: () => onVideoTap(video),
              );
            },
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
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        0,
        spacing.md,
        spacing.md,
      ),
      child: AppPanel(
        blurSigma: 14,
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
            else
              _MobileJumpButton(
                totalPages: totalPages,
                onPageChanged: onPageChanged,
              ),
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

class _MobileJumpButton extends StatelessWidget {
  const _MobileJumpButton({
    required this.totalPages,
    required this.onPageChanged,
  });

  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return _PaginationIconButton(
      icon: Icons.edit_rounded,
      tooltip: context.l10n.jumpToPage,
      onTap: () => _showJumpToPageDialog(context),
    );
  }

  Future<void> _showJumpToPageDialog(BuildContext context) async {
    final controller = TextEditingController();
    final l10n = context.l10n;

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.jumpToPage),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.enterPageRange(totalPages),
            labelText: l10n.pageNumberLabel,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onSubmitted: (value) {
            final page = int.tryParse(value);
            if (page != null && page >= 1 && page <= totalPages) {
              Navigator.of(context).pop(page);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final page = int.tryParse(controller.text);
              if (page != null && page >= 1 && page <= totalPages) {
                Navigator.of(context).pop(page);
              }
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (result != null) {
      onPageChanged(result);
    }
  }
}
