import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stopwatch/app/presentation/widgets/side_navigation_rail.dart';
import 'package:utils/utils.dart';

typedef GoBranch = void Function(int)?;

/// Creates a scaffold with nested navigation.
class ScaffoldWithNestedNavigation extends StatelessWidget {
  /// Create a new [ScaffoldWithNestedNavigation] instance
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    super.key,
  });

  static Page<void> page({
    required Key key,
    required StatefulNavigationShell navigationShell,
  }) => CupertinoPage(
    child: ScaffoldWithNestedNavigation(
      key: key,
      navigationShell: navigationShell,
    ),
  );

  final StatefulNavigationShell navigationShell;

  /// Select the branch on [index] from the app shell route
  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.smallest.width <= Breakpoints.tablet) {
            return CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                currentIndex: navigationShell.currentIndex,
                onTap: _goBranch,
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
              tabBuilder: (_, _) => TapRegion(
                child: navigationShell,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
            );
          }
          return Row(
            children: [
              SideNavigationRail(
                navigationShell: navigationShell,
                goBranch: _goBranch,
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: navigationShell,
              ),
            ],
          );
        },
      ),
    );
  }
}
