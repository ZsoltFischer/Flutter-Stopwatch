import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/lap_entity.dart';
import 'package:stopwatch/features/stopwatch/domain/services/stopwatch_service.dart';
import '../../../../mocks.dart';

void main() {
  late StopwatchService stopwatchService;
  late StreamSubscription<int> msSubscription;
  late StreamSubscription<List<LapEntity>> lapSubscription;
  late List<int> msUpdates;
  late List<List<LapEntity>> lapUpdates;

  setUp(() {
    stopwatchService = StopwatchService(
      clock: MockClock(),
      tickFrequencyHz: 30,
    );
    msUpdates = [];
    lapUpdates = [];
    msSubscription = stopwatchService.msStream.listen(msUpdates.add);
    lapSubscription = stopwatchService.lapStream.listen(lapUpdates.add);
  });

  tearDown(() async {
    stopwatchService.stop();
    await msSubscription.cancel();
    await lapSubscription.cancel();
    await stopwatchService.dispose();
  });

  // ===============================================================
  // * Start Method Tests
  // ===============================================================

  group('start', () {
    test('should start the stopwatch and emit at least 2 ticks', () {
      fakeAsync((async) async {
        // ARRANGE
        // Use a clean frequency for a clear interval of 10ms per tick.
        const tickFrequencyHz = 60;
        const tickIntervalInMs = 1000 ~/ tickFrequencyHz;
        const ticksToSimulate = 20;

        stopwatchService.start();

        async.elapse(
          const Duration(milliseconds: tickIntervalInMs * ticksToSimulate),
        );

        expect(msUpdates.length, greaterThanOrEqualTo(ticksToSimulate));
        expect(msUpdates.last, tickIntervalInMs * ticksToSimulate);
      });
    });

    test(
      'should not create multiple subscriptions if called multiple times',
      () {
        fakeAsync((async) {
          stopwatchService.start();
          async.flushMicrotasks();
          stopwatchService.start(); // Second call to start

          // The tick period is ~33ms for 30Hz.
          // After 20ms, no ticks are expected.
          async.elapse(const Duration(milliseconds: 20));

          // This is a more precise assertion.
          expect(msUpdates.length, 0);

          // Now, elapse enough time for one tick from a single timer.
          async.elapse(
            const Duration(milliseconds: 15),
          ); // 20 + 15 = 35ms > 33ms

          // Expect exactly one update from the single timer.
          expect(msUpdates.length, 1);
        });
      },
    );
  });

  // ===============================================================
  // * Pause Method Tests
  // ===============================================================

  group('pause', () {
    test('should stop emitting stats when paused', () {
      fakeAsync((async) async {
        stopwatchService.start();
        async.elapse(const Duration(milliseconds: 50));

        final updatesBeforePause = msUpdates.length;

        // Pause the stopwatch
        stopwatchService.pause();

        async.elapse(const Duration(milliseconds: 50));

        final updatesAfterPause = msUpdates.length;
        expect(updatesBeforePause, isNotEmpty);
        expect(updatesAfterPause, updatesBeforePause + 1);
        expect(msUpdates.last, 50);
      });
    });
  });

  // ===============================================================
  // * Stop Method Tests
  // ===============================================================

  group('stop', () {
    test('should stop the stopwatch and emit a final state', () {
      fakeAsync((async) async {
        stopwatchService.start();
        async.elapse(const Duration(milliseconds: 50));
        expect(msUpdates.first, greaterThan(0));

        stopwatchService.stop();

        async.flushMicrotasks();

        /// Verify and ensure at least one update is emitted before stop
        expect(msUpdates, isNotEmpty);

        /// Verify that the last emitted update has elapsed time of 0
        /// This confirms that the stopwatch has been reset
        expect(msUpdates.last, 0);
        expect(lapUpdates.last, isEmpty);
      });
    });

    test('should reset elapsed time and clear laps', () {
      fakeAsync((async) async {
        stopwatchService.start();
        async.elapse(const Duration(milliseconds: 50));
        stopwatchService
          ..recordLap()
          ..stop();

        async.flushMicrotasks();

        // Ensure at least one update is emitted after stop
        expect(msUpdates, isNotEmpty);
        expect(msUpdates.last, 0);

        // Ensure the last lap update is an empty list
        expect(lapUpdates, isNotEmpty);
        expect(lapUpdates.last, isEmpty);
      });
    });
  });

  // ===============================================================
  // * recordLap Method Tests
  // ===============================================================

  group('recordLap', () {
    test(
      'should add a new lap with the correct duration and emit a list of laps',
      () {
        fakeAsync((async) async {
          stopwatchService.start();
          async.elapse(const Duration(milliseconds: 50));
          stopwatchService.recordLap();

          // Assert that a lap update was emitted
          expect(lapUpdates, isNotEmpty);
          final laps = lapUpdates.last;

          // Verify the number of laps
          expect(laps.length, 1);

          // Verify the details of the first lap
          expect(laps.first.index, 1);
          expect(laps.first.lapTime, closeTo(50, 5));
        });
      },
    );

    test('should add a second lap correctly', () {
      fakeAsync((async) async {
        stopwatchService.start();
        async.elapse(const Duration(milliseconds: 20));
        stopwatchService.recordLap();

        // Check if the first lap was added correctly
        // ignore: prefer-moving-to-variable
        expect(lapUpdates.last.length, 1);
        expect(lapUpdates.last.first.lapTime, closeTo(20, 5));

        async.elapse(const Duration(milliseconds: 30));
        stopwatchService.recordLap();

        // Check the second lap
        // ignore: prefer-moving-to-variable
        expect(lapUpdates.last.length, 2);
        expect(lapUpdates.last.last.lapTime, closeTo(30, 5));

        // Check the total elapsed time on the stopwatch service
        expect(stopwatchService.laps.length, 2);
      });
    });
  });
}
