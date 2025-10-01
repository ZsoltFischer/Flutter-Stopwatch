// ignore_for_file: no-empty-block

import 'dart:async';

import 'package:clock/clock.dart';

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
  late MockClock clock;

  setUp(() {
    clock = MockClock();
    stopwatchService = StopwatchService(
      clock: clock,
      tickFrequencyHz: 30, // tick period ~33ms
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
        fakeAsync((async) async {
          // Use a real Stopwatch instead of Mock
          stopwatchService = StopwatchService(
            clock: Clock(),
            tickFrequencyHz: 30, // tick period ~33ms
          );

          // First start
          stopwatchService.start();
          async.flushMicrotasks();

          // Second start should not create a new subscription
          stopwatchService.start();

          // After 20ms (< tick period), no ticks yet
          async.elapse(const Duration(milliseconds: 20));
          expect(msUpdates.length, 0);

          // Now elapse enough for one tick (~33ms total)
          async.elapse(const Duration(milliseconds: 15));
          expect(msUpdates.length, 1); // only one tick
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
          expect(laps.first.lapTime, 50);
        });
      },
    );

    test('should add a second lap correctly', () {
      fakeAsync((async) async {
        stopwatchService.start();
        async.elapse(const Duration(milliseconds: 20));
        stopwatchService.recordLap();

        // First lap should be emitted
        // ignore: prefer-moving-to-variable
        expect(lapUpdates.last.length, 1);
        expect(lapUpdates.last.first.lapTime, 20);

        async.elapse(const Duration(milliseconds: 30));
        stopwatchService.recordLap();

        // Second lap should be emitted
        // ignore: prefer-moving-to-variable
        expect(lapUpdates.last.length, 2);
        expect(lapUpdates.last.last.lapTime, 30);
      });
    });
  });

  group('Edge cases', () {
    test('Record Lap Immediately After Start: Should record a lap of 0ms', () {
      fakeAsync((async) {
        // ARRANGE
        stopwatchService.start(); // fakeStopwatch.elapsedMilliseconds is 0

        // ACT
        stopwatchService.recordLap();

        async.flushMicrotasks();

        // ASSERT
        expect(lapUpdates.last.length, 1);
        expect(lapUpdates.last.last.lapTime, 0);
      });
    });

    test('Recording laps with 0 elapsed time works', () {
      fakeAsync((async) {
        stopwatchService.start();
        clock.advance(200);
        async.elapse(const Duration(milliseconds: 0));

        // ACT
        stopwatchService.recordLap();
        stopwatchService.recordLap();

        async.flushMicrotasks();

        // ASSERT
        expect(lapUpdates.last.length, 2);
        expect(lapUpdates.last.last.lapTime, 0);
      });
    });
  });
}
