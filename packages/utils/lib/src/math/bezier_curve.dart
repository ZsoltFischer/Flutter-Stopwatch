import 'dart:math' as math;

/// Parametric cubic Bezier interpolation.
/// Can be used for custom animations or easing functions.
///
/// [t] is the interpolation factor (0..1).
/// [start] is the start value, [end] is the end value.
/// [c1] and [c2] are control point factors (0..1) between start and end.
double cubicBezier(
  double t, {
  required double start,
  required double end,
  double c1 = 0.3,
  double c2 = 0.7,
}) {
  assert(
    t >= 0.0 && t <= 1.0,
    'Interpolation factor [t] must be between 0 and 1',
  );
  assert(c1 >= 0.0 && c1 <= 1.0, 'Control point [c1] must be between 0 and 1');
  assert(c2 >= 0.0 && c2 <= 1.0, 'Control point [c2] must be between 0 and 1');

  final double p1 = start + (end - start) * c1;
  final double p2 = start + (end - start) * c2;

  return math.pow(1 - t, 3) * start +
      3 * math.pow(1 - t, 2) * t * p1 +
      3 * (1 - t) * math.pow(t, 2) * p2 +
      math.pow(t, 3) * end;
}
