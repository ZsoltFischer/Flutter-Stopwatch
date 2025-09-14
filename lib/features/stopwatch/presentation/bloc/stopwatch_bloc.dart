import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/stopwatch_state_entity.dart';
import 'package:stopwatch/features/stopwatch/domain/services/stopwatch_service.dart';
import 'package:stopwatch/features/stopwatch/domain/usecases/usecases.dart';
import 'package:stopwatch/features/stopwatch/presentation/models/lap_viewmodel.dart';

part 'stopwatch_event.dart';
part 'stopwatch_state.dart';

/// BLoC that manages the UI state of the stopwatch application.
///
/// It implements the logic to start, pause, stop, and record laps in the stopwatch.
/// It listens to the [StopwatchService] for duration updates and emits
/// corresponding states to the UI.
///
/// The BLoC uses various use cases to interact with the stopwatch service.
class StopwatchBloc extends Bloc<StopwatchEvent, StopwatchState> {
  /// Creates a [StopwatchBloc] instance.
  StopwatchBloc({
    required StopwatchService stopwatchService,
    required StartStopwatchUsecase startStopwatchUsecase,
    required PauseStopwatchUsecase pauseStopwatchUsecase,
    required StopStopwatchUsecase stopStopwatchUsecase,
    required RecordLapUsecase recordLapUsecase,
  }) : _stopwatchService = stopwatchService,
       _startStopwatch = startStopwatchUsecase,
       _pauseStopwatch = pauseStopwatchUsecase,
       _stopStopwatch = stopStopwatchUsecase,
       _recordLapUsecase = recordLapUsecase,
       super(const StopwatchInitial()) {
    on<StopwatchTick>(_onStopwatchTick, transformer: sequential());
    on<StopwatchStart>(_onStopwatchStart, transformer: sequential());
    on<StopwatchPause>(_onStopwatchPause, transformer: sequential());
    on<StopwatchStop>(_onStopwatchStopped, transformer: sequential());
    on<StopwatchRecordLap>(_onStopwatchRecordLap, transformer: sequential());
  }

  /// ===============================================================
  /// * Members
  /// ===============================================================

  /// The stopwatch service that manages the timer logic.
  final StopwatchService _stopwatchService;

  /// Usecase to start the stopwatch.
  final StartStopwatchUsecase _startStopwatch;

  /// Usecase to pause the stopwatch.
  final PauseStopwatchUsecase _pauseStopwatch;

  /// Usecase to stop the stopwatch.
  final StopStopwatchUsecase _stopStopwatch;

  /// Usecase to record a lap.
  final RecordLapUsecase _recordLapUsecase;

  /// Subscription to the service's duration stream.
  StreamSubscription<StopwatchStateEntity>? _durationSubscription;

  /// ===============================================================
  /// * Initialization & Private Methods
  /// ===============================================================

  /// Initializes the BLoC by subscribing to the service's duration stream.
  void _initializeDurationSubscription() {
    // 1. cancel any existing subscription
    _durationSubscription?.cancel();

    // 2. Subscribe to the service's duration stream and add ticks to the BLoC.
    _durationSubscription = _stopwatchService.durationStream.listen(
      _onTick,
      // onDone: stop,
    );
  }

  /// ===============================================================
  /// * Public API
  /// ===============================================================

  /// Starts the stopwatch.
  void start() {
    add(StopwatchStart());
  }

  /// Pauses the stopwatch.
  void pause() {
    add(StopwatchPause());
  }

  /// Resets the stopwatch.
  void stop() {
    add(StopwatchStop());
  }

  /// Records a lap.
  void recordLap() {
    add(StopwatchRecordLap());
  }

  /// ===============================================================
  /// * Event Handlers
  /// ===============================================================

  void _onTick(StopwatchStateEntity stopwatchState) {
    add(StopwatchTick(stopwatchStateEntity: stopwatchState));
  }

  /// Handle the start event by starting the service.
  void _onStopwatchStart(
    StopwatchStart event,
    Emitter<StopwatchState> emit,
  ) {
    if (state is StopwatchRunning) {
      return;
    }

    // 2. initialize the duration subscription
    _initializeDurationSubscription();

    // 3. start the service
    _startStopwatch();

    // 4. emit the running state
    emit(
      StopwatchRunning(
        elapsedTimeInMs: state.elapsedTimeInMs,
        startTime: DateTime.now(),
        laps: state.laps,
      ),
    );
  }

  /// Handle the pause event by pausing the service and emitting a paused state.
  void _onStopwatchPause(
    StopwatchPause event,
    Emitter<StopwatchState> emit,
  ) {
    if (state is! StopwatchRunning) {
      return;
    }
    // 1. cancel any existing subscription
    _durationSubscription?.cancel();

    // 2. pause the service
    _pauseStopwatch();

    // 3. emit the paused state
    emit(
      StopwatchPaused(
        elapsedTimeInMs: state.elapsedTimeInMs,
        laps: state.laps,
      ),
    );
  }

  /// Handle the reset event by resetting the service
  /// and emitting the initial state.
  void _onStopwatchStopped(
    StopwatchStop event,
    Emitter<StopwatchState> emit,
  ) {
    if (state is! StopwatchRunning && state is! StopwatchPaused) {
      return;
    }
    // 1. cancel any existing subscription
    _durationSubscription?.cancel();

    // 2. stop the service
    _stopStopwatch();

    // 3. emit the initial state
    emit(const StopwatchInitial());
  }

  /// Handle the lap event by recording a lap.
  void _onStopwatchRecordLap(
    StopwatchRecordLap event,
    Emitter<StopwatchState> emit,
  ) {
    /// Only record a lap if the stopwatch is running and has elapsed time.
    if (state is StopwatchRunning && state.elapsedTimeInMs > 0) {
      /// Record the lap using the usecase.
      _recordLapUsecase();
    }
  }

  /// Handle the tick event by updating the state with the new duration.
  void _onStopwatchTick(
    StopwatchTick event,
    Emitter<StopwatchState> emit,
  ) {
    // 1. If the stopwatch is complete, stop the service and return.
    if (event.stopwatchStateEntity.isComplete) {
      /// If the stopwatch is complete, stop the service.
      stop();
      return;
    }

    // 2. Emit the appropriate state based on the current state.
    if (state is StopwatchRunning) {
      emit(
        (state as StopwatchRunning).copyWith(
          elapsedTimeInMs: event.stopwatchStateEntity.elapsedTimeInMs,
          laps: List<LapViewModel>.unmodifiable(
            event.stopwatchStateEntity.laps.map(LapViewModel.fromEntity),
          ),
        ),
      );
      return;
    }
    if (state is StopwatchPaused) {
      emit(
        (state as StopwatchPaused).copyWith(
          elapsedTimeInMs: event.stopwatchStateEntity.elapsedTimeInMs,
          laps: List<LapViewModel>.unmodifiable(
            event.stopwatchStateEntity.laps.map(LapViewModel.fromEntity),
          ),
        ),
      );
      return;
    }
  }

  /// ==============================================================
  /// * Cleanup
  /// ===============================================================

  // Clean up the subscriptions when the Bloc is closed.
  @override
  Future<void> close() {
    _durationSubscription?.cancel();
    _stopwatchService.dispose();
    return super.close();
  }
}
