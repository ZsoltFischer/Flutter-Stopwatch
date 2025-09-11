import 'package:core/core.dart' show BaseTheme;
import 'package:flutter/cupertino.dart';

class StopwatchAppTheme {
  static final CupertinoThemeData cupertinoThemeData = BaseTheme
      .cupertinoThemeData
      .copyWith(
        primaryColor: CupertinoColors.activeBlue,
        brightness: Brightness.light,
      );
}
