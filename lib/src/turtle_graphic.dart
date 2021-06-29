import 'dart:math' as math;
import 'dart:ui' show Offset, Path, PointMode;

import 'package:flutter/material.dart';
import 'package:flutter_fractal/flutter_fractal.dart';
import 'package:flutter_fractal/src/math.dart';

import 'math.dart';

extension PointEx on Offset {
  Offset rotate({
    Offset origin: Offset.zero,
    required double angle,
  }) {
    var t = Matrix4.identity()
      ..translate(-origin.dx, -origin.dy)
      ..rotateZ(toRad(angle))
      ..translate(origin.dx, origin.dy);
    return MatrixUtils.transformPoint(t, this);
  }
}

class TurtleGraphic extends Path {
  var _currentAngle = 0.0;
  var _currentPoint = Offset.zero;
  var _points = <Offset>[];

  get currentAngle => _currentAngle;

  @override
  void moveTo(double x, double y) {
    super.moveTo(x, y);
    _currentPoint = Offset(x, y);
    _points.add(_currentPoint);
  }

  void moveToPoint(Offset p) {
    moveTo(p.dx, p.dy);
  }

  @override
  void lineTo(double x, double y) {
    super.lineTo(x, y);
    moveTo(x, y);
  }

  @override
  void relativeLineTo(double dx, double dy) {
    super.relativeLineTo(dx, dy);
    moveTo(_currentPoint.dx + dx, _currentPoint.dy + dy);
  }

  void setAngle(double alpha) {
    _currentAngle = alpha * kDegToRad;
  }

  void turnRight(double alpha) {
    _currentAngle += alpha * kDegToRad;
  }

  void turnLeft(double alpha) {
    turnRight(-alpha);
  }

  void forward(double distance) {
    double dx = distance * math.cos(_currentAngle),
        dy = distance * math.sin(_currentAngle);
    moveTo(_currentPoint.dx + dx, _currentPoint.dy + dy);
  }

  void backward(double distance) {
    forward(-distance);
  }

  void lineForward(double distance) {
    double dx = distance * math.cos(_currentAngle),
        dy = distance * math.sin(_currentAngle);
    lineTo(_currentPoint.dx + dx, _currentPoint.dy + dy);
  }

  void lineBackward(double distance) {
    lineForward(-distance);
  }

  Offset get currentPoint => _currentPoint;

  List<Offset> get points => _points;

  Offset get center => getBounds().center;
}

extension TurtleGraphicsCollections on TurtleGraphic {
  void genC({
    required double a,
    int N: 4,
  }) {
    double aV2_2 = a * (math.sqrt(2) / 2);
    if (N > 1) {
      genC(a: aV2_2, N: N - 1);
      turnRight(90);
      genC(a: aV2_2, N: N - 1);
      turnRight(-90);
    } else {
      lineForward(a);
    }
  }

  void genDragon({
    required double a,
    int N: 5,
    double dir: 1,
  }) {
    double aV2_2 = a * (math.sqrt(2) / 2);
    if (N > 1) {
      turnRight((-45 * dir).toDouble());
      genDragon(a: aV2_2, N: N - 1, dir: 1);
      turnRight((90 * dir).toDouble());
      genDragon(a: aV2_2, N: N - 1, dir: -1);
      turnRight((-45 * dir).toDouble());
    } else {
      lineForward(a);
    }
  }

  void genKoch({
    required double a,
    int N: 4,
    required double alpha,
  }) {
    assert(alpha <= 60 && alpha >= -60);
    if (N > 1) {
      a /= 3;
      genKoch(a: a, N: N - 1, alpha: alpha);
      turnRight(-alpha);
      genKoch(a: a, N: N - 1, alpha: alpha);
      turnRight(alpha * 2);
      genKoch(a: a, N: N - 1, alpha: alpha);
      turnRight(-alpha);
      genKoch(a: a, N: N - 1, alpha: alpha);
    } else {
      lineForward(a);
    }
  }

  void genSierpinskiTriangle({
    required Offset p,
    required double a,
    required double theta,
    int N: 4,
  }) {
    if (N > 1) {
      a /= 2;
      double alpha = theta * kDegToRad;
      genSierpinskiTriangle(p: p, a: a, theta: theta, N: N - 1);
      var p2 = Offset(p.dx + (a * math.cos(math.pi / 3 + alpha)),
          p.dy - (a * math.sin(math.pi / 3 + alpha)));
      genSierpinskiTriangle(p: p2, a: a, theta: theta, N: N - 1);
      var p3 =
          Offset(p.dx + (a * math.cos(alpha)), p.dy - (a * math.sin(alpha)));
      genSierpinskiTriangle(p: p3, a: a, theta: theta, N: N - 1);
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

  void genTree2Branches({
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
      genTree2Branches(
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
      genTree2Branches(
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

  void genSpiral({
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

class TurtleGraphicsPainter extends CustomPainter {
  final TurtleGraphic path;
  final Paint brush;

  TurtleGraphicsPainter({
    required this.path,
    required this.brush,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    var center = size.center(Offset.zero);
    canvas.translate(center.dx - path.center.dx, center.dy - path.center.dy);
    canvas.drawPath(path, brush);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TurtleGraphicsPainter oldDelegate) {
    return path._points != oldDelegate.path._points;
  }
}
