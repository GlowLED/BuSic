import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_panel.dart';
import '../../../../shared/widgets/media_cover.dart';
import '../../domain/models/playlist.dart';

/// A glass-like playlist card shared by playlist list style surfaces.
class PlaylistTile extends StatefulWidget {
  const PlaylistTile({
    super.key,
    required this.playlist,
    this.onTap,
    this.onLongPress,
  });

  final Playlist playlist;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  State<PlaylistTile> createState() => _PlaylistTileState();
}

class _PlaylistTileState extends State<PlaylistTile> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final depth = context.appDepth;
    final spacing = context.appSpacing;
    final hasInteraction = widget.onTap != null || widget.onLongPress != null;

    var topColor = palette.surfaceElevated.withValues(alpha: 0.98);
    var bottomColor = palette.surfaceSecondary.withValues(alpha: 0.94);

    if (widget.playlist.isFavorite) {
      topColor = Color.lerp(topColor, palette.accentSoft, 0.62)!;
      bottomColor = Color.lerp(bottomColor, palette.surfaceElevated, 0.58)!;
    }

    if (_isHovered) {
      topColor = Color.alphaBlend(palette.overlayMedium, topColor);
      bottomColor = Color.alphaBlend(palette.overlaySoft, bottomColor);
    }

    if (_isPressed) {
      topColor = Color.alphaBlend(palette.overlayStrong, topColor);
      bottomColor = Color.alphaBlend(palette.overlayMedium, bottomColor);
    }

    final borderColor = widget.playlist.isFavorite
        ? palette.accentStrong.withValues(alpha: 0.5)
        : _isHovered
            ? palette.borderStrong.withValues(alpha: 0.98)
            : palette.borderSubtle.withValues(alpha: 0.92);

    final glowShadow = BoxShadow(
      color: palette.coverGlow.withValues(
          alpha: widget.playlist.isFavorite
              ? 0.24
              : _isHovered
                  ? 0.14
                  : 0.08),
      blurRadius: depth.glowBlur * 0.36,
      spreadRadius: depth.glowSpread * 0.28,
    );

    return AppPanel(
      padding: EdgeInsets.zero,
      borderRadius: context.appRadii.largeRadius,
      backgroundColors: [topColor, bottomColor],
      borderColor: borderColor,
      borderWidth:
          widget.playlist.isFavorite ? depth.outlineStrong : depth.outline,
      boxShadow: [...depth.panelShadow, glowShadow],
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onHover: hasInteraction
              ? (value) {
                  if (_isHovered == value) return;
                  setState(() {
                    _isHovered = value;
                  });
                }
              : null,
          onHighlightChanged: hasInteraction
              ? (value) {
                  if (_isPressed == value) return;
                  setState(() {
                    _isPressed = value;
                  });
                }
              : null,
          borderRadius: context.appRadii.largeRadius,
          child: Padding(
            padding: EdgeInsets.all(spacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MediaCover(
                        coverUrl: widget.playlist.coverUrl,
                        borderRadius: context.appRadii.largeRadius,
                        placeholderIcon: widget.playlist.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.library_music_rounded,
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  palette.backgroundPrimary
                                      .withValues(alpha: 0.08),
                                  palette.backgroundPrimary
                                      .withValues(alpha: 0.72),
                                ],
                              ),
                              borderRadius: context.appRadii.largeRadius,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: spacing.sm,
                        bottom: spacing.sm,
                        child: _PlaylistInfoPill(
                          icon: Icons.queue_music_rounded,
                          label: context.l10n
                              .songsTotal(widget.playlist.songCount),
                        ),
                      ),
                      if (widget.playlist.isFavorite)
                        Positioned(
                          top: spacing.sm,
                          right: spacing.sm,
                          child: Tooltip(
                            message: context.l10n.myFavorites,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color:
                                    palette.dangerSoft.withValues(alpha: 0.92),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: palette.danger.withValues(alpha: 0.34),
                                  width: depth.outline,
                                ),
                              ),
                              child: Icon(
                                Icons.favorite_rounded,
                                size: 18,
                                color: palette.danger,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: spacing.sm),
                Text(
                  widget.playlist.name,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: palette.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  context.l10n.songsTotal(widget.playlist.songCount),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistInfoPill extends StatelessWidget {
  const _PlaylistInfoPill({
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
        color: palette.backgroundPrimary.withValues(alpha: 0.72),
        borderRadius: context.appRadii.pillRadius,
        border: Border.all(
          color: palette.borderSubtle.withValues(alpha: 0.82),
          width: context.appDepth.outline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: palette.textPrimary,
          ),
          SizedBox(width: spacing.xxs),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
