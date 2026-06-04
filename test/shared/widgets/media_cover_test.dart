import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/shared/widgets/media_cover.dart';

import '../../test_helpers/test_app.dart';

void main() {
  testWidgets('shows placeholder icon when cover is missing', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const Center(
          child: MediaCover(),
        ),
      ),
    );

    expect(find.byIcon(Icons.music_note_rounded), findsOneWidget);
  });

  testWidgets('keeps placeholder visible while remote cover is unresolved',
      (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const Center(
          child: MediaCover(
            coverUrl: 'https://example.com/missing-cover.png',
            width: 72,
            height: 72,
          ),
        ),
      ),
    );

    await tester.pump();

    final image = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    final expectedCacheSize = (72 * tester.view.devicePixelRatio * 2).ceil();

    expect(image.filterQuality, FilterQuality.high);
    expect(image.memCacheWidth, expectedCacheSize);
    expect(image.memCacheHeight, expectedCacheSize);
    expect(find.byIcon(Icons.music_note_rounded), findsOneWidget);
  });
}
