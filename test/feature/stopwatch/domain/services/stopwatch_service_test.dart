import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/features/stopwatch/domain/entities/entities.dart';
import 'package:stopwatch/features/stopwatch/domain/services/stopwatch_service.dart';

void main() {
  late StopwatchService stopwatchService;
  late StreamSubscription<StopwatchStateEntity> subscription;
  late List<StopwatchStateEntity> updates;

  setUp(() {
    stopwatchService = StopwatchService();
    updates = [];
    subscription = stopwatchService.durationStream.listen(updates.add);
  });

  tearDown(() async {
    stopwatchService.stop();
    await subscription.cancel();
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

        expect(updates.length, greaterThanOrEqualTo(ticksToSimulate));
        expect(
          updates.last.elapsedTimeInMs,
          closeTo(tickIntervalInMs * ticksToSimulate, 2),
        );
      });
    });

    test(
      'should not create multiple subscriptions if called multiple times',
      () {
        fakeAsync((async) async {
          stopwatchService.start();
          async.flushMicrotasks();
          stopwatchService.start();

          async.elapse(const Duration(milliseconds: 20));

          expect(updates.length, greaterThan(0));
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

        final updatesBeforeStop = updates.length;

        // Pause the stopwatch
        stopwatchService.pause();

        async.elapse(const Duration(milliseconds: 50));

        final updatesAfterPause = updates.length;
        expect(updatesBeforeStop, isNotEmpty);
        expect(updatesAfterPause, updatesBeforeStop);
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
        expect(updates.first.elapsedTimeInMs, greaterThan(0));

        stopwatchService.stop();

        async.flushMicrotasks();

        /// Verify and ensure at least one update is emitted before stop
        expect(updates, isNotEmpty);

        /// Verify that the last emitted update has elapsedTimeInMs of 0
        /// This confirms that the stopwatch has been reset
        expect(updates.last.elapsedTimeInMs, 0);
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
        expect(updates, isNotEmpty);
        final lastUpdate = updates.last;
        expect(lastUpdate.elapsedTimeInMs, 0);
        expect(lastUpdate.laps, isEmpty);
      });
    });
  });

  // ===============================================================
  // * recordLap Method Tests
  // ===============================================================

  group('recordLap', () {
    test('recordLap adds lap correctly', () {
      fakeAsync((async) async {
        stopwatchService.start();
        async.elapse(const Duration(milliseconds: 20));
        stopwatchService.recordLap();
        async.elapse(const Duration(milliseconds: 20));
        stopwatchService.recordLap();

        expect(stopwatchService.laps.length, 2);
        expect(stopwatchService.laps[0].lapTime, greaterThan(0));
        expect(stopwatchService.laps[1].lapTime, greaterThan(0));
      });
    });

    group('recordLap', () {
      test('should add a new lap with the correct duration', () {
        fakeAsync((async) async {
          stopwatchService.start();
          async.elapse(const Duration(milliseconds: 50));

          stopwatchService.recordLap();
          expect(
            updates.last.elapsedTimeInMs,
            closeTo(50, 5),
          );

          // Assert
          final laps = stopwatchService.laps;
          expect(laps.length, 1);
          expect(laps.first.lapTime, closeTo(50, 5));
        });
      });
    });
  });
}
