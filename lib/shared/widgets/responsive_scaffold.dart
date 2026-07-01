import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/utils/platform_utils.dart';
import '../../features/auth/presentation/widgets/user_avatar_widget.dart';

import '../../features/player/presentation/player_bar.dart';
import '../../l10n/generated/app_localizations.dart';
import '../extensions/context_extensions.dart';

const _navigationAnimationDuration = Duration(milliseconds: 220);
const _navigationAnimationCurve = Curves.easeOutCubic;

/// Main application shell.
///
/// Desktop and mobile share the same navigation language, but use different
/// layouts:
/// - Desktop: custom title bar + control-console sidebar.
/// - Mobile portrait: compact label-only bottom dock.
/// - Mobile landscape: compact icon-only side rail.
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

    if (PlatformUtils.isDesktop && context.isDesktop) {
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
              SizedBox(height: spacing.xs),
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
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: _ShellBackdrop(
          child: isLandscape
              ? SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(spacing.sm),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 72,
                          child: _MobileLandscapeNavRail(
                            destinations: destinations,
                            currentIndex: currentIndex,
                            onDestinationSelected: onDestinationSelected,
                          ),
                        ),
                        SizedBox(width: spacing.sm),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: _ShellContentFrame(
                                  child: navigationShell,
                                ),
                              ),
                              const _ShellPlayerDock(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Expanded(child: navigationShell),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          spacing.sm,
                          0,
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
                            spacing.xs,
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
    final spacing = context.appSpacing;
    final textTheme = context.textTheme;

    return Container(
      color: Colors.transparent,
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.appTitle,
                          style: textTheme.labelLarge?.copyWith(
                            color: context.appPalette.textSecondary,
                          ),
                        ),
                        SizedBox(height: spacing.xxs),
                        Text(
                          currentLabel,
                          style: textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (PlatformUtils.isDesktop) ...[
              _WindowButton(
                icon: Icons.horizontal_rule_rounded,
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
    final palette = context.appPalette;
    final spacing = context.appSpacing;

    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(spacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: destinations.length - 1, // 排除设置
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
                _DesktopNavigationItem(
                  destination: destinations[3], // 设置目的地
                  isSelected: currentIndex == 3,
                  onTap: () => onDestinationSelected(3),
                ),
                SizedBox(height: spacing.sm),
                const _DesktopSidebarStatusCard(),
              ],
            ),
          ),
        ),
        Container(
          width: 1,
          color: palette.borderSubtle.withValues(alpha: 0.5),
        ),
      ],
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
    final spacing = context.appSpacing;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: context.appRadii.xLargeRadius,
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.xs,
            vertical: spacing.sm,
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
  }
}

class _DesktopSidebarStatusCard extends ConsumerWidget {
  const _DesktopSidebarStatusCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.appSpacing;

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: const UserAvatarWidget(),
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
    final spacing = context.appSpacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.xs,
        vertical: spacing.xxs,
      ),
      color: Colors.transparent,
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

    return Semantics(
      button: true,
      selected: isSelected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.xs,
            vertical: spacing.xs,
          ),
          child: Center(
            child: Text(
              destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall?.copyWith(
                color: isSelected ? palette.textPrimary : palette.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileLandscapeNavRail extends StatelessWidget {
  const _MobileLandscapeNavRail({
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

    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: spacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: destinations.length - 1,
                    separatorBuilder: (_, __) => SizedBox(height: spacing.xxs),
                    itemBuilder: (context, index) {
                      return _MobileLandscapeNavigationItem(
                        destination: destinations[index],
                        isSelected: currentIndex == index,
                        onTap: () => onDestinationSelected(index),
                      );
                    },
                  ),
                ),
                SizedBox(height: spacing.xs),
                _MobileLandscapeNavigationItem(
                  destination: destinations.last,
                  isSelected: currentIndex == destinations.length - 1,
                  onTap: () => onDestinationSelected(destinations.length - 1),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 1,
          color: palette.borderSubtle.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}

class _MobileLandscapeNavigationItem extends StatelessWidget {
  const _MobileLandscapeNavigationItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final _ShellDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;

    return Semantics(
      label: destination.label,
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: context.appRadii.xLargeRadius,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: EdgeInsets.symmetric(
              horizontal: spacing.xs,
              vertical: spacing.xs,
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
      ),
    );
  }
}

class _ShellPlayerDock extends StatelessWidget {
  const _ShellPlayerDock();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: const PlayerBar(),
    );
  }
}

class _ShellContentFrame extends StatelessWidget {
  const _ShellContentFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
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
          child,
        ],
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
        color: isSelected ? palette.accentStrong : Colors.transparent,
        borderRadius: context.appRadii.mediumRadius,
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
