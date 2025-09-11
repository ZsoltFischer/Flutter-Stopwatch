import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A custom navigation bar widget for the app.
class MobilePageNavbar extends StatelessWidget {
  /// Creates an instance of [MobilePageNavbar].
  const MobilePageNavbar({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      heroTag: ValueKey(title),
      largeTitle: Text(title),
      border: Border.all(color: Colors.transparent),
    );
  }
}
