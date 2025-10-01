import 'dart:async';
import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/clock_hand_painter.dart';

class AnimatedClockHand extends StatefulWidget {
  final Stream<int> elapsedMsStream;
  final int fullCycleInUnits;
  final Paint painter;
  final double lengthFactor;

  const AnimatedClockHand({
    required this.elapsedMsStream,
    required this.fullCycleInUnits,
    required this.painter,
    required this.lengthFactor,
    super.key,
  });

  @override
  State<AnimatedClockHand> createState() => _AnimatedClockHandState();
}

class _AnimatedClockHandState extends State<AnimatedClockHand>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final StreamSubscription<int> _subscription;
  double _displayedMs = 0;
  double _targetMs = 0;

  @override
  void initState() {
    super.initState();
    _subscription = widget.elapsedMsStream.listen((ms) {
      _targetMs = ms.toDouble();
    });
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration _) {
    setState(() {
      const double t = 0.2; // interpolation factor
      final double easedT = Curves.easeOut.transform(t);
      _displayedMs = lerpDouble(_displayedMs, _targetMs, easedT)!;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockHandPainter(
        elapsedMs: _displayedMs,
        fullCycleInUnits: widget.fullCycleInUnits,
        lengthFactor: widget.lengthFactor,
        painter: widget.painter,
      ),
    );
  }
}
