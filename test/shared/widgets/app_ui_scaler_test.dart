import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/shared/extensions/context_extensions.dart';
import 'package:busic/shared/widgets/app_ui_scaler.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('150% 缩放换算逻辑视口和 MediaQuery 几何信息', (tester) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late MediaQueryData innerMediaQuery;
    var taps = 0;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(1000, 800),
          devicePixelRatio: 2,
          textScaler: TextScaler.linear(1.3),
          padding: EdgeInsets.only(top: 24),
          viewPadding: EdgeInsets.only(top: 30),
          viewInsets: EdgeInsets.only(bottom: 300),
          systemGestureInsets: EdgeInsets.only(left: 18),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox.expand(
            child: AppUiScaler(
              scale: 1.5,
              child: Builder(
                builder: (context) {
                  innerMediaQuery = MediaQuery.of(context);
                  return Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      key: const Key('scaled-target'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () => taps++,
                      child: const SizedBox(width: 100, height: 100),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    expect(innerMediaQuery.size.width, closeTo(1000 / 1.5, 0.001));
    expect(innerMediaQuery.size.height, closeTo(800 / 1.5, 0.001));
    expect(innerMediaQuery.devicePixelRatio, 3);
    expect(innerMediaQuery.padding.top, 16);
    expect(innerMediaQuery.viewPadding.top, 20);
    expect(innerMediaQuery.viewInsets.bottom, 200);
    expect(innerMediaQuery.systemGestureInsets.left, 12);
    expect(innerMediaQuery.textScaler.scale(10), 13);
    expect(
      tester.getRect(find.byKey(const Key('scaled-target'))).size,
      const Size(150, 150),
    );

    await tester.tapAt(const Offset(125, 125));
    expect(taps, 1);
  });

  testWidgets('80% 缩放扩大逻辑视口且 100% 保持原始几何信息', (tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late Size innerSize;

    Future<void> pumpScale(double scale) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppUiScaler(
            scale: scale,
            child: Builder(
              builder: (context) {
                innerSize = MediaQuery.sizeOf(context);
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      );
    }

    await pumpScale(0.8);
    expect(innerSize, const Size(1000, 750));

    await pumpScale(1.0);
    expect(innerSize, const Size(800, 600));
  });

  testWidgets('缩放后的有效宽度驱动响应式断点', (tester) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late bool isDesktop;

    Future<void> pumpScale(double scale) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppUiScaler(
            scale: scale,
            child: Builder(
              builder: (context) {
                isDesktop = context.isDesktop;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      );
    }

    await pumpScale(1.0);
    expect(isDesktop, isTrue);

    await pumpScale(1.5);
    expect(isDesktop, isFalse);
  });
}
