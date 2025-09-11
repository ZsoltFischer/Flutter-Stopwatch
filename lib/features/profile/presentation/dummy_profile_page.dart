import 'package:flutter/cupertino.dart';

class DummyProfilePage extends StatelessWidget {
  const DummyProfilePage({super.key});

  static Page<void> page() => const CupertinoPage(
    child: DummyProfilePage(),
  );

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Profile'),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Text('Dummy Profile Page'),
            Text(
              'This page was only to have an extra route for NavigationBar / NavigationRail demo.',
            ),
          ],
        ),
      ),
    );
  }
}
