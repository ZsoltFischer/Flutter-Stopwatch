import 'package:flutter/material.dart';

class StopwatchAppTheme {
  static final MaterialBasedCupertinoThemeData themeData =
      MaterialBasedCupertinoThemeData(
        materialTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      );
}
