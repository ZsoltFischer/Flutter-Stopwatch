import 'package:flutter/cupertino.dart';
import 'package:stopwatch/app/theme.dart';
import 'package:stopwatch/l10n/gen/app_localizations.dart';
import 'package:stopwatch/routing/router.dart';

/// The main application widget for the Stopwatch app.
class StopwatchApp extends StatelessWidget {
  /// Creates a [StopwatchApp] widget.
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoApp.router(
        theme: StopwatchAppTheme.themeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: buildRouter(),
      ),
    );
  }
}
