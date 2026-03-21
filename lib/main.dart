import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/api/bili_dio.dart';
import 'core/database/app_database.dart';
import 'core/router/app_router.dart';
import 'core/services/audio_handler.dart';
import 'core/utils/logger.dart';
import 'core/utils/platform_utils.dart';
import 'core/window/tray_service.dart';
import 'core/window/window_service.dart';
import 'features/auth/application/auth_notifier.dart';

/// Global provider for the audio handler (media session / background playback).
final audioHandlerProvider = Provider<BusicAudioHandler>((ref) {
  throw UnimplementedError('Must be overridden in main()');
});

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Catch Flutter framework errors
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      AppLogger.error(
        'FlutterError: ${details.exceptionAsString()}',
        tag: 'Main',
      );
    };

    // Initialize media_kit engine
    MediaKit.ensureInitialized();

    // Initialize local database
    final database = AppDatabase();

    // Initialize cookie storage for HTTP client
    await BiliDio.initCookieStorage();

    // Initialize audio_service for background playback and media session.
    // On desktop platforms this is a no-op but remains safe to call.
    final audioHandler = await AudioService.init(
      builder: () => BusicAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.github.busic.audio',
        androidNotificationChannelName: 'BuSic 音乐播放',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );

    // Desktop-specific: initialize window manager and system tray
    if (PlatformUtils.isDesktop) {
      await WindowService.initialize();
      await TrayService.instance.initialize(
        showLabel: () => '显示 BuSic',
        quitLabel: () => '退出',
      );
    }

    // 读取极简模式标志
    final prefs = await SharedPreferences.getInstance();
    final isMinimalMode = prefs.getBool('is_minimal_mode') ?? false;

    runApp(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          audioHandlerProvider.overrideWithValue(audioHandler),
          initialMinimalModeProvider.overrideWithValue(isMinimalMode),
        ],
        child: const App(),
      ),
    );
  }, (error, stackTrace) {
    AppLogger.error(
      'Unhandled error: $error\n$stackTrace',
      tag: 'Main',
    );
  });
}
