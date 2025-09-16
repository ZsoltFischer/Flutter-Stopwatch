import 'package:flutter/cupertino.dart';
import 'package:utils/utils.dart';

/// A simple error page displayed when an error occurs.
class ErrorPage extends StatelessWidget {
  /// Creates an [ErrorPage] widget.
  const ErrorPage({super.key});

  /// Returns a [Page] for navigation purposes.
  static Page<void> page({Key? key}) => CupertinoPage(
    child: ErrorPage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Text('An error occurred while loading this page.'.hardcoded),
      ),
    );
  }
}
