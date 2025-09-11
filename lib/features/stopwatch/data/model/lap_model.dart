import 'package:stopwatch/features/stopwatch/domain/entity/lap_entity.dart';

class LapModel {
  LapModel({
    required Duration duration,
    required int number,
  }) : _duration = duration,
       _number = number;

  factory LapModel.fromJson(Map<String, dynamic> json) {
    return LapModel(
      duration: Duration(microseconds: json['duration'] as int),
      number: json['number'] as int,
    );
  }

  final Duration _duration;
  final int _number;

  Map<String, dynamic> toJson() {
    return {
      'duration': _duration.inMilliseconds,
      'number': _number,
    };
  }

  LapEntity toEntity() {
    return LapEntity(
      duration: _duration,
      number: _number,
    );
  }
}
