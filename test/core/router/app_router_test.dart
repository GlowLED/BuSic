import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  });
}
