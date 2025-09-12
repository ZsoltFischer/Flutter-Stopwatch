import 'package:stopwatch/exceptions/model/app_exceptions.dart';
import 'package:stopwatch/features/stopwatch/domain/entity/stopwatch_session_entity.dart';
import 'package:stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';
import 'package:utils/utils.dart' show Result;

class LoadSessionUseCase {
  LoadSessionUseCase(this._repository);

  final StopwatchRepository _repository;

  Future<Result<StopwatchSessionEntity, AppException>> call(
    String id,
  ) async {
    return _repository.loadSession(id);
  }
}
