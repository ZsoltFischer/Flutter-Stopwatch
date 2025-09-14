// stopwatch_service.dart

import 'dart:async';
import 'dart:math';

import 'package:stopwatch/features/stopwatch/domain/entities/entities.dart';

/// This class is a dedicated service for managing the stopwatch timer.
/// It handles starting, pausing, stopping, and recording laps
///
/// The service emits updates via a stream, allowing subscribers to listen for changes in the stopwatch state.
/// It also enforces a maximum duration limit to prevent the stopwatch from running indefinitely.
class StopwatchService {
  /// Creates a [StopwatchService] with an optional tick limit (default is 99 hours).
  StopwatchService({
    double tickFrequencyHz = 60,
    Duration tickLimit = const Duration(hours: 99),
  }) {
    /// Prevent division by zero and ensure a positive tick frequency.
    _tickPeriodInMs = 1000 ~/ (max(double.minPositive, tickFrequencyHz.abs()));
    _tickLimitInMs = tickLimit.inMilliseconds;
    _durationController = _createController();
  }

  /// ===============================================================
  /// * Members
  /// ===============================================================

  /// The maximum duration the stopwatch can run before stopping automatically.
  /// This is useful for preventing the stopwatch from running indefinitely.
  ///
  /// The default limit is set to 99 hours.
  late final int _tickLimitInMs;

  /// The tick limit in milliseconds.
  int get tickLimit => _tickLimitInMs;

  /// Controller for broadcasting stopwatch state updates.
  late StreamController<StopwatchStateEntity> _durationController;

  /// Subscription to the periodic timer stream.
  StreamSubscription<int>? _timerSubscription;

  /// The timestamp of the last tick in milliseconds.
  int? _lastTickInMs;

  /// The total elapsed time in milliseconds.
  int _elapsedTimeInMs = 0;

  /// The elapsed time of the previous lap.
  int _lastLapTimeInMs = 0;

  /// The timestamp when the stopwatch was started in milliseconds.
  // int? _startTimeInMs;

  /// Stream that emits the current state of the stopwatch.
  Stream<StopwatchStateEntity> get durationStream => _durationController.stream;

  /// List of recorded laps.
  final List<LapEntity> _laps = [];

  /// Unmodifiable list of the recorded laps.
  List<LapEntity> get laps => List.unmodifiable(_laps);

  /// Frequency of timer ticks in Hz.
  late final int _tickPeriodInMs;

  /// Exposes the tick frequency in Hz for testing and inspection.
  int get tickFrequencyHz => _tickPeriodInMs;

  /// Factory for a reusable StreamController
  StreamController<StopwatchStateEntity> _createController() {
    return StreamController<StopwatchStateEntity>.broadcast();
  }

  /// ===============================================================
  /// * Public Methods
  /// ===============================================================

  /// Starts or resumes the stopwatch.
  void start() {
    // 1. Avoid multiple subscriptions
    if (_timerSubscription != null) return;

    // 2. Recreate the controller if it has been closed
    if (_durationController.isClosed) {
      _durationController = _createController();
    }

    // 3. Start the periodic timer to update the stopwatch
    _lastTickInMs = DateTime.now().millisecondsSinceEpoch;

    // _lastTickInMs = _startTimeInMs;
    _timerSubscription = Stream.periodic(
      Duration(milliseconds: _tickPeriodInMs),
      (ticks) => ticks,
    ).listen(_tick);
  }

  /// Pauses the stopwatch.
  void pause() {
    _timerSubscription?.cancel();
    _timerSubscription = null;
    _lastTickInMs = null;
  }

  /// Resets the stopwatch to 0.
  void stop() {
    // 1. Pause the stopwatch if it's running
    pause();

    // 2. Reset elapsed time and laps
    _laps.clear();
    _elapsedTimeInMs = 0;
    _lastLapTimeInMs = 0;

    // 3. Emit the reset state
    _emit();
  }

  /// Records a lap at the current elapsed time.
  void recordLap() {
    /// Calculate the duration of the current lap.
    final lapDuration = _elapsedTimeInMs - _lastLapTimeInMs;

    /// Adds a new lap entry to the list of recorded laps.
    _laps.add(
      LapEntity(
        index: _laps.length,
        lapTime: lapDuration,
      ),
    );

    /// Update the last lap time for the next calculation.
    _lastLapTimeInMs = _elapsedTimeInMs;
  }

  /// ==============================================================
  /// * Private Methods
  /// ===============================================================

  /// Handles each tick of the stopwatch.
  void _tick(int _) {
    final nowInMs = DateTime.now().millisecondsSinceEpoch;

    // Update elapsed time
    if (_lastTickInMs != null) {
      _elapsedTimeInMs += nowInMs - _lastTickInMs!;
    }
    _lastTickInMs = nowInMs;

    // Check if the tick limit has been reached
    if (_elapsedTimeInMs >= _tickLimitInMs) {
      // Cap the elapsed time at the tick limit
      _elapsedTimeInMs = _tickLimitInMs;
      _emit();
      stop();
      return;
    }

    // Emit the updated stopwatch state
    _emit();
  }

  /// Emits the current stopwatch state to the stream.
  void _emit() {
    /// Creates a new [StopwatchStateEntity] and adds it to the stream.
    _durationController.add(
      StopwatchStateEntity(
        elapsedTimeInMs: _elapsedTimeInMs,
        laps: laps,
        isComplete: _elapsedTimeInMs >= tickLimit,
      ),
    );
  }

  /// ==============================================================
  /// * Cleanup
  /// ===============================================================

  // Disposes of the StreamController and subscription.
  Future<void> dispose() async {
    await _timerSubscription?.cancel();
    await _durationController.close();
  }
}
