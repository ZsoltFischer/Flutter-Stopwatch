import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utils/src/extensions/extensions.dart';

import '../helpers/helpers.dart';
import '../helpers/test_widget.dart';

void main() {
  group('LayoutBreakPoints', () {
    testWidgets('isMobile when shortestSide < 600', (tester) async {
      late bool isMobile;
      await tester.pumpApp(
        TestWidget(
          size: const Size(400, 800),
          onBuild: (context) => isMobile = context.isMobile,
        ),
      );

      expect(isMobile, isTrue);
    });

    testWidgets('isTablet when shortestSide >= 600', (tester) async {
      late bool isTablet;
      await tester.pumpWidget(
        TestWidget(
          size: const Size(800, 1200),
          onBuild: (context) => isTablet = context.isTablet,
        ),
      );

      expect(isTablet, isTrue);
    });

    testWidgets('isDesktop when shortestSide >= 900', (tester) async {
      late bool isDesktop;
      await tester.pumpWidget(
        TestWidget(
          size: const Size(1000, 1200),
          onBuild: (context) => isDesktop = context.isDesktop,
        ),
      );

      expect(isDesktop, isTrue);
    });
  });

  group('HardCodedStrings', () {
    test('returns the same string via .hardcoded', () {
      const original = 'Hello world';
      final result = original.hardcoded;

      expect(result, equals(original));
    });

    test('works with an empty string', () {
      const original = '';
      final result = original.hardcoded;

      expect(result, equals(original));
    });
  });
}
