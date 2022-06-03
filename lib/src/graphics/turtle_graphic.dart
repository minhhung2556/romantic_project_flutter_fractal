import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/index.dart';

part 'turtle_graphic_collection.dart';

/// [TurtleGraphicsPainter] is a [CustomPainter]. It helps in drawing some fractal art to create some romantic UI for your awesome applications.
/// It's based on Turtle Graphic, [Wikipedia](https://en.wikipedia.org/wiki/Turtle_graphics).
class TurtleGraphicsPainter extends CustomPainter {
  final Function(TurtleGraphicsPainter painter, Canvas canvas, Size size)
      onDrawing;

  var _currentAngle = 0.0;
  var _currentPoint = Offset.zero;
  Offset? _temporaryPoint;

  /// [onDrawing] draw your own art.
  TurtleGraphicsPainter({required this.onDrawing});

  /// Get current angle.
  get currentAngle => _currentAngle;

  /// Get current point.
  get currentPoint => _currentPoint;

  /// Move the [currentPoint] to a point [x],[y]
  void moveTo(double x, double y) {
    _currentPoint = Offset(x, y);
  }

  /// Move the [currentPoint] to [p]
  void moveToPoint(Offset p) {
    moveTo(p.dx, p.dy);
  }

  /// Draw a line from the [currentPoint] to a point [x],[y] by current [canvas] and a single or dynamic [paint].
  void drawLineTo(Canvas canvas, Paint paint, double x, double y) {
    canvas.drawLine(_currentPoint, Offset(x, y), paint);
    moveTo(x, y);
  }

  /// Draw a line from the [currentPoint] to a point that translated [dx],[dy] from the [currentPoint] by current [canvas] and a single or dynamic [paint].
  void drawRelativeLineTo(Canvas canvas, Paint paint, double dx, double dy) {
    drawLineTo(canvas, paint, _currentPoint.dx + dx, _currentPoint.dy + dy);
  }

  /// Set an [angle] in degree. Why do I use degree? because it's easy to read and understand, it helps you make art easier.
  void setAngle(double angle) {
    _currentAngle = angle * kDegToRad;
  }

  /// Turn the [currentAngle] right/clockwise an [angle] in degree.
  void turnRight(double angle) {
    _currentAngle += angle * kDegToRad;
  }

  /// Turn the [currentAngle] left/anticlockwise an [angle] in degree.
  void turnLeft(double alpha) {
    turnRight(-alpha);
  }

  /// Move the [currentPoint] to a point that forward a [distance] by the [currentAngle].
  void forward(double distance) {
    double dx = distance * math.cos(_currentAngle),
        dy = distance * math.sin(_currentAngle);
    moveTo(_currentPoint.dx + dx, _currentPoint.dy + dy);
  }

  /// Move the [currentPoint] to a point that backward a [distance] by the [currentAngle].
  void backward(double distance) {
    forward(-distance);
  }

  /// Draw a line that forward a [distance] by the [currentAngle], and then move the [currentPoint] to the end of line.
  void drawLineForward(Canvas canvas, Paint paint, double distance) {
    double dx = distance * math.cos(_currentAngle),
        dy = distance * math.sin(_currentAngle);
    drawLineTo(canvas, paint, _currentPoint.dx + dx, _currentPoint.dy + dy);
  }

  /// Draw a line that backward a [distance] by the [currentAngle], and then move the [currentPoint] to the end of line.
  void drawLineBackward(Canvas canvas, Paint paint, double distance) {
    drawLineForward(canvas, paint, -distance);
  }

  /// Point [currentPoint] to a point [x],[y] without saving.
  /// Then remember to call [resetTemporaryPoint] after using.
  void pointTo(double x, double y) {
    _temporaryPoint = Offset(_currentPoint.dx, _currentPoint.dy);
    _currentPoint = Offset(x, y);
  }

  /// Reset the [currentPoint] to the true current point before [pointTo].
  void resetTemporaryPoint() {
    if (_temporaryPoint != null) {
      _currentPoint = Offset(_temporaryPoint!.dx, _temporaryPoint!.dy);
      _temporaryPoint = null;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    onDrawing(this, canvas, size);
  }

  @override
  bool shouldRepaint(covariant TurtleGraphicsPainter oldDelegate) {
    return true;
  }

  /// Draw a point with your [size] by current [canvas] and a single or dynamic [paint].
  /// [p] is the point to draw.
  void drawPoint(Canvas canvas, Paint paint, Offset p, double size) {
    canvas.drawCircle(p, size, paint);
  }
}
