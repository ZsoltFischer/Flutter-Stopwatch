import 'package:stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';

/// Use case for recording a lap in the stopwatch.
class RecordLapUsecase {
  /// Creates a [RecordLapUsecase].
  RecordLapUsecase({
    required StopwatchRepository stopwatchRepository,
  }) : _stopwatchRepository = stopwatchRepository;

  final StopwatchRepository _stopwatchRepository;

  void call() {
    _stopwatchRepository.recordLap();
  }
}
