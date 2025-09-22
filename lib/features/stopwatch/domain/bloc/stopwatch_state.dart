part of 'stopwatch_bloc.dart';

// States represent the current condition of the stopwatch.
// The sealed class guarantees type safety and that all states are handled.
sealed class StopwatchState extends Equatable {
  /// Base constructor for all stopwatch states.
  const StopwatchState({this.laps = const []});

  StopwatchState copyWith({List<LapEntity>? laps});

  /// The list of recorded laps, if any.
  final List<LapEntity> laps;

  @override
  List<Object?> get props => [laps];

  @override
  String toString() => 'StopwatchState(lap count: ${laps.length})';
}

/// Initial state when the stopwatch is reset or hasn't started yet.
class StopwatchInitial extends StopwatchState {
  /// Creates an initial state with an optional duration (default is 0).
  const StopwatchInitial({super.laps});

  @override
  StopwatchInitial copyWith({List<LapEntity>? laps}) {
    return StopwatchInitial(laps: laps ?? this.laps);
  }
}

/// State when the stopwatch is actively running.
class StopwatchRunning extends StopwatchState {
  /// Creates a running state with the current duration and start time.
  const StopwatchRunning({super.laps});
  @override
  StopwatchRunning copyWith({List<LapEntity>? laps}) {
    return StopwatchRunning(laps: laps ?? this.laps);
  }
}

/// State when the stopwatch is paused.
class StopwatchPaused extends StopwatchState {
  /// Creates a paused state with the current duration.
  const StopwatchPaused({super.laps});
  @override
  StopwatchPaused copyWith({List<LapEntity>? laps}) {
    return StopwatchPaused(laps: laps ?? this.laps);
  }
}
