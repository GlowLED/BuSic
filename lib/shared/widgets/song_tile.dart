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
                  iconColor:
                      isFavorited! ? palette.danger : palette.textSecondary,
                ),
                SizedBox(width: spacing.xxs),
              ],
              if (onMorePressed != null)
                _SongActionButton(
                  icon: Icons.more_vert_rounded,
                  tooltip: l10n.moreActions,
                  onPressed: enabled ? onMorePressed : null,
                  iconColor: palette.textSecondary,
                ),
            ],
          ),
        ],
      ),
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      isActive: isPlaying,
      isSelected: isSelected,
      enabled: enabled,
      embedded: true,
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

/// Flat, borderless icon button used in a song row's trailing actions.
class _SongActionButton extends StatelessWidget {
  const _SongActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.iconColor,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final enabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onPressed,
        radius: 22,
        containedInkWell: true,
        borderRadius: context.appRadii.pillRadius,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: enabled ? iconColor : palette.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
