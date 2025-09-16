import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:utils/utils.dart';

class SideNavigationRail extends StatelessWidget {
  const SideNavigationRail({
    required this.onBranchSelected,
    required StatefulNavigationShell navigationShell,
    super.key,
  }) : _navigationShell = navigationShell;

  final StatefulNavigationShell _navigationShell;
  final ValueChanged<int> onBranchSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      indicatorColor: CupertinoColors.activeBlue.withOpacity(0.3),
      selectedIndex: _navigationShell.currentIndex,
      groupAlignment: -1,
      onDestinationSelected: onBranchSelected,
      labelType: NavigationRailLabelType.all,
      destinations: [
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
