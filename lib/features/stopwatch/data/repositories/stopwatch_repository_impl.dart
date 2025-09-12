import 'package:stopwatch/exceptions/model/app_exceptions.dart';
import 'package:stopwatch/features/stopwatch/domain/entity/stopwatch_session_entity.dart';
import 'package:stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';
import 'package:stopwatch/features/stopwatch/domain/services/stopwatch_service.dart';
import 'package:utils/utils.dart' show Result;

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

  @override
  void recordLap() {
    _stopwatchService.recordLap();
  }

  @override
  Future<Result<StopwatchSessionEntity, AppException>> loadSession(
    String sessionId,
  ) {
    // TODO: implement getSession
    throw UnimplementedError();
  }

  @override
  Future<Result<void, AppException>> saveSession(
    StopwatchSessionEntity session,
  ) {
    // TODO: implement saveSession
    throw UnimplementedError();
  }
}
