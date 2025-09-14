import 'package:flutter/cupertino.dart';
import 'package:utils/utils.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

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
