import 'package:stopwatch/features/stopwatch/data/models/lap_model.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/stopwatch_session_entity.dart';

const _id = 'id';
const _startTime = 'startTime';
const _laps = 'laps';

/// Data model representing a stopwatch session
///
/// This model is used to cache a session in local storage.
/// Sessions can be restored and continued from the cache
/// if the app was in the background or terminated.
class StopwatchSessionModel {
  /// Creates a new instance of [StopwatchSessionModel].
  StopwatchSessionModel({
    required this.id,
    required this.startTime,
    this.laps = const [],
  });

  /// Creates a StopwatchSessionModel from a StopwatchSessionEntity.
  ///
  /// Call it when you need to convert an entity to a model for storage.
  factory StopwatchSessionModel.fromEntity(StopwatchSessionEntity entity) {
    return StopwatchSessionModel(
      id: entity.id,
      startTime: entity.startTime,
      laps: entity.laps.map(LapModel.fromEntity).toList(),
    );
  }

  /// Creates a StopwatchSessionModel from a JSON map.
  ///
  /// Call it when you need to restore a session from local storage.
  factory StopwatchSessionModel.fromJson(Map<String, dynamic> json) {
    return StopwatchSessionModel(
      id: json[_id] as String,
      startTime: DateTime.parse(json[_startTime] as String),
      laps: (json[_laps] as List<dynamic>)
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
      _id: id,
      _startTime: startTime.toIso8601String(),
      _laps: laps.map((lap) => lap.toJson()).toList(),
    };
  }
}
