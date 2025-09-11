import 'package:stopwatch/features/stopwatch/data/services/stopwatch_service.dart';
import 'package:stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';

class StopwatchRepositoryImpl implements StopwatchRepository {
  StopwatchRepositoryImpl({
    required StopwatchService stopwatchService,
  }) : _stopwatchService = stopwatchService;

  final StopwatchService _stopwatchService;

  @override
  void startStopwatch() {
    _stopwatchService.start();
  }

  @override
  void pauseStopwatch() {
    _stopwatchService.pause();
  }

  @override
  void stopStopwatch() {
    _stopwatchService.stop();
  }
}
