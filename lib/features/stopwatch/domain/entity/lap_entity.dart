import 'package:equatable/equatable.dart';

class LapEntity extends Equatable {
  const LapEntity({
    required this.duration,
    required this.number,
  });

  final Duration duration;
  final int number;

  @override
  List<Object?> get props => [duration, number];
}
