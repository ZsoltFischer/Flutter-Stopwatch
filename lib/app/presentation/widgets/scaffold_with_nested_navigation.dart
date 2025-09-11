import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stopwatch/app/presentation/widgets/app_navigation_rail.dart';
import 'package:utils/utils.dart';

/// Creates a scaffold with nested navigation.
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('scaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

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
                    label: 'Todos'.hardcoded,
                    icon: const Icon(CupertinoIcons.calendar),
                  ),
                  BottomNavigationBarItem(
                    label: 'Statistics'.hardcoded,
                    icon: const Icon(Icons.fitness_center_outlined, weight: 10),
                  ),
                ],
              ),
              tabBuilder: (_, __) => TapRegion(
                child: navigationShell,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
            );
          }
          return Row(
            children: [
              AppNavigationRail(
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
