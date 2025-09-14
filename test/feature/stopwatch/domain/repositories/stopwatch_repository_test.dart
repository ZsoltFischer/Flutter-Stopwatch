import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../mocks.dart';

void main() {
  group('StopwatchRepository', () {
    late MockStopwatchRepository mockRepo;

    setUp(() {
      mockRepo = MockStopwatchRepository();
    });

    test('startStopwatch() calls start', () {
      mockRepo.startStopwatch();
      verify(() => mockRepo.startStopwatch()).called(1);
    });

    test('pauseStopwatch() calls pause', () {
      mockRepo.pauseStopwatch();
      verify(() => mockRepo.pauseStopwatch()).called(1);
    });

    test('stopStopwatch() calls stop', () {
      mockRepo.stopStopwatch();
      verify(() => mockRepo.stopStopwatch()).called(1);
    });

    test('recordLap() calls recordLap', () {
      mockRepo.recordLap();
      verify(() => mockRepo.recordLap()).called(1);
    });
  });
}
