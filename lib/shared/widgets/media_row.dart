import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_panel.dart';

/// Shared horizontal media row used by songs and search results.
class MediaRow extends StatefulWidget {
  const MediaRow({
    super.key,
    required this.cover,
    required this.title,
    this.subtitle,
    this.badges = const [],
    this.leadingAccessory,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.isActive = false,
    this.isSelected = false,
    this.enabled = true,
    this.padding,
  });

  final Widget cover;
  final Widget title;
  final Widget? subtitle;
  final List<Widget> badges;
  final Widget? leadingAccessory;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isActive;
  final bool isSelected;
  final bool enabled;
  final EdgeInsetsGeometry? padding;

  @override
  State<MediaRow> createState() => _MediaRowState();
}

class _MediaRowState extends State<MediaRow> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final depth = context.appDepth;
    final radii = context.appRadii;
    final spacing = context.appSpacing;
    final hasSurfaceInteraction =
        widget.enabled && (widget.onTap != null || widget.onLongPress != null);

    final baseTop = palette.surfaceElevated.withValues(alpha: 0.96);
    final baseBottom = palette.surfaceSecondary.withValues(alpha: 0.92);

    var topColor = baseTop;
    var bottomColor = baseBottom;

    if (widget.isSelected) {
      topColor = Color.lerp(topColor, palette.accentSoft, 0.72)!;
      bottomColor = Color.lerp(bottomColor, palette.surfaceElevated, 0.55)!;
    }

    if (widget.isActive) {
      topColor = Color.lerp(topColor, palette.accentSoft, 0.52)!;
      bottomColor = Color.lerp(bottomColor, palette.surfaceElevated, 0.72)!;
    }

    if (_isHovered && widget.enabled) {
      topColor = Color.alphaBlend(palette.overlayMedium, topColor);
      bottomColor = Color.alphaBlend(palette.overlaySoft, bottomColor);
    }

    if (_isPressed && widget.enabled) {
      topColor = Color.alphaBlend(palette.overlayStrong, topColor);
      bottomColor = Color.alphaBlend(palette.overlayMedium, bottomColor);
    }

    final borderColor = widget.enabled
        ? widget.isActive
            ? palette.accentStrong.withValues(alpha: 0.82)
            : widget.isSelected
                ? palette.accentStrong.withValues(alpha: 0.58)
                : palette.borderSubtle.withValues(alpha: _isHovered ? 1 : 0.9)
        : palette.borderSubtle.withValues(alpha: 0.52);

    final glowShadow = BoxShadow(
      color: palette.coverGlow.withValues(alpha: 0.22),
      blurRadius: depth.glowBlur * 0.42,
      spreadRadius: depth.glowSpread * 0.35,
    );

    return Semantics(
      container: true,
      button: widget.onTap != null,
      enabled: widget.enabled,
      selected: widget.isSelected,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.58,
        child: AppPanel(
          padding: EdgeInsets.zero,
          borderRadius: radii.largeRadius,
          blurSigma: 14,
          backgroundColors: [topColor, bottomColor],
          borderColor: borderColor,
          borderWidth: widget.isActive ? depth.outlineStrong : depth.outline,
          boxShadow:
              widget.isActive ? [...depth.panelShadow, glowShadow] : null,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: hasSurfaceInteraction ? widget.onTap : null,
              onLongPress: hasSurfaceInteraction ? widget.onLongPress : null,
              onHover: hasSurfaceInteraction
                  ? (value) {
                      if (_isHovered == value) return;
                      setState(() {
                        _isHovered = value;
                      });
                    }
                  : null,
              onHighlightChanged: hasSurfaceInteraction
                  ? (value) {
                      if (_isPressed == value) return;
                      setState(() {
                        _isPressed = value;
                      });
                    }
                  : null,
              borderRadius: radii.largeRadius,
              child: Padding(
                padding: widget.padding ??
                    EdgeInsets.symmetric(
                      horizontal: spacing.sm,
                      vertical: spacing.sm,
                    ),
                child: Row(
                  children: [
                    if (widget.leadingAccessory != null) ...[
                      widget.leadingAccessory!,
                      SizedBox(width: spacing.sm),
                    ],
                    _MediaCoverFrame(
                      isActive: widget.isActive,
                      child: widget.cover,
                    ),
                    SizedBox(width: spacing.md),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.title,
                          if (widget.subtitle != null) ...[
                            SizedBox(height: spacing.xxs),
                            widget.subtitle!,
                          ],
                          if (widget.badges.isNotEmpty) ...[
                            SizedBox(height: spacing.sm),
                            Wrap(
                              spacing: spacing.xs,
                              runSpacing: spacing.xs,
                              children: widget.badges,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.trailing != null) ...[
                      SizedBox(width: spacing.sm),
                      widget.trailing!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaCoverFrame extends StatelessWidget {
  const _MediaCoverFrame({
    required this.child,
    required this.isActive,
  });

  final Widget child;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final depth = context.appDepth;

    return Container(
      decoration: BoxDecoration(
        borderRadius: context.appRadii.mediumRadius,
        border: Border.all(
          color: isActive
              ? palette.accentStrong.withValues(alpha: 0.36)
              : palette.borderSubtle.withValues(alpha: 0.88),
          width: depth.outline,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: palette.coverGlow.withValues(alpha: 0.2),
                  blurRadius: depth.glowBlur * 0.28,
                  spreadRadius: depth.glowSpread * 0.18,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: context.appRadii.mediumRadius,
        child: child,
      ),
    );
  }
}
