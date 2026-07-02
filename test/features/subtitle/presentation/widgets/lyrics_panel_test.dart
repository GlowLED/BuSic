import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/player/application/player_notifier.dart';
import 'package:busic/features/player/domain/models/player_state.dart';
import 'package:busic/features/subtitle/application/subtitle_notifier.dart';
import 'package:busic/features/subtitle/domain/models/subtitle_data.dart';
import 'package:busic/features/subtitle/presentation/widgets/lyrics_panel.dart';

import '../../../../test_helpers/test_app.dart';

void main() {
  testWidgets('错误终态显示重试按钮并触发显式重试', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    final subtitleNotifier = _FakeSubtitleNotifier(
      status: SubtitleLoadStatus.error,
      errorMessage: SubtitleNotifier.loginRequiredErrorCode,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          playerNotifierProvider.overrideWith(_FakePlayerNotifier.new),
          subtitleNotifierProvider('BVerror', 1).overrideWith(
            () => subtitleNotifier,
          ),
        ],
        child: buildTestApp(
          const LyricsPanel(bvid: 'BVerror', cid: 1),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();

    expect(subtitleNotifier.retryCallCount, 1);
  });

  testWidgets('无歌词终态不显示重试按钮', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          playerNotifierProvider.overrideWith(_FakePlayerNotifier.new),
          subtitleNotifierProvider('BVempty', 2).overrideWith(
            () => _FakeSubtitleNotifier(status: SubtitleLoadStatus.notFound),
          ),
        ],
        child: buildTestApp(
          const LyricsPanel(bvid: 'BVempty', cid: 2),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Retry'), findsNothing);
  });
}

class _FakePlayerNotifier extends PlayerNotifier {
  @override
  PlayerState build() => const PlayerState();
}

class _FakeSubtitleNotifier extends SubtitleNotifier {
  _FakeSubtitleNotifier({
    required this.status,
    this.errorMessage,
  });

  final SubtitleLoadStatus status;
  final String? errorMessage;
  int retryCallCount = 0;

  @override
  ({
    SubtitleData? subtitleData,
    int currentLineIndex,
    SubtitleLoadStatus status,
    String? errorMessage,
  }) build(String bvid, int cid) {
    return (
      subtitleData: null,
      currentLineIndex: -1,
      status: status,
      errorMessage: errorMessage,
    );
  }

  @override
  Future<void> retry() async {
    retryCallCount++;
  }
}
