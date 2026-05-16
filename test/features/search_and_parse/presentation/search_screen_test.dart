import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/search_and_parse/application/parse_notifier.dart';
import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/presentation/search_screen.dart';

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
      expect(inputRect.top, lessThan(80));
      expect(inputRect.center.dy, lessThan(140));
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
      expect(notifier.searchCalls.single, (keyword: 'missing song', page: 1));

      final inputRect = _inputBarRect(tester);
      expect(inputRect.top, lessThan(80));
      expect(inputRect.center.dy, lessThan(140));
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
  return tester.getRect(find.byKey(const ValueKey('search_input_surface')));
}

void _setDesktopViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 800);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

class _FakeParseNotifier extends ParseNotifier {
  _FakeParseNotifier({
    this.searchResults = const [],
  });

  final List<BvidInfo> searchResults;
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
  }) async {
    searchCalls.add((keyword: keyword, page: page));
    return (results: searchResults, numPages: 1);
  }
}
