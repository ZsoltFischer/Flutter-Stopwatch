import 'package:flutter/cupertino.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/ticker/animated_clock.dart';
import 'package:utils/utils.dart';

class DigitalClockTicker extends StatelessWidget {
  const DigitalClockTicker({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedClock(
      child: (elapsedMs) {
        return SliverToBoxAdapter(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              key: const ValueKey('DigitalClockTicker'),
              Duration(milliseconds: elapsedMs).toDigitalClock(),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
        );
      },
    );
  }
}
