part of 'stopwatch_bloc.dart';

// States represent the current condition of the stopwatch.
// The sealed class guarantees type safety and that all states are handled.
sealed class StopwatchState {
  /// Base constructor for all stopwatch states.
  StopwatchState({
    required this.elapsedTimeInMs,
    this.laps = const [],
  });

  StopwatchState copyWith();

  /// The current elapsed time of the stopwatch in milliseconds.
  final int elapsedTimeInMs;

  /// The list of recorded laps, if any.
  final List<LapViewModel> laps;

  @override
  String toString() =>
      'StopwatchState(durationInMilliseconds: $elapsedTimeInMs, laps: ${laps.length})';
}

/// Initial state when the stopwatch is reset or hasn't started yet.
class StopwatchInitial extends StopwatchState {
  /// Creates an initial state with an optional duration (default is 0).
  StopwatchInitial({
    super.elapsedTimeInMs = 0,
    super.laps,
  });

  @override
  StopwatchInitial copyWith({
    int? elapsedTimeInMs,
    List<LapViewModel>? laps,
  }) {
    return StopwatchInitial(
      elapsedTimeInMs: elapsedTimeInMs ?? this.elapsedTimeInMs,
      laps: laps ?? this.laps,
    );
  }

  @override
  String toString() =>
      'StopwatchInitial(durationInMilliseconds: $elapsedTimeInMs, laps: ${laps.length})';
}

/// State when the stopwatch is actively running.
class StopwatchRunning extends StopwatchState {
  /// Creates a running state with the current duration and start time.
  StopwatchRunning({
    required this.startTime,
    required super.elapsedTimeInMs,
    super.laps,
  });

  @override
  StopwatchRunning copyWith({
    int? elapsedTimeInMs,
    DateTime? startTime,
    List<LapViewModel>? laps,
  }) {
    return StopwatchRunning(
      elapsedTimeInMs: elapsedTimeInMs ?? this.elapsedTimeInMs,
      startTime: startTime ?? this.startTime,
      laps: laps ?? this.laps,
    );
  }

  /// The time when the stopwatch was started or last resumed.
  final DateTime startTime;

  @override
  String toString() =>
      'StopwatchRunning(durationInMilliseconds: $elapsedTimeInMs, startTime: $startTime, laps: ${laps.length})';
}

/// State when the stopwatch is paused.
class StopwatchPaused extends StopwatchState {
  /// Creates a paused state with the current duration.
  StopwatchPaused({
    required super.elapsedTimeInMs,
    super.laps,
  });

  @override
  StopwatchPaused copyWith({
    int? elapsedTimeInMs,
    List<LapViewModel>? laps,
  }) {
    return StopwatchPaused(
      elapsedTimeInMs: elapsedTimeInMs ?? this.elapsedTimeInMs,
      laps: laps ?? this.laps,
    );
  }

  @override
  String toString() =>
      'StopwatchPaused(durationInMilliseconds: $elapsedTimeInMs, laps: ${laps.length})';
}
