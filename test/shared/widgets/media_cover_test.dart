import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/shared/widgets/media_cover.dart';

import '../../test_helpers/test_app.dart';

void main() {
  testWidgets('shows placeholder icon when cover is missing', (tester) async {
    await tester.pumpWidget(buildTestApp(const Center(child: MediaCover())));

    expect(find.byIcon(Icons.music_note_rounded), findsOneWidget);
  });

  testWidgets('keeps placeholder visible while remote cover is unresolved', (
    tester,
  ) async {
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
    // 只约束宽度，保持宽高比，避免长图被压扁。
    expect(image.memCacheHeight, isNull);
    expect(find.byIcon(Icons.music_note_rounded), findsOneWidget);
  });

  testWidgets('decodes local cover with aspect-preserving ResizeImage', (
    tester,
  ) async {
    final tempDir = Directory.systemTemp.createTempSync('media_cover_test');
    addTearDown(() => tempDir.deleteSync(recursive: true));
    final file = File('${tempDir.path}/cover.png')..writeAsBytesSync(const []);

    await tester.pumpWidget(
      buildTestApp(
        Center(child: MediaCover(coverUrl: file.path, width: 72, height: 72)),
      ),
    );

    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image;
    expect(provider, isA<ResizeImage>());
    // fit 策略保持原始宽高比，长图不会被压扁成正方形位图。
    expect((provider as ResizeImage).policy, ResizeImagePolicy.fit);
  });
}
