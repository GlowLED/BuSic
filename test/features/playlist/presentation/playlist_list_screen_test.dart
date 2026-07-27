import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/theme/app_theme.dart';
import 'package:busic/core/theme/app_theme_tokens.dart';
import 'package:busic/features/playlist/application/playlist_notifier.dart';
import 'package:busic/features/playlist/domain/models/playlist.dart';
import 'package:busic/features/playlist/presentation/playlist_list_screen.dart';
import 'package:busic/features/playlist/presentation/widgets/create_playlist_dialog.dart';
import 'package:busic/features/playlist/presentation/widgets/playlist_tile.dart';
import 'package:busic/shared/widgets/app_panel.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  testWidgets('shows a title-free action row and a clear empty state', (
    tester,
  ) async {
    await _pumpPlaylistScreen(tester, playlists: const []);

    expect(find.text('Playlists'), findsNothing);
    expect(find.byTooltip('Create Playlist'), findsOneWidget);
    expect(find.byIcon(Icons.library_music_outlined), findsOneWidget);
    expect(find.text('No playlists yet'), findsOneWidget);
    expect(
      find.text(
        'Create a playlist or import one to start building your library.',
      ),
      findsOneWidget,
    );
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byType(AppPanel), findsNothing);

    final createTarget = find.ancestor(
      of: find.byIcon(Icons.add_rounded),
      matching: find.byType(InkWell),
    );
    expect(tester.getSize(createTarget), const Size.square(48));

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CreatePlaylistDialog), findsOneWidget);
    expect(find.text('Create Custom Playlist'), findsOneWidget);
    expect(find.text('Import from Clipboard'), findsOneWidget);
    expect(find.text('Import from Bilibili Favorites'), findsOneWidget);
  });

  testWidgets('uses two columns on a 390px phone', (tester) async {
    await _pumpPlaylistScreen(tester, playlists: _playlists(6));

    final tiles = find.byType(PlaylistTile);
    expect(tiles, findsNWidgets(6));

    final first = tester.getRect(tiles.at(0));
    final second = tester.getRect(tiles.at(1));
    final third = tester.getRect(tiles.at(2));

    expect(first.top, closeTo(second.top, 0.1));
    expect(first.left, lessThan(second.left));
    expect(third.top, greaterThan(first.top));
    expect(first.width, lessThanOrEqualTo(216));
  });

  testWidgets('keeps two columns and contained actions on a 375px phone', (
    tester,
  ) async {
    await _pumpPlaylistScreen(
      tester,
      size: const Size(375, 812),
      playlists: _playlists(2),
    );

    final tiles = find.byType(PlaylistTile);
    expect(tiles, findsNWidgets(2));
    expect(tester.getRect(tiles.at(0)).top, tester.getRect(tiles.at(1)).top);
    expect(tester.takeException(), isNull);

    final moreButtons = find.byIcon(Icons.more_horiz_rounded);
    expect(moreButtons, findsNWidgets(2));
    for (var index = 0; index < 2; index++) {
      final tileRect = tester.getRect(tiles.at(index));
      final actionRect = tester.getRect(
        find.ancestor(
          of: moreButtons.at(index),
          matching: find.byType(IconButton),
        ),
      );
      expect(tileRect.contains(actionRect.center), isTrue);
      expect(actionRect.size, const Size.square(48));
    }
  });

  testWidgets('adds columns while keeping tiles bounded on wide layouts', (
    tester,
  ) async {
    await _pumpPlaylistScreen(
      tester,
      size: const Size(1000, 800),
      playlists: _playlists(6),
    );

    final tiles = find.byType(PlaylistTile);
    final firstTop = tester.getRect(tiles.at(0)).top;

    for (var index = 1; index < 5; index++) {
      expect(tester.getRect(tiles.at(index)).top, closeTo(firstTop, 0.1));
      expect(tester.getRect(tiles.at(index)).width, lessThanOrEqualTo(216));
    }
    expect(tester.getRect(tiles.at(5)).top, greaterThan(firstTop));
  });

  testWidgets('keeps the grid operable in mobile landscape', (tester) async {
    await _pumpPlaylistScreen(
      tester,
      size: const Size(700, 390),
      playlists: _playlists(4),
    );

    final tiles = find.byType(PlaylistTile);
    final firstTop = tester.getRect(tiles.at(0)).top;

    expect(tester.takeException(), isNull);
    expect(find.byTooltip('Create Playlist'), findsOneWidget);
    expect(tester.getRect(tiles.at(1)).top, closeTo(firstTop, 0.1));
    expect(tester.getRect(tiles.at(2)).top, closeTo(firstTop, 0.1));
    expect(tester.getRect(tiles.at(3)).top, greaterThan(firstTop));
  });

  testWidgets('uses neutral dark surfaces with the configured theme accent', (
    tester,
  ) async {
    await _pumpPlaylistScreen(
      tester,
      playlists: _playlists(2),
      theme: AppTheme.darkTheme(seedColor: AppTheme.greenSeed),
    );

    final context = tester.element(find.byType(PlaylistListScreen));
    final palette = Theme.of(context).extension<AppThemePalette>()!;

    expect(palette.backgroundPrimary.computeLuminance(), lessThan(0.1));
    expect(find.text('Playlists'), findsNothing);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
  });

  testWidgets('opens playlist management from the visible more action', (
    tester,
  ) async {
    await _pumpPlaylistScreen(tester, playlists: _playlists(1));

    final moreButton = find.byIcon(Icons.more_horiz_rounded);
    expect(moreButton, findsOneWidget);
    expect(
      tester.getSize(
        find.ancestor(of: moreButton, matching: find.byType(IconButton)),
      ),
      const Size.square(48),
    );

    await tester.tap(moreButton);
    await tester.pumpAndSettle();

    expect(find.text('Rename Playlist'), findsOneWidget);
    expect(find.text('Change Cover'), findsOneWidget);
    expect(find.text('Delete Playlist'), findsOneWidget);
    expect(find.byType(AppPanel), findsNothing);
  });

  testWidgets('keeps long names stable with enlarged system text', (
    tester,
  ) async {
    await _pumpPlaylistScreen(
      tester,
      playlists: [
        _playlist(
          name: 'A very long playlist name that needs two display lines',
        ),
      ],
      textScale: 2,
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(PlaylistTile), findsOneWidget);
  });
}

Future<void> _pumpPlaylistScreen(
  WidgetTester tester, {
  required List<Playlist> playlists,
  Size size = const Size(390, 844),
  double textScale = 1,
  ThemeData? theme,
}) async {
  tester.platformDispatcher.localeTestValue = const Locale('en');
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.platformDispatcher.clearLocaleTestValue);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        playlistListNotifierProvider.overrideWith(
          () => _FakePlaylistListNotifier(playlists: playlists),
        ),
      ],
      child: buildTestApp(
        Builder(
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              child: const PlaylistListScreen(),
            );
          },
        ),
        theme: theme,
      ),
    ),
  );

  await tester.pumpAndSettle();
}

List<Playlist> _playlists(int count) {
  return List.generate(
    count,
    (index) => _playlist(
      id: index + 1,
      name: 'Playlist ${index + 1}',
      songCount: index + 1,
    ),
  );
}

Playlist _playlist({int id = 1, String name = 'Playlist', int songCount = 1}) {
  return Playlist(
    id: id,
    name: name,
    songCount: songCount,
    createdAt: DateTime(2026, 4, 1),
  );
}

class _FakePlaylistListNotifier extends PlaylistListNotifier {
  _FakePlaylistListNotifier({required this.playlists});

  final List<Playlist> playlists;

  @override
  Future<List<Playlist>> build() async {
    return playlists;
  }
}
