import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/app/theme.dart';
import 'package:stopwatch/l10n/l10n.dart';
import 'package:stopwatch/routing/router.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp() async {
    await pumpWidget(
      CupertinoApp.router(
        theme: StopwatchAppTheme.themeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: buildRouter(),
      ),
    );
    await pumpAndSettle();
  }
}
