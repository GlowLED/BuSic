import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/presentation/widgets/search_result_list.dart';

import '../../../../test_helpers/test_app.dart';

void main() {
  testWidgets('renders results and triggers row tap callback', (tester) async {
    _setMobileViewport(tester);
    BvidInfo? tappedVideo;

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
        ),
      ),
    );

    expect(find.text('Night Drive'), findsOneWidget);

    await tester.tap(find.text('Night Drive'));
    await tester.pump();
    expect(tappedVideo?.bvid, 'BV1xx411c7mD');
  });

  testWidgets('has no pagination controls and loads more near the bottom',
      (tester) async {
    _setMobileViewport(tester);
    var loadMoreCount = 0;

    await tester.pumpWidget(
      buildTestApp(
        SizedBox(
          key: const ValueKey('search_results_host'),
          width: 390,
          height: 420,
          child: SearchResultList(
            results: _manyResults,
            currentPage: 1,
            totalPages: 8,
            onVideoTap: (_) {},
            onLoadMore: () async => loadMoreCount++,
          ),
        ),
      ),
    );

    expect(find.byTooltip('Previous Page'), findsNothing);
    expect(find.byTooltip('Next Page'), findsNothing);
    expect(find.byTooltip('Jump to Page'), findsNothing);

    await tester.drag(find.byType(Scrollable), const Offset(0, -600));
    await tester.pump();

    expect(loadMoreCount, greaterThanOrEqualTo(1));
  });

  testWidgets('does not auto load while already loading or failed',
      (tester) async {
    _setMobileViewport(tester);
    var loadMoreCount = 0;

    await tester.pumpWidget(
      buildTestApp(
        SearchResultList(
          results: _manyResults,
          currentPage: 1,
          totalPages: 8,
          onVideoTap: (_) {},
          onLoadMore: () async => loadMoreCount++,
          isLoadingMore: true,
        ),
      ),
    );

    await tester.drag(find.byType(Scrollable), const Offset(0, -600));
    await tester.pump();
    expect(loadMoreCount, 0);

    await tester.pumpWidget(
      buildTestApp(
        SearchResultList(
          results: _manyResults,
          currentPage: 1,
          totalPages: 8,
          onVideoTap: (_) {},
          onLoadMore: () async => loadMoreCount++,
          loadMoreErrorMessage: 'Failed to load more',
        ),
      ),
    );

    await tester.drag(find.byType(Scrollable), const Offset(0, -600));
    await tester.pump();
    expect(loadMoreCount, 0);
  });

  testWidgets('preserves scroll offset across load-more states',
      (tester) async {
    _setMobileViewport(tester);
    const storageKey = 'mobile_search_results';

    Widget buildList({
      required List<BvidInfo> results,
      required int currentPage,
      bool isLoadingMore = false,
      int totalPages = 2,
    }) {
      return buildTestApp(
        SizedBox(
          width: 390,
          height: 280,
          child: SearchResultList(
            results: results,
            currentPage: currentPage,
            totalPages: totalPages,
            onVideoTap: (_) {},
            onLoadMore: () async {},
            isLoadingMore: isLoadingMore,
            listStorageKey: storageKey,
          ),
        ),
      );
    }

    await tester.pumpWidget(
      buildList(results: _manyResults, currentPage: 1),
    );

    var scrollable = _scrollableStateForStorageKey(tester, storageKey);
    final targetOffset = scrollable.position.maxScrollExtent / 2;
    expect(targetOffset, greaterThan(0));
    scrollable.position.jumpTo(targetOffset);
    await tester.pump();
    expect(scrollable.position.pixels, greaterThan(0));

    await tester.pumpWidget(
      buildList(
        results: _manyResults,
        currentPage: 1,
        isLoadingMore: true,
      ),
    );
    await tester.pump();

    scrollable = _scrollableStateForStorageKey(tester, storageKey);
    expect(scrollable.position.pixels, greaterThan(0));

    await tester.pumpWidget(
      buildList(
        results: [..._manyResults, ..._moreResults],
        currentPage: 2,
        totalPages: 2,
      ),
    );
    await tester.pump();

    scrollable = _scrollableStateForStorageKey(tester, storageKey);
    expect(scrollable.position.pixels, greaterThan(0));
  });

  testWidgets('footer shows loading, end, and retry states', (tester) async {
    _setMobileViewport(tester);
    var retryCount = 0;

    await tester.pumpWidget(
      buildTestApp(
        SearchResultList(
          results: _manyResults,
          currentPage: 1,
          totalPages: 8,
          onVideoTap: (_) {},
          isLoadingMore: true,
        ),
      ),
    );

    expect(find.text('Loading more...'), findsOneWidget);

    await tester.pumpWidget(
      buildTestApp(
        SearchResultList(
          results: _manyResults,
          currentPage: 8,
          totalPages: 8,
          onVideoTap: (_) {},
        ),
      ),
    );

    expect(find.text('— All results loaded —'), findsOneWidget);

    await tester.pumpWidget(
      buildTestApp(
        SearchResultList(
          results: _manyResults,
          currentPage: 1,
          totalPages: 8,
          onVideoTap: (_) {},
          loadMoreErrorMessage: 'Failed to load more',
          onRetryLoadMore: () async => retryCount++,
        ),
      ),
    );

    expect(find.text('Failed to load more'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(retryCount, 1);
  });
}

const _manyResults = [
  BvidInfo(
    bvid: 'BV1xx411c7m1',
    title: 'Night Drive 1',
    owner: 'BuSic',
    duration: 245,
  ),
  BvidInfo(
    bvid: 'BV1xx411c7m2',
    title: 'Night Drive 2',
    owner: 'BuSic',
    duration: 245,
  ),
  BvidInfo(
    bvid: 'BV1xx411c7m3',
    title: 'Night Drive 3',
    owner: 'BuSic',
    duration: 245,
  ),
  BvidInfo(
    bvid: 'BV1xx411c7m4',
    title: 'Night Drive 4',
    owner: 'BuSic',
    duration: 245,
  ),
  BvidInfo(
    bvid: 'BV1xx411c7m5',
    title: 'Night Drive 5',
    owner: 'BuSic',
    duration: 245,
  ),
  BvidInfo(
    bvid: 'BV1xx411c7m6',
    title: 'Night Drive 6',
    owner: 'BuSic',
    duration: 245,
  ),
];

const _moreResults = [
  BvidInfo(
    bvid: 'BV1xx411c7m7',
    title: 'Night Drive 7',
    owner: 'BuSic',
    duration: 245,
  ),
  BvidInfo(
    bvid: 'BV1xx411c7m8',
    title: 'Night Drive 8',
    owner: 'BuSic',
    duration: 245,
  ),
];

ScrollableState _scrollableStateForStorageKey(
  WidgetTester tester,
  String storageKey,
) {
  return tester.state<ScrollableState>(
    find.descendant(
      of: find.byKey(PageStorageKey<String>(storageKey)),
      matching: find.byType(Scrollable),
    ),
  );
}

void _setMobileViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}
