import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/features/settings/application/settings_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsNotifier.resetToDefaults', () {
    test('removes legacy startup recommendation preferences', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': 2,
        'is_minimal_mode': true,
        'minimal_playlist_id': 42,
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(settingsNotifierProvider.notifier);
      await notifier.resetToDefaults();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_minimal_mode'), isNull);
      expect(prefs.getInt('minimal_playlist_id'), isNull);
      expect(prefs.getInt('theme_mode'), isNull);
    });
  });
}
