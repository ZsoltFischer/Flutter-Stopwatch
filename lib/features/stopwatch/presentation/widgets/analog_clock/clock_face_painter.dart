import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:utils/utils.dart';

/// Painter for a static clock face with ticks and center point
class ClockFacePainter extends CustomPainter {
  /// Creates a new instance of [ClockFacePainter].
  ClockFacePainter({
    Paint? tickPaint,
    Paint? centerPaint,
    double longTickFraction = 0.15,
    double shortTickFraction = 0.05,
    double centerPointFraction = 0.05,
    int numberOfTicks = 60,
    int longTickPeriod = 5,
  }) : _tickPaint = tickPaint ?? Paint()
         ..color = const Color(0xFF000000)
         ..strokeWidth = 2.0,
       _centerPaint = centerPaint ?? Paint()
         ..color = const Color(0xFF000000)
         ..style = PaintingStyle.fill
         ..strokeWidth = 1.0,
       _longTickFraction = longTickFraction,
       _shortTickFraction = shortTickFraction,
       _numberOfTicks = numberOfTicks,
       _longTickPeriod = longTickPeriod,
       _centerPointFraction = centerPointFraction;

  /// Paint for the ticks
  final Paint _tickPaint;

  /// Paint for the center point
  final Paint _centerPaint;

  /// Fraction of the radius for long ticks
  final double _longTickFraction;

  /// Fraction of the radius for short ticks
  final double _shortTickFraction;

  /// Fraction of the radius for the center point
  final double _centerPointFraction;

  /// Number of ticks on the clock face (60 for a standard clock)
  final int _numberOfTicks;

  /// Period for long ticks (e.g., every 5th tick for hour markers)
  final int _longTickPeriod;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.width, size.height) / 2;
    canvas
      ..translate(size.width / 2, size.height / 2)
      ..drawCircle(Offset.zero, radius * _centerPointFraction, _centerPaint);

    // Draw ticks
    final longTickLength = radius * _longTickFraction;
    final shortTickLength = radius * _shortTickFraction;

    for (var i = 0; i < _numberOfTicks; i++) {
      final isHourTick = i % _longTickPeriod == 0;
      final p1 = Offset(0, -radius);
      final p2 = Offset(
        0,
        -(radius - (isHourTick ? longTickLength : shortTickLength)),
      );

      canvas
        ..save()
        ..rotate((i * (360 / _numberOfTicks)).degToRad())
        ..drawLine(p1, p2, _tickPaint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
