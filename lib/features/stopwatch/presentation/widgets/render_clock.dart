import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// The main StatefulWidget that manages the clock's state and animation.
class RenderClock extends StatefulWidget {
  const RenderClock({super.key});

  @override
  State<RenderClock> createState() => _RenderClockState();
}

class _RenderClockState extends State<RenderClock> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();

    // Use a Timer to update the clock once per second for efficiency.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A custom widget that holds the clock's render objects.
    // It takes a list of hands to be laid out and painted by the main clock render object.
    return CustomClockRender(
      time: _currentTime,
      children: const [
        // The hour hand is the shortest and thickest.
        ClockHand(lengthFactor: 0.5, thickness: 10, color: Colors.black87),
        // The minute hand is longer and thinner than the hour hand.
        ClockHand(lengthFactor: 0.7, thickness: 6, color: Colors.black87),
        // The second hand is the longest, thinnest, and a different color.
        ClockHand(lengthFactor: 0.9, thickness: 2, color: Colors.red),
      ],
    );
  }
}

// A MultiChildRenderObjectWidget that creates the main RenderClockFace.
// This is the bridge between the declarative Widget tree and the imperative RenderObject tree.
class CustomClockRender extends MultiChildRenderObjectWidget {
  const CustomClockRender({
    required this.time,
    required super.children,
    super.key,
  });
  final DateTime time;

  // Creates the main RenderObject for the clock face.
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderClockFace();
  }

  // Updates the RenderObject when the widget's properties change.
  @override
  void updateRenderObject(BuildContext context, RenderClockFace renderObject) {
    renderObject.time = time;
  }
}

// A simple LeafRenderObjectWidget for each clock hand.
// This widget creates the RenderClockHand object.
class ClockHand extends LeafRenderObjectWidget {
  const ClockHand({
    required this.lengthFactor,
    required this.thickness,
    required this.color,
    super.key,
  });
  final double lengthFactor;
  final double thickness;
  final Color color;

  // Creates the RenderObject for a single clock hand.
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderClockHand(
      lengthFactor: lengthFactor,
      thickness: thickness,
      color: color,
    );
  }

  // Updates the RenderObject properties when the widget rebuilds.
  @override
  void updateRenderObject(BuildContext context, RenderClockHand renderObject) {
    renderObject
      ..lengthFactor = lengthFactor
      ..thickness = thickness
      ..color = color;
  }
}

// The core RenderObject for a single clock hand.
// It is responsible for painting the hand itself.
class RenderClockHand extends RenderBox {
  RenderClockHand({
    required double lengthFactor,
    required double thickness,
    required Color color,
  }) : _lengthFactor = lengthFactor,
       _thickness = thickness,
       _color = color;

  // Private fields with getters and setters to trigger repaints.
  double get lengthFactor => _lengthFactor;
  double _lengthFactor;
  set lengthFactor(double value) {
    if (_lengthFactor == value) return;
    _lengthFactor = value;
    markNeedsPaint();
  }

  double get thickness => _thickness;
  double _thickness;
  set thickness(double value) {
    if (_thickness == value) return;
    _thickness = value;
    markNeedsPaint();
  }

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = Size(
      constraints.biggest.shortestSide,
      constraints.biggest.shortestSide,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final parentData = this.parentData! as ClockHandParentData;

    // Save the canvas state before applying transformations.
    canvas.save();

    // The hand is drawn from the center of its parent (the clock face).
    final center = size.center(offset);

    // Translate the canvas to the center of the clock.
    canvas
      ..translate(center.dx, center.dy)
      // Rotate the canvas by the calculated angle.
      // The angle is stored in the hand's parent data.
      ..rotate(parentData.angle);

    // The length of the hand is a fraction of the clock's shortest side.
    final handLength = size.shortestSide / 2.0 * lengthFactor;

    // Create the paint object for the hand.
    final handPaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickness;

    // Draw the hand as a line from the center outward.
    canvas
      ..drawLine(Offset.zero, Offset(0, -handLength), handPaint)
      // Restore the canvas state.
      ..restore();
  }
}

// A custom RenderBox that handles the layout and painting of the entire clock face.
// It manages its children (the clock hands).
class RenderClockFace extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, ClockHandParentData> {
  DateTime get time => _time;
  DateTime _time = DateTime.now();
  set time(DateTime value) {
    if (_time == value) return;
    _time = value;
    // Mark the object as needing a new layout and repaint.
    markNeedsLayout();
    markNeedsPaint();
  }

  // We don't need to specify a size; the parent will handle it.
  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    // The shortest side of the clock is its effective size.
    size = Size(
      constraints.biggest.shortestSide,
      constraints.biggest.shortestSide,
    );
  }

  // This is the missing method that Flutter was complaining about.
  // It ensures the child's parentData object is of the correct type.
  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! ClockHandParentData) {
      child.parentData = ClockHandParentData();
    }
  }

  // The performLayout method calculates the position and rotation of each child.
  @override
  void performLayout() {
    // Calculate the angles for the hands based on the current time.
    // We use a mix of seconds and milliseconds for smoother second hand movement.
    final second = time.second + time.millisecond / 1000.0;
    final minute = time.minute + second / 60.0;
    final hour = time.hour + minute / 60.0;

    final secondAngle = second * 2 * pi / 60;
    final minuteAngle = minute * 2 * pi / 60;
    final hourAngle = hour * 2 * pi / 12;

    // The clock hands are the children of this render object.
    var child = firstChild;
    while (child != null) {
      // Get the parent data for the child.
      final parentData = child.parentData! as ClockHandParentData;

      // Assign the correct angle to each hand based on its index.
      if (child == firstChild) {
        parentData.angle = hourAngle;
      } else if (child == childAfter(firstChild!)) {
        parentData.angle = minuteAngle;
      } else {
        parentData.angle = secondAngle;
      }

      // Lay out the child with the clock's constraints.
      child.layout(BoxConstraints.tight(size));

      // Move to the next child.
      child = childAfter(child);
    }
  }

  // The paint method draws the clock face and then paints the hands.
  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    // The center of the clock face.
    final center = size.center(offset);
    final shortestSide = size.shortestSide;

    // Draw the main clock circle.
    final facePaint = Paint()
      ..color = Colors.blueGrey.shade100
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, shortestSide / 2, facePaint);

    // Draw the clock border.
    final borderPaint = Paint()
      ..color = Colors.blueGrey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawCircle(center, shortestSide / 2, borderPaint);

    // Draw a small circle at the center.
    final centerDotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 10, centerDotPaint);

    // Draw the ticks.
    final tickPaint = Paint()
      ..color = Colors.blueGrey.shade800
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final hourTickPaint = Paint()
      ..color = Colors.blueGrey.shade800
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 60; i++) {
      final angle = i * 2 * pi / 60;
      final isHourTick = i % 5 == 0;
      final length = isHourTick ? shortestSide * 0.05 : shortestSide * 0.025;

      final startOffset = Offset(
        shortestSide / 2.0 * cos(angle),
        shortestSide / 2.0 * sin(angle),
      );
      final endOffset = Offset(
        (shortestSide / 2.0 - length) * cos(angle),
        (shortestSide / 2.0 - length) * sin(angle),
      );

      canvas.drawLine(
        center + startOffset,
        center + endOffset,
        isHourTick ? hourTickPaint : tickPaint,
      );
    }

    // The hands are children of this render object, so we paint them next.
    var child = firstChild;
    while (child != null) {
      // Paint each child (the hands). The child's own paint method handles its drawing.
      // The child's position is relative to its parent's origin, which is at `offset`.
      context.paintChild(child, offset);
      child = childAfter(child);
    }
  }
}

// A custom ParentData class to store the rotation angle for each hand.
class ClockHandParentData extends ContainerBoxParentData<RenderBox> {
  double angle = 0;
}
