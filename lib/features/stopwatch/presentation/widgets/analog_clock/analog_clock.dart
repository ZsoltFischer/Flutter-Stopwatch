import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/clock_face.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/linear_seconds_hand.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/performant_clock_hand.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/secondary_clock_face.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/ticking_seconds_hand.dart';

/// An analog clock widget that displays hours, minutes, and seconds hands.
/// The clock is designed to fit in a square area responsively,
/// maintaining its aspect ratio.
///
/// The clock consists of two main components:
/// 1. The main clock face with hour and minute hands.
/// 2. A smaller, offset clock face with a ticking seconds hand.
class AnalogClock extends StatelessWidget {
  /// Creates an [AnalogClock] widget.
  const AnalogClock({super.key});

  @override
  Widget build(BuildContext context) {
    final clockComponents = <Widget>[
      const ClockFace(),
      PerformantClockHand.hours(),
      PerformantClockHand.minutes(),
      const LinearSecondsHand(),
    ];

    final secondaryClockComponents = <Widget>[
      const SecondaryClockFace(),
      const TickingSecondsHand(),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      sliver: SliverToBoxAdapter(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = math.min(
                constraints.maxWidth,
                constraints.maxHeight,
              );
              return SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, size / 4),
                      child: SizedBox(
                        width: size / 3,
                        height: size / 3,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            for (final child in secondaryClockComponents)
                              Positioned.fill(child: child),
                          ],
                        ),
                      ),
                    ),
                    for (final child in clockComponents)
                      Positioned.fill(child: child),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
