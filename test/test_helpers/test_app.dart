import 'package:flutter/material.dart';

import 'package:busic/core/theme/app_theme.dart';
import 'package:busic/l10n/generated/app_localizations.dart';

Widget buildTestApp(
  Widget child, {
  ThemeData? theme,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: theme ?? AppTheme.lightTheme(seedColor: AppTheme.greenSeed),
    home: Scaffold(
      body: child,
    ),
  );
}
