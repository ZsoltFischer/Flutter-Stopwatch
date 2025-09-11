import 'package:core/core.dart' show GoRouterRefreshStream;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:go_router/go_router.dart';
import 'package:stopwatch/app/presentation/widgets/scaffold_with_nested_navigation.dart';
import 'package:stopwatch/app/routing/fakes.dart';
import 'package:stopwatch/app/routing/routes.dart';
import 'package:stopwatch/exceptions/view/app_error_widget.dart' show ErrorPage;
import 'package:stopwatch/features/profile/presentation/dummy_profile_page.dart';
import 'package:stopwatch/features/stopwatch/presentation/pages/stopwatch_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _stopwatchNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'stopwatchNavigatorKey',
);

final _profileNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'historyNavigatorKey',
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

  return GoRouter(
    initialLocation: AppRoutes.stopwatch.path,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: refreshStream,
    redirect: (context, state) async {
      // Implement redirections if applicable
      return null;
    },
    routes: [
      AppGoRoutes.appShell,
    ],
    errorPageBuilder: (BuildContext context, GoRouterState state) =>
        ErrorPage.page(key: state.pageKey),
  );
}

class AppGoRoutes {
  /// Page route for Stopwatch.
  static final home = GoRoute(
    path: AppRoutes.stopwatch.path,
    pageBuilder: (context, state) => StopwatchPage.page(),
  );

  /// Profile page route. Not part of the main shell
  static final profile = GoRoute(
    path: AppRoutes.profile.path,
    pageBuilder: (context, state) => const CupertinoPage(
      child: DummyProfilePage(),
    ),
  );

  /// The main shell for the app.
  static final appShell = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return ScaffoldWithNestedNavigation(
        key: GlobalKey(),
        navigationShell: navigationShell,
      );
    },
    branches: [
      StatefulShellBranch(
        navigatorKey: _stopwatchNavigatorKey,
        routes: [
          home,
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
}
