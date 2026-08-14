import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/shared/widgets/app_panel.dart';

import '../../test_helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget wrap(Widget child) {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return UncontrolledProviderScope(
      container: container,
      child: buildTestApp(child),
    );
  }

  testWidgets('applies the same border radius to the inner decoration', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    const customRadius = BorderRadius.all(Radius.circular(28));

    await tester.pumpWidget(
      wrap(
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

  testWidgets('skips BackdropFilter when reduceTransparency is enabled', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'reduce_transparency': true,
    });

    await tester.pumpWidget(
      wrap(const AppPanel(child: SizedBox(width: 120, height: 60))),
    );
    await tester.pump(const Duration(milliseconds: 40));

    expect(find.byType(BackdropFilter), findsNothing);
  });
}
