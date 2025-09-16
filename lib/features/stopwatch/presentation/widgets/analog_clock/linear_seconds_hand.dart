import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/clock_hand_painter.dart';

/// A widget that displays a linear seconds hand for an analog clock.
/// The hand updates its position based on the elapsed time
/// from the [StopwatchBloc].
///
///! This widget is NOT optimized for performance
///! and should be used with caution in high-frequency update scenarios.
class LinearSecondsHand extends StatelessWidget {
  const LinearSecondsHand({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StopwatchBloc, StopwatchState, int>(
      selector: (state) {
        return state.elapsedTimeInMs;
      },
      builder: (context, seconds) {
        return CustomPaint(
          painter: HandPainter(
            elapsedMs: seconds,
            fullCycleInMs: const Duration(seconds: 60).inMilliseconds,
            lengthFactor: 0.9,
            // easingFunction: snappyEasing,
            painter: Paint()
              ..color = const Color(0xFFFF0000)
              ..strokeWidth = 2
              ..strokeCap = StrokeCap.round,
          ),
        );
      },
    );
  }
}
