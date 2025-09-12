import 'package:stopwatch/features/stopwatch/domain/entity/lap_entity.dart';

class LapModel {
  LapModel({
    required int lapTime,
    required int index,
  }) : _duration = lapTime,
       _number = index;

  /// Creates a [LapModel] from a [LapEntity].
  factory LapModel.fromEntity(LapEntity entity) {
    return LapModel(
      lapTime: entity.lapTime,
      index: entity.index,
    );
  }

  /// Creates a [LapModel] from a JSON map.
  factory LapModel.fromJson(Map<String, dynamic> json) {
    return LapModel(
      lapTime: json['lapTime'] as int,
      index: json['index'] as int,
    );
  }

  /// The duration of the lap.
  final int _duration;

  /// The lap number.
  final int _number;

  /// Converts the [LapModel] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'lapTime': _duration,
      'index': _number,
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
