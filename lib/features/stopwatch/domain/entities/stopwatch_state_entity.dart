import 'package:equatable/equatable.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/lap_entity.dart';

/// Represents the state of the stopwatch.
class StopwatchStateEntity extends Equatable {
  /// Creates a [StopwatchStateEntity] instance.
  const StopwatchStateEntity({
    required this.elapsedTimeInMs,
    required this.laps,
    required this.isComplete,
  });

  /// The total elapsed time of the stopwatch.
  final int elapsedTimeInMs;

  /// List of lap times recorded.
  final List<LapEntity> laps;

  /// Indicates whether the stopwatch is complete.
  final bool isComplete;

  @override
  List<Object?> get props => [elapsedTimeInMs, laps, isComplete];
}
