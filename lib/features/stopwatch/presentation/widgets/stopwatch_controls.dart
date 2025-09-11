import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';

class StopwatchControls extends StatelessWidget {
  const StopwatchControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopwatchBloc, StopwatchState>(
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
