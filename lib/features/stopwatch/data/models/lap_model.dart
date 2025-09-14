import 'package:stopwatch/features/stopwatch/domain/entities/lap_entity.dart';

const _lapTime = 'lapTime';
const _index = 'index';

/// Data model representing a lap in the stopwatch.
/// Used for caching lap data in local storage.
class LapModel {
  /// Creates a [LapModel].
  LapModel({
    required int lapTime,
    required int index,
  }) : _duration = lapTime,
       _number = index;

  /// Creates a [LapModel] from a [LapEntity].
  ///
  /// Call it when you need to convert an entity to a model for storage.
  factory LapModel.fromEntity(LapEntity entity) {
    return LapModel(
      lapTime: entity.lapTime,
      index: entity.index,
    );
  }

  /// Creates a [LapModel] from a JSON map.
  ///
  /// Call it when you need to restore a lap from local storage.
  factory LapModel.fromJson(Map<String, dynamic> json) {
    return LapModel(
      lapTime: json[_lapTime] as int,
      index: json[_index] as int,
    );
  }

  /// The duration of the lap.
  final int _duration;

  /// The lap number.
  final int _number;

  /// Converts the [LapModel] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      _lapTime: _duration,
      _index: _number,
    };
  }

  /// Converts the [LapModel] to a [LapEntity].
  LapEntity toEntity() {
    return LapEntity(
      lapTime: _duration,
      index: _number,
    );
  }
}
