part of 'stopwatch_bloc.dart';

// Events represent the user's intent. They are simple and do not contain complex logic.
// The sealed class ensures that we handle all possible events.
sealed class StopwatchEvent {}

class _StopwatchStart extends StopwatchEvent {}

class _StopwatchPause extends StopwatchEvent {}

class _StopwatchStop extends StopwatchEvent {}

class _StopwatchTick extends StopwatchEvent {
  _StopwatchTick({required this.stopwatchStateEntity});
  final StopwatchStateEntity stopwatchStateEntity;
}

class _StopwatchRecordLap extends StopwatchEvent {
  _StopwatchRecordLap();
}
