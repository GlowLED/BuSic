import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:busic/core/router/app_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('appRouterProvider', () {
    test('startup always lands on the home route', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);
      addTearDown(router.dispose);

      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.home,
      );
    });

    test('player route uses a bottom-up transition', () {
      final page = buildPlayerRoutePage(
        key: const ValueKey('player'),
        child: const SizedBox(),
      );

      expect(page, isA<CustomTransitionPage<void>>());

      expect(page.transitionDuration, const Duration(milliseconds: 280));
      expect(
        page.reverseTransitionDuration,
        const Duration(milliseconds: 240),
      );
    });

    testWidgets('player transition builds a slide from the bottom',
        (tester) async {
      final page = buildPlayerRoutePage(
        key: const ValueKey('player'),
        child: const SizedBox(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return page.transitionsBuilder(
                context,
                const AlwaysStoppedAnimation<double>(1),
                const AlwaysStoppedAnimation<double>(0),
                const SizedBox(),
              );
            },
          ),
        ),
      );

      expect(find.byType(SlideTransition), findsOneWidget);
      expect(find.byType(FadeTransition), findsOneWidget);
    });
  });
}
