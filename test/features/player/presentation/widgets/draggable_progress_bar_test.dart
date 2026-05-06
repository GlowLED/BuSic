import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/player/presentation/widgets/draggable_progress_bar.dart';

import '../../../../test_helpers/test_app.dart';

void main() {
  Widget buildSubject({
    double progress = 0.5,
    ValueChanged<Duration>? onSeek,
  }) {
    return buildTestApp(
      Center(
        child: SizedBox(
          width: 200,
          height: 20,
          child: DraggableProgressBar(
            progress: progress,
            duration: const Duration(seconds: 120),
            onSeek: onSeek ?? (_) {},
          ),
        ),
      ),
    );
  }

  Finder findProgressBarDescendant(Type type) {
    return find.descendant(
      of: find.byType(DraggableProgressBar),
      matching: find.byType(type),
    );
  }

  TweenAnimationBuilder<double> findEmphasisAnimation(WidgetTester tester) {
    return tester.widget<TweenAnimationBuilder<double>>(
      find.byWidgetPredicate(
        (widget) => widget is TweenAnimationBuilder<double>,
      ),
    );
  }

  testWidgets('seeks to tapped progress position', (tester) async {
    Duration? seekPosition;

    await tester.pumpWidget(
      buildSubject(
        onSeek: (position) => seekPosition = position,
      ),
    );

    final topLeft = tester.getTopLeft(find.byType(DraggableProgressBar));
    await tester.tapAt(topLeft + const Offset(100, 10));
    await tester.pump();

    expect(seekPosition, const Duration(seconds: 60));
  });

  testWidgets('paints active progress with a default endpoint marker',
      (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(
      findProgressBarDescendant(CustomPaint),
      paints
        ..rrect()
        ..rrect()
        ..circle(),
    );
  });

  testWidgets('uses click cursor and emphasizes on hover', (tester) async {
    await tester.pumpWidget(buildSubject());

    final mouseRegion = tester.widget<MouseRegion>(
      findProgressBarDescendant(MouseRegion),
    );
    expect(mouseRegion.cursor, SystemMouseCursors.click);
    expect(findEmphasisAnimation(tester).tween.end, 0);

    final gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    addTearDown(() async {
      await gesture.removePointer();
    });

    await gesture.addPointer(
      location: tester.getCenter(find.byType(DraggableProgressBar)),
    );
    await tester.pump();

    expect(findEmphasisAnimation(tester).tween.end, 1);
  });
}
