import 'package:flutter/cupertino.dart';
import 'package:stopwatch/app/presentation/theme/theme.dart';
import 'package:stopwatch/app/routing/router.dart';
import 'package:stopwatch/l10n/gen/app_localizations.dart';

class StopwatchApp extends StatelessWidget {
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoApp.router(
        theme: StopwatchAppTheme.cupertinoThemeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: buildRouter(),
      ),
    );
  }
}
