import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/clock_hand_painter.dart';

/// A performant analog clock hand widget that updates its position
/// at a throttled rate to reduce unnecessary rebuilds.
/// This widget is suitable for minute and hour hands
/// where high-frequency updates are not critical.
class PerformantAnalogClock extends StatefulWidget {
  /// Creates a [PerformantAnalogClock] widget.
  const PerformantAnalogClock({
    required Duration throttleDuration,
    required Duration fullCycle,
    required Paint painter,
    required double lengthFactor,
    super.key,
  }) : _throttleDuration = throttleDuration,
       _fullCycle = fullCycle,
       _lengthFactor = lengthFactor,
       _painter = painter;

  /// Creates a [PerformantAnalogClock] configured as the default minute hand.
  ///
  /// The minute hand updates its position every 10 seconds,
  factory PerformantAnalogClock.minutes({Key? key}) {
    return PerformantAnalogClock(
      key: key,
      throttleDuration: const Duration(seconds: 10),
      fullCycle: const Duration(hours: 1),
      lengthFactor: 0.9,
      painter: Paint()
        ..color = const Color(0xFF000000)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Creates a [PerformantAnalogClock] configured as the default hour hand.
  ///
  /// The hour hand updates its position every 10 seconds,
  factory PerformantAnalogClock.hours({Key? key}) {
    return PerformantAnalogClock(
      key: key,
      throttleDuration: const Duration(seconds: 10),
      fullCycle: const Duration(hours: 12),
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

  /// The duration to throttle updates to the hand's position.
  final Duration _throttleDuration;
  Duration get throttleDuration => _throttleDuration;

  /// The full cycle duration of the hand (e.g., 12 hours for hour hand).
  final Duration _fullCycle;
  Duration get fullCycle => _fullCycle;

  /// The length factor of the hand relative to the clock radius (0.0 to 1.0).
  final double _lengthFactor;
  double get lengthFactor => _lengthFactor;

  @override
  State<PerformantAnalogClock> createState() => _PerformantAnalogClockState();
}

class _PerformantAnalogClockState extends State<PerformantAnalogClock> {
  late final Stream<StopwatchState> _filteredStream;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<StopwatchBloc>();

    // Filter the bloc's stream using RxDart's throttleTime operator
    _filteredStream = bloc.stream
        .throttleTime(widget.throttleDuration)
        .startWith(bloc.state);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StopwatchState>(
      stream: _filteredStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return CustomPaint(
          painter: HandPainter(
            elapsedMs: snapshot.data!.elapsedTimeInMs,
            fullCycleInMs: widget.fullCycle.inMilliseconds,
            lengthFactor: widget.lengthFactor,
            painter: widget.paint,
          ),
        );
      },
    );
  }
}
