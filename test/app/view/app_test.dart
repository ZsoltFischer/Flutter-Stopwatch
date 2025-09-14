// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart' show CupertinoApp;
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/app/app.dart';
import 'package:stopwatch/features/stopwatch/presentation/pages/stopwatch_page.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/widgets.dart';

void main() {
  group('App Start', () {
    testWidgets('renders StopwatchPage', (tester) async {
      await tester.pumpWidget(const StopwatchApp());
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoApp), findsOneWidget);
      expect(find.byType(StopwatchPage), findsOneWidget);
      expect(find.byType(StopwatchControls), findsOneWidget);
    });
  });
}
