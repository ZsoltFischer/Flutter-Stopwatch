import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

/// A ChangeNotifier that listens to multiple streams and
/// calls notifyListeners() whenever any of them emit.
class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterRefreshStream] that listens to the provided [streams].
  GoRouterRefreshStream(Iterable<Stream<dynamic>> streams) {
    // Convert each incoming stream to Stream<void>
    final voidStreams = streams.map((s) => s.map((_) => null));

    _subscription = StreamGroup.merge(voidStreams).listen(
      (_) => notifyListeners(),
    );
  }

  late final StreamSubscription<void> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
