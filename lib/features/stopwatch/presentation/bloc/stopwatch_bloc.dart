// stopwatch_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:stopwatch/features/stopwatch/data/services/stopwatch_service.dart';
import 'package:stopwatch/features/stopwatch/domain/usecases/usecases.dart';

part 'stopwatch_event.dart';
part 'stopwatch_state.dart';

class StopwatchBloc extends Bloc<StopwatchEvent, StopwatchState> {
  StopwatchBloc({
    required StopwatchService stopwatchService,
    required StartStopwatchUsecase startStopwatchUsecase,
    required PauseStopwatchUsecase pauseStopwatchUsecase,
    required StopStopwatchUsecase stopStopwatchUsecase,
  }) : _stopwatchService = stopwatchService,
       _startStopwatch = startStopwatchUsecase,
       _pauseStopwatch = pauseStopwatchUsecase,
       _stopStopwatch = stopStopwatchUsecase,
       super(StopwatchInitial()) {
    on<_StopwatchTick>(_onStopwatchTick);
    on<_StopwatchStart>(_onStopwatchStart);
    on<_StopwatchPause>(_onStopwatchPause);
    on<_StopwatchStop>(_onStopwatchStopped);
  }

  /// The stopwatch service that manages the timer logic.
  final StopwatchService _stopwatchService;

  /// Usecase to start the stopwatch.
  final StartStopwatchUsecase _startStopwatch;

  /// Usecase to pause the stopwatch.
  final PauseStopwatchUsecase _pauseStopwatch;

  /// Usecase to stop the stopwatch.
  final StopStopwatchUsecase _stopStopwatch;

  /// Subscription to the service's duration stream.
  StreamSubscription<int>? _durationSubscription;

  /// Initializes the BLoC by subscribing to the service's duration stream.
  void _initializeDurationSubscription() {
    // 1. cancel any existing subscription
    _durationSubscription?.cancel();

    // 2. Subscribe to the service's duration stream and add ticks to the BLoC.
    _durationSubscription = _stopwatchService.durationStream.listen((duration) {
      add(_StopwatchTick(durationInMilliseconds: duration));
    });
  }

  /// Starts the stopwatch.
  void start() {
    add(_StopwatchStart());
  }

  /// Pauses the stopwatch.
  void pause() {
    add(_StopwatchPause());
  }

  /// Resets the stopwatch.
  void stop() {
    add(_StopwatchStop());
  }

  /// Handle the start event by starting the service.
  void _onStopwatchStart(
    _StopwatchStart event,
    Emitter<StopwatchState> emit,
  ) {
    if (state is StopwatchRunning) {
      return;
    }

    // 2. initialize the duration subscription
    _initializeDurationSubscription();

    // 3. start the service
    _startStopwatch.call();

    // 4. emit the running state
    emit(
      StopwatchRunning(
        durationInMilliseconds: state.durationInMilliseconds,
        startTime: DateTime.now(),
      ),
    );
  }

  /// Handle the pause event by pausing the service and emitting a paused state.
  void _onStopwatchPause(
    _StopwatchPause event,
    Emitter<StopwatchState> emit,
  ) {
    if (state is! StopwatchRunning) {
      return;
    }
    // 1. cancel any existing subscription
    _durationSubscription?.cancel();

    // 2. pause the service
    _pauseStopwatch.call();

    // 3. emit the paused state
    emit(
      StopwatchPaused(durationInMilliseconds: state.durationInMilliseconds),
    );
  }

  /// Handle the reset event by resetting the service
  /// and emitting the initial state.
  void _onStopwatchStopped(
    _StopwatchStop event,
    Emitter<StopwatchState> emit,
  ) {
    if (state is! StopwatchRunning && state is! StopwatchPaused) {
      return;
    }
    // 1. cancel any existing subscription
    _durationSubscription?.cancel();

    // 2. stop the service
    _stopStopwatch.call();

    // 3. emit the initial state
    emit(StopwatchInitial());
  }

  /// Handle the tick event by updating the state with the new duration.
  FutureOr<void> _onStopwatchTick(
    _StopwatchTick event,
    Emitter<StopwatchState> emit,
  ) {
    if (state is StopwatchRunning) {
      emit(
        StopwatchRunning(
          durationInMilliseconds: event.durationInMilliseconds,
          startTime: (state as StopwatchRunning).startTime,
        ),
      );
    } else {
      emit(
        StopwatchPaused(
          durationInMilliseconds: event.durationInMilliseconds,
        ),
      );
    }
  }

  // Clean up the subscriptions when the Bloc is closed.
  @override
  Future<void> close() {
    _durationSubscription?.cancel();
    _stopwatchService.dispose();
    return super.close();
  }
}
