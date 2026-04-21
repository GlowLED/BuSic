import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/presentation/widgets/search_result_list.dart';

import '../../../../test_helpers/test_app.dart';

void main() {
  testWidgets('renders results and triggers row and pagination callbacks',
      (tester) async {
    BvidInfo? tappedVideo;
    int? changedPage;

    await tester.pumpWidget(
      buildTestApp(
        SearchResultList(
          results: const [
            BvidInfo(
              bvid: 'BV1xx411c7mD',
              title: 'Night Drive',
              owner: 'BuSic',
              duration: 245,
            ),
          ],
          currentPage: 2,
          totalPages: 5,
          onVideoTap: (video) => tappedVideo = video,
          onPageChanged: (page) => changedPage = page,
        ),
      ),
    );

    expect(find.text('Night Drive'), findsOneWidget);

    await tester.tap(find.text('Night Drive'));
    await tester.pump();
    expect(tappedVideo?.bvid, 'BV1xx411c7mD');

    await tester.tap(find.byTooltip('Previous Page'));
    await tester.pump();
    expect(changedPage, 1);

    await tester.tap(find.byTooltip('Next Page'));
    await tester.pump();
    expect(changedPage, 3);
  });

  testWidgets('opens jump dialog and confirms target page on mobile',
      (tester) async {
    int? changedPage;

    await tester.pumpWidget(
      buildTestApp(
        SearchResultList(
          results: const [
            BvidInfo(
              bvid: 'BV1xx411c7mD',
              title: 'Night Drive',
              owner: 'BuSic',
              duration: 245,
            ),
          ],
          currentPage: 1,
          totalPages: 8,
          onVideoTap: (_) {},
          onPageChanged: (page) => changedPage = page,
        ),
      ),
    );

    await tester.tap(find.byTooltip('Jump to Page'));
    await tester.pumpAndSettle();

    expect(find.text('Jump to Page'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, '4');
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(changedPage, 4);
  });
}
