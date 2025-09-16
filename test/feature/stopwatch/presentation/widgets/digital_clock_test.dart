import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/digital_clock/accurate_digital_clock.dart';
import 'package:utils/utils.dart';

import '../../../../helpers/fakes/fake_stopwatch_bloc.dart';
import '../../../../helpers/helpers.dart';

void main() {
  group('DigitalClock', () {
    late FakeStopwatchBloc fakeBloc;

    setUp(() {
      fakeBloc = FakeStopwatchBloc(const StopwatchInitial());
    });

    tearDown(() {
      fakeBloc.dispose();
    });

    testWidgets('shows initial display', (tester) async {
      await tester.pumpWithFakeStopwatchBloc(
        initialState: const StopwatchInitial(),
        fakeBloc: fakeBloc,
        child: const AccurateDigitalClock(),
      );
      expect(find.text(Duration.zero.toDigitalClock()), findsOneWidget);
    });

    testWidgets('updates display after 100ms when running', (tester) async {
      await tester.pumpWithFakeStopwatchBloc(
        initialState: StopwatchRunning(
          elapsedTimeInMs: 100,
          startTime: DateTime.now(),
        ),
        fakeBloc: fakeBloc,
        child: const AccurateDigitalClock(),
      );
      expect(
        find.text(const Duration(milliseconds: 100).toDigitalClock()),
        findsOneWidget,
      );
    });

    testWidgets('paused state displays correct elapsed time', (tester) async {
      await tester.pumpWithFakeStopwatchBloc(
        initialState: StopwatchRunning(
          elapsedTimeInMs: 100,
          startTime: DateTime.now(),
        ),
        fakeBloc: fakeBloc,
        child: const AccurateDigitalClock(),
      );
      expect(
        find.text(const Duration(milliseconds: 100).toDigitalClock()),
        findsOneWidget,
      );

      // Pause the stopwatch
      fakeBloc.emit(const StopwatchPaused(elapsedTimeInMs: 100));
      await tester.pumpAndSettle();
      expect(
        find.text(const Duration(milliseconds: 100).toDigitalClock()),
        findsOneWidget,
      );
    });
  });
}
