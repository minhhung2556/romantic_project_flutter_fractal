part of 'turtle_graphic.dart';

/// The collection of some famous arts created by Turtle Graphic.
/// This is an extension of [TurtleGraphicsPainter].
/// You can use this template to make your own art.
extension TurtleGraphicsCollection on TurtleGraphicsPainter {
  /// Draw a [Spiral](https://en.wikipedia.org/wiki/Spiral).
  ///
  /// [drawDot] : draw a dot by current [canvas] and [size] of this [CustomPaint].
  void drawSpiralByRadius({
    required Canvas canvas,
    required Size size,
    required double alpha,
    double deltaAlpha: 0,
    required double radius,
    double deltaRadius: 0,
    required int count,
    required Function(Canvas canvas, Size size) drawDot,
  }) {
    var da = alpha;
    var dr = radius;
    final startPoint = Offset(_currentPoint.dx, _currentPoint.dy);
    for (var i = 0; i < count; ++i) {
      forward(dr);
      drawDot(canvas, size);
      turnRight(da);
      pointTo(startPoint.dx, startPoint.dy);
      da += deltaAlpha;
      dr += deltaRadius;
    }
  }

  /// Add a Lévy C curve. See [Wikipedia](https://en.wikipedia.org/wiki/L%C3%A9vy_C_curve)
  void drawCCurve({
    required double a,
    int N: 4,
    required Canvas canvas,
    required Size size,
    required Function(
            TurtleGraphicsPainter painter, Canvas canvas, Size size, double a)
        lineForward,
  }) {
    double aV2_2 = a * (math.sqrt(2) / 2);
    if (N > 1) {
      drawCCurve(
        a: aV2_2,
        N: N - 1,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
      turnRight(90);
      drawCCurve(
        a: aV2_2,
        N: N - 1,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
      turnRight(-90);
    } else {
      lineForward(this, canvas, size, a);
    }
  }

  /// Add a Dragon curve. See [Wikipedia](https://en.wikipedia.org/wiki/Dragon_curve)
  void drawDragonCurve({
    required double a,
    int N: 5,
    double dir: 1,
    required Canvas canvas,
    required Size size,
    required Function(
            TurtleGraphicsPainter painter, Canvas canvas, Size size, double a)
        lineForward,
  }) {
    double aV2_2 = a * (math.sqrt(2) / 2);
    if (N > 1) {
      turnRight((-45 * dir).toDouble());
      drawDragonCurve(
        a: aV2_2,
        N: N - 1,
        dir: 1,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
      turnRight((90 * dir).toDouble());
      drawDragonCurve(
        a: aV2_2,
        N: N - 1,
        dir: -1,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
      turnRight((-45 * dir).toDouble());
    } else {
      lineForward(this, canvas, size, a);
    }
  }

  /// Add a Koch snowflake curve. See [Wikipedia](https://en.wikipedia.org/wiki/Koch_snowflake)
  void drawKochCurve({
    required double a,
    int N: 4,
    required double alpha,
    required Canvas canvas,
    required Size size,
    required Function(
            TurtleGraphicsPainter painter, Canvas canvas, Size size, double a)
        lineForward,
  }) {
    assert(alpha <= 60 && alpha >= -60);
    if (N > 1) {
      a /= 3;
      drawKochCurve(
        a: a,
        N: N - 1,
        alpha: alpha,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
      turnRight(-alpha);
      drawKochCurve(
        a: a,
        N: N - 1,
        alpha: alpha,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
      turnRight(alpha * 2);
      drawKochCurve(
        a: a,
        N: N - 1,
        alpha: alpha,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
      turnRight(-alpha);
      drawKochCurve(
        a: a,
        N: N - 1,
        alpha: alpha,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
    } else {
      lineForward(this, canvas, size, a);
    }
  }

  /// Add a Sierpiński triangle. See [Wikipedia](https://en.wikipedia.org/wiki/Sierpi%C5%84ski_triangle)
  void drawSierpinskiTriangle({
    required Offset p,
    required double a,
    required double theta,
    int N: 4,
    required Canvas canvas,
    required Size size,
    required Function(
            TurtleGraphicsPainter painter, Canvas canvas, Size size, double a)
        lineForward,
  }) {
    if (N > 1) {
      a /= 2;
      double alpha = theta * kDegToRad;
      drawSierpinskiTriangle(
        p: p,
        a: a,
        theta: theta,
        N: N - 1,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
      var p2 = Offset(p.dx + (a * math.cos(math.pi / 3 + alpha)),
          p.dy - (a * math.sin(math.pi / 3 + alpha)));
      drawSierpinskiTriangle(
        p: p2,
        a: a,
        theta: theta,
        N: N - 1,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
      var p3 =
          Offset(p.dx + (a * math.cos(alpha)), p.dy - (a * math.sin(alpha)));
      drawSierpinskiTriangle(
        p: p3,
        a: a,
        theta: theta,
        N: N - 1,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
    } else {
      moveToPoint(p);
      setAngle(theta);
      lineForward(this, canvas, size, a);
      turnRight(-120);
      lineForward(this, canvas, size, a);
      turnRight(-120);
      lineForward(this, canvas, size, a);
      turnRight(-120);
    }
  }

  /// Add a L-system trees. See [Wikipedia](https://en.wikipedia.org/wiki/L-system)
  void drawTree2Branches({
    double a: 20.0,
    double deltaA1: 1,
    double deltaA2: 1,
    int N: 7,
    double alpha1: 12,
    double deltaAlpha1: 1,
    double alpha2: 36,
    double deltaAlpha2: -12,
    required Canvas canvas,
    required Size size,
    required Function(
            TurtleGraphicsPainter painter, Canvas canvas, Size size, double a)
        lineForward,
  }) {
    if (N > 1) {
      lineForward(this, canvas, size, a);
      turnRight(alpha1);
      var p = Offset(_currentPoint.dx, _currentPoint.dy);
      drawTree2Branches(
        a: a + deltaA1,
        N: N - 1,
        alpha1: alpha1 + deltaA1,
        deltaA1: deltaA1,
        deltaA2: deltaA2,
        alpha2: alpha2 + deltaAlpha2,
        deltaAlpha1: deltaAlpha1,
        deltaAlpha2: deltaAlpha2,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
      turnRight(-alpha1 - alpha2);
      moveToPoint(p);
      drawTree2Branches(
        a: a + deltaA2,
        N: N - 1,
        alpha1: alpha2 + deltaA2,
        deltaA1: deltaA1,
        deltaA2: deltaA2,
        alpha2: alpha2 + deltaAlpha2,
        deltaAlpha1: deltaAlpha1,
        deltaAlpha2: deltaAlpha2,
        canvas: canvas,
        size: size,
        lineForward: lineForward,
      );
      turnRight(alpha2);
    } else {
      lineForward(this, canvas, size, a);
    }
  }
}
