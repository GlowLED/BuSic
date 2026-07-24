import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/features/settings/application/settings_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsNotifier 播放渐变设置', () {
    test('默认启用且默认时长为 1 秒', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(
        settingsNotifierProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await _settle();

      final settings = container.read(settingsNotifierProvider);
      expect(settings.playbackFadeEnabled, isTrue);
      expect(settings.playbackFadeDurationMs, 1000);
    });

    test('读取已保存设置且非法时长回退到 1 秒', () async {
      SharedPreferences.setMockInitialValues({
        'playback_fade_enabled': false,
        'playback_fade_duration_ms': 750,
      });
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(
        settingsNotifierProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await _settle();

      final settings = container.read(settingsNotifierProvider);
      expect(settings.playbackFadeEnabled, isFalse);
      expect(settings.playbackFadeDurationMs, 1000);
    });

    test('更新开关和时长后写入 SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(
        settingsNotifierProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);
      final notifier = container.read(settingsNotifierProvider.notifier);
      await _settle();

      await notifier.setPlaybackFadeEnabled(false);
      await notifier.setPlaybackFadeDurationMs(2000);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('playback_fade_enabled'), isFalse);
      expect(prefs.getInt('playback_fade_duration_ms'), 2000);
      expect(
        container.read(settingsNotifierProvider).playbackFadeDurationMs,
        2000,
      );
    });
  });

  group('SettingsNotifier.resetToDefaults', () {
    test('removes legacy startup recommendation preferences', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': 2,
        'is_minimal_mode': true,
        'minimal_playlist_id': 42,
        'playback_fade_enabled': false,
        'playback_fade_duration_ms': 2000,
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(
        settingsNotifierProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      final notifier = container.read(settingsNotifierProvider.notifier);
      await notifier.resetToDefaults();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_minimal_mode'), isNull);
      expect(prefs.getInt('minimal_playlist_id'), isNull);
      expect(prefs.getInt('theme_mode'), isNull);
      expect(prefs.getBool('playback_fade_enabled'), isNull);
      expect(prefs.getInt('playback_fade_duration_ms'), isNull);
    });
  });
}

Future<void> _settle() async {
  await Future<void>.delayed(const Duration(milliseconds: 30));
}
