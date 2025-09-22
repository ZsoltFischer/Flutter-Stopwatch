import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/lap_entity.dart';
import 'package:stopwatch/features/stopwatch/domain/services/stopwatch_service.dart';
import 'package:stopwatch/features/stopwatch/domain/usecases/usecases.dart';
import 'package:stopwatch/features/stopwatch/presentation/utils/event_transformers.dart';

part 'stopwatch_event.dart';
part 'stopwatch_state.dart';

/// BLoC that manages the UI state of the stopwatch application.
///
/// It implements the logic to start, pause, stop,
/// and record laps in the stopwatch.
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
    on<StopwatchStart>(_onStopwatchStart, transformer: sequential());
    on<StopwatchPause>(_onStopwatchPause, transformer: sequential());
    on<StopwatchStop>(_onStopwatchStopped, transformer: sequential());
    on<StopwatchRecordLap>(_onStopwatchRecordLap, transformer: sequential());
    on<StopwatchLapsUpdated>(
      _onStopwatchLapsUpdated,
      transformer: sequential(),
    );

    _initializeLapSubscription();
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

  /// Subscription to the service's lap stream.
  StreamSubscription<List<LapEntity>>? _lapSubscription;

  /// ===============================================================
  /// * Initialization & Private Methods
  /// ===============================================================

  void _initializeLapSubscription() {
    _lapSubscription = _stopwatchService.lapStream.listen((laps) {
      // When a new lap is recorded, update the BLoC state.
      if (laps.isNotEmpty) {
        add(StopwatchLapsUpdated(laps: laps));
      }
    });
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

  /// Exposes a stream of elapsed milliseconds.
  Stream<int> get msStream => _stopwatchService.msStream;

  /// Exposes a stream of elapsed seconds, derived from the msStream.
  Stream<int> get secondsStream => msStream
      .map((milliseconds) => milliseconds ~/ Duration.millisecondsPerSecond)
      .distinct();

  /// Exposes a stream of elapsed minutes, emitting a double value every 2 seconds.
  ///
  /// This provides a finer granularity for the minute hand movement
  /// on the analog clock without overwhelming updates.
  Stream<double> get minuteStream => secondsStream
      .where(
        (seconds) => seconds % 2 == 0,
      ) // Only pass values on 2-second intervals
      .map((seconds) => seconds / Duration.secondsPerMinute)
      .distinct();

  /// Exposes a stream of elapsed hours, emitting a double value every minute.
  ///
  /// This provides a finer granularity for the hour hand movement
  /// on the analog clock without overwhelming updates.
  Stream<double> get hourStream => secondsStream
      .where(
        (seconds) => seconds % 60 == 0,
      ) // Only pass values on 1-minute intervals
      .map((seconds) => seconds / Duration.secondsPerHour)
      .distinct();

  /// Exposes a stream of laps to listen for new additions.
  Stream<List<LapEntity>> get lapStream => _stopwatchService.lapStream;

  /// ===============================================================
  /// * Event Handlers
  /// ===============================================================

  /// Handle the start event by starting the service.
  void _onStopwatchStart(StopwatchStart event, Emitter<StopwatchState> emit) {
    if (state is StopwatchRunning) {
      return;
    }
    _startStopwatch();
    emit(StopwatchRunning(laps: state.laps));
  }

  /// Handle the pause event by pausing the service and emitting a paused state.
  void _onStopwatchPause(StopwatchPause event, Emitter<StopwatchState> emit) {
    if (state is! StopwatchRunning) {
      return;
    }
    _pauseStopwatch();
    emit(StopwatchPaused(laps: state.laps));
  }

  /// Handle the stop event by resetting the service
  /// and emitting the initial state.
  void _onStopwatchStopped(StopwatchStop event, Emitter<StopwatchState> emit) {
    if (state is! StopwatchRunning && state is! StopwatchPaused) {
      return;
    }
    _stopStopwatch();
    emit(const StopwatchInitial());
  }

  /// Handle the lap event by recording a lap.
  void _onStopwatchRecordLap(
    StopwatchRecordLap event,
    Emitter<StopwatchState> emit,
  ) {
    if (state is StopwatchRunning) {
      _recordLapUsecase();
    }
  }

  /// Handles lap updates from the service and updates the BLoC's state.
  void _onStopwatchLapsUpdated(
    StopwatchLapsUpdated event,
    Emitter<StopwatchState> emit,
  ) {
    emit(state.copyWith(laps: event.laps));
  }

  /// ==============================================================
  /// * Cleanup
  /// ===============================================================

  // Clean up the subscriptions when the Bloc is closed.
  @override
  Future<void> close() {
    _lapSubscription?.cancel();
    _stopwatchService.dispose();

    return super.close();
  }
}
