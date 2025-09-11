// stopwatch_service.dart

import 'dart:async';

// This class is a dedicated service for managing the stopwatch timer.
class StopwatchService {
  final _durationController = StreamController<int>.broadcast();
  StreamSubscription<int>? _timerSubscription;
  DateTime? _lastTick;
  int _currentDuration = 0;

  // Public stream for BLoC to listen to.
  Stream<int> get durationStream => _durationController.stream;

  // Starts or resumes the stopwatch.
  void start() {
    if (_timerSubscription != null) {
      return;
    }

    _lastTick = DateTime.now();
    _timerSubscription =
        Stream.periodic(const Duration(milliseconds: 10), (x) => x).listen((
          _,
        ) {
          if (_lastTick != null) {
            final now = DateTime.now();
            final elapsed = now.difference(_lastTick!).inMilliseconds;
            _currentDuration += elapsed;
            _lastTick = now;
          }
          _durationController.add(_currentDuration);
        });
  }

  // Pauses the stopwatch.
  void pause() {
    _timerSubscription?.cancel();
    _timerSubscription = null;
    _lastTick = null;
  }

  // Resets the stopwatch to 0.
  void stop() {
    _timerSubscription?.cancel();
    _timerSubscription = null;
    _currentDuration = 0;
    _lastTick = null;
    _durationController.add(_currentDuration);
  }

  // Disposes of the StreamController and subscription.
  void dispose() {
    _timerSubscription?.cancel();
    _durationController.close();
  }
}
