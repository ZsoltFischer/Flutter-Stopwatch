import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:utils/utils.dart';

/// A widget that displays the stopwatch controls
/// (Start, Pause, Resume, Stop, Lap).
/// The available controls change based on the current state of the stopwatch.
///
/// States and their corresponding controls:
// ignore: comment_references
/// - Initial: [Start]
/// - Running: [Pause, Stop, Lap]
/// - Paused: [Resume, Stop]
class StopwatchControls extends StatelessWidget {
  /// Creates a [StopwatchControls] widget.
  const StopwatchControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopwatchBloc, StopwatchState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        final buttons = switch (state) {
          StopwatchInitial() => [
            const _StartButton(),
          ],
          StopwatchRunning() => [
            const _StopButton(),
            const _PauseButton(),
            const _LapButton(),
          ],
          StopwatchPaused() => [
            const _ResumeButton(),
            const _StopButton(),
          ],
        };

        return SliverToBoxAdapter(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: buttons,
          ),
        );
      },
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      key: const ValueKey('StartButton'),
      onPressed: context.read<StopwatchBloc>().start,
      child: Text('Start'.hardcoded),
    );
  }
}

class _PauseButton extends StatelessWidget {
  const _PauseButton();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      key: const ValueKey('PauseButton'),
      onPressed: context.read<StopwatchBloc>().pause,
      child: Text('Pause'.hardcoded),
    );
  }
}

class _ResumeButton extends StatelessWidget {
  const _ResumeButton();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      key: const ValueKey('ResumeButton'),
      onPressed: context.read<StopwatchBloc>().start,
      child: Text('Resume'.hardcoded),
    );
  }
}

class _StopButton extends StatelessWidget {
  const _StopButton();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      key: const ValueKey('StopButton'),
      onPressed: context.read<StopwatchBloc>().stop,
      child: Text('Stop'.hardcoded),
    );
  }
}

class _LapButton extends StatelessWidget {
  const _LapButton();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      key: const ValueKey('LapButton'),
      onPressed: context.read<StopwatchBloc>().recordLap,
      child: Text('Lap'.hardcoded),
    );
  }
}
