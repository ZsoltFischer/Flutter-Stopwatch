import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/lap_list_tile.dart';

import 'helpers/duration_parser.dart';

/// Robot for integration testing the Stopwatch app.
/// Encapsulates all UI interactions and verifications for complex workflows.
class AppRobot {
  AppRobot(this.tester);
  final WidgetTester tester;

  /// ==========================================
  /// * Actions
  /// ==========================================

  Future<void> tapStartButton() async {
    final startButton = find.byKey(const ValueKey('StartButton'));
    expect(startButton, findsOneWidget);
    await tester.tap(startButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapPauseButton() async {
    final pauseButton = find.byKey(const ValueKey('PauseButton'));
    expect(pauseButton, findsOneWidget);
    await tester.tap(pauseButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapStopButton() async {
    final stopButton = find.byKey(const ValueKey('StopButton'));
    expect(stopButton, findsOneWidget);
    await tester.tap(stopButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapLapButton() async {
    final lapButton = find.byKey(const ValueKey('LapButton'));
    expect(lapButton, findsOneWidget);
    await tester.tap(lapButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapResumeButton() async {
    final resumeButton = find.byKey(const ValueKey('ResumeButton'));
    expect(resumeButton, findsOneWidget);
    await tester.tap(resumeButton);
    await tester.pumpAndSettle();
  }

  /// ==========================================
  /// * Verifications
  /// ==========================================

  Future<void> verifyClockTextCloseTo(
    Duration expected, {
    Duration tolerance = const Duration(milliseconds: 50),
  }) async {
    await tester.pumpAndSettle();
    final clockFinder = find.byKey(const ValueKey('AccurateDigitalClock'));
    expect(clockFinder, findsOneWidget);
    final clockWidget = tester.widget<Text>(clockFinder);
    final actualText = clockWidget.data ?? '';
    final actualDuration = parseDuration(actualText);
    expect(
      (actualDuration - expected).abs() <= tolerance,
      isTrue,
      reason: 'Expected $expected (+/- $tolerance), but found $actualDuration',
    );
  }

  ///
  Future<void> verifyLapCount(int expected) async {
    await tester.pumpAndSettle();
    final lapItems = find.byType(LapListTile);
    expect(lapItems, findsNWidgets(expected));
  }

  /// Verifies that a button with the given key is visible.
  Future<void> verifyButtonVisible(String key) async {
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey(key)), findsOneWidget);
  }
}
