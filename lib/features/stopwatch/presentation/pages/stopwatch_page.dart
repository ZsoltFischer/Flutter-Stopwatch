import 'package:flutter/cupertino.dart';
import 'package:stopwatch/app/presentation/widgets/default_sliver_appbar.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/analog_clock.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/widgets.dart';

/// Page displaying the stopwatch with analog and digital clocks,
/// controls, and lap list.
class StopwatchPage extends StatelessWidget {
  /// Creates a [StopwatchPage] widget.
  const StopwatchPage({super.key});

  /// Returns a [Page] for navigation purposes.
  static Page<void> page() => const CupertinoPage(
    child: StopwatchProvider(child: StopwatchPage()),
  );

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          DefaultSliverAppbar(title: 'Stopwatch'),
          AnalogClock(),
          DigitalClockComparison(),
          StopwatchControls(),
          LapList(),
        ],
      ),
    );
  }
}
