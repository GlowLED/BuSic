import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/player/presentation/widgets/cover_image.dart';

import '../../../../test_helpers/test_app.dart';

void main() {
  testWidgets('uses high quality cached network image by default',
      (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        Center(
          child: Builder(
            builder: (context) => buildCoverImage(
              context,
              'https://example.com/cover.jpg',
            ),
          ),
        ),
      ),
    );

    final image = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );

    expect(image.filterQuality, FilterQuality.high);
    expect(image.memCacheWidth, isNull);
    expect(image.memCacheHeight, isNull);
    expect(image.fadeInDuration, const Duration(milliseconds: 500));
    expect(image.fadeOutDuration, const Duration(milliseconds: 1000));
    expect(image.useOldImageOnUrlChange, isFalse);
  });

  testWidgets('passes high quality options to cached network image',
      (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        Center(
          child: Builder(
            builder: (context) => buildCoverImage(
              context,
              'https://example.com/cover.jpg',
              filterQuality: FilterQuality.high,
              cacheSizePx: 256,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              useOldImageOnUrlChange: true,
            ),
          ),
        ),
      ),
    );

    final image = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );

    expect(image.filterQuality, FilterQuality.high);
    expect(image.memCacheWidth, 256);
    expect(image.memCacheHeight, 256);
    expect(image.fadeInDuration, Duration.zero);
    expect(image.fadeOutDuration, Duration.zero);
    expect(image.useOldImageOnUrlChange, isTrue);
  });
}
