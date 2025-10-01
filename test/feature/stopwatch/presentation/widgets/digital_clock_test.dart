// ignore_for_file: prefer-moving-to-variable

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stopwatch/features/stopwatch/domain/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/digital_clock/digital_clock.dart';

import '../../../../mocks.dart';

void main() {
  group('DigitalClock', () {
    late MockStopwatchBloc mockStopwatchBloc;

    // setUpAll(() {
    //   registerFallbackValue(const StopwatchInitial());
    //   registerFallbackValue(StopwatchStart());
    // });

    setUp(() {
      mockStopwatchBloc = MockStopwatchBloc();
    });

    // Helper method to pump the widget with a mock bloc in a sliver-aware context
    Future<void> pumpDigitalClockWidget({
      required WidgetTester tester,
      required MockStopwatchBloc bloc,
      required StopwatchState initialState,
      Stream<int>? msStream,
    }) async {
      when(() => bloc.msStream).thenAnswer((_) => msStream ?? Stream.value(0));

      // Use whenListen to properly mock the stream and state
      whenListen(
        bloc,
        Stream.fromIterable([initialState]),
        initialState: initialState,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<StopwatchBloc>.value(
            value: bloc,
            child: const CustomScrollView(slivers: [DigitalClock()]),
          ),
        ),
      );
    }

    testWidgets('should render with initial time 00:00:00.000', (tester) async {
      // Arrange
      await pumpDigitalClockWidget(
        tester: tester,
        bloc: mockStopwatchBloc,
        initialState: const StopwatchInitial(),
        msStream: Stream.value(0),
      );

      // Assert
      final digitalClockTextFinder = find.byKey(const ValueKey('DigitalClock'));
      expect(digitalClockTextFinder, findsOneWidget);
      final textWidget = tester.widget<Text>(digitalClockTextFinder);
      expect(textWidget.data, equals('00:00:00.000'));
    });

    testWidgets('should display correct time based on stream updates', (
      tester,
    ) async {
      // Arrange
      final msController = StreamController<int>();
      await pumpDigitalClockWidget(
        tester: tester,
        bloc: mockStopwatchBloc,
        initialState: const StopwatchInitial(),
        msStream: msController.stream,
      );

      // Act & Assert for 10 seconds
      msController.add(10000);
      await tester.pumpAndSettle();
      expect(find.text('00:00:10.000'), findsOneWidget);

      // Act & Assert for 1 minute
      msController.add(60000);
      await tester.pumpAndSettle();
      expect(find.text('00:01:00.000'), findsOneWidget);

      // Act & Assert for 1 hour
      msController.add(3600000);
      await tester.pumpAndSettle();
      expect(find.text('01:00:00.000'), findsOneWidget);

      // Act & Assert for an odd value
      msController.add(3665123);
      await tester.pumpAndSettle();
      expect(find.text('01:01:05.123'), findsOneWidget);

      // Clean up the stream controller.
      addTearDown(msController.close);
    });
  });
}
