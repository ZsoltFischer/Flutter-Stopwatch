import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/helpers.dart';
import 'app_robot.dart';
import 'workflows.dart';

/// To run integration tests, use the following command:
/// ignore: unintended_html_in_doc_comment
/// * flutter test integration_test --flavor <flavor> integration_test/app_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('integration testing', () {
    testWidgets('lap only workflow', (tester) async {
      await tester.pumpApp();
      final workflows = Workflows(AppRobot(tester));

      await workflows.lapOnlyWorkflow(5);
    });

    testWidgets('start/pause/resume/stop workflow', (tester) async {
      await tester.pumpApp();
      final workflows = Workflows(AppRobot(tester));

      await workflows.startPauseResumeStopWorkflow();
    });

    testWidgets('full cycle workflow', (tester) async {
      await tester.pumpApp();
      final workflows = Workflows(AppRobot(tester));

      await workflows.fullCycleWorkflow();
    });

    testWidgets('reset workflow', (tester) async {
      await tester.pumpApp();
      final workflows = Workflows(AppRobot(tester));

      await workflows.resetWorkflow();
    });
  });
}
