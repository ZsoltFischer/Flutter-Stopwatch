part of 'stopwatch_bloc.dart';

// States represent the current condition of the stopwatch.
// The sealed class guarantees type safety and that all states are handled.
sealed class StopwatchState {
  StopwatchState({required this.durationInMilliseconds});
  final int durationInMilliseconds;

  @override
  String toString() {
    return 'StopwatchState(durationInMilliseconds: $durationInMilliseconds)';
  }
}

class StopwatchInitial extends StopwatchState {
  StopwatchInitial({super.durationInMilliseconds = 0});

  @override
  String toString() {
    return 'StopwatchInitial(durationInMilliseconds: $durationInMilliseconds)';
  }
}

class StopwatchRunning extends StopwatchState {
  StopwatchRunning({
    required super.durationInMilliseconds,
    required this.startTime,
  });
  final DateTime startTime;

  @override
  String toString() {
    // toString() override
    // ignore: lines_longer_than_80_chars
    return 'StopwatchRunning(durationInMilliseconds: $durationInMilliseconds, startTime: $startTime)';
  }
}

class StopwatchPaused extends StopwatchState {
  StopwatchPaused({required super.durationInMilliseconds});

  @override
  String toString() {
    return 'StopwatchPaused(durationInMilliseconds: $durationInMilliseconds)';
  }
}
