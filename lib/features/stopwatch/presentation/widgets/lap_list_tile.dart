import 'package:flutter/cupertino.dart';
import 'package:stopwatch/features/stopwatch/presentation/models/lap_viewmodel.dart';
import 'package:utils/utils.dart';

/// A widget that represents a single lap entry in the lap list.
class LapListTile extends StatelessWidget {
  /// Creates a [LapListTile] widget.
  const LapListTile({
    required this.lap,
    super.key,
  });

  final LapViewModel lap;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text('Lap ${lap.index}'.hardcoded),
      trailing: Text(Duration(milliseconds: lap.lapTime).toDigitalClock()),
    );
  }
}
