import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stopwatch/app/presentation/widgets/side_navigation_rail.dart';
import 'package:utils/utils.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    required StatefulNavigationShell navigationShell,
    super.key,
  }) : _navigationShell = navigationShell;

  static Page<void> page({
    required Key key,
    required StatefulNavigationShell navigationShell,
  }) => CupertinoPage(
    child: ScaffoldWithNestedNavigation(
      key: key,
      navigationShell: navigationShell,
    ),
  );

  final StatefulNavigationShell _navigationShell;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.smallest.width <= Breakpoints.tablet) {
            return CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                currentIndex: _navigationShell.currentIndex,
                onTap: (index) => _navigationShell.goBranch(
                  index,
                  initialLocation: index == _navigationShell.currentIndex,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(CupertinoIcons.stopwatch),
                    activeIcon: const Icon(CupertinoIcons.stopwatch_fill),
                    label: 'Stopwatch'.hardcoded,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(CupertinoIcons.person),
                    activeIcon: const Icon(CupertinoIcons.person_solid),
                    label: 'Profile'.hardcoded,
                  ),
                ],
              ),
              tabBuilder: (context, index) => TapRegion(
                child: _navigationShell,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
            );
          }
          return Row(
            children: [
              SideNavigationRail(
                navigationShell: _navigationShell,
                onBranchSelected: (index) => _navigationShell.goBranch(
                  index,
                  initialLocation: index == _navigationShell.currentIndex,
                ),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: _navigationShell),
            ],
          );
        },
      ),
    );
  }
}
