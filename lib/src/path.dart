import 'dart:math' as math;
import 'dart:ui' show Offset, Path, PointMode;

import 'package:flutter/material.dart';
import 'package:flutter_turtle_graphics/src/complex.dart';
import 'package:flutter_turtle_graphics/src/math.dart';

class TurtleGraphics extends Path {
  var _currentAngle = 0.0;
  var _currentPoint = Offset.zero;
  var _minX = 0.0;
  var _minY = 0.0;
  var _maxX = 0.0;
  var _maxY = 0.0;
  var _points = <Offset>[];

  @override
  void moveTo(double x, double y) {
    super.moveTo(x, y);
    _currentPoint = Offset(x, y);
    _points.add(_currentPoint);
    _findMinMax();
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

  void forward(double distance) {
    double dx = distance * math.cos(_currentAngle),
        dy = distance * math.sin(_currentAngle);
    moveTo(_currentPoint.dx + dx, _currentPoint.dy + dy);
  }

  void lineForward(double distance) {
    double dx = distance * math.cos(_currentAngle),
        dy = distance * math.sin(_currentAngle);
    lineTo(_currentPoint.dx + dx, _currentPoint.dy + dy);
  }

  void _findMinMax() {
    _minX = 0;
    _minY = 0;
    _maxX = 0;
    _maxY = 0;
    for (var o in _points) {
      _minX = math.min(o.dx, _minX);
      _minY = math.min(o.dy, _minY);
      _maxX = math.max(o.dx, _maxX);
      _maxY = math.max(o.dy, _maxY);
    }
  }
}

extension TurtleGraphicsCurve on TurtleGraphics {
  void genC(double a, int N) {
    double aV2_2 = a * (math.sqrt(2) / 2);
    if (N > 1) {
      genC(aV2_2, N - 1);
      turnRight(90);
      genC(aV2_2, N - 1);
      turnRight(-90);
    } else {
      lineForward(a);
    }
  }

  void genDragon(double a, int N, double dir) {
    double aV2_2 = a * (math.sqrt(2) / 2);
    if (N > 1) {
      turnRight((-45 * dir).toDouble());
      genDragon(aV2_2, N - 1, 1);
      turnRight((90 * dir).toDouble());
      genDragon(aV2_2, N - 1, -1);
      turnRight((-45 * dir).toDouble());
    } else {
      lineForward(a);
    }
  }

  void genKoch(double a, int N, double alpha) {
    assert(alpha <= 60 && alpha >= -60);
    if (N > 1) {
      a /= 3;
      genKoch(a, N - 1, alpha);
      turnRight(-alpha);
      genKoch(a, N - 1, alpha);
      turnRight(alpha * 2);
      genKoch(a, N - 1, alpha);
      turnRight(-alpha);
      genKoch(a, N - 1, alpha);
    } else {
      lineForward(a);
    }
  }

  void genSierpinskiTriangle(Offset p, double a, double theta, int N) {
    if (N > 1) {
      a /= 2;
      double alpha = theta * kDegToRad;
      genSierpinskiTriangle(p, a, theta, N - 1);
      var p2 = Offset(p.dx + (a * math.cos(math.pi / 3 + alpha)),
          p.dy - (a * math.sin(math.pi / 3 + alpha)));
      genSierpinskiTriangle(p2, a, theta, N - 1);
      var p3 =
          Offset(p.dx + (a * math.cos(alpha)), p.dy - (a * math.sin(alpha)));
      genSierpinskiTriangle(p3, a, theta, N - 1);
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

  void genSpiralLine(double alpha, double deltaAlpha, double distance,
      double deltaDistance, int count) {
    var da = alpha;
    var dd = distance;

    for (var i = 0; i < count; ++i) {
      lineForward(dd);
      turnRight(da);
      da += deltaAlpha;
      dd += deltaDistance;
    }
  }

  void genSpiralCircle({
    required double distance,
    required double deltaDistance,
    required double alpha,
    required double deltaAlpha,
    required double radius,
    required double deltaRadius,
    required int count,
  }) {
    var dd = distance;
    var da = alpha;
    var dr = radius;
    var center = Offset.zero;
    for (var i = 0; i < count; ++i) {
      forward(dd);
      addOval(Rect.fromCircle(center: _currentPoint, radius: dr));
      moveToPoint(center);
      turnRight(da);
      dd += deltaDistance;
      da += deltaAlpha;
      dr += deltaRadius;
    }
  }

  void genSpiralRRect({
    required double distance,
    required double deltaDistance,
    required double alpha,
    required double deltaAlpha,
    required Size size,
    required Offset deltaSize,
    required int count,
    required Radius borderRadius,
    required Offset deltaBorderRadius,
  }) {
    var dd = distance;
    var da = alpha;
    var ds = size;
    var center = Offset.zero;
    var br = borderRadius;
    for (var i = 0; i < count; ++i) {
      forward(dd);
      addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: _currentPoint, width: ds.width, height: ds.height),
          br));
      moveToPoint(center);
      turnRight(da);
      dd += deltaDistance;
      da += deltaAlpha;
      ds += deltaSize;
      br += Radius.elliptical(deltaBorderRadius.dx, deltaBorderRadius.dy);
    }
  }

  void genSpiralDragon(double a, int N, double dir, double alpha,
      double deltaAlpha, double distance, double deltaDistance, int count) {
    var da = alpha;
    var dd = distance;

    for (var i = 0; i < count; ++i) {
      forward(dd);
      genDragon(a, N, dir);
      turnRight(da);
      da += deltaAlpha;
      dd += deltaDistance;
    }
  }

  void genSpiralC(double a, int N, double alpha, double deltaAlpha,
      double distance, double deltaDistance, int count) {
    var da = alpha;
    var dd = distance;

    for (var i = 0; i < count; ++i) {
      forward(dd);
      genC(a, N);
      turnRight(da);
      da += deltaAlpha;
      dd += deltaDistance;
    }
  }

  void genSpiralKoch(double a, int N, double alpha0, double alpha,
      double deltaAlpha, double distance, double deltaDistance, int count) {
    var da = alpha;
    var dd = distance;

    for (var i = 0; i < count; ++i) {
      forward(dd);
      genKoch(a, N, alpha0);
      turnRight(da);
      da += deltaAlpha;
      dd += deltaDistance;
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
    required Function(TurtleGraphics path) builder,
  }) {
    var da = alpha;
    var dd = distance;

    for (var i = 0; i < count; ++i) {
      forward(dd);
      builder(this);
      turnRight(da);
      da += deltaAlpha;
      dd += deltaDistance;
    }
  }
}

class TurtleGraphicsPainter extends CustomPainter {
  final TurtleGraphics path;
  final Paint painter;

  TurtleGraphicsPainter({
    required this.path,
    required this.painter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    var center = size.center(Offset.zero);
    canvas.translate(center.dx - (path._maxX + path._minX) / 2,
        center.dy - (path._maxY + path._minY) / 2);
    canvas.drawPath(path, painter);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TurtleGraphicsPainter oldDelegate) {
    // debugPrint(
    //     'TurtleGraphicsPainter.shouldRepaint: minX=${path.minX},maxX=${path.maxX},minY=${path.minY},maxY=${path.maxY}');
    return path._points != oldDelegate.path._points;
  }
}

class MandelbrotPainter extends CustomPainter {
  late List<List<int>> _currentPixelIteration;
  late List<List<Complex>> C, z;
  int _currentIter = 0;
  int get currentIter => _currentIter;
  final int width;
  final int height;

  MandelbrotPainter(this.width, this.height) {
    double wratio = 1;
    double hratio = 1;

    final ratio = width / height;
    if (ratio < 1) {
      hratio = hratio / ratio;
    } else {
      wratio = ratio;
    }

    C = List<List<Complex>>.generate(
        height,
        (y) => List<Complex>.generate(
            width,
            (x) => Complex(wratio * (3.0 * x / width - 2.25),
                hratio * (3.0 * y / height - 1.5))));
    z = List<List<Complex>>.generate(
        height, (y) => List<Complex>.generate(width, (x) => Complex(0, 0)));
    _currentPixelIteration = List<List<int>>.generate(
        height, (y) => List<int>.generate(width, (x) => 0));
  }

  void update() {
    _currentIter += 1;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (z[y][x].abs() < 2) {
          z[y][x] = z[y][x] * z[y][x] + C[y][x];
          _currentPixelIteration[y][x] += 1;
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) async {
    // Define a paint object with 1 pixel stroke width
    final paint = Paint()
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke
        //
        ;
    int width = math.min(_currentPixelIteration[0].length, size.width.toInt());
    int height = math.min(_currentPixelIteration.length, size.height.toInt());

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        var iter = _currentPixelIteration[y][x] + 1;
        // Convert threshold iteration into an RBG value for pixel color
        paint.color = Color.fromRGBO(
            255 * (1 + math.cos(3.32 * math.log(iter))) ~/ 2,
            255 * (1 + math.cos(0.774 * math.log(iter))) ~/ 2,
            255 * (1 + math.cos(0.412 * math.log(iter))) ~/ 2,
            1);
        // Paint the pixel on canvas
        canvas.drawPoints(PointMode.points,
            <Offset>[Offset(x.toDouble(), y.toDouble())], paint);
      }
    }
  }

  @override
  bool shouldRepaint(MandelbrotPainter oldDelegate) => true;
}
