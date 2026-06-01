import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/playlist/application/playlist_notifier.dart';
import 'package:busic/features/playlist/domain/models/playlist.dart';
import 'package:busic/features/playlist/presentation/playlist_list_screen.dart';
import 'package:busic/shared/widgets/app_panel.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  testWidgets('empty playlist library matches the downloads empty state shape',
      (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          playlistListNotifierProvider.overrideWith(
            () => _FakePlaylistListNotifier(playlists: const []),
          ),
        ],
        child: buildTestApp(const PlaylistListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.library_music_outlined), findsOneWidget);
    expect(find.text('No playlists yet'), findsOneWidget);
    expect(
      find.text(
          'Create a playlist or import one to start building your library.'),
      findsNothing,
    );
    expect(find.byType(AppPanel), findsNothing);
  });
}

class _FakePlaylistListNotifier extends PlaylistListNotifier {
  _FakePlaylistListNotifier({required this.playlists});

  final List<Playlist> playlists;

  @override
  Future<List<Playlist>> build() async {
    return playlists;
  }
}
