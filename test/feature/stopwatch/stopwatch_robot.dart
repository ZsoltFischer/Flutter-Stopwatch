import 'package:flutter/foundation.dart' show ValueKey;
import 'package:flutter_test/flutter_test.dart';

class StopwatchRobot {
  const StopwatchRobot(this.tester);
  final WidgetTester tester;

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
}
