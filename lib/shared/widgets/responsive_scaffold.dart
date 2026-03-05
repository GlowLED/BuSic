import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/platform_utils.dart';
import '../../features/player/presentation/player_bar.dart';
import '../../features/auth/presentation/widgets/user_avatar_widget.dart';

/// A responsive scaffold that adapts navigation between desktop and mobile.
///
/// - **Desktop (width >= 840):** Fixed sidebar navigation on the left,
///   custom draggable title bar, content area on the right.
/// - **Mobile (width < 840):** Bottom navigation bar,
///   standard mobile app bar.
///
/// The bottom [PlayerBar] is always visible when a track is playing.
class ResponsiveScaffold extends StatelessWidget {
  /// Stateful navigation shell for preserving per-tab stacks.
  final StatefulNavigationShell navigationShell;

  const ResponsiveScaffold({super.key, required this.navigationShell});

  void _onDestinationSelected(int index) {
    // If user taps the already-active branch, go back to the branch root
    // (e.g., from playlist detail back to playlist list).
    final isCurrentBranch = navigationShell.currentIndex == index;
    navigationShell.goBranch(index, initialLocation: isCurrentBranch);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= AppTheme.desktopBreakpoint;
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final currentIdx = navigationShell.currentIndex;

    if (isDesktop) {
      return Scaffold(
        body: Column(
          children: [
            // Custom title bar with drag area and window controls
            if (PlatformUtils.isDesktop)
              _DesktopTitleBar(colorScheme: colorScheme),
            // Desktop content
            Expanded(
              child: Row(
                children: [
                  // Sidebar
                  NavigationRail(
                    selectedIndex: currentIdx,
                    onDestinationSelected: (idx) =>
                        _onDestinationSelected(idx),
                    extended: width >= 1100,
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Icon(Icons.music_note,
                              size: 32, color: colorScheme.primary),
                          const SizedBox(height: 4),
                          if (width >= 1100)
                            Text('BuSic',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary)),
                        ],
                      ),
                    ),
                    trailing: const Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: UserAvatarWidget(),
                        ),
                      ),
                    ),
                    destinations: [
                      NavigationRailDestination(
                        icon: const Icon(Icons.library_music_outlined),
                        selectedIcon: const Icon(Icons.library_music),
                        label: Text(l10n.playlists),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.search_outlined),
                        selectedIcon: const Icon(Icons.search),
                        label: Text(l10n.search),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.download_outlined),
                        selectedIcon: const Icon(Icons.download),
                        label: Text(l10n.downloads),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.settings_outlined),
                        selectedIcon: const Icon(Icons.settings),
                        label: Text(l10n.settings),
                      ),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  // Main content
                  Expanded(child: navigationShell),
                ],
              ),
            ),
            // Player bar at bottom
            const PlayerBar(),
          ],
        ),
      );
    }

    // Mobile layout
    return Scaffold(
      body: SafeArea(
        bottom: false, // NavigationBar handles bottom padding
        child: Column(
          children: [
            Expanded(child: navigationShell),
            const PlayerBar(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIdx,
        onDestinationSelected: (idx) =>
            _onDestinationSelected(idx),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.library_music_outlined),
            selectedIcon: const Icon(Icons.library_music),
            label: l10n.playlists,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
            label: l10n.search,
          ),
          NavigationDestination(
            icon: const Icon(Icons.download_outlined),
            selectedIcon: const Icon(Icons.download),
            label: l10n.downloads,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}

/// Custom desktop title bar with drag-to-move area and window control buttons.
class _DesktopTitleBar extends StatelessWidget {
  final ColorScheme colorScheme;

  const _DesktopTitleBar({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) => windowManager.startDragging(),
      child: Container(
        height: 36,
        color: colorScheme.surface,
        child: Row(
          children: [
            const SizedBox(width: 12),
            Text(
              'BuSic',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            // Minimize
            _WindowButton(
              icon: Icons.minimize,
              onPressed: () => windowManager.minimize(),
              colorScheme: colorScheme,
            ),
            // Maximize / Restore
            _WindowButton(
              icon: Icons.crop_square,
              onPressed: () async {
                if (await windowManager.isMaximized()) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
              },
              colorScheme: colorScheme,
            ),
            // Close (hide to tray)
            _WindowButton(
              icon: Icons.close,
              onPressed: () => windowManager.hide(),
              colorScheme: colorScheme,
              isClose: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _WindowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;
  final bool isClose;

  const _WindowButton({
    required this.icon,
    required this.onPressed,
    required this.colorScheme,
    this.isClose = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 36,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          hoverColor: isClose
              ? Colors.red.withValues(alpha: 0.8)
              : colorScheme.onSurface.withValues(alpha: 0.08),
          child: Center(
            child: Icon(
              icon,
              size: 16,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
