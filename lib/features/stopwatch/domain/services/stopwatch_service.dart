import 'dart:async';
import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:stopwatch/features/stopwatch/domain/entities/lap_entity.dart';

/// Service that manages the stopwatch functionality, including starting,
/// pausing, stopping, and recording laps. It emits streams for elapsed time
/// in milliseconds and a list of recorded laps.
///
/// The stopwatch uses a [Stopwatch] instance for time tracking and a
/// periodic [Timer] to emit elapsed time updates at a configurable frequency.
class StopwatchService {
  /// Creates a [StopwatchService] with the given [stopwatch] and
  /// [tickFrequencyHz]. The [tickFrequencyHz] determines how often the
  /// elapsed time is emitted, constrained between 15 and 60 Hz.

  StopwatchService({required Clock clock, required int tickFrequencyHz}) {
    _clock = clock;
    _stopwatch = _clock.stopwatch();
    // Constrain tick frequency between 15 and 60 Hz.
    _tickPeriodInMs = 1000 ~/ tickFrequencyHz.clamp(15, 60);
  }

  /// The Clock instance of the service
  late final Clock _clock;

  /// The underlying [Stopwatch] instance used for time tracking.
  late final Stopwatch _stopwatch;

  /// The tick period in milliseconds, derived from the tick frequency.
  late final int _tickPeriodInMs;

  /// Stream controllers for emitting elapsed milliseconds and lap updates.
  final _msController = StreamController<int>.broadcast();

  /// Stream controller for emitting lap updates.
  final _lapController = StreamController<List<LapEntity>>.broadcast();

  /// Timer for emitting elapsed time updates.
  Timer? _timer;

  /// The last recorded lap time in milliseconds.
  int _lastLapTimeMilliseconds = 0;

  /// List of recorded laps.
  final List<LapEntity> _laps = [];

  int get currentMs => _stopwatch.elapsedMilliseconds;

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
    _timer = Timer.periodic(
      Duration(milliseconds: _tickPeriodInMs),
      (_) => _emitElapsed(),
    );
  }

  void _emitElapsed() {
    _msController.add(_stopwatch.elapsedMilliseconds);
  }

  @visibleForTesting
  void emitNow() {
    _emitElapsed();
  }

  /// Disposes of all streams and the timer.
  Future<void> dispose() async {
    _timer?.cancel();
    await _msController.close();
    await _lapController.close();
  }
}
