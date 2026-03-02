import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
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
  /// The child widget to display in the main content area (from ShellRoute).
  final Widget child;

  const ResponsiveScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/downloads')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0; // home / playlists
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/downloads');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= AppTheme.desktopBreakpoint;
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final currentIdx = _currentIndex(context);

    if (isDesktop) {
      return Scaffold(
        body: Column(
          children: [
            // Desktop content
            Expanded(
              child: Row(
                children: [
                  // Sidebar
                  NavigationRail(
                    selectedIndex: currentIdx,
                    onDestinationSelected: (idx) =>
                        _onDestinationSelected(context, idx),
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
                  Expanded(child: child),
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
      body: Column(
        children: [
          Expanded(child: child),
          const PlayerBar(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIdx,
        onDestinationSelected: (idx) =>
            _onDestinationSelected(context, idx),
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
