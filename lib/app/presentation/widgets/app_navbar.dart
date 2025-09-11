import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stopwatch/app/routing/routes.dart';
import 'package:utils/utils.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      heroTag: 'todoPageHeroTag',
      largeTitle: const Text('Stopwatch'),
      leading: context.isMobile
          ? IconButton(
              icon: const Icon(CupertinoIcons.person),
              onPressed: () => GoRouter.of(context).go(
                AppRoutes.stopwatch.path,
              ),
            )
          : null,
      trailing: context.isMobile
          ? IconButton(
              icon: const Icon(CupertinoIcons.settings),
              onPressed: () => GoRouter.of(context).go(
                AppRoutes.profile.path,
              ),
            )
          : null,
      border: Border.all(color: Colors.transparent),
    );
  }
}
