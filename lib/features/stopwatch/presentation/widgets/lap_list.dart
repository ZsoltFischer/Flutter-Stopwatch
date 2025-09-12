import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:utils/utils.dart';

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

        return SliverList.builder(
          itemCount: laps.length,
          itemBuilder: (context, index) {
            final lap = laps[index];
            final lapDuration = Duration(milliseconds: lap.lapTime);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lap ${lap.index}'),
                  Text(lapDuration.toDigital()),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
