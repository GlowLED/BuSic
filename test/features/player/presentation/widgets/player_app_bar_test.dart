import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/player/presentation/widgets/player_app_bar.dart';

import '../../../../test_helpers/test_app.dart';

void main() {
  testWidgets('shows desktop window controls and invokes injected actions', (
    tester,
  ) async {
    var didStartDragging = false;
    var didMinimize = false;
    var didToggleMaximize = false;
    var didHideToTray = false;

    await tester.pumpWidget(
      ProviderScope(
        child: buildTestApp(
          PlayerAppBar(
            isDesktopOverride: true,
            onStartDragging: () => didStartDragging = true,
            onMinimize: () async => didMinimize = true,
            onToggleMaximize: () async => didToggleMaximize = true,
            onHideToTray: () async => didHideToTray = true,
          ),
        ),
      ),
    );

    expect(find.byTooltip('Minimize'), findsOneWidget);
    expect(find.byTooltip('Maximize or restore'), findsOneWidget);
    expect(find.byTooltip('Hide to tray'), findsOneWidget);

    await tester.drag(
      find.byKey(const ValueKey('player-window-drag-region')),
      const Offset(24, 0),
    );
    await tester.pump();
    expect(didStartDragging, isTrue);

    await tester.tap(find.byTooltip('Minimize'));
    await tester.pump();
    expect(didMinimize, isTrue);

    await tester.tap(find.byTooltip('Maximize or restore'));
    await tester.pump();
    expect(didToggleMaximize, isTrue);

    await tester.tap(find.byTooltip('Hide to tray'));
    await tester.pump();
    expect(didHideToTray, isTrue);
  });

  testWidgets('hides desktop window controls outside desktop mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: buildTestApp(
          const PlayerAppBar(isDesktopOverride: false),
        ),
      ),
    );

    expect(find.byTooltip('Queue'), findsOneWidget);
    expect(find.byTooltip('Minimize'), findsNothing);
    expect(find.byTooltip('Maximize or restore'), findsNothing);
    expect(find.byTooltip('Hide to tray'), findsNothing);
    expect(
      find.byKey(const ValueKey('player-window-drag-region')),
      findsNothing,
    );
  });
}
