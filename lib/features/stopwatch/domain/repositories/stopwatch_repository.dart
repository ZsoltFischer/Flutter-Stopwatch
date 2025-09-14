import 'package:stopwatch/exceptions/app_exceptions.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/stopwatch_session_entity.dart';
import 'package:utils/utils.dart' show Result;

abstract class StopwatchRepository {
  void startStopwatch();
  void pauseStopwatch();
  void stopStopwatch();
  void recordLap();
  Future<Result<void, AppException>> saveSession(
    StopwatchSessionEntity session,
  );
  Future<Result<StopwatchSessionEntity, AppException>> loadSession(
    String sessionId,
  );
}
