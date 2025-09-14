import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';
import 'package:stopwatch/features/stopwatch/domain/services/stopwatch_service.dart';
import 'package:stopwatch/features/stopwatch/domain/usecases/usecases.dart';

class MockStopwatchRepository extends Mock implements StopwatchRepository {}

class MockStopwatchService extends Mock implements StopwatchService {}

class MockStartStopwatchUsecase extends Mock implements StartStopwatchUsecase {}

class MockPauseStopwatchUsecase extends Mock implements PauseStopwatchUsecase {}

class MockStopStopwatchUsecase extends Mock implements StopStopwatchUsecase {}

class MockRecordLapUsecase extends Mock implements RecordLapUsecase {}

class MockStreamSubscription<T> extends Mock implements StreamSubscription<T> {}
