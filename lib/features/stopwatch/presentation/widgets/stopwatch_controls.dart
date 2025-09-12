import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';

/// A widget that displays the stopwatch controls (Start, Pause, Resume, Stop, Lap).
/// The available controls change based on the current state of the stopwatch.
///
/// States and their corresponding controls:
// ignore: comment_references
/// - Initial: [Start]
/// - Running: [Pause, Stop, Lap]
/// - Paused: [Resume, Stop]
class StopwatchControls extends StatelessWidget {
  const StopwatchControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopwatchBloc, StopwatchState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        final buttons = switch (state) {
          StopwatchInitial() => [
            CupertinoButton.filled(
              onPressed: context.read<StopwatchBloc>().start,
              child: const Text('Start'),
            ),
          ],
          StopwatchRunning() => [
            CupertinoButton.filled(
              onPressed: context.read<StopwatchBloc>().pause,
              child: const Text('Pause'),
            ),
            const SizedBox(width: 16),
            CupertinoButton.filled(
              onPressed: context.read<StopwatchBloc>().stop,
              child: const Text('Stop'),
            ),
            const SizedBox(width: 16),
            CupertinoButton.filled(
              onPressed: context.read<StopwatchBloc>().recordLap,
              child: const Text('Lap'),
            ),
          ],
          StopwatchPaused() => [
            CupertinoButton.filled(
              onPressed: context.read<StopwatchBloc>().start,
              child: const Text('Resume'),
            ),
            const SizedBox(width: 16),
            CupertinoButton.filled(
              onPressed: context.read<StopwatchBloc>().stop,
              child: const Text('Stop'),
            ),
          ],
        };

        return SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons,
          ),
        );
      },
    );
  }
}
