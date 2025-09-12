import 'package:flutter/cupertino.dart';
import 'package:stopwatch/app/presentation/widgets.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/widgets.dart';

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({super.key});

  static Page<void> page() => const CupertinoPage(
    child: StopwatchProvider(child: StopwatchPage()),
  );

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          MobilePageNavbar(title: 'Stopwatch'),
          DigitalClock(),
          StopwatchControls(),
          LapList(),
        ],
      ),
    );
  }
}
