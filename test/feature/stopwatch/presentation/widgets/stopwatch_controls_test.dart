// ignore_for_file: no-empty-block

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stopwatch/features/stopwatch/domain/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/stopwatch_controls.dart';

import '../../../../helpers/helpers.dart';
import '../../../../mocks.dart';
import '../../stopwatch_robot.dart';

void main() {
  group('StopwatchControls', () {
    late MockStopwatchBloc mockBloc;

    setUpAll(() {
      // Register a fallback value for the bloc state to satisfy mocktail
      registerFallbackValue(const StopwatchInitial());
    });

    setUp(() {
      // Instantiate the mock bloc
      mockBloc = MockStopwatchBloc();

      // Mock the methods that the widget will call
      when(() => mockBloc.start()).thenAnswer((_) {});
      when(() => mockBloc.pause()).thenAnswer((_) {});
      when(() => mockBloc.stop()).thenAnswer((_) {});
      when(() => mockBloc.recordLap()).thenAnswer((_) {});
    });

    testWidgets('should render the start button in the initial state', (
      tester,
    ) async {
      // Arrange
      await tester.pumpMockStopwatchBlocWithSliverChild(
        initialState: const StopwatchInitial(),
        mockBloc: mockBloc,
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
      await tester.pumpMockStopwatchBlocWithSliverChild(
        initialState: const StopwatchRunning(),
        mockBloc: mockBloc,
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
      await tester.pumpMockStopwatchBlocWithSliverChild(
        initialState: const StopwatchPaused(),
        mockBloc: mockBloc,
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
      await tester.pumpMockStopwatchBlocWithSliverChild(
        initialState: const StopwatchInitial(),
        mockBloc: mockBloc,
        sliverChild: const StopwatchControls(),
      );

      // Act
      await StopwatchRobot(tester).tapStartButton();

      // Assert
      verify(() => mockBloc.start()).called(1);
    });

    testWidgets('tapping pause button should call bloc.pause()', (
      tester,
    ) async {
      // Arrange
      await tester.pumpMockStopwatchBlocWithSliverChild(
        initialState: const StopwatchRunning(),
        mockBloc: mockBloc,
        sliverChild: const StopwatchControls(),
      );

      // Act
      await StopwatchRobot(tester).tapPauseButton();

      // Assert
      verify(() => mockBloc.pause()).called(1);
    });

    testWidgets('tapping resume button should call bloc.start()', (
      tester,
    ) async {
      // Arrange
      await tester.pumpMockStopwatchBlocWithSliverChild(
        initialState: const StopwatchPaused(),
        mockBloc: mockBloc,
        sliverChild: const StopwatchControls(),
      );

      // Act
      await StopwatchRobot(tester).tapResumeButton();

      // Assert
      verify(() => mockBloc.start()).called(1);
    });

    testWidgets(
      'tapping stop button should call bloc.stop() in running state',
      (tester) async {
        // Arrange
        await tester.pumpMockStopwatchBlocWithSliverChild(
          initialState: const StopwatchRunning(),
          mockBloc: mockBloc,
          sliverChild: const StopwatchControls(),
        );

        // Act
        await StopwatchRobot(tester).tapStopButton();

        // Assert
        verify(() => mockBloc.stop()).called(1);
      },
    );

    testWidgets('tapping stop button should call bloc.stop() in paused state', (
      tester,
    ) async {
      // Arrange
      await tester.pumpMockStopwatchBlocWithSliverChild(
        initialState: const StopwatchPaused(),
        mockBloc: mockBloc,
        sliverChild: const StopwatchControls(),
      );

      // Act
      await StopwatchRobot(tester).tapStopButton();

      // Assert
      verify(() => mockBloc.stop()).called(1);
    });

    testWidgets('tapping lap button should call bloc.recordLap()', (
      tester,
    ) async {
      // Arrange
      await tester.pumpMockStopwatchBlocWithSliverChild(
        initialState: const StopwatchRunning(),
        sliverChild: const StopwatchControls(),
        mockBloc: mockBloc,
      );

      // Act
      await StopwatchRobot(tester).tapLapButton();

      // Assert
      verify(() => mockBloc.recordLap()).called(1);
    });
  });
}
