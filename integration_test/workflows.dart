import 'app_robot.dart';
import 'helpers/extensions.dart';

class Workflows {
  Workflows(this.robot);

  final AppRobot robot;

  /// ==========================================
  /// * Workflows
  /// ==========================================

  /// Resets the stopwatch by starting, pausing, and stopping it.
  Future<void> resetWorkflow() async {
    await robot.tapStartButton();
    await robot.tapPauseButton();
    await robot.tapStopButton();
  }

  /// Starts, records a lap, pauses, resumes, records another lap, pauses again, and stops.
  Future<void> fullCycleWorkflow() async {
    await robot.tapStartButton();
    await robot.tapLapButton();
    await robot.tapPauseButton();
    await robot.tapResumeButton();
    await robot.tapLapButton();
    await robot.tapPauseButton();
    await robot.tapStopButton();
  }

  /// Starts the stopwatch, records multiple laps, pauses, and stops.
  /// Verifies the correct number of laps recorded.
  Future<void> lapOnlyWorkflow(int lapCount) async {
    await robot.tapStartButton();
    for (var i = 0; i < lapCount; i++) {
      await robot.tester.wait(const Duration(milliseconds: 100));
      await robot.tapLapButton();
    }
    await robot.verifyLapCount(lapCount);
    await robot.tapPauseButton();
    await robot.tapStopButton();
  }

  /// Starts the stopwatch, lets it run for a duration, pauses, resumes, and stops.
  Future<void> startPauseResumeStopWorkflow() async {
    await robot.tapStartButton();
    await robot.tester.pump(const Duration(seconds: 5));
    await robot.verifyClockTextCloseTo(
      const Duration(seconds: 5),
      tolerance: const Duration(milliseconds: 500),
    );
    await robot.tapPauseButton();
    await robot.tester.pump(const Duration(seconds: 1));
    await robot.tapResumeButton();
    await robot.tester.pump(const Duration(seconds: 1));
    await robot.tapStopButton();
  }
}
