import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

import 'app.dart';
import 'core/api/bili_dio.dart';
import 'core/database/app_database.dart';
import 'core/services/audio_handler.dart';
import 'core/utils/platform_utils.dart';
import 'core/window/window_service.dart';
import 'features/auth/application/auth_notifier.dart';

/// Global provider for the audio handler (media session / background playback).
final audioHandlerProvider = Provider<BusicAudioHandler>((ref) {
  throw UnimplementedError('Must be overridden in main()');
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  // Desktop-specific: initialize window manager
  if (PlatformUtils.isDesktop) {
    await WindowService.initialize();
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        audioHandlerProvider.overrideWithValue(audioHandler),
      ],
      child: const App(),
    ),
  );
}
