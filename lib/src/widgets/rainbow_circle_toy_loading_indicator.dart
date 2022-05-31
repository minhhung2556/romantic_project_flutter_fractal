import 'package:flutter/material.dart';
import 'package:flutter_fractal/flutter_fractal.dart';

class RainbowCircleToyLoadingIndicator extends StatefulWidget {
  final int colorCount;
  final Curve curve;
  final Duration duration;
  final int circleCount;
  final double circleRadius;
  final double spiralRadius;
  final bool isLoading;
  const RainbowCircleToyLoadingIndicator({
    Key? key,
    this.colorCount: 255,
    this.curve: Curves.easeInOutCirc,
    this.duration: const Duration(seconds: 3),
    this.circleCount: 120,
    this.circleRadius: 70,
    this.spiralRadius: 14,
    this.isLoading: true,
  }) : super(key: key);

  @override
  _RainbowCircleToyLoadingIndicatorState createState() =>
      _RainbowCircleToyLoadingIndicatorState();
}

class _RainbowCircleToyLoadingIndicatorState
    extends State<RainbowCircleToyLoadingIndicator>
    with TickerProviderStateMixin {
  late final List<Color> colors;
  late final AnimationController ac;
  late final CurveTween tween;

  @override
  void initState() {
    colors = rainbowColorList(80);
    tween = CurveTween(curve: widget.curve);
    ac = AnimationController(vsync: this, duration: widget.duration);
    ac.addListener(() {
      setState(() {});
    });

    if (widget.isLoading) {
      ac.repeat(reverse: true);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(RainbowCircleToyLoadingIndicator oldWidget) {
    if (widget.isLoading && !oldWidget.isLoading) {
      ac.repeat(reverse: true);
    } else if (!widget.isLoading && oldWidget.isLoading) {
      ac.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(widget.circleRadius + widget.spiralRadius),
      painter: TurtleGraphicsPainter(
        onDrawing: _drawing,
      ),
    );
  }

  void _drawing(TurtleGraphicsPainter painter, Canvas canvas, Size size) {
    painter.moveToPoint(size.center(Offset.zero));
    painter.turnRight(90);
    final acv = tween.transform(ac.value);
    int i = 0;
    painter.drawSpiralByRadius(
      radius: widget.spiralRadius,
      alpha: acv * 360 / widget.circleCount,
      count: widget.circleCount,
      deltaRadius: 0.1 - acv,
      drawDot: (canvas, size) {
        canvas.drawOval(
          Rect.fromCenter(
              center: painter.currentPoint,
              width: widget.circleRadius * 2,
              height: widget.circleRadius * 2),
          Paint()
            ..color = colors[i++]
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        if (i >= colors.length) {
          i = 0;
        }
      },
      canvas: canvas,
      size: size,
    );
  }
}
