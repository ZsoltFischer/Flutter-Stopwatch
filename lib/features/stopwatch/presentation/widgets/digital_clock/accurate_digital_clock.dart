import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:utils/utils.dart';

class AccurateDigitalClock extends StatelessWidget {
  const AccurateDigitalClock({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<StopwatchBloc, StopwatchState>(
        buildWhen: (previous, current) =>
            previous.elapsedTimeInMs != current.elapsedTimeInMs,
        builder: (context, state) {
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              key: const ValueKey('AccurateDigitalClock'),
              Duration(
                milliseconds: state.elapsedTimeInMs,
              ).toDigitalClock(),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          );
        },
      ),
    );
  }
}
