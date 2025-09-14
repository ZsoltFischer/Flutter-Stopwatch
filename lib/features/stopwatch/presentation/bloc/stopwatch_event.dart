part of 'stopwatch_bloc.dart';

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
