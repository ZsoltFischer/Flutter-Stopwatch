import 'package:flutter/material.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/digital_clock/accurate_digital_clock.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/digital_clock/preformant_digital_clock.dart';
import 'package:utils/utils.dart';

class DigitalClockComparison extends StatelessWidget {
  const DigitalClockComparison({super.key});

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelMedium;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 1000,
          child: Wrap(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Performant digital clock:'.hardcoded,
                    style: labelStyle,
                  ),
                  const PerformantDigitalClock(),
                ],
              ),
              Column(
                children: [
                  Text('Accurate digital clock:'.hardcoded, style: labelStyle),
                  const AccurateDigitalClock(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
