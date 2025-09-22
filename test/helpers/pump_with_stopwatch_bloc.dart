import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/features/stopwatch/domain/bloc/stopwatch_bloc.dart';
import 'fakes/fake_stopwatch_bloc.dart';

extension PumpWithStopwatchBloc on WidgetTester {
  Future<void> pumpStopwatchBlocWithSliverChild({
    required StopwatchState initialState,
    required FakeStopwatchBloc fakeBloc,
    required Widget sliverChild,
  }) async {
    fakeBloc.emit(initialState);

    await pumpWidget(
      BlocProvider<StopwatchBloc>.value(
        value: fakeBloc,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: CustomScrollView(slivers: [sliverChild]),
        ),
      ),
    );
    await pumpAndSettle();
  }
}
