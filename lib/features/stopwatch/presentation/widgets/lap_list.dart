import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/lap_list_tile.dart';

/// A widget that displays a list of recorded laps in the stopwatch application.
class LapList extends StatelessWidget {
  /// Creates a [LapList] widget.
  const LapList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopwatchBloc, StopwatchState>(
      buildWhen: (previous, current) =>
          !listEquals(previous.laps, current.laps),
      builder: (context, state) {
        final lapCount = state.laps.length;
        return SliverPadding(
          padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: lapCount,
            itemBuilder: (context, index) {
              final lap = state.laps[lapCount - 1 - index]; // Reverse order
              return LapListTile(
                key: ValueKey(lap.toString()),
                lap: lap,
              );
            },
          ),
        );
      },
    );
  }
}
