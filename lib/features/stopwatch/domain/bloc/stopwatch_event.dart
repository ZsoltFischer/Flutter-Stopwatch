part of 'stopwatch_bloc.dart';

sealed class StopwatchEvent {}

class StopwatchStart extends StopwatchEvent {}

class StopwatchPause extends StopwatchEvent {}

class StopwatchStop extends StopwatchEvent {}

class StopwatchRecordLap extends StopwatchEvent {}

class StopwatchLapsUpdated extends StopwatchEvent {
  StopwatchLapsUpdated({required this.laps});

  final List<LapEntity> laps;
}
