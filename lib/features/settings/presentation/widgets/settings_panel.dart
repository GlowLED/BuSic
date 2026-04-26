import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_panel.dart';

/// Console-style settings section used by the settings screen.
class SettingsSectionPanel extends StatelessWidget {
  const SettingsSectionPanel({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.subtitle,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return AppPanel(
      padding: EdgeInsets.all(spacing.md),
      borderRadius: context.appRadii.xLargeRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: palette.accentSoft.withValues(alpha: 0.72),
                  borderRadius: context.appRadii.mediumRadius,
                  border: Border.all(
                    color: palette.accentStrong.withValues(alpha: 0.28),
                    width: context.appDepth.outline,
                  ),
                ),
                child: Icon(icon, size: 20, color: palette.accentStrong),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: spacing.xxs),
                      Text(
                        subtitle!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: spacing.sm),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// A settings row with the BuSic panel visual language.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.body,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? body;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;
    final accent = destructive ? palette.danger : palette.accentStrong;
    final iconBackground =
        destructive ? palette.dangerSoft : palette.surfaceSecondary;
    final active = enabled && (onTap != null || onLongPress != null);

    return Opacity(
      opacity: enabled ? 1 : 0.58,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: context.appRadii.largeRadius,
          onTap: active ? onTap : null,
          onLongPress: active ? onLongPress : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.surfacePrimary.withValues(alpha: 0.42),
              borderRadius: context.appRadii.largeRadius,
              border: Border.all(
                color: palette.borderSubtle.withValues(alpha: 0.72),
                width: context.appDepth.hairline,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: iconBackground.withValues(alpha: 0.88),
                          borderRadius: context.appRadii.mediumRadius,
                        ),
                        child: Icon(icon, size: 19, color: accent),
                      ),
                      SizedBox(width: spacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: context.textTheme.titleSmall?.copyWith(
                                color: destructive
                                    ? palette.danger
                                    : palette.textPrimary,
                              ),
                            ),
                            if (subtitle != null) ...[
                              SizedBox(height: spacing.xxs),
                              Text(
                                subtitle!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: palette.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (trailing != null) ...[
                        SizedBox(width: spacing.sm),
                        trailing!,
                      ],
                    ],
                  ),
                  if (body != null) ...[
                    SizedBox(height: spacing.sm),
                    body!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
