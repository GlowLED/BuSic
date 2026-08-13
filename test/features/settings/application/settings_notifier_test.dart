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

  group('SettingsNotifier 背景图片设置', () {
    test('默认无背景且透明度 0.5、模糊度 0', () async {
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
      expect(settings.backgroundImagePath, isNull);
      expect(settings.backgroundImageOpacity, 0.5);
      expect(settings.backgroundImageBlur, 0);
    });

    test('读取已保存背景设置且越界值被钳制', () async {
      SharedPreferences.setMockInitialValues({
        'background_image_path': '/tmp/bg.png',
        'background_image_opacity': 2.5,
        'background_image_blur': -3.0,
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
      expect(settings.backgroundImagePath, '/tmp/bg.png');
      expect(settings.backgroundImageOpacity, 1.0);
      expect(settings.backgroundImageBlur, 0);
    });

    test('更新背景字段后写入 SharedPreferences', () async {
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

      await notifier.setBackgroundImagePath('/data/bg.png');
      await notifier.setBackgroundImageOpacity(0.3);
      await notifier.setBackgroundImageBlur(12);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('background_image_path'), '/data/bg.png');
      expect(prefs.getDouble('background_image_opacity'), 0.3);
      expect(prefs.getDouble('background_image_blur'), 12);

      final settings = container.read(settingsNotifierProvider);
      expect(settings.backgroundImagePath, '/data/bg.png');
      expect(settings.backgroundImageOpacity, 0.3);
      expect(settings.backgroundImageBlur, 12);

      // 移除背景时清空路径 key。
      await notifier.setBackgroundImagePath(null);
      expect(prefs.getString('background_image_path'), isNull);
      expect(
        container.read(settingsNotifierProvider).backgroundImagePath,
        isNull,
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
        'background_image_path': '/tmp/bg.png',
        'background_image_opacity': 0.5,
        'background_image_blur': 10.0,
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
      expect(prefs.getString('background_image_path'), isNull);
      expect(prefs.getDouble('background_image_opacity'), isNull);
      expect(prefs.getDouble('background_image_blur'), isNull);
    });
  });
}

Future<void> _settle() async {
  await Future<void>.delayed(const Duration(milliseconds: 30));
}
