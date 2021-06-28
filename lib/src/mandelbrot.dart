import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'complex.dart';

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
