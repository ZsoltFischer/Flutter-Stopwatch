import 'package:stopwatch/features/stopwatch/data/model/lap_model.dart';
import 'package:stopwatch/features/stopwatch/domain/entity/stopwatch_session_entity.dart';

/// Data model representing a stopwatch session, including its laps.
class StopwatchSessionModel {
  /// Constructor for StopwatchSessionModel.
  StopwatchSessionModel({
    required this.id,
    required this.startTime,
    this.laps = const [],
  });

  /// Creates a StopwatchSessionModel from a StopwatchSessionEntity.
  factory StopwatchSessionModel.fromEntity(StopwatchSessionEntity entity) {
    return StopwatchSessionModel(
      id: entity.id,
      startTime: entity.startTime,
      laps: entity.laps.map(LapModel.fromEntity).toList(),
    );
  }

  /// Creates a StopwatchSessionModel from a JSON map.
  factory StopwatchSessionModel.fromJson(Map<String, dynamic> json) {
    return StopwatchSessionModel(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      laps: (json['laps'] as List<dynamic>)
          .map((lapJson) => LapModel.fromJson(lapJson as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Unique identifier for the stopwatch session.
  final String id;

  /// The start time of the stopwatch session.
  final DateTime startTime;

  /// List of laps recorded during the stopwatch session.
  final List<LapModel> laps;

  /// Converts the StopwatchSessionModel to a StopwatchSessionEntity.
  StopwatchSessionEntity toEntity() {
    return StopwatchSessionEntity(
      id: id,
      startTime: startTime,
      laps: laps.map((lap) => lap.toEntity()).toList(),
    );
  }

  /// Converts the StopwatchSessionModel to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'laps': laps.map((lap) => lap.toJson()).toList(),
    };
  }
}
