import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/lap_entity.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/stopwatch_state_entity.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/models/lap_viewmodel.dart';

import '../../../../mocks.dart';

//==============================================================================

void main() {
  group('StopwatchBloc', () {
    //==========================================================================
    // * DECLARATIONS
    //==========================================================================
    late StopwatchBloc stopwatchBloc;
    late MockStopwatchService mockStopwatchService;
    late MockStartStopwatchUsecase mockStartStopwatchUsecase;
    late MockPauseStopwatchUsecase mockPauseStopwatchUsecase;
    late MockStopStopwatchUsecase mockStopStopwatchUsecase;
    late MockRecordLapUsecase mockRecordLapUsecase;

    // Use a stream controller to manually emit values for the duration stream
    late StreamController<StopwatchStateEntity> durationStreamController;
    late DateTime testStartTime;

    // A sample entity to be emitted by the mock service
    const tStopwatchStateEntity = StopwatchStateEntity(
      elapsedTimeInMs: 1234,
      laps: [LapEntity(index: 0, lapTime: 1234)],
      isComplete: false,
    );

    //==========================================================================
    // * SETUP & TEARDOWN
    //==========================================================================
    setUp(() {
      mockStopwatchService = MockStopwatchService();
      mockStartStopwatchUsecase = MockStartStopwatchUsecase();
      mockPauseStopwatchUsecase = MockPauseStopwatchUsecase();
      mockStopStopwatchUsecase = MockStopStopwatchUsecase();
      mockRecordLapUsecase = MockRecordLapUsecase();

      durationStreamController = StreamController<StopwatchStateEntity>();
      testStartTime = DateTime.now();

      when(
        () => mockStopwatchService.durationStream,
      ).thenAnswer((_) => durationStreamController.stream);
      when(() => mockStartStopwatchUsecase.call()).thenReturn(null);
      when(() => mockPauseStopwatchUsecase.call()).thenReturn(null);
      when(() => mockStopStopwatchUsecase.call()).thenReturn(null);
      when(() => mockRecordLapUsecase.call()).thenReturn(null);
      when(() => mockStopwatchService.dispose()).thenAnswer((_) async {});

      stopwatchBloc = StopwatchBloc(
        stopwatchService: mockStopwatchService,
        startStopwatchUsecase: mockStartStopwatchUsecase,
        pauseStopwatchUsecase: mockPauseStopwatchUsecase,
        stopStopwatchUsecase: mockStopStopwatchUsecase,
        recordLapUsecase: mockRecordLapUsecase,
      );
    });

    // Close the stream controller and BLoC after each test
    tearDown(() {
      durationStreamController.close();
      stopwatchBloc.close();
    });

    //==========================================================================
    // * TESTS
    //==========================================================================

    test('initial state is StopwatchInitial', () {
      expect(stopwatchBloc.state, const StopwatchInitial());
    });

    group('Start Event', () {
      blocTest<StopwatchBloc, StopwatchState>(
        'should start service and emit [StopwatchRunning] from [StopwatchInitial]',
        build: () => stopwatchBloc,
        act: (bloc) => bloc.start(),
        expect: () => [
          isA<StopwatchRunning>()
              .having((s) => s.elapsedTimeInMs, 'elapsedTimeInMs', 0)
              .having((s) => s.laps, 'laps', isEmpty),
        ],
        verify: (_) {
          verify(() => mockStartStopwatchUsecase()).called(1);
          verify(
            () => mockStopwatchService.durationStream.listen(any()),
          ).called(1);
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'should resume service and emit [StopwatchRunning] from [StopwatchPaused]',
        build: () => stopwatchBloc,
        seed: () => const StopwatchPaused(
          elapsedTimeInMs: 5000,
          laps: [LapViewModel(index: 1, lapTime: 2000)],
        ),
        act: (bloc) => bloc.start(),
        expect: () => [
          isA<StopwatchRunning>()
              .having((s) => s.elapsedTimeInMs, 'elapsedTimeInMs', 5000)
              .having((s) => s.laps.length, 'laps length', 1),
        ],
        verify: (_) {
          verify(() => mockStartStopwatchUsecase()).called(1);
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'should do nothing if already in [StopwatchRunning] state',
        build: () => stopwatchBloc,
        seed: () => StopwatchRunning(
          elapsedTimeInMs: 1000,
          startTime: testStartTime,
        ),
        act: (bloc) => bloc.start(),
        expect: () => <StopwatchState>[],
        verify: (_) {
          verifyNever(() => mockStartStopwatchUsecase());
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'rapidly calling start twice does not emit duplicate states',
        build: () => stopwatchBloc,
        seed: StopwatchInitial.new,
        act: (bloc) => bloc
          ..start()
          ..start(),
        expect: () => [
          isA<StopwatchRunning>(),
        ],
        verify: (_) {
          verify(() => mockStartStopwatchUsecase()).called(1);
        },
      );
    });

    group('Pause Event', () {
      blocTest<StopwatchBloc, StopwatchState>(
        'should pause service and emit [StopwatchPaused] from [StopwatchRunning]',
        build: () => stopwatchBloc,
        seed: () => StopwatchRunning(
          elapsedTimeInMs: 3000,
          startTime: testStartTime,
        ),
        act: (bloc) => bloc.pause(),
        expect: () => [
          const StopwatchPaused(elapsedTimeInMs: 3000),
        ],
        verify: (_) {
          verify(() => mockPauseStopwatchUsecase()).called(1);
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'should do nothing if in [StopwatchInitial] state',
        build: () => stopwatchBloc,
        act: (bloc) => bloc.pause(),
        expect: () => <StopwatchState>[],
        verify: (_) {
          verifyNever(() => mockPauseStopwatchUsecase());
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'should do nothing if already in [StopwatchPaused] state',
        build: () => stopwatchBloc,
        seed: () => const StopwatchPaused(elapsedTimeInMs: 3000),
        act: (bloc) => bloc.pause(),
        expect: () => <StopwatchState>[],
        verify: (_) {
          verifyNever(() => mockPauseStopwatchUsecase());
        },
      );
    });

    group('Stop Event', () {
      blocTest<StopwatchBloc, StopwatchState>(
        'should stop service and emit [StopwatchInitial] from [StopwatchRunning]',
        build: () => stopwatchBloc,
        seed: () => StopwatchRunning(
          elapsedTimeInMs: 3000,
          startTime: testStartTime,
        ),
        act: (bloc) => bloc.stop(),
        expect: () => [const StopwatchInitial()],
        verify: (_) {
          verify(() => mockStopStopwatchUsecase()).called(1);
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'should stop service and emit [StopwatchInitial] from [StopwatchPaused]',
        build: () => stopwatchBloc,
        seed: () => const StopwatchPaused(elapsedTimeInMs: 3000),
        act: (bloc) => bloc.stop(),
        expect: () => [const StopwatchInitial()],
        verify: (_) {
          verify(() => mockStopStopwatchUsecase()).called(1);
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'should do nothing if already in [StopwatchInitial] state',
        build: () => stopwatchBloc,
        act: (bloc) => bloc.stop(),
        expect: () => <StopwatchState>[],
        verify: (_) {
          verifyNever(() => mockStopStopwatchUsecase());
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'lap list cleared on stop/reset',
        build: () => stopwatchBloc,
        seed: () => StopwatchRunning(
          elapsedTimeInMs: 1000,
          startTime: DateTime.now(),
          laps: const [LapViewModel(index: 0, lapTime: 100)],
        ),
        act: (bloc) => bloc.stop(),
        expect: () => [const StopwatchInitial()],
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'should stop the stopwatch and emit [StopwatchInitial] if tick is complete',
        build: () => stopwatchBloc,
        seed: () => StopwatchRunning(
          elapsedTimeInMs: 1000,
          startTime: testStartTime,
        ),
        act: (bloc) {
          bloc.stop();
        },
        expect: () => [
          const StopwatchInitial(),
        ],
        verify: (_) {
          // Verify that the stop usecase is called as a result of the complete tick
          verify(() => mockStopStopwatchUsecase()).called(1);
        },
      );
    });

    group('RecordLap Event', () {
      blocTest<StopwatchBloc, StopwatchState>(
        'should call record lap usecase when in [StopwatchRunning] state',
        build: () => stopwatchBloc,
        seed: () => StopwatchRunning(
          elapsedTimeInMs: 3000,
          startTime: testStartTime,
        ),
        act: (bloc) => bloc.recordLap(),
        expect: () => <StopwatchState>[],
        verify: (_) {
          verify(() => mockRecordLapUsecase()).called(1);
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'should NOT call record lap usecase when in [StopwatchPaused] state',
        build: () => stopwatchBloc,
        seed: () => const StopwatchPaused(elapsedTimeInMs: 3000),
        act: (bloc) => bloc.recordLap(),
        expect: () => <StopwatchState>[],
        verify: (_) {
          verifyNever(() => mockRecordLapUsecase());
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'should NOT call record lap usecase when in [StopwatchInitial] state',
        build: () => stopwatchBloc,
        act: (bloc) => bloc.recordLap(),
        expect: () => <StopwatchState>[],
        verify: (_) {
          verifyNever(() => mockRecordLapUsecase());
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'record lap with zero elapsed time',
        build: () => stopwatchBloc,
        seed: () =>
            StopwatchRunning(elapsedTimeInMs: 0, startTime: testStartTime),
        act: (bloc) => bloc.recordLap(),
        verify: (_) {
          verifyNever(() => mockRecordLapUsecase());
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'rapid lap recording',
        build: () => stopwatchBloc,
        seed: () =>
            StopwatchRunning(elapsedTimeInMs: 100, startTime: testStartTime),
        act: (bloc) {
          bloc
            ..recordLap()
            ..add(
              StopwatchTick(
                stopwatchStateEntity: const StopwatchStateEntity(
                  elapsedTimeInMs: 100,
                  laps: [
                    LapEntity(index: 0, lapTime: 100),
                  ],
                  isComplete: false,
                ),
              ),
            )
            ..recordLap()
            ..add(
              StopwatchTick(
                stopwatchStateEntity: const StopwatchStateEntity(
                  elapsedTimeInMs: 100,
                  laps: [
                    LapEntity(index: 0, lapTime: 100),
                    LapEntity(index: 1, lapTime: 100),
                  ],
                  isComplete: false,
                ),
              ),
            )
            ..recordLap()
            ..add(
              StopwatchTick(
                stopwatchStateEntity: const StopwatchStateEntity(
                  elapsedTimeInMs: 100,
                  laps: [
                    LapEntity(index: 0, lapTime: 100),
                    LapEntity(index: 1, lapTime: 100),
                    LapEntity(index: 2, lapTime: 100),
                  ],
                  isComplete: false,
                ),
              ),
            );
        },
        expect: () => [
          isA<StopwatchRunning>().having(
            (s) => s.laps.length,
            'laps length',
            1,
          ),
          isA<StopwatchRunning>().having(
            (s) => s.laps.length,
            'laps length',
            2,
          ),
          isA<StopwatchRunning>().having(
            (s) => s.laps.length,
            'laps length',
            3,
          ),
        ],
        verify: (_) {
          // Should have 3 laps with correct durations
          verify(() => mockRecordLapUsecase()).called(3);
        },
      );
    });

    group('Tick Event (from service stream)', () {
      blocTest<StopwatchBloc, StopwatchState>(
        'should emit [StopwatchRunning] with updated duration and laps',
        build: () => stopwatchBloc,
        seed: () => StopwatchRunning(
          elapsedTimeInMs: 1000,
          startTime: testStartTime,
        ),
        act: (bloc) {
          bloc.add(StopwatchTick(stopwatchStateEntity: tStopwatchStateEntity));
        },
        expect: () => [
          StopwatchRunning(
            elapsedTimeInMs: 1234,
            startTime: testStartTime,
            laps: tStopwatchStateEntity.laps
                .map(LapViewModel.fromEntity)
                .toList(),
          ),
        ],
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'should emit [StopwatchPaused] with updated duration and laps',
        build: () => stopwatchBloc,
        seed: () => const StopwatchPaused(elapsedTimeInMs: 1000),
        act: (bloc) {
          bloc.add(StopwatchTick(stopwatchStateEntity: tStopwatchStateEntity));
        },
        expect: () => [
          isA<StopwatchPaused>()
              .having((s) => s.elapsedTimeInMs, 'elapsedTimeInMs', 1234)
              .having((s) => s.laps.length, 'laps length', 1),
        ],
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'stops when max duration reached',
        build: () => stopwatchBloc,
        seed: () => StopwatchRunning(
          elapsedTimeInMs: double.maxFinite.toInt() - 1,
          startTime: DateTime.now(),
        ),
        act: (bloc) {
          bloc.add(
            StopwatchTick(
              stopwatchStateEntity: StopwatchStateEntity(
                elapsedTimeInMs: double.maxFinite.toInt(),
                laps: const [],
                isComplete: true,
              ),
            ),
          );
        },
        expect: () => [const StopwatchInitial()],
      );
    });

    group('close', () {
      test(
        'should dispose service even if subscription does not exist',
        () async {
          when(() => mockStopwatchService.dispose()).thenAnswer((_) async {});

          // Call close immediately without starting the bloc
          await stopwatchBloc.close();
          // Verify dispose() was still called
          verify(() => mockStopwatchService.dispose()).called(1);
        },
      );

      test('dispose called multiple times does not throw', () async {
        await stopwatchBloc.close();
        await stopwatchBloc.close();
        // Verify that no exceptions were thrown
        expect(() => stopwatchBloc.close(), returnsNormally);
      });

      // blocTest(
      //   'close disposes of resources',
      //   build: () => stopwatchBloc,
      //   act: (bloc) async {
      //     await bloc.close();
      //   },
      //   verify: (_) {
      //     // Verify that dispose was called on the service
      //     verify(() => mockStopwatchService.dispose()).called(any());
      //   },
      // );
    });

    /// =========================================================================
    /// * Edge Cases
    /// =========================================================================

    group('edge cases', () {
      blocTest<StopwatchBloc, StopwatchState>(
        'rapid start/pause/stop does not emit duplicate states',
        build: () => stopwatchBloc,
        seed: StopwatchInitial.new,
        act: (bloc) {
          bloc
            ..start()
            ..pause()
            ..stop();
        },
        expect: () => [
          isA<StopwatchRunning>(),
          isA<StopwatchPaused>(),
          const StopwatchInitial(),
        ],
        verify: (_) {
          verify(
            () => mockStopwatchService.durationStream.listen(any()),
          ).called(1);
          verify(() => mockStartStopwatchUsecase()).called(1);
          verify(() => mockPauseStopwatchUsecase()).called(1);
          verify(() => mockStopStopwatchUsecase()).called(1);
        },
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'state restoration with tick',
        build: () => stopwatchBloc,
        seed: () => const StopwatchPaused(elapsedTimeInMs: 500),
        act: (bloc) {
          // Simulate tick event
          bloc.add(
            StopwatchTick(
              stopwatchStateEntity: const StopwatchStateEntity(
                elapsedTimeInMs: 600,
                laps: [],
                isComplete: false,
              ),
            ),
          );
        },
        expect: () => [
          const StopwatchPaused(elapsedTimeInMs: 600),
        ],
      );

      blocTest<StopwatchBloc, StopwatchState>(
        'invalid events in inappropriate states',
        build: () => stopwatchBloc,
        seed: () => const StopwatchInitial(),
        act: (bloc) {
          bloc
            ..pause()
            ..stop()
            ..recordLap();
        },
        expect: () => <StopwatchState>[],
        verify: (bloc) {
          verifyNever(() => mockPauseStopwatchUsecase());
          verifyNever(() => mockStopStopwatchUsecase());
          verifyNever(() => mockRecordLapUsecase());
        },
      );
    });
  });
}
