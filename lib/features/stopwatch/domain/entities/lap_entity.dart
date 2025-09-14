import 'package:equatable/equatable.dart';

class LapEntity extends Equatable {
  const LapEntity({
    required this.lapTime,
    required this.index,
  });

  final int lapTime;
  final int index;

  @override
  List<Object?> get props => [lapTime, index];
}
