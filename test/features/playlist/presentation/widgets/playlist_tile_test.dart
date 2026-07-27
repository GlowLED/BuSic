import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/theme/app_theme.dart';
import 'package:busic/core/theme/app_theme_tokens.dart';
import 'package:busic/features/playlist/domain/models/playlist.dart';
import 'package:busic/features/playlist/presentation/widgets/playlist_tile.dart';
import 'package:busic/shared/widgets/app_panel.dart';
import 'package:busic/shared/widgets/media_cover.dart';

import '../../../../test_helpers/test_app.dart';

void main() {
  testWidgets('fills the card with cover art and handles every tile action', (
    tester,
  ) async {
    var taps = 0;
    var longPresses = 0;
    var morePresses = 0;

    await _pumpTile(
      tester,
      PlaylistTile(
        playlist: _playlist(),
        onTap: () => taps++,
        onLongPress: () => longPresses++,
        onMorePressed: () => morePresses++,
      ),
    );

    expect(find.text('Road Trip'), findsOneWidget);
    expect(find.text('12 songs'), findsOneWidget);

    final tileRect = tester.getRect(find.byType(PlaylistTile));
    final coverRect = tester.getRect(find.byType(MediaCover));
    expect(coverRect, tileRect);
    expect(coverRect.height, greaterThan(coverRect.width));

    final moreButton = find.ancestor(
      of: find.byIcon(Icons.more_horiz_rounded),
      matching: find.byType(IconButton),
    );
    expect(tester.getSize(moreButton), const Size.square(48));
    final moreRect = tester.getRect(moreButton);
    expect(moreRect.right, closeTo(tileRect.right - 8, 0.1));
    expect(moreRect.bottom, closeTo(tileRect.bottom - 8, 0.1));
    expect(coverRect.contains(moreRect.center), isTrue);

    final button = tester.widget<IconButton>(moreButton);
    final states = <WidgetState>{};
    expect(button.style?.backgroundColor?.resolve(states), Colors.transparent);
    expect(button.style?.side?.resolve(states), isNull);

    await tester.tap(find.text('Road Trip'));
    await tester.pump();
    expect(taps, 1);

    await tester.longPress(find.text('Road Trip'));
    await tester.pump();
    expect(longPresses, 1);

    await tester.tap(find.byIcon(Icons.more_horiz_rounded));
    await tester.pump();
    expect(morePresses, 1);
    expect(taps, 1);
  });

  testWidgets('keeps the favorite tile free of a more action', (tester) async {
    await _pumpTile(
      tester,
      PlaylistTile(playlist: _playlist(isFavorite: true), onMorePressed: () {}),
    );

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz_rounded), findsNothing);
  });

  testWidgets('uses one functional gradient without glass, shadow, or glow', (
    tester,
  ) async {
    await _pumpTile(tester, PlaylistTile(playlist: _playlist()));

    final context = tester.element(find.byType(PlaylistTile));
    final palette = Theme.of(context).extension<AppThemePalette>()!;
    final surface = _surfaceDecoration(tester);
    final foreground = _surfaceForegroundDecoration(tester);
    final gradientDecoration = _gradientDecoration(tester);
    final gradient = gradientDecoration.gradient! as LinearGradient;

    expect(find.byType(AppPanel), findsNothing);
    expect(find.byType(BackdropFilter), findsNothing);
    expect(
      tester
          .widget<AnimatedContainer>(
            find.byKey(const ValueKey<String>('playlist-tile-surface')),
          )
          .clipBehavior,
      Clip.antiAlias,
    );
    expect(surface.boxShadow, isNull);
    expect(surface.border, isNull);
    expect(foreground.border, isNotNull);
    expect(gradientDecoration.borderRadius, isNull);
    expect(
      tester.getRect(
        find.byKey(const ValueKey<String>('playlist-tile-gradient')),
      ),
      tester.getRect(find.byType(MediaCover)),
    );
    expect(
      tester.getRect(
        find.byKey(const ValueKey<String>('playlist-tile-gradient')),
      ),
      tester.getRect(find.byType(PlaylistTile)),
    );
    expect(gradient.begin, Alignment.topCenter);
    expect(gradient.end, Alignment.bottomCenter);
    expect(gradient.stops, const <double>[0.18, 0.38, 0.56, 0.72, 0.86, 1]);
    expect(gradient.colors[0], palette.surfacePrimary.withValues(alpha: 0));
    expect(gradient.colors[1], palette.surfacePrimary.withValues(alpha: 0.08));
    expect(gradient.colors[2], palette.surfacePrimary.withValues(alpha: 0.28));
    expect(gradient.colors[3], palette.surfacePrimary.withValues(alpha: 0.58));
    expect(gradient.colors[4], palette.surfacePrimary.withValues(alpha: 0.86));
    expect(gradient.colors[5], palette.surfacePrimary);

    final decoratedBoxes = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>();
    expect(
      decoratedBoxes.where((decoration) => decoration.gradient != null),
      hasLength(1),
    );
    expect(
      decoratedBoxes.every(
        (decoration) =>
            decoration.boxShadow == null || decoration.boxShadow!.isEmpty,
      ),
      isTrue,
    );
  });

  testWidgets('derives coordinated accessible colors in light and dark modes', (
    tester,
  ) async {
    final coverPath = '${Directory.current.path}/assets/images/app_icon.png';
    final provider = MediaCover.imageProviderFor(coverPath)!;
    final expectedLight = await tester.runAsync(
      () => ColorScheme.fromImageProvider(
        provider: provider,
        brightness: Brightness.light,
        dynamicSchemeVariant: DynamicSchemeVariant.content,
      ),
    );

    await _pumpTile(
      tester,
      PlaylistTile(playlist: _playlist(coverUrl: coverPath)),
    );
    await _waitForPalette(tester, expectedLight!.primaryContainer);

    var gradient = _gradientDecoration(tester).gradient! as LinearGradient;
    var titleColor = _titleStyle(tester).style.color!;
    var metadataColor = _metadataStyle(tester).style.color!;
    expect(gradient.colors.last, expectedLight.primaryContainer);
    expect(titleColor, expectedLight.onPrimaryContainer);
    expect(
      _contrastRatio(titleColor, gradient.colors.last),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      _contrastRatio(metadataColor, gradient.colors.last),
      greaterThanOrEqualTo(3),
    );

    final expectedDark = await tester.runAsync(
      () => ColorScheme.fromImageProvider(
        provider: provider,
        brightness: Brightness.dark,
        dynamicSchemeVariant: DynamicSchemeVariant.content,
      ),
    );
    await _pumpTile(
      tester,
      PlaylistTile(playlist: _playlist(coverUrl: coverPath)),
      theme: AppTheme.darkTheme(seedColor: AppTheme.greenSeed),
    );
    await _waitForPalette(tester, expectedDark!.primaryContainer);

    gradient = _gradientDecoration(tester).gradient! as LinearGradient;
    titleColor = _titleStyle(tester).style.color!;
    metadataColor = _metadataStyle(tester).style.color!;
    expect(gradient.colors.last, expectedDark.primaryContainer);
    expect(titleColor, expectedDark.onPrimaryContainer);
    expect(
      _contrastRatio(titleColor, gradient.colors.last),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      _contrastRatio(metadataColor, gradient.colors.last),
      greaterThanOrEqualTo(3),
    );
  });

  testWidgets('falls back to a neutral surface when cover extraction fails', (
    tester,
  ) async {
    final missingPath =
        '${Directory.systemTemp.path}/missing-playlist-cover-for-test.png';

    await _pumpTile(
      tester,
      PlaylistTile(playlist: _playlist(coverUrl: missingPath)),
    );
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(PlaylistTile));
    final palette = Theme.of(context).extension<AppThemePalette>()!;
    final gradient = _gradientDecoration(tester).gradient! as LinearGradient;
    expect(gradient.colors.last, palette.surfacePrimary);
  });

  testWidgets('does not apply a stale palette after the cover changes', (
    tester,
  ) async {
    final firstCover = File(
      '${Directory.current.path}/assets/images/app_icon.png',
    ).uri.toString();

    await _pumpTile(
      tester,
      PlaylistTile(playlist: _playlist(coverUrl: firstCover)),
    );
    await tester.pump();
    await _pumpTile(tester, PlaylistTile(playlist: _playlist()));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(PlaylistTile));
    final palette = Theme.of(context).extension<AppThemePalette>()!;
    final gradient = _gradientDecoration(tester).gradient! as LinearGradient;
    expect(gradient.colors.last, palette.surfacePrimary);
  });

  testWidgets('scales only the cover on hover and retains pressed feedback', (
    tester,
  ) async {
    await _pumpTile(
      tester,
      PlaylistTile(playlist: _playlist(), onTap: () {}, onMorePressed: () {}),
    );

    final scaleFinder = find.byKey(
      const ValueKey<String>('playlist-tile-cover-scale'),
    );
    final initialScale = tester.widget<AnimatedScale>(scaleFinder);
    final mouseRegion = tester.widget<MouseRegion>(
      find.byKey(const ValueKey<String>('playlist-tile-mouse-region')),
    );
    final tileInkWell = tester.widget<InkWell>(
      find.byKey(const ValueKey<String>('playlist-tile-ink-well')),
    );
    final titleRect = tester.getRect(find.text('Road Trip'));
    final moreRect = tester.getRect(find.byIcon(Icons.more_horiz_rounded));
    final defaultBorder =
        _surfaceForegroundDecoration(tester).border! as Border;
    expect(initialScale.scale, 1);
    expect(initialScale.duration, const Duration(milliseconds: 240));
    expect(initialScale.curve, Curves.easeOutCubic);
    expect(mouseRegion.cursor, SystemMouseCursors.click);
    expect(mouseRegion.onHover, isNotNull);
    expect(mouseRegion.hitTestBehavior, HitTestBehavior.opaque);
    expect(tileInkWell.mouseCursor, SystemMouseCursors.click);
    expect(tileInkWell.onHover, isNotNull);

    final mouse = await tester.createGesture(kind: ui.PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(PlaylistTile)));
    await tester.pump();
    expect(tester.widget<AnimatedScale>(scaleFinder).scale, 1.04);
    await tester.pump(const Duration(milliseconds: 240));
    expect(tester.getRect(find.text('Road Trip')), titleRect);
    expect(tester.getRect(find.byIcon(Icons.more_horiz_rounded)), moreRect);
    final hoverBorder = _surfaceForegroundDecoration(tester).border! as Border;
    expect(hoverBorder.top.color, isNot(defaultBorder.top.color));

    await mouse.moveTo(Offset.zero);
    await tester.pump();
    expect(tester.widget<AnimatedScale>(scaleFinder).scale, 1);
    await tester.pump(const Duration(milliseconds: 240));

    final touch = await tester.startGesture(
      tester.getCenter(find.byType(PlaylistTile)),
    );
    await tester.pump(const Duration(milliseconds: 160));
    final stateLayer = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey<String>('playlist-tile-state-layer')),
    );
    final stateDecoration = stateLayer.decoration! as BoxDecoration;
    expect(stateDecoration.color, isNot(Colors.transparent));
    await touch.cancel();
  });

  testWidgets('disables hover scaling with reduced motion and shows focus', (
    tester,
  ) async {
    await _pumpTile(
      tester,
      PlaylistTile(playlist: _playlist(), onTap: () {}),
      disableAnimations: true,
    );

    final mouse = await tester.createGesture(kind: ui.PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(PlaylistTile)));
    await tester.pump();

    final scale = tester.widget<AnimatedScale>(
      find.byKey(const ValueKey<String>('playlist-tile-cover-scale')),
    );
    final surface = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey<String>('playlist-tile-surface')),
    );
    final gradient = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey<String>('playlist-tile-gradient')),
    );
    expect(scale.scale, 1);
    expect(scale.duration, Duration.zero);
    expect(surface.duration, Duration.zero);
    expect(gradient.duration, Duration.zero);

    await mouse.moveTo(Offset.zero);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final context = tester.element(find.byType(PlaylistTile));
    final palette = Theme.of(context).extension<AppThemePalette>()!;
    final focusedBorder =
        _surfaceForegroundDecoration(tester).border! as Border;
    expect(focusedBorder.top.color, palette.accentStrong);
  });
}

Future<void> _pumpTile(
  WidgetTester tester,
  PlaylistTile tile, {
  bool disableAnimations = false,
  ThemeData? theme,
}) async {
  await tester.pumpWidget(
    buildTestApp(
      MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Center(child: SizedBox(width: 220, height: 280, child: tile)),
      ),
      theme: theme,
    ),
  );
  await tester.pump();
}

Playlist _playlist({String? coverUrl, bool isFavorite = false}) {
  return Playlist(
    id: isFavorite ? 99 : 1,
    name: isFavorite ? 'My Favorites' : 'Road Trip',
    coverUrl: coverUrl,
    songCount: 12,
    isFavorite: isFavorite,
    createdAt: DateTime(2026, 4, 1),
  );
}

BoxDecoration _surfaceDecoration(WidgetTester tester) {
  return tester
          .widget<AnimatedContainer>(
            find.byKey(const ValueKey<String>('playlist-tile-surface')),
          )
          .decoration!
      as BoxDecoration;
}

BoxDecoration _surfaceForegroundDecoration(WidgetTester tester) {
  return tester
          .widget<AnimatedContainer>(
            find.byKey(const ValueKey<String>('playlist-tile-surface')),
          )
          .foregroundDecoration!
      as BoxDecoration;
}

BoxDecoration _gradientDecoration(WidgetTester tester) {
  return tester
          .widget<AnimatedContainer>(
            find.byKey(const ValueKey<String>('playlist-tile-gradient')),
          )
          .decoration!
      as BoxDecoration;
}

AnimatedDefaultTextStyle _titleStyle(WidgetTester tester) {
  return tester.widget<AnimatedDefaultTextStyle>(
    find.byKey(const ValueKey<String>('playlist-tile-title-style')),
  );
}

AnimatedDefaultTextStyle _metadataStyle(WidgetTester tester) {
  return tester.widget<AnimatedDefaultTextStyle>(
    find.byKey(const ValueKey<String>('playlist-tile-metadata-style')),
  );
}

double _contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter = firstLuminance > secondLuminance
      ? firstLuminance
      : secondLuminance;
  final darker = firstLuminance > secondLuminance
      ? secondLuminance
      : firstLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}

Future<void> _waitForPalette(WidgetTester tester, Color expected) async {
  for (var attempt = 0; attempt < 40; attempt++) {
    final gradient = _gradientDecoration(tester).gradient! as LinearGradient;
    if (gradient.colors.last == expected) return;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 25)),
    );
    await tester.pump(const Duration(milliseconds: 25));
  }
}
