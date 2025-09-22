import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stopwatch/features/stopwatch/domain/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/stopwatch_controls.dart';

import '../../../../helpers/fakes/fake_stopwatch_bloc.dart';
import '../../../../helpers/helpers.dart';
import '../../stopwatch_robot.dart';

void main() {
  group('StopwatchControls', () {
    late FakeStopwatchBloc fakeBloc;

    setUp(() {
      fakeBloc = FakeStopwatchBloc();
    });

    testWidgets('should render the start button in the initial state', (
      tester,
    ) async {
      // Arrange
      await tester.pumpStopwatchBlocWithSliverChild(
        initialState: const StopwatchInitial(),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );

      // Assert
      expect(find.byKey(const ValueKey('StartButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('PauseButton')), findsNothing);
      expect(find.byKey(const ValueKey('ResumeButton')), findsNothing);
      expect(find.byKey(const ValueKey('StopButton')), findsNothing);
      expect(find.byKey(const ValueKey('LapButton')), findsNothing);
    });

    testWidgets('should render correct buttons in the running state', (
      tester,
    ) async {
      // Arrange
      await tester.pumpStopwatchBlocWithSliverChild(
        initialState: const StopwatchRunning(),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );

      // Assert
      expect(find.byKey(const ValueKey('StartButton')), findsNothing);
      expect(find.byKey(const ValueKey('PauseButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('ResumeButton')), findsNothing);
      expect(find.byKey(const ValueKey('StopButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('LapButton')), findsOneWidget);
    });

    testWidgets('should render correct buttons in the paused state', (
      tester,
    ) async {
      // Arrange
      await tester.pumpStopwatchBlocWithSliverChild(
        initialState: const StopwatchPaused(),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );

      // Assert
      expect(find.byKey(const ValueKey('StartButton')), findsNothing);
      expect(find.byKey(const ValueKey('PauseButton')), findsNothing);
      expect(find.byKey(const ValueKey('ResumeButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('StopButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('LapButton')), findsNothing);
    });

    testWidgets('tapping start button should call bloc.start()', (
      tester,
    ) async {
      // Arrange
      await tester.pumpStopwatchBlocWithSliverChild(
        initialState: const StopwatchInitial(),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );

      // Act
      await StopwatchRobot(tester).tapStartButton();

      // Assert
      verify(() => fakeBloc.start()).called(1);
    });

    testWidgets('tapping pause button should call bloc.pause()', (
      tester,
    ) async {
      // Arrange
      await tester.pumpStopwatchBlocWithSliverChild(
        initialState: const StopwatchRunning(),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );

      // Act
      await StopwatchRobot(tester).tapPauseButton();

      // Assert
      verify(() => fakeBloc.pause()).called(1);
    });

    testWidgets('tapping resume button should call bloc.start()', (
      tester,
    ) async {
      // Arrange
      await tester.pumpStopwatchBlocWithSliverChild(
        initialState: const StopwatchPaused(),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );

      // Act
      await StopwatchRobot(tester).tapResumeButton();

      // Assert
      verify(() => fakeBloc.start()).called(1);
    });

    testWidgets(
      'tapping stop button should call bloc.stop() in running state',
      (tester) async {
        // Arrange
        await tester.pumpStopwatchBlocWithSliverChild(
          initialState: const StopwatchRunning(),
          fakeBloc: fakeBloc,
          sliverChild: const StopwatchControls(),
        );

        // Act
        await StopwatchRobot(tester).tapStopButton();

        // Assert
        verify(() => fakeBloc.stop()).called(1);
      },
    );

    testWidgets('tapping stop button should call bloc.stop() in paused state', (
      tester,
    ) async {
      // Arrange
      await tester.pumpStopwatchBlocWithSliverChild(
        initialState: const StopwatchPaused(),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );

      // Act
      await StopwatchRobot(tester).tapStopButton();

      // Assert
      verify(() => fakeBloc.stop()).called(1);
    });

    testWidgets('tapping lap button should call bloc.recordLap()', (
      tester,
    ) async {
      // Arrange
      await tester.pumpStopwatchBlocWithSliverChild(
        initialState: const StopwatchRunning(),
        fakeBloc: fakeBloc,
        sliverChild: const StopwatchControls(),
      );

      // Act
      await StopwatchRobot(tester).tapLapButton();

      // Assert
      verify(() => fakeBloc.recordLap()).called(1);
    });
  });
}
