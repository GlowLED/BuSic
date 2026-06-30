import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/theme/app_theme_tokens.dart';
import 'package:busic/features/search_and_parse/application/parse_notifier.dart';
import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/presentation/search_screen.dart';
import 'package:busic/shared/widgets/app_panel.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SearchScreen', () {
    testWidgets('centers the input on the default state without the empty card',
        (tester) async {
      _setDesktopViewport(tester);

      await _pumpSearchScreen(tester);
      await tester.pumpAndSettle();

      expect(find.text('Start with a keyword or BV link'), findsNothing);
      expect(find.text('输入关键词或 BV 链接开始'), findsNothing);
      expect(
        find.text(
          'Results, parsed video details, page selection and comments will '
          'appear here.',
        ),
        findsNothing,
      );
      expect(find.text('搜索结果、视频详情、分 P 选择和评论会显示在这里。'), findsNothing);

      final inputRect = _inputBarRect(tester);

      expect(inputRect.top, greaterThan(200));
      expect((inputRect.center.dy - 400).abs(), lessThan(80));
    });

    testWidgets('moves the input to the top after submitting a search',
        (tester) async {
      _setDesktopViewport(tester);
      final notifier = _FakeParseNotifier(
        searchResults: const [
          BvidInfo(
            bvid: 'BV1xx411c7mD',
            title: 'Night Drive',
            owner: 'BuSic',
            duration: 245,
          ),
        ],
      );

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.enterText(find.byType(TextField), 'night drive');
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Night Drive'), findsOneWidget);
      expect(notifier.searchCalls.single, (keyword: 'night drive', page: 1));

      final inputRect = _inputBarRect(tester);
      final resultsRect = tester.getRect(
        _searchResultsScrollableFinder('night drive'),
      );
      expect(inputRect.top, lessThan(80));
      expect(inputRect.center.dy, lessThan(140));
      expect(resultsRect.top - inputRect.bottom, greaterThanOrEqualTo(0));
      expect(resultsRect.top - inputRect.bottom, lessThan(24));
      _expectDockedSearchBarSurface(tester);
    });

    testWidgets('clears a submitted desktop search and recenters the input',
        (tester) async {
      _setDesktopViewport(tester);
      final notifier = _FakeParseNotifier(
        searchResults: const [
          BvidInfo(
            bvid: 'BV1xx411c7mD',
            title: 'Night Drive',
            owner: 'BuSic',
            duration: 245,
          ),
        ],
      );

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.pumpAndSettle();
      final centeredRect = _inputBarRect(tester);

      await tester.enterText(find.byType(TextField), 'night drive');
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Night Drive'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      final input = tester.widget<TextField>(find.byType(TextField));
      final inputRect = _inputBarRect(tester);

      expect(input.controller?.text, isEmpty);
      expect(find.text('Night Drive'), findsNothing);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
      expect(notifier.searchCalls.single, (keyword: 'night drive', page: 1));
      expect((inputRect.top - centeredRect.top).abs(), lessThan(1));
      expect((inputRect.center.dy - centeredRect.center.dy).abs(), lessThan(1));
    });

    testWidgets('clear keeps a pending search from restoring stale results',
        (tester) async {
      _setDesktopViewport(tester);
      final searchGate = Completer<void>();
      final notifier = _FakeParseNotifier(
        searchDelay: searchGate.future,
        searchResults: const [
          BvidInfo(
            bvid: 'BV1xx411c7mD',
            title: 'Night Drive',
            owner: 'BuSic',
            duration: 245,
          ),
        ],
      );

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.pumpAndSettle();
      final centeredRect = _inputBarRect(tester);

      await tester.enterText(find.byType(TextField), 'night drive');
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pump();

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      expect(find.text('Searching...'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      searchGate.complete();
      await tester.pumpAndSettle();

      final input = tester.widget<TextField>(find.byType(TextField));
      final inputRect = _inputBarRect(tester);

      expect(input.controller?.text, isEmpty);
      expect(find.text('Night Drive'), findsNothing);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
      expect(notifier.searchCalls.single, (keyword: 'night drive', page: 1));
      expect((inputRect.top - centeredRect.top).abs(), lessThan(1));
      expect((inputRect.center.dy - centeredRect.center.dy).abs(), lessThan(1));
    });

    testWidgets('keyboard search keeps input focused and manually editable',
        (tester) async {
      _setDesktopViewport(tester);
      final notifier = _FakeParseNotifier(
        searchResults: const [
          BvidInfo(
            bvid: 'BV1xx411c7mD',
            title: 'Night Drive',
            owner: 'BuSic',
            duration: 245,
          ),
        ],
      );

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'night drive');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('Night Drive'), findsOneWidget);
      expect(_inputHasFocus(tester), isTrue);
      expect(notifier.searchCalls.single, (keyword: 'night drive', page: 1));

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      var input = tester.widget<TextField>(find.byType(TextField));
      var inputRect = _inputBarRect(tester);

      expect(input.controller?.text, isEmpty);
      expect(_inputHasFocus(tester), isTrue);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
      expect(find.text('Night Drive'), findsOneWidget);
      expect(inputRect.top, lessThan(80));

      await tester.enterText(find.byType(TextField), 'next search');
      await tester.pump();

      input = tester.widget<TextField>(find.byType(TextField));
      inputRect = _inputBarRect(tester);

      expect(input.controller?.text, 'next search');
      expect(_inputHasFocus(tester), isTrue);
      expect(inputRect.top, lessThan(80));
    });

    testWidgets('keeps the input docked after an empty search result',
        (tester) async {
      _setDesktopViewport(tester);
      final notifier = _FakeParseNotifier();

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.enterText(find.byType(TextField), 'missing song');
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Start with a keyword or BV link'), findsNothing);
      expect(find.text('输入关键词或 BV 链接开始'), findsNothing);
      expect(find.text('No results found'), findsOneWidget);
      expect(notifier.searchCalls.single, (keyword: 'missing song', page: 1));

      final inputRect = _inputBarRect(tester);
      expect(inputRect.top, lessThan(80));
      expect(inputRect.center.dy, lessThan(140));
    });

    testWidgets('empty focused input stays docked until focus is lost',
        (tester) async {
      _setDesktopViewport(tester);
      final notifier = _FakeParseNotifier();

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.pumpAndSettle();
      final centeredRect = _inputBarRect(tester);

      await tester.enterText(find.byType(TextField), 'missing song');
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      final emptiedFocusedRect = _inputBarRect(tester);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
      expect(emptiedFocusedRect.top, lessThan(80));
      expect(emptiedFocusedRect.center.dy, lessThan(140));

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      await tester.pumpAndSettle();

      final input = tester.widget<TextField>(find.byType(TextField));
      final inputRect = _inputBarRect(tester);

      expect(input.controller?.text, isEmpty);
      expect(find.text('No results found'), findsNothing);
      expect(notifier.searchCalls.single, (keyword: 'missing song', page: 1));
      expect((inputRect.top - centeredRect.top).abs(), lessThan(1));
      expect((inputRect.center.dy - centeredRect.center.dy).abs(), lessThan(1));
    });

    testWidgets('mobile portrait centers input and hides search button',
        (tester) async {
      _setMobilePortraitViewport(tester);

      await _pumpSearchScreen(tester);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_rounded), findsNothing);

      final inputRect = _inputBarRect(tester);
      expect(inputRect.top, greaterThan(250));
      expect((inputRect.center.dy - 422).abs(), lessThan(100));
    });

    testWidgets('mobile portrait submits with keyboard search action',
        (tester) async {
      _setMobilePortraitViewport(tester);
      final notifier = _FakeParseNotifier(
        searchResults: const [
          BvidInfo(
            bvid: 'BV1xx411c7mD',
            title: 'Night Drive',
            owner: 'BuSic',
            duration: 245,
          ),
        ],
      );

      await _pumpSearchScreen(tester, notifier: notifier);
      final centeredRect = _inputBarRect(tester);
      await tester.enterText(find.byType(TextField), 'night drive');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 130));
      final animatingRect = _inputBarRect(tester);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_rounded), findsNothing);
      expect(find.text('Night Drive'), findsOneWidget);
      expect(notifier.searchCalls.single, (keyword: 'night drive', page: 1));

      final inputRect = _inputBarRect(tester);
      final resultsRect = tester.getRect(
        _searchResultsScrollableFinder('night drive'),
      );
      expect(animatingRect.top, lessThan(centeredRect.top));
      expect(animatingRect.top, greaterThan(inputRect.top));
      expect(inputRect.top, lessThan(100));
      expect(inputRect.width, greaterThanOrEqualTo(centeredRect.width));
      expect(resultsRect.top - inputRect.bottom, greaterThanOrEqualTo(0));
      expect(resultsRect.top - inputRect.bottom, lessThan(24));
      _expectDockedSearchBarSurface(tester);
    });

    testWidgets('mobile clear button animates the input back to center',
        (tester) async {
      _setMobilePortraitViewport(tester);
      final notifier = _FakeParseNotifier(
        searchResults: const [
          BvidInfo(
            bvid: 'BV1xx411c7mD',
            title: 'Night Drive',
            owner: 'BuSic',
            duration: 245,
          ),
        ],
      );

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.pumpAndSettle();
      final centeredRect = _inputBarRect(tester);

      await tester.enterText(find.byType(TextField), 'night drive');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      final dockedRect = _inputBarRect(tester);

      expect(find.text('Night Drive'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 130));
      final animatingRect = _inputBarRect(tester);
      await tester.pumpAndSettle();

      final input = tester.widget<TextField>(find.byType(TextField));
      final inputRect = _inputBarRect(tester);

      expect(input.controller?.text, isEmpty);
      expect(find.text('Night Drive'), findsNothing);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
      expect(notifier.searchCalls.single, (keyword: 'night drive', page: 1));
      expect(animatingRect.top, greaterThan(dockedRect.top));
      expect(animatingRect.top, lessThan(inputRect.top));
      expect((inputRect.top - centeredRect.top).abs(), lessThan(1));
      expect((inputRect.center.dy - centeredRect.center.dy).abs(), lessThan(1));
    });

    testWidgets('mobile empty input blur animates the input back to center',
        (tester) async {
      _setMobilePortraitViewport(tester);
      final notifier = _FakeParseNotifier(
        searchResults: const [
          BvidInfo(
            bvid: 'BV1xx411c7mD',
            title: 'Night Drive',
            owner: 'BuSic',
            duration: 245,
          ),
        ],
      );

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.pumpAndSettle();
      final centeredRect = _inputBarRect(tester);

      await tester.enterText(find.byType(TextField), 'night drive');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      final emptiedFocusedRect = _inputBarRect(tester);

      expect(find.byIcon(Icons.close_rounded), findsNothing);
      expect(emptiedFocusedRect.top, lessThan(100));

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 130));
      final animatingRect = _inputBarRect(tester);
      await tester.pumpAndSettle();

      final input = tester.widget<TextField>(find.byType(TextField));
      final inputRect = _inputBarRect(tester);

      expect(input.controller?.text, isEmpty);
      expect(find.text('Night Drive'), findsNothing);
      expect(notifier.searchCalls.single, (keyword: 'night drive', page: 1));
      expect(animatingRect.top, greaterThan(emptiedFocusedRect.top));
      expect(animatingRect.top, lessThan(inputRect.top));
      expect((inputRect.top - centeredRect.top).abs(), lessThan(1));
      expect((inputRect.center.dy - centeredRect.center.dy).abs(), lessThan(1));
    });

    testWidgets('mobile portrait shows empty result state after no matches',
        (tester) async {
      _setMobilePortraitViewport(tester);
      final notifier = _FakeParseNotifier();

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.enterText(find.byType(TextField), 'missing song');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('No results found'), findsOneWidget);
      expect(
          find.text('Try another keyword or paste a BV link.'), findsOneWidget);
      expect(notifier.searchCalls.single, (keyword: 'missing song', page: 1));
    });

    testWidgets('mobile portrait appends next search page when scrolling down',
        (tester) async {
      _setMobilePortraitViewport(tester);
      final notifier = _FakeParseNotifier(
        searchResultsByPage: {
          1: _pageResults('Page One', 16),
          2: const [
            BvidInfo(
              bvid: 'BVpage2001',
              title: 'Page Two Result',
              owner: 'BuSic',
              duration: 245,
            ),
          ],
        },
        numPages: 2,
      );

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.enterText(find.byType(TextField), 'night drive');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('Page One 1'), findsOneWidget);
      expect(notifier.searchCalls.single, (keyword: 'night drive', page: 1));

      await _scrollSearchResultsToBottom(tester);

      expect(notifier.searchCalls, [
        (keyword: 'night drive', page: 1),
        (keyword: 'night drive', page: 2),
      ]);
      expect(
        _searchResultsScrollableState(tester, keyword: 'night drive')
            .position
            .pixels,
        greaterThan(0),
      );
      await _scrollSearchResultsUntilVisible(
        tester,
        'Page Two Result',
      );
      expect(find.text('Page Two Result'), findsOneWidget);
    });

    testWidgets('mobile load-more failure keeps existing results and retries',
        (tester) async {
      _setMobilePortraitViewport(tester);
      final notifier = _FakeParseNotifier(
        searchResultsByPage: {
          1: _pageResults('Page One', 16),
          2: const [
            BvidInfo(
              bvid: 'BVpage2001',
              title: 'Page Two Result',
              owner: 'BuSic',
              duration: 245,
            ),
          ],
        },
        numPages: 2,
        failPages: {2},
      );

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.enterText(find.byType(TextField), 'night drive');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      await _scrollSearchResultsToBottom(tester);

      expect(
        _searchResultsScrollableState(tester, keyword: 'night drive')
            .position
            .pixels,
        greaterThan(0),
      );
      expect(find.text('Failed to load more'), findsOneWidget);
      expect(find.text('Page Two Result'), findsNothing);

      notifier.failPages.clear();
      await _scrollSearchResultsToBottom(tester);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(notifier.searchCalls, [
        (keyword: 'night drive', page: 1),
        (keyword: 'night drive', page: 2),
        (keyword: 'night drive', page: 2),
      ]);
      await _scrollSearchResultsUntilVisible(
        tester,
        'Page Two Result',
      );
      expect(find.text('Page Two Result'), findsOneWidget);
    });

    testWidgets('new mobile search resets previously appended results',
        (tester) async {
      _setMobilePortraitViewport(tester);
      final notifier = _FakeParseNotifier(
        searchResultsByKeywordAndPage: {
          'night drive': {
            1: _pageResults('Old Page', 16),
            2: const [
              BvidInfo(
                bvid: 'BVold2001',
                title: 'Old Page Two Result',
                owner: 'BuSic',
                duration: 245,
              ),
            ],
          },
          'new song': {
            1: const [
              BvidInfo(
                bvid: 'BVnew1001',
                title: 'New Search Result',
                owner: 'BuSic',
                duration: 245,
              ),
            ],
          },
        },
        numPagesByKeyword: const {
          'night drive': 2,
          'new song': 1,
        },
      );

      await _pumpSearchScreen(tester, notifier: notifier);
      await tester.enterText(find.byType(TextField), 'night drive');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      await _scrollSearchResultsToBottom(tester);

      expect(notifier.searchCalls, [
        (keyword: 'night drive', page: 1),
        (keyword: 'night drive', page: 2),
      ]);
      await _scrollSearchResultsUntilVisible(
        tester,
        'Old Page Two Result',
      );
      expect(find.text('Old Page Two Result'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'new song');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('New Search Result'), findsOneWidget);
      expect(find.text('Old Page 1'), findsNothing);
      expect(find.text('Old Page Two Result'), findsNothing);
      expect(notifier.searchCalls.last, (keyword: 'new song', page: 1));
    });
  });
}

Future<void> _pumpSearchScreen(
  WidgetTester tester, {
  _FakeParseNotifier? notifier,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        parseNotifierProvider.overrideWith(
          () => notifier ?? _FakeParseNotifier(),
        ),
      ],
      child: buildTestApp(const SearchScreen()),
    ),
  );
}

Rect _inputBarRect(WidgetTester tester) {
  return tester.getRect(find.byKey(const ValueKey('search_bar_surface')));
}

void _expectDockedSearchBarSurface(WidgetTester tester) {
  final searchBarSurface = _searchBarSurface(tester);
  final inputDecoration = _inputSurfaceDecoration(tester);

  expect(searchBarSurface.borderRadius, _themeLargeRadius(tester));
  expect(searchBarSurface.boxShadow, isNull);
  expect(inputDecoration.borderRadius, _themeLargeRadius(tester));
  expect(inputDecoration.border, isNull);
  expect(inputDecoration.boxShadow, isNull);
}

AppPanel _searchBarSurface(WidgetTester tester) {
  return tester.widget<AppPanel>(
    find.byKey(const ValueKey('search_bar_surface')),
  );
}

BoxDecoration _inputSurfaceDecoration(WidgetTester tester) {
  final inputSurface = tester.widget<DecoratedBox>(
    find.byKey(const ValueKey('search_input_surface')),
  );
  return inputSurface.decoration as BoxDecoration;
}

BorderRadius _themeLargeRadius(WidgetTester tester) {
  final context = tester.element(find.byType(SearchScreen));
  return Theme.of(context).extension<AppThemeRadii>()!.largeRadius;
}

bool _inputHasFocus(WidgetTester tester) {
  return tester.widget<TextField>(find.byType(TextField)).focusNode?.hasFocus ??
      false;
}

void _setDesktopViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 800);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

void _setMobilePortraitViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

List<BvidInfo> _pageResults(String prefix, int count) {
  return List.generate(
    count,
    (index) => BvidInfo(
      bvid: 'BV${prefix.replaceAll(' ', '')}${index + 1}',
      title: '$prefix ${index + 1}',
      owner: 'BuSic',
      duration: 245,
    ),
  );
}

Future<void> _scrollSearchResultsToBottom(
  WidgetTester tester, {
  String keyword = 'night drive',
}) async {
  final scrollable = _searchResultsScrollableState(tester, keyword: keyword);
  scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
  await tester.pump();
  await tester.pumpAndSettle();
}

Future<void> _scrollSearchResultsUntilVisible(
  WidgetTester tester,
  String text, {
  String keyword = 'night drive',
}) async {
  await tester.scrollUntilVisible(
    find.text(text),
    200,
    scrollable: _searchResultsScrollableFinder(keyword),
  );
  await tester.pumpAndSettle();
}

ScrollableState _searchResultsScrollableState(
  WidgetTester tester, {
  required String keyword,
}) {
  return tester.state<ScrollableState>(_searchResultsScrollableFinder(keyword));
}

Finder _searchResultsScrollableFinder(String keyword) {
  return find.descendant(
    of: find.byKey(PageStorageKey<String>('search_results_$keyword')),
    matching: find.byType(Scrollable),
  );
}

class _FakeParseNotifier extends ParseNotifier {
  _FakeParseNotifier({
    this.searchResults = const [],
    this.searchResultsByPage,
    this.searchResultsByKeywordAndPage,
    this.searchDelay,
    this.numPages = 1,
    this.numPagesByKeyword = const {},
    Set<int>? failPages,
  }) : failPages = failPages ?? <int>{};

  final List<BvidInfo> searchResults;
  final Map<int, List<BvidInfo>>? searchResultsByPage;
  final Map<String, Map<int, List<BvidInfo>>>? searchResultsByKeywordAndPage;
  final Future<void>? searchDelay;
  final int numPages;
  final Map<String, int> numPagesByKeyword;
  final Set<int> failPages;
  final List<({String keyword, int page})> searchCalls = [];

  @override
  ParseState build() {
    return const ParseState.idle();
  }

  @override
  Future<void> parseInput(String input) async {
    state = const ParseState.parsing();
  }

  @override
  void reset() {
    state = const ParseState.idle();
  }

  @override
  Future<({int numPages, List<BvidInfo> results})> searchVideos(
    String keyword, {
    int page = 1,
    int pageSize = 20,
    bool updateStateOnError = true,
  }) async {
    searchCalls.add((keyword: keyword, page: page));
    if (searchDelay != null) {
      await searchDelay;
    }

    if (failPages.contains(page)) {
      throw StateError('load more failed');
    }

    final keywordPages = searchResultsByKeywordAndPage?[keyword];
    if (keywordPages != null) {
      return (
        results: keywordPages[page] ?? const <BvidInfo>[],
        numPages: numPagesByKeyword[keyword] ?? numPages,
      );
    }

    return (
      results: searchResultsByPage?[page] ?? searchResults,
      numPages: numPages,
    );
  }
}
