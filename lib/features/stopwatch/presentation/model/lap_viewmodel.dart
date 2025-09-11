import 'package:stopwatch/features/stopwatch/domain/entity/lap_entity.dart';

class LapViewModel {
  const LapViewModel({
    required this.lapNumber,
    required this.lapTime,
  });

  factory LapViewModel.fromEntity({
    required LapEntity lap,
  }) {
    return LapViewModel(lapNumber: lap.number, lapTime: lap.duration);
  }

  final int lapNumber;
  final Duration lapTime;
}
