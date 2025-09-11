// stopwatch_service.dart

import 'dart:async';

// This class is a dedicated service for managing the stopwatch timer.
class StopwatchService {
  /// Creates a StopwatchService with an optional tick limit (default is 99 hours).
  StopwatchService({
    Duration tickLimit = const Duration(hours: 99),
  }) {
    _tickLimit = tickLimit.inMilliseconds;
    _durationController = _createController();
  }

  late final int _tickLimit;
  int get tickLimit => _tickLimit;
  late StreamController<int> _durationController;
  StreamSubscription<int>? _timerSubscription;
  DateTime? _lastTick;
  int _currentDuration = 0;
  Stream<int> get durationStream => _durationController.stream;

  // Factory for a reusable StreamController
  StreamController<int> _createController() {
    return StreamController<int>.broadcast();
  }

  // Starts or resumes the stopwatch.
  void start() {
    if (_timerSubscription != null) return;

    // If controller was closed previously, recreate it
    if (_durationController.isClosed) {
      _durationController = _createController();
    }

    _lastTick = DateTime.now();
    _timerSubscription = Stream.periodic(
      const Duration(milliseconds: 10),
      (ticks) => ticks,
    ).listen(_tick);
  }

  // Pauses the stopwatch.
  void pause() {
    _timerSubscription?.cancel();
    _timerSubscription = null;
    _lastTick = null;
  }

  // Resets the stopwatch to 0.
  void stop() {
    pause();
    _currentDuration = 0;

    // Emit reset value, recreate controller if needed
    if (_durationController.isClosed) {
      _durationController = _createController();
    }

    _durationController.add(_currentDuration);
  }

  /// Handles each tick from the periodic timer.
  void _tick(int tick) {
    if (_currentDuration > _tickLimit) {
      // Emit max duration once
      _currentDuration = _tickLimit;
      _durationController
        ..add(_currentDuration)
        ..close();
      stop();
      return;
    }

    /// Update the current duration based on elapsed time.
    if (_lastTick != null) {
      /// Ignoring tick count and calculating based on real time elapsed
      /// to ensure accuracy even if ticks are delayed, skipped, etc.
      ///
      /// This also ensures that the stopwatch remains accurate
      /// even if the app is paused or in the background, or for long-running timers.
      final now = DateTime.now();
      final elapsed = now.difference(_lastTick!).inMilliseconds;
      _currentDuration += elapsed;
      _lastTick = now;
    }

    /// Emit the updated duration.
    _durationController.add(_currentDuration);
  }

  // Disposes of the StreamController and subscription.
  void dispose() {
    _timerSubscription?.cancel();
    _durationController.close();
  }
}
