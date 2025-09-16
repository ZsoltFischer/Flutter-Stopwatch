import 'package:flutter/widgets.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/clock_face_painter.dart';

/// A secondary clock face widget that displays
/// a simplified clock face with fewer ticks.
/// This widget is typically used as a smaller,
/// offset clock face within a larger analog clock.
class SecondaryClockFace extends StatelessWidget {
  /// Creates a [SecondaryClockFace] widget.
  const SecondaryClockFace({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockFacePainter(
        numberOfTicks: 12,
        longTickFraction: 0.2,
        shortTickFraction: 0.1,
        longTickPeriod: 3,
        centerPointFraction: 0.1,
      ),
    );
  }
}
