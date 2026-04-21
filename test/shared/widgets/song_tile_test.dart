import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/theme/app_theme.dart';
import 'package:busic/core/theme/app_theme_tokens.dart';
import 'package:busic/shared/widgets/app_panel.dart';
import 'package:busic/shared/widgets/song_tile.dart';

import '../../test_helpers/test_app.dart';

void main() {
  testWidgets('renders metadata and forwards user actions', (tester) async {
    var tapped = 0;
    var favorited = 0;
    var morePressed = 0;
    var longPressed = 0;

    await tester.pumpWidget(
      buildTestApp(
        SongTile(
          title: 'Test Song',
          artist: 'Test Artist',
          duration: '3:20',
          isCached: true,
          qualityLabel: '192kbps',
          isFavorited: false,
          onTap: () => tapped++,
          onFavoritePressed: () => favorited++,
          onMorePressed: () => morePressed++,
          onLongPress: () => longPressed++,
        ),
      ),
    );

    expect(find.text('Test Song'), findsOneWidget);
    expect(find.text('Test Artist'), findsOneWidget);
    expect(find.text('192kbps'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.tap(find.byIcon(Icons.more_horiz_rounded));
    await tester.longPress(find.text('Test Song'));
    await tester.pump();

    expect(tapped, 1);
    expect(favorited, 1);
    expect(morePressed, 1);
    expect(longPressed, 1);
  });

  testWidgets('uses selected styling for highlighted rows', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const SongTile(
          title: 'Selected Song',
          artist: 'Muted Artist',
          isSelected: true,
        ),
      ),
    );

    final panel = tester.widget<AppPanel>(find.byType(AppPanel).first);
    final theme = AppTheme.lightTheme(seedColor: AppTheme.greenSeed);
    final palette = theme.extension<AppThemePalette>()!;

    expect(
      panel.borderColor,
      palette.accentStrong.withValues(alpha: 0.58),
    );
  });

  testWidgets('blocks disabled actions', (tester) async {
    var tapped = 0;

    await tester.pumpWidget(
      buildTestApp(
        SongTile(
          title: 'Selected Song',
          artist: 'Muted Artist',
          enabled: false,
          onTap: () => tapped++,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump();

    expect(tapped, 0);
  });
}
