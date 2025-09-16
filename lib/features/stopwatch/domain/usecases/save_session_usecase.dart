import 'package:stopwatch/features/stopwatch/domain/entities/stopwatch_session_entity.dart';
import 'package:stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';

/// Use case for saving a session in the stopwatch.
class SaveSessionUsecase {
  /// Creates a [SaveSessionUsecase].
  SaveSessionUsecase({
    required StopwatchRepository stopwatchRepository,
  }) : _stopwatchRepository = stopwatchRepository;

  final StopwatchRepository _stopwatchRepository;

  void call(StopwatchSessionEntity session) {
    //!TODO Implement proper error handling etc.
    _stopwatchRepository.saveSession(session);
  }
}
