import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stopwatch/app/presentation/widgets/scaffold_with_nested_navigation.dart'
    show GoBranch;
import 'package:utils/utils.dart';

class SideNavigationRail extends StatelessWidget {
  const SideNavigationRail({
    required this.goBranch,
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  final GoBranch goBranch;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      indicatorColor: CupertinoColors.activeBlue.withOpacity(0.3),
      selectedIndex: navigationShell.currentIndex,
      groupAlignment: -1,
      onDestinationSelected: goBranch,
      labelType: NavigationRailLabelType.all,
      destinations: <NavigationRailDestination>[
        NavigationRailDestination(
          icon: const Icon(CupertinoIcons.stopwatch),
          selectedIcon: const Icon(CupertinoIcons.stopwatch_fill),
          label: Text('Stopwatch'.hardcoded),
        ),
        NavigationRailDestination(
          icon: const Icon(CupertinoIcons.person),
          selectedIcon: const Icon(CupertinoIcons.person_solid),
          label: Text('Profile'.hardcoded),
        ),
      ],
    );
  }
}
