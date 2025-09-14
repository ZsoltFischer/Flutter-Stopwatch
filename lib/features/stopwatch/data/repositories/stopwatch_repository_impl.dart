import 'package:stopwatch/exceptions/app_exceptions.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/stopwatch_session_entity.dart';
import 'package:stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';
import 'package:stopwatch/features/stopwatch/domain/services/stopwatch_service.dart';
import 'package:utils/utils.dart' show Result;

/// Implementation of [StopwatchRepository] that interacts with the
/// [StopwatchService].
/// This class serves as a bridge between the domain layer
/// and the service layer, delegating stopwatch operations to the service.
///
/// Implementation of [StopwatchRepository] that interacts
/// with the [StopwatchService].
/// This class serves as a bridge between the domain layer and the service layer
/// delegating stopwatch operations to the service.
class StopwatchRepositoryImpl implements StopwatchRepository {
  /// Creates a [StopwatchRepositoryImpl] with the given [StopwatchService].
  StopwatchRepositoryImpl({
    required StopwatchService stopwatchService,
  }) : _stopwatchService = stopwatchService;

  final StopwatchService _stopwatchService;

  @override
  /// Starts the stopwatch by delegating to the [StopwatchService].
  void startStopwatch() {
    _stopwatchService.start();
  }

  @override
  /// Pauses the stopwatch by delegating to the [StopwatchService].
  void pauseStopwatch() {
    _stopwatchService.pause();
  }

  @override
  /// Stops the stopwatch by delegating to the [StopwatchService].
  void stopStopwatch() {
    _stopwatchService.stop();
  }

  @override
  /// Records a lap by delegating to the [StopwatchService].
  void recordLap() {
    _stopwatchService.recordLap();
  }

  @override
  /// Loads a stopwatch session by its ID.
  Future<Result<StopwatchSessionEntity, AppException>> loadSession(
    String sessionId,
  ) {
    //!TODO: Implement loadSession method for persistent storage.
    throw UnimplementedError();
  }

  @override
  /// Saves a stopwatch session.
  Future<Result<void, AppException>> saveSession(
    StopwatchSessionEntity session,
  ) {
    //!TODO: Implement saveSession method for persistent storage.
    throw UnimplementedError();
  }
}
