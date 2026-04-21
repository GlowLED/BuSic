import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/shared/widgets/app_panel.dart';

import '../../test_helpers/test_app.dart';

void main() {
  testWidgets('applies the same border radius to the inner decoration',
      (tester) async {
    const customRadius = BorderRadius.all(Radius.circular(28));

    await tester.pumpWidget(
      buildTestApp(
        const AppPanel(
          borderRadius: customRadius,
          child: SizedBox(width: 120, height: 60),
        ),
      ),
    );

    final decoratedBox = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(AppPanel),
            matching: find.byType(DecoratedBox),
          ),
        )
        .last;
    final decoration = decoratedBox.decoration as BoxDecoration;

    expect(decoration.borderRadius, customRadius);
  });
}
