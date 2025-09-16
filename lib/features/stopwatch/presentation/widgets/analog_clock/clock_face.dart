import 'package:flutter/widgets.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/clock_face_painter.dart';

/// A clock face widget that displays the background of an analog clock.
class ClockFace extends StatelessWidget {
  /// Creates a [ClockFace] widget.
  const ClockFace({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: ClockFacePainter());
  }
}
