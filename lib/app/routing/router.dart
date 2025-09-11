import 'package:core/core.dart' show GoRouterRefreshStream;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:go_router/go_router.dart';
import 'package:stopwatch/app/presentation/widgets/scaffold_with_nested_navigation.dart';
import 'package:stopwatch/app/routing/fake_route_refresh_stream.dart';
import 'package:stopwatch/app/routing/routes.dart';
import 'package:stopwatch/exceptions/view/app_error_widget.dart' show ErrorPage;
import 'package:stopwatch/features/profile/presentation/dummy_profile_page.dart';
import 'package:stopwatch/features/stopwatch/presentation/pages/stopwatch_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _stopwatchNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'stopwatchNavigatorKey',
);

final _profileNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'profileNavigatorKey',
);

GoRouter buildRouter() {
  final refreshStream = GoRouterRefreshStream([
    // Only for showcasing refresh listenable stream
    // ignore: deprecated_member_use_from_same_package
    FakeRouteRefreshStream.authStream,
    // Only for showcasing refresh listenable stream
    // ignore: deprecated_member_use_from_same_package
    FakeRouteRefreshStream.connectivityStream,
  ]);

  /// Page route for Stopwatch.
  final stopwatch = GoRoute(
    path: AppRoutes.stopwatch.path,
    pageBuilder: (context, state) => StopwatchPage.page(),
  );

  /// Profile page route.
  final profile = GoRoute(
    path: AppRoutes.profile.path,
    pageBuilder: (context, state) => DummyProfilePage.page(),
  );

  /// The main shell for the app.
  final appShell = StatefulShellRoute.indexedStack(
    pageBuilder: (context, state, navigationShell) =>
        ScaffoldWithNestedNavigation.page(
          key: GlobalKey(),
          navigationShell: navigationShell,
        ),
    branches: [
      StatefulShellBranch(
        navigatorKey: _stopwatchNavigatorKey,
        routes: [
          stopwatch,
        ],
      ),
      StatefulShellBranch(
        navigatorKey: _profileNavigatorKey,
        routes: [
          profile,
        ],
      ),
    ],
  );

  return GoRouter(
    initialLocation: AppRoutes.stopwatch.path,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: refreshStream,
    redirect: (context, state) async {
      // Implement redirections if applicable
      return null;
    },
    routes: [appShell],
    errorPageBuilder: (BuildContext context, GoRouterState state) =>
        ErrorPage.page(key: state.pageKey),
  );
}
