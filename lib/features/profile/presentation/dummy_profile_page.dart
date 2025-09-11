import 'package:flutter/cupertino.dart';
import 'package:stopwatch/app/presentation/widgets.dart';

class DummyProfilePage extends StatelessWidget {
  const DummyProfilePage({super.key});

  static Page<void> page() => const CupertinoPage(
    child: DummyProfilePage(),
  );

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          MobilePageNavbar(title: 'Profile'),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Text(
                'This page was only created to have an extra route for NavigationBar / NavigationRail demo.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
