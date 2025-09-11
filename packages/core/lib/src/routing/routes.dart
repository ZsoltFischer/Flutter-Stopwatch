import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:utils/utils.dart';

/// All the supported routes in the app.
/// By using an enum, we route by name using this syntax:
/// ```dart
/// context.goNamed(CommonRoutes.authentication.path)
/// ```
enum CommonRoutes {
  /// The authentication route.
  auth(path: '/authentication');

  const CommonRoutes({required this.path});

  /// The route path
  final String path;
}

/// General routes applicable to all company apps.
class CommonGoRoutes {
  /// The splash screen route.
  static final authentication = GoRoute(
    path: CommonRoutes.auth.path,
    pageBuilder: (context, state) => CupertinoPage(
      //!TODO: Implement the authentication in a separate package
      child: Center(
        child: Text('Auth page'.hardcoded),
      ),
    ),
  );
}
