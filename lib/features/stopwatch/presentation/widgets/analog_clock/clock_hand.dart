import 'package:flutter/widgets.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/clock_hand_painter.dart';

/// A performant analog clock hand widget that updates its position
/// at a throttled rate to reduce unnecessary rebuilds.
/// This widget is suitable for minute and hour hands
/// where high-frequency updates are not critical.
class ClockHand extends StatelessWidget {
  /// Creates a [ClockHand] widget.
  const ClockHand({
    required Stream<num> elapsedTimeStream,
    required int fullCycleInUnits,
    required Paint painter,
    required double lengthFactor,
    super.key,
  }) : _fullCycle = fullCycleInUnits,
       _lengthFactor = lengthFactor,
       _elapsedTimeStream = elapsedTimeStream,
       _painter = painter;

  /// Creates a [ClockHand] configured as the default seconds hand.
  ///
  /// For linear movement a millisecond stream should be used.
  factory ClockHand.seconds({
    Key? key,
    required Stream<int> elapsedTimeStream,
  }) {
    return ClockHand(
      key: key,
      elapsedTimeStream: elapsedTimeStream,
      fullCycleInUnits: 60 * 1000,
      lengthFactor: 0.9,
      painter: Paint()
        ..color = const Color(0xFFFF0000)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Creates a [ClockHand] configured as the default seconds hand.
  ///
  /// For discrete movement a seconds stream should be used.
  factory ClockHand.discreteSeconds({
    Key? key,
    required Stream<int> elapsedTimeStream,
  }) {
    return ClockHand(
      key: key,
      elapsedTimeStream: elapsedTimeStream,
      fullCycleInUnits: 60,
      lengthFactor: 0.9,
      painter: Paint()
        ..color = const Color(0xFFFF0000)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Creates a [ClockHand] configured as the default minute hand.
  factory ClockHand.minutes({
    Key? key,
    required Stream<double> elapsedTimeStream,
  }) {
    return ClockHand(
      key: key,
      elapsedTimeStream: elapsedTimeStream,
      fullCycleInUnits: 60,
      lengthFactor: 0.9,
      painter: Paint()
        ..color = const Color(0xFF000000)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Creates a [ClockHand] configured as the default hour hand.
  factory ClockHand.hours({
    Key? key,
    required Stream<double> elapsedTimeStream,
  }) {
    return ClockHand(
      key: key,
      elapsedTimeStream: elapsedTimeStream,
      fullCycleInUnits: 12,
      lengthFactor: 0.6,
      painter: Paint()
        ..color = const Color.fromARGB(255, 21, 0, 255)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  /// The paint object used to draw the hand.
  final Paint _painter;
  Paint get paint => _painter;

  /// The full cycle duration of the hand (e.g., 12 hours for hour hand).
  final int _fullCycle;
  int get fullCycle => _fullCycle;

  /// The length factor of the hand relative to the clock radius (0.0 to 1.0).
  final double _lengthFactor;
  double get lengthFactor => _lengthFactor;

  final Stream<num> _elapsedTimeStream;
  Stream<num> get elapsedTimeStream => _elapsedTimeStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<num>(
      stream: elapsedTimeStream,
      builder: (context, snapshot) {
        return CustomPaint(
          painter: ClockHandPainter(
            elapsedMs: snapshot.data ?? 0,
            fullCycleInUnits: fullCycle,
            lengthFactor: lengthFactor,
            painter: paint,
          ),
        );
      },
    );
  }
}
