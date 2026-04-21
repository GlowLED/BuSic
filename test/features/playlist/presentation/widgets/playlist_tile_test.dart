import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/playlist/domain/models/playlist.dart';
import 'package:busic/features/playlist/presentation/widgets/playlist_tile.dart';

import '../../../../test_helpers/test_app.dart';

void main() {
  testWidgets('renders playlist metadata and handles taps', (tester) async {
    var tapped = 0;

    await tester.pumpWidget(
      buildTestApp(
        PlaylistTile(
          playlist: Playlist(
            id: 1,
            name: 'Road Trip',
            songCount: 12,
            createdAt: DateTime(2026, 4, 1),
          ),
          onTap: () => tapped++,
        ),
      ),
    );

    expect(find.text('Road Trip'), findsOneWidget);
    expect(find.text('12 songs'), findsWidgets);

    await tester.tap(find.text('Road Trip'));
    await tester.pump();

    expect(tapped, 1);
  });

  testWidgets('shows favorite badge for favorite playlists', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        PlaylistTile(
          playlist: Playlist(
            id: 99,
            name: 'My Favorites',
            songCount: 3,
            isFavorite: true,
            createdAt: DateTime(2026, 4, 1),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_rounded), findsWidgets);
  });
}
