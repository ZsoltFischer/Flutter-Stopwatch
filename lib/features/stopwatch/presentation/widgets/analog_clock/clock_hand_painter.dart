import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:utils/utils.dart';

/// The [ClockHandPainter] class is responsible for rendering a clock hand
/// on a canvas. It calculates the angle of the hand based on the elapsed
/// time and the full cycle duration. The hand's length and appearance
/// can be customized through the provided parameters.
class ClockHandPainter extends CustomPainter {
  ClockHandPainter({
    required this.elapsedMs,
    required this.fullCycleInUnits,
    required this.lengthFactor,
    required this.painter,
    super.repaint,
  });

  /// The elapsed time in milliseconds.
  final num elapsedMs;

  /// The full cycle duration in milliseconds. e.g., 60,000 ms for a minute hand
  final int fullCycleInUnits;

  /// The length factor of the hand relative to the clock radius (0.0 to 1.0).
  final double lengthFactor;

  /// The paint object used to draw the hand.
  final Paint painter;

  /// Calculates the angle in degrees for the clock hand based on the time
  double calculateAngle({required num elapsed, required int fullCycle}) {
    return (elapsed / fullCycle * 360) - 90;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    final length = radius * lengthFactor;

    final angle = calculateAngle(
      elapsed: elapsedMs,
      fullCycle: fullCycleInUnits,
    );

    final rad = angle.degToRad();
    final end = Offset(
      center.dx + length * math.cos(rad),
      center.dy + length * math.sin(rad),
    );
    canvas.drawLine(center, end, painter);
  }

  @override
  bool shouldRepaint(covariant ClockHandPainter old) =>
      old.elapsedMs != elapsedMs ||
      old.fullCycleInUnits != fullCycleInUnits ||
      old.lengthFactor != lengthFactor ||
      old.painter.color != painter.color ||
      old.painter.strokeWidth != painter.strokeWidth ||
      old.painter.strokeCap != painter.strokeCap;
}
