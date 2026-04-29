import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/utils/platform_utils.dart';
import '../../features/auth/presentation/widgets/user_avatar_widget.dart';
import '../../features/player/application/player_notifier.dart';
import '../../features/player/presentation/player_bar.dart';
import '../../l10n/generated/app_localizations.dart';
import '../extensions/context_extensions.dart';
import 'app_panel.dart';

const _navigationAnimationDuration = Duration(milliseconds: 220);
const _navigationAnimationCurve = Curves.easeOutCubic;

/// Main application shell.
///
/// Desktop and mobile share the same navigation language, but use different
/// layouts:
/// - Desktop: custom title bar + control-console sidebar.
/// - Mobile: floating bottom dock.
/// - Both keep [PlayerBar] visible at the bottom.
class ResponsiveScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ResponsiveScaffold({super.key, required this.navigationShell});

  void _onDestinationSelected(int index) {
    final isCurrentBranch = navigationShell.currentIndex == index;
    navigationShell.goBranch(index, initialLocation: isCurrentBranch);
  }

  List<_ShellDestination> _buildDestinations(AppLocalizations l10n) {
    return [
      _ShellDestination(
        icon: Icons.library_music_outlined,
        selectedIcon: Icons.library_music,
        label: l10n.playlists,
      ),
      _ShellDestination(
        icon: Icons.search_outlined,
        selectedIcon: Icons.search,
        label: l10n.search,
      ),
      _ShellDestination(
        icon: Icons.download_outlined,
        selectedIcon: Icons.download,
        label: l10n.downloads,
      ),
      _ShellDestination(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        label: l10n.settings,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final destinations = _buildDestinations(context.l10n);
    final currentIndex = navigationShell.currentIndex;

    if (context.isDesktop) {
      return _DesktopShell(
        navigationShell: navigationShell,
        destinations: destinations,
        currentIndex: currentIndex,
        onDestinationSelected: _onDestinationSelected,
      );
    }

    return _MobileShell(
      navigationShell: navigationShell,
      destinations: destinations,
      currentIndex: currentIndex,
      onDestinationSelected: _onDestinationSelected,
    );
  }
}

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.navigationShell,
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final StatefulNavigationShell navigationShell;
  final List<_ShellDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    const sidebarWidth = 112.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _ShellBackdrop(
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            children: [
              _DesktopTitleBar(
                currentLabel: destinations[currentIndex].label,
              ),
              SizedBox(height: spacing.md),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: sidebarWidth,
                      child: _DesktopSidebar(
                        destinations: destinations,
                        currentIndex: currentIndex,
                        onDestinationSelected: onDestinationSelected,
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Expanded(
                      child: _ShellContentFrame(child: navigationShell),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.md),
              const _ShellPlayerDock(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileShell extends StatelessWidget {
  const _MobileShell({
    required this.navigationShell,
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final StatefulNavigationShell navigationShell;
  final List<_ShellDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _ShellBackdrop(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(child: navigationShell),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    spacing.sm,
                    spacing.sm,
                    spacing.sm,
                    0,
                  ),
                  child: const _ShellPlayerDock(),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      spacing.sm,
                      spacing.sm,
                      spacing.sm,
                      spacing.sm,
                    ),
                    child: _MobileNavDock(
                      destinations: destinations,
                      currentIndex: currentIndex,
                      onDestinationSelected: onDestinationSelected,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopTitleBar extends StatelessWidget {
  const _DesktopTitleBar({required this.currentLabel});

  final String currentLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final spacing = context.appSpacing;
    final textTheme = context.textTheme;

    return _ShellPanel(
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (_) {
                  if (PlatformUtils.isDesktop) {
                    windowManager.startDragging();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.md),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              palette.accentStrong,
                              palette.accentStrong.withValues(alpha: 0.68),
                            ],
                          ),
                          borderRadius: context.appRadii.largeRadius,
                          boxShadow: context.appDepth.coverGlowShadow,
                        ),
                        child: Icon(
                          Icons.graphic_eq_rounded,
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                      SizedBox(width: spacing.md),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.appTitle,
                            style: textTheme.labelLarge?.copyWith(
                              color: palette.textSecondary,
                            ),
                          ),
                          SizedBox(height: spacing.xxs),
                          Text(
                            currentLabel,
                            style: textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (PlatformUtils.isDesktop) ...[
              _WindowButton(
                icon: Icons.minimize_rounded,
                onPressed: () => windowManager.minimize(),
              ),
              _WindowButton(
                icon: Icons.crop_square_rounded,
                onPressed: () async {
                  if (await windowManager.isMaximized()) {
                    await windowManager.unmaximize();
                  } else {
                    await windowManager.maximize();
                  }
                },
              ),
              _WindowButton(
                icon: Icons.close_rounded,
                onPressed: () => windowManager.hide(),
                isClose: true,
              ),
            ],
            SizedBox(width: spacing.xs),
          ],
        ),
      ),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final List<_ShellDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;

    return _ShellPanel(
      padding: EdgeInsets.all(spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: destinations.length,
              separatorBuilder: (_, __) => SizedBox(height: spacing.xs),
              itemBuilder: (context, index) {
                return _DesktopNavigationItem(
                  destination: destinations[index],
                  isSelected: currentIndex == index,
                  onTap: () => onDestinationSelected(index),
                );
              },
            ),
          ),
          SizedBox(height: spacing.sm),
          const _DesktopSidebarStatusCard(),
        ],
      ),
    );
  }
}

class _DesktopNavigationItem extends StatelessWidget {
  const _DesktopNavigationItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final _ShellDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final spacing = context.appSpacing;
    final depth = context.appDepth;
    final baseSurface = palette.surfaceSecondary.withValues(alpha: 0.48);
    final glowShadow = BoxShadow(
      color: palette.coverGlow.withValues(alpha: isSelected ? 1 : 0),
      blurRadius: isSelected ? depth.glowBlur : 0,
      spreadRadius: isSelected ? depth.glowSpread : 0,
    );
    final item = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: context.appRadii.xLargeRadius,
        onTap: onTap,
        child: AnimatedContainer(
          duration: _navigationAnimationDuration,
          curve: _navigationAnimationCurve,
          constraints: const BoxConstraints(minHeight: 64),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.xs,
            vertical: spacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  baseSurface,
                  palette.accentSoft.withValues(alpha: 0.98),
                  isSelected ? 1 : 0,
                )!,
                Color.lerp(
                  baseSurface,
                  palette.surfaceElevated.withValues(alpha: 0.96),
                  isSelected ? 1 : 0,
                )!,
              ],
            ),
            borderRadius: context.appRadii.xLargeRadius,
            border: Border.all(
              color: isSelected
                  ? palette.accentStrong.withValues(alpha: 0.72)
                  : palette.borderSubtle.withValues(alpha: 0.9),
              width: isSelected ? depth.outlineStrong : depth.outline,
            ),
            boxShadow: [glowShadow],
          ),
          child: Center(
            child: _NavigationIconPill(
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
              isSelected: isSelected,
              compact: true,
            ),
          ),
        ),
      ),
    );

    return item;
  }
}

class _DesktopSidebarStatusCard extends ConsumerWidget {
  const _DesktopSidebarStatusCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.appPalette;
    final spacing = context.appSpacing;
    final currentTrack = ref.watch(
      playerNotifierProvider.select((state) => state.currentTrack),
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      decoration: BoxDecoration(
        color: palette.surfaceSecondary.withValues(alpha: 0.56),
        borderRadius: context.appRadii.largeRadius,
        border: Border.all(
          color: palette.borderSubtle.withValues(alpha: 0.9),
          width: context.appDepth.outline,
        ),
      ),
      child: Column(
        children: [
          Icon(
            currentTrack == null
                ? Icons.music_off_rounded
                : Icons.graphic_eq_rounded,
            color: palette.textSecondary,
          ),
          SizedBox(height: spacing.sm),
          const UserAvatarWidget(),
        ],
      ),
    );
  }
}

class _MobileNavDock extends StatelessWidget {
  const _MobileNavDock({
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final List<_ShellDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final spacing = context.appSpacing;

    return Container(
      padding: EdgeInsets.all(spacing.xs),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            palette.surfaceElevated.withValues(alpha: 0.98),
            palette.surfaceSecondary.withValues(alpha: 0.94),
          ],
        ),
        borderRadius: context.appRadii.xLargeRadius,
        border: Border.all(
          color: palette.borderSubtle.withValues(alpha: 0.95),
          width: context.appDepth.outline,
        ),
        boxShadow: context.appDepth.floatingShadow,
      ),
      child: Row(
        children: [
          for (var index = 0; index < destinations.length; index++)
            Expanded(
              child: _MobileNavigationItem(
                destination: destinations[index],
                isSelected: currentIndex == index,
                onTap: () => onDestinationSelected(index),
              ),
            ),
        ],
      ),
    );
  }
}

class _MobileNavigationItem extends StatelessWidget {
  const _MobileNavigationItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final _ShellDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final spacing = context.appSpacing;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: context.appRadii.largeRadius,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.xs,
            vertical: spacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      palette.accentSoft,
                      palette.surfaceElevated,
                    ],
                  )
                : null,
            borderRadius: context.appRadii.largeRadius,
            border: Border.all(
              color: isSelected
                  ? palette.accentStrong.withValues(alpha: 0.68)
                  : Colors.transparent,
              width: context.appDepth.outline,
            ),
            boxShadow: isSelected ? context.appDepth.coverGlowShadow : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavigationIconPill(
                icon: destination.icon,
                selectedIcon: destination.selectedIcon,
                isSelected: isSelected,
                compact: true,
              ),
              SizedBox(height: spacing.xs),
              Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: context.textTheme.labelSmall?.copyWith(
                  color:
                      isSelected ? palette.textPrimary : palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShellPlayerDock extends StatelessWidget {
  const _ShellPlayerDock();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: context.appRadii.xLargeRadius,
        boxShadow: context.appDepth.floatingShadow,
      ),
      child: ClipRRect(
        borderRadius: context.appRadii.xLargeRadius,
        child: const PlayerBar(),
      ),
    );
  }
}

class _ShellContentFrame extends StatelessWidget {
  const _ShellContentFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return AppPanel(
      borderRadius: context.appRadii.xLargeRadius,
      blurSigma: 12,
      backgroundColors: [
        palette.surfacePrimary.withValues(alpha: 0.98),
        palette.backgroundPrimary.withValues(alpha: 0.94),
      ],
      gradientBegin: Alignment.topCenter,
      gradientEnd: Alignment.bottomCenter,
      child: child,
    );
  }
}

class _ShellPanel extends StatelessWidget {
  const _ShellPanel({
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return AppPanel(
      borderRadius: context.appRadii.xLargeRadius,
      blurSigma: 18,
      padding: padding,
      backgroundColors: [
        palette.surfaceElevated.withValues(alpha: 0.96),
        palette.surfaceSecondary.withValues(alpha: 0.92),
      ],
      child: child,
    );
  }
}

class _ShellBackdrop extends StatelessWidget {
  const _ShellBackdrop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.backgroundPrimary,
            palette.backgroundSecondary,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -96,
            left: -72,
            child: _BackdropGlow(
              size: 260,
              color: palette.accentStrong.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            right: -120,
            bottom: -110,
            child: _BackdropGlow(
              size: 320,
              color: palette.coverGlow.withValues(alpha: 0.34),
            ),
          ),
          Positioned(
            top: 120,
            right: 80,
            child: _BackdropGlow(
              size: 180,
              color: palette.overlayStrong.withValues(alpha: 0.2),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _BackdropGlow extends StatelessWidget {
  const _BackdropGlow({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationIconPill extends StatelessWidget {
  const _NavigationIconPill({
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    this.compact = false,
  });

  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final size = compact ? 38.0 : 44.0;

    return AnimatedContainer(
      duration: _navigationAnimationDuration,
      curve: _navigationAnimationCurve,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isSelected
            ? palette.accentStrong
            : palette.surfaceElevated.withValues(alpha: 0.92),
        borderRadius: context.appRadii.mediumRadius,
        border: Border.all(
          color: isSelected
              ? palette.accentStrong.withValues(alpha: 0.7)
              : palette.borderSubtle.withValues(alpha: 0.9),
          width: context.appDepth.outline,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: isSelected ? 0 : 1,
            duration: _navigationAnimationDuration,
            curve: _navigationAnimationCurve,
            child: Icon(
              icon,
              size: compact ? 18 : 20,
              color: palette.textSecondary,
            ),
          ),
          AnimatedOpacity(
            opacity: isSelected ? 1 : 0,
            duration: _navigationAnimationDuration,
            curve: _navigationAnimationCurve,
            child: Icon(
              selectedIcon,
              size: compact ? 18 : 20,
              color: context.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowButton extends StatelessWidget {
  const _WindowButton({
    required this.icon,
    required this.onPressed,
    this.isClose = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isClose;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: context.appRadii.mediumRadius,
          onTap: onPressed,
          hoverColor: isClose
              ? Colors.red.withValues(alpha: 0.82)
              : palette.overlayMedium,
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: palette.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellDestination {
  const _ShellDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
