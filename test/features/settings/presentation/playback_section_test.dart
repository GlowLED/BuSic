import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/features/settings/application/settings_notifier.dart';
import 'package:busic/features/settings/presentation/widgets/playback_section.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('播放渐变开关控制时长选项的启用状态', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: buildTestApp(
          const SingleChildScrollView(child: PlaybackSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Playback fade'), findsOneWidget);
    expect(find.text('Fade duration'), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    expect(
      tester
          .widget<DropdownButton<int>>(find.byType(DropdownButton<int>).last)
          .onChanged,
      isNotNull,
    );

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(
      container.read(settingsNotifierProvider).playbackFadeEnabled,
      isFalse,
    );
    expect(
      tester
          .widget<DropdownButton<int>>(find.byType(DropdownButton<int>).last)
          .onChanged,
      isNull,
    );
  });
}
