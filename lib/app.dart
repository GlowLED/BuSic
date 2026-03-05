import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/app_update/application/update_notifier.dart';
import 'features/settings/application/settings_notifier.dart';

/// Root application widget.
///
/// Configures [MaterialApp.router] with:
/// - go_router navigation
/// - Light/Dark theme support
/// - i18n localization delegates (en, zh)
class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  bool _updateCheckDone = false;

  @override
  void initState() {
    super.initState();
    // Schedule silent update check after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_updateCheckDone) {
        _updateCheckDone = true;
        ref
            .read(updateNotifierProvider.notifier)
            .checkForUpdate(silent: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsNotifierProvider);
    final seedColor = Color(settings.themeSeedColor);

    return MaterialApp.router(
      title: 'BuSic',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme(seedColor: seedColor),
      darkTheme: AppTheme.darkTheme(seedColor: seedColor),
      themeMode: settings.themeMode,

      // Routing
      routerConfig: router,

      // Localization
      locale: settings.locale != null ? Locale(settings.locale!) : null,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
