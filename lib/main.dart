import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/utils/platform_utils.dart';
import 'core/window/window_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize media_kit engine
  MediaKit.ensureInitialized();

  // Initialize local database
  final database = AppDatabase();

  // Desktop-specific: initialize window manager
  if (PlatformUtils.isDesktop) {
    await WindowService.initialize();
  }

  runApp(
    ProviderScope(
      overrides: [
        // TODO: provide database instance via override
      ],
      child: const App(),
    ),
  );
}
