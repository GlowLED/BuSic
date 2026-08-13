import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/features/settings/application/settings_notifier.dart';
import 'package:busic/features/settings/presentation/widgets/background_section.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('无背景图片时滑杆禁用且显示说明文案', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: buildTestApp(
          const SingleChildScrollView(child: BackgroundSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Background'), findsOneWidget);
    expect(find.text('Background image'), findsOneWidget);
    expect(find.text('Opacity'), findsOneWidget);
    expect(find.text('Blur'), findsOneWidget);

    final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
    expect(sliders, hasLength(2));
    expect(sliders[0].onChanged, isNull);
    expect(sliders[1].onChanged, isNull);
  });

  testWidgets('有背景图片时滑杆可用并联动更新设置', (tester) async {
    SharedPreferences.setMockInitialValues({
      'background_image_path': '/tmp/bg.png',
      'background_image_opacity': 0.4,
      'background_image_blur': 12.0,
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: buildTestApp(
          const SingleChildScrollView(child: BackgroundSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
    expect(sliders, hasLength(2));
    expect(sliders[0].onChanged, isNotNull);
    expect(sliders[1].onChanged, isNotNull);

    // 拖动透明度滑杆。
    sliders[0].onChanged!(0.8);
    await tester.pumpAndSettle();
    expect(
      container.read(settingsNotifierProvider).backgroundImageOpacity,
      closeTo(0.8, 0.001),
    );

    // 拖动模糊度滑杆。
    tester
        .widget<Slider>(find.byType(Slider).at(1))
        .onChanged!(24);
    await tester.pumpAndSettle();
    expect(
      container.read(settingsNotifierProvider).backgroundImageBlur,
      closeTo(24, 0.001),
    );

    // 透明度标签实时显示百分比。
    expect(find.text('80%'), findsOneWidget);
  });
}
