import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:window_manager/window_manager.dart';

import 'package:busic/shared/widgets/desktop_window_resize_frame.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('wraps child in resize area when enabled', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DesktopWindowResizeFrame(enabled: true, child: Text('content')),
      ),
    );

    final resizeArea = tester.widget<DragToResizeArea>(
      find.byType(DragToResizeArea),
    );
    expect(resizeArea.resizeEdgeSize, 8);
    expect(resizeArea.enableResizeEdges, isNull);
    expect(find.text('content'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('returns child directly when disabled', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DesktopWindowResizeFrame(enabled: false, child: Text('content')),
      ),
    );

    expect(find.byType(DragToResizeArea), findsNothing);
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('disables resize edges while maximized or fullscreen', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DesktopWindowResizeFrame(enabled: true, child: Text('content')),
      ),
    );

    final listener = windowManager.listeners.single;

    listener.onWindowMaximize();
    await tester.pump();
    expect(
      tester
          .widget<DragToResizeArea>(find.byType(DragToResizeArea))
          .enableResizeEdges,
      isEmpty,
    );

    listener.onWindowUnmaximize();
    await tester.pump();
    expect(
      tester
          .widget<DragToResizeArea>(find.byType(DragToResizeArea))
          .enableResizeEdges,
      isNull,
    );

    listener.onWindowEnterFullScreen();
    await tester.pump();
    expect(
      tester
          .widget<DragToResizeArea>(find.byType(DragToResizeArea))
          .enableResizeEdges,
      isEmpty,
    );

    listener.onWindowLeaveFullScreen();
    await tester.pump();
    expect(
      tester
          .widget<DragToResizeArea>(find.byType(DragToResizeArea))
          .enableResizeEdges,
      isNull,
    );

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
