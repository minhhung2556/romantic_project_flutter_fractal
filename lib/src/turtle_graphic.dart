import 'dart:math' as math;
import 'dart:ui' show Offset, Path, PointMode;

import 'package:flutter/material.dart';
import 'package:flutter_fractal/flutter_fractal.dart';
import 'package:flutter_fractal/src/math.dart';

import 'math.dart';

/// What is [TurtleGraphic]? - [Wikipedia](https://en.wikipedia.org/wiki/Turtle_graphics)
/// This class is extended from [Path]. Easier to handle logic and re-use functions.
class TurtleGraphic extends Path {
  var _currentAngle = 0.0;
  var _currentPoint = Offset.zero;
  var _points = <Offset>[];

  /// Get current angle
  get currentAngle => _currentAngle;

  /// Move the [currentPoint] to a point [x],[y]
  @override
  void moveTo(double x, double y) {
    super.moveTo(x, y);
    _currentPoint = Offset(x, y);
    _points.add(_currentPoint);
  }

  /// Move the [currentPoint] to [p]
  void moveToPoint(Offset p) {
    moveTo(p.dx, p.dy);
  }

  /// Draw a line from the [currentPoint] to a point [x],[y]
  @override
  void lineTo(double x, double y) {
    super.lineTo(x, y);
    moveTo(x, y);
  }

  /// Draw a line from the [currentPoint] to a point that translated [dx],[dy] from the [currentPoint].
  @override
  void relativeLineTo(double dx, double dy) {
    super.relativeLineTo(dx, dy);
    moveTo(_currentPoint.dx + dx, _currentPoint.dy + dy);
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
  void lineForward(double distance) {
    double dx = distance * math.cos(_currentAngle),
        dy = distance * math.sin(_currentAngle);
    lineTo(_currentPoint.dx + dx, _currentPoint.dy + dy);
  }

  /// Draw a line that backward a [distance] by the [currentAngle], and then move the [currentPoint] to the end of line.
  void lineBackward(double distance) {
    lineForward(-distance);
  }

  /// Get the current point that Turtle is placed.
  Offset get currentPoint => _currentPoint;

  /// Get the list of points that Turtle was placed.
  List<Offset> get points => _points;

  /// Get the center of this path. See also [Path].
  Offset get center => getBounds().center;
}

/// The collection of some famous arts created by Turtle Graphic.
/// This is an extension of [TurtleGraphic].
/// You can you this template to make your own art.
extension TurtleGraphicsCollections on TurtleGraphic {
  /// Add a Lévy C curve. See [Wikipedia](https://en.wikipedia.org/wiki/L%C3%A9vy_C_curve)
  void addCCurve({
    required double a,
    int N: 4,
  }) {
    double aV2_2 = a * (math.sqrt(2) / 2);
    if (N > 1) {
      addCCurve(a: aV2_2, N: N - 1);
      turnRight(90);
      addCCurve(a: aV2_2, N: N - 1);
      turnRight(-90);
    } else {
      lineForward(a);
    }
  }

  /// Add a Dragon curve. See [Wikipedia](https://en.wikipedia.org/wiki/Dragon_curve)
  void addDragonCurve({
    required double a,
    int N: 5,
    double dir: 1,
  }) {
    double aV2_2 = a * (math.sqrt(2) / 2);
    if (N > 1) {
      turnRight((-45 * dir).toDouble());
      addDragonCurve(a: aV2_2, N: N - 1, dir: 1);
      turnRight((90 * dir).toDouble());
      addDragonCurve(a: aV2_2, N: N - 1, dir: -1);
      turnRight((-45 * dir).toDouble());
    } else {
      lineForward(a);
    }
  }

  /// Add a Koch snowflake curve. See [Wikipedia](https://en.wikipedia.org/wiki/Koch_snowflake)
  void addKochCurve({
    required double a,
    int N: 4,
    required double alpha,
  }) {
    assert(alpha <= 60 && alpha >= -60);
    if (N > 1) {
      a /= 3;
      addKochCurve(a: a, N: N - 1, alpha: alpha);
      turnRight(-alpha);
      addKochCurve(a: a, N: N - 1, alpha: alpha);
      turnRight(alpha * 2);
      addKochCurve(a: a, N: N - 1, alpha: alpha);
      turnRight(-alpha);
      addKochCurve(a: a, N: N - 1, alpha: alpha);
    } else {
      lineForward(a);
    }
  }

  /// Add a Sierpiński triangle. See [Wikipedia](https://en.wikipedia.org/wiki/Sierpi%C5%84ski_triangle)
  void addSierpinskiTriangle({
    required Offset p,
    required double a,
    required double theta,
    int N: 4,
  }) {
    if (N > 1) {
      a /= 2;
      double alpha = theta * kDegToRad;
      addSierpinskiTriangle(p: p, a: a, theta: theta, N: N - 1);
      var p2 = Offset(p.dx + (a * math.cos(math.pi / 3 + alpha)),
          p.dy - (a * math.sin(math.pi / 3 + alpha)));
      addSierpinskiTriangle(p: p2, a: a, theta: theta, N: N - 1);
      var p3 =
          Offset(p.dx + (a * math.cos(alpha)), p.dy - (a * math.sin(alpha)));
      addSierpinskiTriangle(p: p3, a: a, theta: theta, N: N - 1);
    } else {
      moveToPoint(p);
      setAngle(theta);
      lineForward(a);
      turnRight(-120);
      lineForward(a);
      turnRight(-120);
      lineForward(a);
      turnRight(-120);
    }
  }

  /// Add a L-system trees. See [Wikipedia](https://en.wikipedia.org/wiki/L-system)
  void addTree2Branches({
    double a: 20.0,
    double deltaA1: 1,
    double deltaA2: 1,
    int N: 7,
    double alpha1: 12,
    double deltaAlpha1: 1,
    double alpha2: 36,
    double deltaAlpha2: -12,
  }) {
    if (N > 1) {
      lineForward(a);
      turnRight(alpha1);
      var p = Offset(_currentPoint.dx, _currentPoint.dy);
      addTree2Branches(
          a: a + deltaA1,
          N: N - 1,
          alpha1: alpha1 + deltaA1,
          deltaA1: deltaA1,
          deltaA2: deltaA2,
          alpha2: alpha2 + deltaAlpha2,
          deltaAlpha1: deltaAlpha1,
          deltaAlpha2: deltaAlpha2);
      turnRight(-alpha1 - alpha2);
      moveToPoint(p);
      addTree2Branches(
          a: a + deltaA2,
          N: N - 1,
          alpha1: alpha2 + deltaA2,
          deltaA1: deltaA1,
          deltaA2: deltaA2,
          alpha2: alpha2 + deltaAlpha2,
          deltaAlpha1: deltaAlpha1,
          deltaAlpha2: deltaAlpha2);
      turnRight(alpha2);
    } else {
      lineForward(a);
    }
  }

  /// Add a Spiral that repeatedly draws a path by [builder]. See [Wikipedia](https://en.wikipedia.org/wiki/Spiral)
  void addSpiral({
    required double alpha,
    double deltaAlpha: 0,
    required double distance,
    double deltaDistance: 0,
    required int count,
    required Function(TurtleGraphic path) builder,
  }) {
    var da = alpha;
    var dr = distance;

    for (var i = 0; i < count; ++i) {
      forward(dr);
      builder(this);
      turnRight(da);
      da += deltaAlpha;
      dr += deltaDistance;
    }
  }
}

/// This is a [CustomPainter], used to draw the [TurtleGraphic] path.
class TurtleGraphicsPainter extends CustomPainter {
  /// [path]: the [Path] to draw by [Canvas]
  final TurtleGraphic path;

  /// [brush] : the [Paint] describes how to draw the [path].
  final Paint brush;

  /// Constructor
  TurtleGraphicsPainter({
    required this.path,
    required this.brush,
  });

  /// Painting method
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    var center = size.center(Offset.zero);
    canvas.translate(center.dx - path.center.dx, center.dy - path.center.dy);
    canvas.drawPath(path, brush);
    canvas.restore();
  }

  /// Should repaint if the current [TurtleGraphic.points] is different from the old points.
  @override
  bool shouldRepaint(covariant TurtleGraphicsPainter oldDelegate) {
    return path.points != oldDelegate.path.points;
  }
}
