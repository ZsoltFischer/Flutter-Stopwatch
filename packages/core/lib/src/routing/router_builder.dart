// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:go_router/go_router.dart';

// /// Custom error builder for each applications that utilise [RouterBuilder]
// typedef GoRouterErrorBuilder = Widget Function(BuildContext, GoRouterState)?;

// /// Root navigator key for the app.
// final _rootNavigatorKey = GlobalKey<NavigatorState>();

// /// A builder for the [GoRouter] instance.
// class RouterBuilder {
//   /// Creates a new [RouterBuilder].
//   RouterBuilder({
//     required List<RouteBase> routes,
//     required GoRouterErrorBuilder errorBuilder,
//   }) : _routes = routes,
//        _errorBuilder = errorBuilder;

//   final List<RouteBase> _routes;

//   final GoRouterErrorBuilder _errorBuilder;

//   /// Builds the [GoRouter] instance form the provided routes.
//   GoRouter build() => GoRouter(
//     initialLocation: '/',
//     navigatorKey: _rootNavigatorKey,
//     debugLogDiagnostics: kDebugMode,
//     //!TODO: Implement authentication redirections if applicable
//     redirect: (context, state) async {
//       return null;
//     },
//     routes: _routes,
//     errorBuilder: _errorBuilder,
//   );
// }
