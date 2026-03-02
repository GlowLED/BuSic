import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../features/player/presentation/player_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= AppTheme.desktopBreakpoint;

    // TODO: implement responsive layout switching
    // Desktop: Row [ Sidebar | Expanded(child) ]
    // Mobile:  Scaffold( body: child, bottomNavigationBar: ... )
    // Both:    Stack bottom PlayerBar

    return Scaffold(
      body: child,
    );
  }
}
