import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/download/presentation/download_screen.dart';
import '../../features/minimal/presentation/minimal_screen.dart';
import '../../features/player/presentation/full_player_screen.dart';
import '../../features/playlist/presentation/playlist_detail_screen.dart';
import '../../features/playlist/presentation/playlist_list_screen.dart';
import '../../features/search_and_parse/presentation/search_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../shared/widgets/responsive_scaffold.dart';

/// Route path constants.
abstract class AppRoutes {
  static const String home = '/';
  static const String playlists = '/playlists';
  static const String playlistDetail = '/playlists/:id';
  static const String search = '/search';
  static const String downloads = '/downloads';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String player = '/player';
  static const String minimal = '/minimal';
}

/// 启动时读取的极简模式标志，由 main() 通过 ProviderScope override 注入。
final initialMinimalModeProvider = Provider<bool>((ref) => false);

/// Global router provider for the application.
final appRouterProvider = Provider<GoRouter>((ref) {
  final isMinimalMode = ref.read(initialMinimalModeProvider);

  return GoRouter(
    initialLocation: isMinimalMode ? AppRoutes.minimal : AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ResponsiveScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const PlaylistListScreen(),
                routes: [
                  GoRoute(
                    path: 'playlists/:id',
                    name: 'playlistDetail',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return PlaylistDetailScreen(playlistId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                name: 'search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.downloads,
                name: 'downloads',
                builder: (context, state) => const DownloadScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      // Standalone routes (outside shell)
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.player,
        name: 'player',
        builder: (context, state) => const FullPlayerScreen(),
      ),
      // 极简模式独立路由（不包含底部导航栏）
      GoRoute(
        path: AppRoutes.minimal,
        name: 'minimal',
        builder: (context, state) => const MinimalScreen(),
      ),
    ],
  );
});
