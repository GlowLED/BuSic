import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/features/settings/application/settings_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsNotifier 界面缩放设置', () {
    test('默认值为 100%', () async {
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

      expect(container.read(settingsNotifierProvider).uiScale, 1.0);
    });

    test('读取合法设置并将非法值回退到 100%', () async {
      SharedPreferences.setMockInitialValues({'ui_scale': 1.3});
      final validContainer = ProviderContainer();
      addTearDown(validContainer.dispose);
      final validSubscription = validContainer.listen(
        settingsNotifierProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(validSubscription.close);
      await _settle();
      expect(validContainer.read(settingsNotifierProvider).uiScale, 1.3);

      expect(SettingsNotifier.normalizeUiScale(double.nan), 1.0);
      expect(SettingsNotifier.normalizeUiScale(double.infinity), 1.0);
      expect(SettingsNotifier.normalizeUiScale(0.1), 1.0);
      expect(SettingsNotifier.normalizeUiScale(2.0), 1.0);
    });

    test('按 10% 步进并在上下限停止', () async {
      SharedPreferences.setMockInitialValues({'ui_scale': 1.0});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(
        settingsNotifierProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);
      await _settle();
      final notifier = container.read(settingsNotifierProvider.notifier);

      await notifier.increaseUiScale();
      expect(container.read(settingsNotifierProvider).uiScale, 1.1);
      await notifier.decreaseUiScale();
      expect(container.read(settingsNotifierProvider).uiScale, 1.0);

      await notifier.setUiScale(0.8);
      await notifier.decreaseUiScale();
      expect(container.read(settingsNotifierProvider).uiScale, 0.8);

      await notifier.setUiScale(1.5);
      await notifier.increaseUiScale();
      expect(container.read(settingsNotifierProvider).uiScale, 1.5);
    });

    test('更新与单独重置会写入 SharedPreferences', () async {
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
      final notifier = container.read(settingsNotifierProvider.notifier);

      await notifier.setUiScale(1.4);
      var prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('ui_scale'), 1.4);

      await notifier.resetUiScale();
      prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('ui_scale'), 1.0);
      expect(container.read(settingsNotifierProvider).uiScale, 1.0);
    });
  });

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
        'ui_scale': 1.4,
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
      expect(prefs.getDouble('ui_scale'), isNull);
    });
  });
}

Future<void> _settle() async {
  await Future<void>.delayed(const Duration(milliseconds: 30));
}
