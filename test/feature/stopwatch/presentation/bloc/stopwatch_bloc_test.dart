import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stopwatch/features/stopwatch/domain/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/lap_entity.dart';

import '../../../../mocks.dart';

void main() {
  late StopwatchBloc stopwatchBloc;
  late MockStopwatchService mockStopwatchService;
  late MockStartStopwatchUsecase mockStartStopwatchUsecase;
  late MockPauseStopwatchUsecase mockPauseStopwatchUsecase;
  late MockStopStopwatchUsecase mockStopStopwatchUsecase;
  late MockRecordLapUsecase mockRecordLapUsecase;
  late StreamController<List<LapEntity>> lapStreamController;

  setUpAll(() {
    registerFallbackValue(const Duration());
  });

  setUp(() {
    mockStopwatchService = MockStopwatchService();
    mockStartStopwatchUsecase = MockStartStopwatchUsecase();
    mockPauseStopwatchUsecase = MockPauseStopwatchUsecase();
    mockStopStopwatchUsecase = MockStopStopwatchUsecase();
    mockRecordLapUsecase = MockRecordLapUsecase();
    lapStreamController = StreamController<List<LapEntity>>();

    // Stub the lap stream and dispose method
    when(
      () => mockStopwatchService.lapStream,
    ).thenAnswer((_) => lapStreamController.stream);
    // ignore: no-empty-block
    when(() => mockStopwatchService.dispose()).thenAnswer((_) async {});

    stopwatchBloc = StopwatchBloc(
      stopwatchService: mockStopwatchService,
      startStopwatchUsecase: mockStartStopwatchUsecase,
      pauseStopwatchUsecase: mockPauseStopwatchUsecase,
      stopStopwatchUsecase: mockStopStopwatchUsecase,
      recordLapUsecase: mockRecordLapUsecase,
    );
  });

  tearDown(() {
    stopwatchBloc.close();
    lapStreamController.close();
  });

  // ===========================================================================
  // * Start Event Tests
  // ===========================================================================

  group('Start Event', () {
    blocTest<StopwatchBloc, StopwatchState>(
      'should start service and emit [StopwatchRunning] from [StopwatchInitial]',
      build: () => stopwatchBloc,
      act: (bloc) => bloc.add(StopwatchStart()),
      setUp: () {
        when(() => mockStartStopwatchUsecase()).thenReturn(null);
      },
      expect: () => [const StopwatchRunning(laps: [])],
      verify: (_) {
        verify(() => mockStartStopwatchUsecase()).called(1);
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'should resume service and emit [StopwatchRunning] from [StopwatchPaused]',
      build: () => stopwatchBloc,
      seed: () => const StopwatchPaused(),
      act: (bloc) => bloc.add(StopwatchStart()),
      setUp: () {
        when(() => mockStartStopwatchUsecase()).thenReturn(null);
      },
      expect: () => [const StopwatchRunning(laps: [])],
      verify: (_) {
        verify(() => mockStartStopwatchUsecase()).called(1);
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'should do nothing if already in [StopwatchRunning] state',
      build: () => stopwatchBloc,
      seed: () => const StopwatchRunning(),
      act: (bloc) => bloc.add(StopwatchStart()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockStartStopwatchUsecase());
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'rapidly calling start twice does not emit duplicate states',
      build: () => stopwatchBloc,
      act: (bloc) => bloc
        ..add(StopwatchStart())
        ..add(StopwatchStart()),
      setUp: () {
        when(() => mockStartStopwatchUsecase()).thenReturn(null);
      },
      verify: (bloc) {
        verify(() => mockStartStopwatchUsecase()).called(1);
      },
      expect: () => [const StopwatchRunning()],
    );
  });

  // ===========================================================================
  // * Pause Event Tests
  // ===========================================================================

  group('Pause Event', () {
    blocTest<StopwatchBloc, StopwatchState>(
      'should pause service and emit [StopwatchPaused] from [StopwatchRunning]',
      build: () => stopwatchBloc,
      seed: () => const StopwatchRunning(),
      act: (bloc) => bloc.add(StopwatchPause()),
      setUp: () {
        when(() => mockPauseStopwatchUsecase()).thenReturn(null);
      },
      expect: () => [const StopwatchPaused()],
      verify: (_) {
        verify(() => mockPauseStopwatchUsecase()).called(1);
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'should do nothing if in [StopwatchInitial] state',
      build: () => stopwatchBloc,
      seed: () => const StopwatchInitial(),
      act: (bloc) => bloc.add(StopwatchPause()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockPauseStopwatchUsecase());
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'should do nothing if already in [StopwatchPaused] state',
      build: () => stopwatchBloc,
      seed: () => const StopwatchPaused(),
      act: (bloc) => bloc.add(StopwatchPause()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockPauseStopwatchUsecase());
      },
    );
  });

  // ===========================================================================
  // * Stop Event Tests
  // ===========================================================================

  group('Stop Event', () {
    blocTest<StopwatchBloc, StopwatchState>(
      'should stop service and emit [StopwatchInitial] from [StopwatchRunning]',
      build: () => stopwatchBloc,
      seed: () => const StopwatchRunning(),
      act: (bloc) => bloc.add(StopwatchStop()),
      setUp: () {
        when(() => mockStopStopwatchUsecase()).thenReturn(null);
      },
      expect: () => [const StopwatchInitial()],
      verify: (_) {
        verify(() => mockStopStopwatchUsecase()).called(1);
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'should stop service and emit [StopwatchInitial] from [StopwatchPaused]',
      build: () => stopwatchBloc,
      seed: () => const StopwatchPaused(),
      act: (bloc) => bloc.add(StopwatchStop()),
      setUp: () {
        when(() => mockStopStopwatchUsecase()).thenReturn(null);
      },
      expect: () => [const StopwatchInitial()],
      verify: (_) {
        verify(() => mockStopStopwatchUsecase()).called(1);
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'should do nothing if already in [StopwatchInitial] state',
      build: () => stopwatchBloc,
      seed: () => const StopwatchInitial(),
      act: (bloc) => bloc.add(StopwatchStop()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockStopStopwatchUsecase());
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'lap list cleared on stop/reset',
      build: () => stopwatchBloc,
      seed: () =>
          const StopwatchPaused(laps: [LapEntity(index: 1, lapTime: 100)]),
      act: (bloc) => bloc.add(StopwatchStop()),
      setUp: () {
        when(() => mockStopStopwatchUsecase()).thenReturn(null);
      },
      expect: () => [const StopwatchInitial(laps: [])],
      verify: (_) {
        verify(() => mockStopStopwatchUsecase()).called(1);
      },
    );
  });

  // ===========================================================================
  // * RecordLap Event Tests
  // ===========================================================================

  group('RecordLap Event', () {
    blocTest<StopwatchBloc, StopwatchState>(
      'should call record lap usecase when in [StopwatchRunning] state',
      build: () => stopwatchBloc,
      seed: () => const StopwatchRunning(),
      act: (bloc) => bloc.add(StopwatchRecordLap()),
      setUp: () {
        when(() => mockRecordLapUsecase()).thenReturn(null);
      },
      expect: () => [],
      verify: (_) {
        verify(() => mockRecordLapUsecase()).called(1);
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'should NOT call record lap usecase when in [StopwatchPaused] state',
      build: () => stopwatchBloc,
      seed: () => const StopwatchPaused(),
      act: (bloc) => bloc.add(StopwatchRecordLap()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockRecordLapUsecase());
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'should NOT call record lap usecase when in [StopwatchInitial] state',
      build: () => stopwatchBloc,
      seed: () => const StopwatchInitial(),
      act: (bloc) => bloc.add(StopwatchRecordLap()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockRecordLapUsecase());
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'should update laps state when a lap is recorded',
      build: () {
        when(() => mockRecordLapUsecase()).thenAnswer((_) {
          lapStreamController.add([const LapEntity(index: 1, lapTime: 100)]);
        });

        return stopwatchBloc;
      },
      seed: () => const StopwatchRunning(),
      act: (bloc) => bloc.add(StopwatchRecordLap()),
      wait: const Duration(milliseconds: 50),
      expect: () => [
        const StopwatchRunning(laps: [LapEntity(index: 1, lapTime: 100)]),
      ],
      verify: (_) {
        verify(() => mockRecordLapUsecase()).called(1);
      },
    );
  });

  // ===========================================================================
  // * StopwatchLapsUpdated Event Tests
  // ===========================================================================

  group('StopwatchLapsUpdated Event', () {
    const initialLaps = [LapEntity(index: 1, lapTime: 100)];
    const newLaps = [...initialLaps, LapEntity(index: 2, lapTime: 50)];

    blocTest<StopwatchBloc, StopwatchState>(
      'should update state with new laps from service stream',
      build: () => stopwatchBloc,
      seed: () => const StopwatchRunning(laps: initialLaps),
      act: (bloc) => bloc.add(StopwatchLapsUpdated(laps: newLaps)),
      expect: () => [const StopwatchRunning(laps: newLaps)],
    );
  });
  // ===========================================================================
  // * Edge Cases Group
  // ===========================================================================

  group('edge cases', () {
    blocTest<StopwatchBloc, StopwatchState>(
      'rapid start/pause/stop does not emit duplicate states',
      build: () => stopwatchBloc,
      setUp: () {
        when(() => mockStartStopwatchUsecase()).thenReturn(null);
        when(() => mockPauseStopwatchUsecase()).thenReturn(null);
        when(() => mockStopStopwatchUsecase()).thenReturn(null);
      },
      act: (bloc) => bloc
        ..add(StopwatchStart())
        ..add(StopwatchPause())
        ..add(StopwatchStop()),
      expect: () => [
        const StopwatchRunning(),
        const StopwatchPaused(),
        const StopwatchInitial(),
      ],
      verify: (_) {
        verifyInOrder([
          () => mockStartStopwatchUsecase(),
          () => mockPauseStopwatchUsecase(),
          () => mockStopStopwatchUsecase(),
        ]);
      },
    );

    blocTest<StopwatchBloc, StopwatchState>(
      'invalid events in inappropriate states',
      build: () => stopwatchBloc,
      seed: () => const StopwatchInitial(),
      act: (bloc) {
        bloc.add(StopwatchPause());
        bloc.add(StopwatchStop());
        bloc.add(StopwatchRecordLap());
      },
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockPauseStopwatchUsecase());
        verifyNever(() => mockStopStopwatchUsecase());
        verifyNever(() => mockRecordLapUsecase());
      },
    );
  });

  // ===========================================================================
  // * Ungrouped
  // ===========================================================================

  test('initial state is StopwatchInitial', () {
    expect(stopwatchBloc.state, equals(const StopwatchInitial()));
  });
}
