part of 'stopwatch_bloc.dart';

// Events represent the user's intent. They are simple and do not contain complex logic.
// The sealed class ensures that we handle all possible events.
sealed class StopwatchEvent {}

class StopwatchStart extends StopwatchEvent {}

class StopwatchPause extends StopwatchEvent {}

class StopwatchStop extends StopwatchEvent {}

class StopwatchTick extends StopwatchEvent {
  StopwatchTick({required this.stopwatchStateEntity});
  final StopwatchStateEntity stopwatchStateEntity;
}

class StopwatchRecordLap extends StopwatchEvent {
  StopwatchRecordLap();
}
