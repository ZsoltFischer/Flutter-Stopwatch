import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/stopwatch_controls.dart';

import '../../../../helpers/fakes/fake_stopwatch_bloc.dart';
import '../../../../helpers/helpers.dart';
import '../../stopwatch_robot.dart';

void main() {
  group('StopwatchControls', () {
    late FakeStopwatchBloc fakeBloc;
    late StopwatchRobot robot;

    setUp(() {
      fakeBloc = FakeStopwatchBloc(const StopwatchInitial());
    });

    tearDown(() {
      fakeBloc.dispose();
    });

    testWidgets('shows Start button in Initial state', (tester) async {
      await tester.pumpFakeStopwatchWithSliverChild(
        initialState: const StopwatchInitial(),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );
      robot = StopwatchRobot(tester);

      expect(find.byKey(const ValueKey('PauseButton')), findsNothing);
      expect(find.byKey(const ValueKey('StopButton')), findsNothing);
      expect(find.byKey(const ValueKey('LapButton')), findsNothing);
      expect(find.byKey(const ValueKey('StartButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('ResumeButton')), findsNothing);

      await robot.tapStartButton();
    });

    testWidgets('shows Pause, Stop, Lap buttons in Running state', (
      tester,
    ) async {
      await tester.pumpFakeStopwatchWithSliverChild(
        initialState: StopwatchRunning(
          elapsedTimeInMs: 0,
          startTime: DateTime(100),
        ),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );
      expect(find.byKey(const ValueKey('PauseButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('StopButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('LapButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('StartButton')), findsNothing);
      expect(find.byKey(const ValueKey('ResumeButton')), findsNothing);
    });

    testWidgets('shows Resume and Stop buttons in Paused state', (
      tester,
    ) async {
      await tester.pumpFakeStopwatchWithSliverChild(
        initialState: const StopwatchPaused(elapsedTimeInMs: 100),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );
      expect(find.byKey(const ValueKey('ResumeButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('StopButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('StartButton')), findsNothing);
      expect(find.byKey(const ValueKey('PauseButton')), findsNothing);
      expect(find.byKey(const ValueKey('LapButton')), findsNothing);
    });

    testWidgets('tapping start transitions to running state', (tester) async {
      await tester.pumpFakeStopwatchWithSliverChild(
        initialState: const StopwatchInitial(),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );
      robot = StopwatchRobot(tester);

      expect(find.byKey(const ValueKey('PauseButton')), findsNothing);
      expect(find.byKey(const ValueKey('StopButton')), findsNothing);
      expect(find.byKey(const ValueKey('LapButton')), findsNothing);
      expect(find.byKey(const ValueKey('StartButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('ResumeButton')), findsNothing);

      await robot.tapStartButton();

      fakeBloc.emit(
        StopwatchRunning(
          elapsedTimeInMs: 0,
          startTime: DateTime(100),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('PauseButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('StopButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('LapButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('StartButton')), findsNothing);
      expect(find.byKey(const ValueKey('ResumeButton')), findsNothing);
    });
  });
}
