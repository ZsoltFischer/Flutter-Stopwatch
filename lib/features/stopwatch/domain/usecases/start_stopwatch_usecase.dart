import 'package:stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';

class StartStopwatchUsecase {
  StartStopwatchUsecase({
    required StopwatchRepository stopwatchRepository,
  }) : _stopwatchRepository = stopwatchRepository;
  final StopwatchRepository _stopwatchRepository;

  void call() {
    _stopwatchRepository.startStopwatch();
  }
}
