import 'package:equatable/equatable.dart';
import 'package:stopwatch/features/stopwatch/domain/entity/lap_entity.dart';

class StopwatchSessionEntity extends Equatable {
  const StopwatchSessionEntity({
    required this.id,
    required this.startTime,
    required this.laps,
  });

  final String id;
  final DateTime startTime;
  final List<LapEntity> laps;

  @override
  List<Object?> get props => [startTime, id, laps];
}
