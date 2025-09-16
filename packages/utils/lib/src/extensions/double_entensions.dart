import 'dart:math' as math;

/// Extension on double to convert degrees to radians
extension DoubleToRadian on double {
  /// Converts degrees to radians.
  double degToRad() => this * (math.pi / 180);
}
