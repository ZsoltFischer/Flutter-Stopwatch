import 'package:flutter_test/flutter_test.dart';

extension Wait on WidgetTester {
  Future<void> wait(Duration duration) async {
    await pump(duration);
    await pumpAndSettle();
  }
}
