import 'package:flutter/widgets.dart';

/// Destination model for navigation
class AppNavigationDestination {
  const AppNavigationDestination({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final Widget icon;
  final Widget activeIcon;
  final String label;
}
