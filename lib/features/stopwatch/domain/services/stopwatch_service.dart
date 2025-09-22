import 'dart:async';
import 'dart:math' as math;
import 'package:clock/clock.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/lap_entity.dart';

class StopwatchService {
  StopwatchService({required Clock clock, required int tickFrequencyHz}) {
    _clock = clock;
    _stopwatch = _clock.stopwatch();

    /// Prevent division by zero and ensure a positive tick frequency.
    _tickPeriodInMs =
        1000 ~/ (math.max(double.minPositive, tickFrequencyHz.abs()));
  }

  late final Clock _clock;
  late final Stopwatch _stopwatch;
  late final int _tickPeriodInMs;

  final _msController = StreamController<int>.broadcast();
  final _lapController = StreamController<List<LapEntity>>.broadcast();

  Timer? _timer;
  int _lastLapTimeMilliseconds = 0;

  /// List of recorded laps.
  final List<LapEntity> _laps = [];

  /// Unmodifiable list of the recorded laps.
  List<LapEntity> get laps => List<LapEntity>.unmodifiable(_laps);

  /// Exposes a stream of elapsed milliseconds.
  Stream<int> get msStream => _msController.stream;

  /// Exposes a stream of laps to listen for new additions.
  Stream<List<LapEntity>> get lapStream => _lapController.stream;

  /// Starts or resumes the stopwatch.
  void start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _startTimer();
    }
  }

  /// Pauses the stopwatch.
  void pause() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      _msController.add(_stopwatch.elapsedMilliseconds);
    }
  }

  /// Records a new lap.
  void recordLap() {
    if (!_stopwatch.isRunning) {
      return;
    }

    final totalTime = _stopwatch.elapsedMilliseconds;
    final lapTime = totalTime - _lastLapTimeMilliseconds;

    final newLap = LapEntity(index: _laps.length + 1, lapTime: lapTime);

    _laps.add(newLap);
    _lastLapTimeMilliseconds = totalTime;
    _lapController.add(List<LapEntity>.unmodifiable(_laps));
  }

  /// Stops and resets the stopwatch.
  void stop() {
    _stopwatch
      ..stop()
      ..reset();
    _timer?.cancel();
    _msController.add(0);
    _laps.clear();
    _lastLapTimeMilliseconds = 0;
    _lapController.add(List.unmodifiable(_laps));
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: _tickPeriodInMs), (_) {
      _msController.add(_stopwatch.elapsedMilliseconds);
    });
  }

  /// Disposes of all streams and the timer.
  Future<void> dispose() async {
    _timer?.cancel();
    await _msController.close();
    await _lapController.close();
  }
}
