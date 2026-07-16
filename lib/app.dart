import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/app_update/application/update_notifier.dart';
import 'features/auth/application/auth_notifier.dart';
import 'features/settings/application/settings_notifier.dart';
import 'shared/extensions/context_extensions.dart';
import 'shared/widgets/desktop_window_resize_frame.dart';

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
        ref.read(updateNotifierProvider.notifier).checkForUpdate(silent: true);
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
      builder: (context, child) {
        return DesktopWindowResizeFrame(
          child: _StartupAuthProbe(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}

class _StartupAuthProbe extends ConsumerStatefulWidget {
  const _StartupAuthProbe({required this.child});

  final Widget child;

  @override
  ConsumerState<_StartupAuthProbe> createState() => _StartupAuthProbeState();
}

class _StartupAuthProbeState extends ConsumerState<_StartupAuthProbe> {
  @override
  Widget build(BuildContext context) {
    ref.watch(authNotifierProvider);
    ref.listen<AuthSessionNotice?>(authSessionNoticeProvider, (_, next) {
      if (next == null) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        switch (next) {
          case AuthSessionNotice.sessionInvalid:
            context.showSnackBar(context.l10n.biliSessionInvalid);
        }
        ref.read(authSessionNoticeProvider.notifier).state = null;
      });
    });

    return widget.child;
  }
}
