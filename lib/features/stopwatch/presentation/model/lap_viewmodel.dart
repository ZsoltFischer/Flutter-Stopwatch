import 'package:equatable/equatable.dart';
import 'package:stopwatch/features/stopwatch/domain/entity/lap_entity.dart';

class LapViewModel extends Equatable {
  const LapViewModel({
    required this.index,
    required this.lapTime,
  });

  factory LapViewModel.fromEntity(LapEntity lap) =>
      LapViewModel(index: lap.index + 1, lapTime: lap.lapTime);

  final int index;
  final int lapTime;

  @override
  List<Object?> get props => [index, lapTime];

  @override
  String toString() {
    return 'LapViewModel{lapNumber: $index, lapTime: $lapTime}';
  }
}
