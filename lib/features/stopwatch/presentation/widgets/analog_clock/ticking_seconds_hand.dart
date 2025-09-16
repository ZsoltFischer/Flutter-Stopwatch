import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/clock_hand_painter.dart';

/// A ticking seconds hand widget for an analog clock.
/// This hand updates its position every second,
/// moving in discrete steps to indicate the passing seconds.
///
/// * Animartions are not yet implemented.
class TickingSecondsHand extends StatelessWidget {
  /// Creates a [TickingSecondsHand] widget.
  const TickingSecondsHand({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StopwatchBloc, StopwatchState, int>(
      selector: (state) {
        final seconds =
            state.elapsedTimeInMs ~/ const Duration(seconds: 1).inMilliseconds;

        return seconds;
      },
      builder: (context, seconds) {
        return CustomPaint(
          painter: HandPainter(
            elapsedMs: seconds % 60 * 1000,
            fullCycleInMs: 60 * 1000,
            lengthFactor: 0.9,
            painter: Paint()
              ..color = const Color(0xFFFF0000)
              ..strokeWidth = 1,
          ),
        );
      },
    );
  }
}
