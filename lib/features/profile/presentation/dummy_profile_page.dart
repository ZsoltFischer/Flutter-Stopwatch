import 'package:flutter/cupertino.dart';
import 'package:stopwatch/app/presentation/widgets/default_sliver_appbar.dart';
import 'package:utils/utils.dart';

class DummyProfilePage extends StatelessWidget {
  const DummyProfilePage({super.key});

  static Page<void> page() => const CupertinoPage(
    child: DummyProfilePage(),
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          DefaultSliverAppbar(title: 'Profile'.hardcoded),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Text(
                // Long text
                // ignore: lines_longer_than_80_chars
                'This page was only created to have an extra route for demonstrating responsivity and navigation.'
                    .hardcoded,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
