import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A custom navigation bar widget for the app.
class DefaultSliverAppbar extends StatelessWidget {
  /// Creates an instance of [DefaultSliverAppbar].
  const DefaultSliverAppbar({
    required String title,
    super.key,
  }) : _title = title;

  /// The title text displayed in the app bar.
  final String _title;

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      heroTag: ValueKey(_title),
      largeTitle: Text(_title),
      border: Border.all(color: Colors.transparent),
    );
  }
}
