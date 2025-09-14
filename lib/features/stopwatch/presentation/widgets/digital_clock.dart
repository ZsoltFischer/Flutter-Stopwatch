import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:utils/utils.dart';

class DigitalClock extends StatelessWidget {
  const DigitalClock({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: BlocBuilder<StopwatchBloc, StopwatchState>(
            buildWhen: (previous, current) =>
                previous.elapsedTimeInMs != current.elapsedTimeInMs,
            builder: (context, state) {
              return Text(
                key: const ValueKey('DigitalClockText'),
                Duration(
                  milliseconds: state.elapsedTimeInMs,
                ).toDigital(),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
