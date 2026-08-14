import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/features/settings/application/settings_notifier.dart';
import 'package:busic/features/settings/presentation/widgets/appearance_section.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('桌面外观设置显示缩放比例并通过按钮更新', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: buildTestApp(
          const SingleChildScrollView(child: AppearanceSection()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 40));

    expect(find.text('Interface scale'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);

    final resetButton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.restart_alt_rounded),
    );
    expect(resetButton.onPressed, isNull);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.add_rounded));
    await tester.pump();
    expect(container.read(settingsNotifierProvider).uiScale, 1.1);
    expect(find.text('110%'), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.restart_alt_rounded),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.widgetWithIcon(IconButton, Icons.remove_rounded));
    await tester.pump();
    expect(container.read(settingsNotifierProvider).uiScale, 1.0);

    await container
        .read(settingsNotifierProvider.notifier)
        .setUiScale(SettingsNotifier.supportedUiScales.last);
    await tester.pump();
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.add_rounded),
          )
          .onPressed,
      isNull,
    );

    await container
        .read(settingsNotifierProvider.notifier)
        .setUiScale(SettingsNotifier.supportedUiScales.first);
    await tester.pump();
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.remove_rounded),
          )
          .onPressed,
      isNull,
    );
  });
}
