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

    expect(find.byIcon(Icons.music_note_rounded), findsOneWidget);
  });
}
