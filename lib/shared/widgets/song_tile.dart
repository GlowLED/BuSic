import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'media_cover.dart';
import 'media_row.dart';

/// A reusable song media row shared by playlist and search-related screens.
class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    this.coverUrl,
    required this.title,
    required this.artist,
    this.duration,
    this.isPlaying = false,
    this.isCached = false,
    this.qualityLabel,
    this.isSelected = false,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.onMorePressed,
    this.isFavorited,
    this.onFavoritePressed,
  });

  /// Song cover image URL.
  final String? coverUrl;

  /// Song title to display.
  final String title;

  /// Song artist to display.
  final String artist;

  /// Formatted duration string (e.g., "3:42").
  final String? duration;

  /// Whether this song is currently playing.
  final bool isPlaying;

  /// Whether this song has been cached locally.
  final bool isCached;

  /// Quality label for the cached version (e.g., "192kbps").
  final String? qualityLabel;

  /// Whether the row is visually selected.
  final bool isSelected;

  /// Whether the row is enabled.
  final bool enabled;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  /// Callback when the tile is long-pressed.
  final VoidCallback? onLongPress;

  /// Callback when the more/options button is tapped.
  final VoidCallback? onMorePressed;

  /// Whether this song is favorited (null = don't show heart button).
  final bool? isFavorited;

  /// Callback when the favorite/heart button is tapped.
  final VoidCallback? onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final spacing = context.appSpacing;
    final textTheme = context.textTheme;
    final l10n = context.l10n;

    return MediaRow(
      cover: MediaCover(
        coverUrl: coverUrl,
        width: 58,
        height: 58,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleSmall?.copyWith(
                color: isPlaying ? palette.accentStrong : palette.textPrimary,
                fontWeight: isPlaying ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          if (isPlaying) ...[
            SizedBox(width: spacing.xs),
            Icon(
              Icons.graphic_eq_rounded,
              size: 16,
              color: palette.accentStrong,
            ),
          ],
        ],
      ),
      subtitle: Text(
        artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodyMedium?.copyWith(
          color: palette.textSecondary,
        ),
      ),
      badges: [
        if (isCached)
          _SongMetaBadge(
            icon: Icons.download_done_rounded,
            label: (qualityLabel != null && qualityLabel!.isNotEmpty)
                ? qualityLabel!
                : l10n.cached,
          ),
      ],
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (duration != null) ...[
            Text(
              duration!,
              style: textTheme.labelMedium?.copyWith(
                color: palette.textMuted,
              ),
            ),
            SizedBox(height: spacing.xs),
          ],
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isFavorited != null) ...[
                _SongActionButton(
                  icon: isFavorited!
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  tooltip: isFavorited!
                      ? l10n.removeFromFavorites
                      : l10n.addToFavorites,
                  onPressed: enabled ? onFavoritePressed : null,
                  backgroundColor: isFavorited!
                      ? palette.dangerSoft
                      : palette.surfaceSecondary.withValues(alpha: 0.88),
                  borderColor: isFavorited!
                      ? palette.danger.withValues(alpha: 0.36)
                      : palette.borderSubtle.withValues(alpha: 0.88),
                  iconColor:
                      isFavorited! ? palette.danger : palette.textSecondary,
                ),
                SizedBox(width: spacing.xs),
              ],
              _SongActionButton(
                icon:
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                tooltip: isPlaying ? l10n.pause : l10n.play,
                onPressed: enabled ? onTap : null,
                backgroundColor: palette.accentStrong,
                borderColor: palette.accentStrong.withValues(alpha: 0.7),
                iconColor: context.colorScheme.onPrimary,
                isPrimary: true,
              ),
              if (onMorePressed != null) ...[
                SizedBox(width: spacing.xs),
                _SongActionButton(
                  icon: Icons.more_horiz_rounded,
                  tooltip: l10n.moreActions,
                  onPressed: enabled ? onMorePressed : null,
                  backgroundColor:
                      palette.surfaceSecondary.withValues(alpha: 0.88),
                  borderColor: palette.borderSubtle.withValues(alpha: 0.88),
                  iconColor: palette.textSecondary,
                ),
              ],
            ],
          ),
        ],
      ),
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      isActive: isPlaying,
      isSelected: isSelected,
      enabled: enabled,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.sm,
      ),
    );
  }
}

class _SongMetaBadge extends StatelessWidget {
  const _SongMetaBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final spacing = context.appSpacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.xs,
        vertical: spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: palette.successSoft,
        borderRadius: context.appRadii.pillRadius,
        border: Border.all(
          color: palette.success.withValues(alpha: 0.26),
          width: context.appDepth.outline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: palette.success,
          ),
          SizedBox(width: spacing.xxs),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: palette.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _SongActionButton extends StatelessWidget {
  const _SongActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    this.isPrimary = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final enabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: isPrimary ? 38 : 34,
        height: isPrimary ? 38 : 34,
        child: Material(
          color: enabled ? backgroundColor : palette.accentMuted,
          borderRadius: context.appRadii.mediumRadius,
          child: InkWell(
            borderRadius: context.appRadii.mediumRadius,
            onTap: onPressed,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: context.appRadii.mediumRadius,
                border: Border.all(
                  color: enabled ? borderColor : palette.borderSubtle,
                  width: context.appDepth.outline,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: isPrimary ? 22 : 18,
                  color: enabled ? iconColor : palette.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
