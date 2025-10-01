import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/app/presentation/widgets/default_sliver_appbar.dart';
import 'package:stopwatch/features/stopwatch/domain/services/stopwatch_service.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/analog_clock/analog_clock.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/digital_clock/digital_clock.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/ticker/digital_clock_ticker.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/widgets.dart';
import 'package:utils/utils.dart';

/// Page displaying the stopwatch with analog and digital clocks,
/// controls, and lap list.
class StopwatchPage extends StatelessWidget {
  /// Creates a [StopwatchPage] widget.
  const StopwatchPage({super.key});

  /// Returns a [Page] for navigation purposes.
  static Page<void> page() =>
      const CupertinoPage(child: StopwatchProvider(child: StopwatchPage()));

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          DefaultSliverAppbar(title: 'Stopwatch'),
          AnalogClock(),
          DigitalClock(),
          DigitalClockTicker(), // --- IGNORE ---
          StopwatchControls(),
          LapList(),
        ],
      ),
    );
  }
}

// ignore: prefer-single-widget-per-file
class DirectService extends StatelessWidget {
  const DirectService({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: StreamBuilder(
        stream: context.read<StopwatchService>().msStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          final elapsed = snapshot.data ?? 0;

          return Text(Duration(milliseconds: elapsed).toDigitalClock());
        },
      ),
    );
  }
}
