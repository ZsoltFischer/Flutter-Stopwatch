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
        final laps = state.laps.reversed.toList();

        return SliverPadding(
          padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: laps.length,
            itemBuilder: (context, index) {
              final lap = laps[index];
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
