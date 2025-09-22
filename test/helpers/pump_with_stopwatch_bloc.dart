import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/features/stopwatch/domain/bloc/stopwatch_bloc.dart';
import '../mocks.dart';

/// An extension on [WidgetTester] to simplify the setup of the test environment.
extension PumpWithStopwatchBloc on WidgetTester {
  Future<void> pumpMockStopwatchBlocWithSliverChild({
    required StopwatchState initialState,
    required MockStopwatchBloc mockBloc,
    required Widget sliverChild,
  }) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([initialState]),
      initialState: initialState,
    );

    await pumpWidget(
      BlocProvider<StopwatchBloc>.value(
        value: mockBloc,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: CustomScrollView(slivers: [sliverChild]),
        ),
      ),
    );
    await pumpAndSettle();
  }
}
