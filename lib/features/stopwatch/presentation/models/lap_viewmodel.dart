import 'package:equatable/equatable.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/lap_entity.dart';

/// ViewModel representing a lap in the stopwatch application.
class LapViewModel extends Equatable {
  /// Creates a [LapViewModel] instance.
  const LapViewModel({
    required this.index,
    required this.lapTime,
  });

  /// Factory constructor to create a [LapViewModel] from a [LapEntity].
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
