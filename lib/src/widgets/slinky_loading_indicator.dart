import 'package:flutter/material.dart';

import '../graphics/index.dart';
import '../utils/index.dart';

/// Inspired by [Rainbow Slinky toy](https://en.wikipedia.org/wiki/Slinky)
class SlinkyLoadingIndicator extends StatefulWidget {
  final int colorCount;
  final int colorAlphaValue;
  final Curve curve;
  final Duration duration;
  final int circleCount;
  final double circleRadius;
  final double spiralRadius;
  final double startAngle;
  final double deltaAlpha;
  final double deltaSpiralRadius;

  /// Create a [SlinkyLoadingIndicator].
  ///
  /// [colorCount], [colorAlphaValue] : to create the rainbow color list, see [RomanticColor.rainbowColorList].
  ///
  ///  [curve], [duration] : to custom the animation.
  ///
  ///  [circleCount], [circleRadius], [spiralRadius], [startAngle], [deltaAlpha], [deltaSpiralRadius] : to draw a Spiral, see [TurtleGraphicsCollection.drawSpiralByRadius]. Try yourself changing these fields to create a new effect.
  const SlinkyLoadingIndicator({
    Key? key,
    this.colorCount: 30,
    this.colorAlphaValue: 255,
    this.curve: Curves.bounceIn,
    this.duration: const Duration(seconds: 2),
    this.circleCount: 30,
    this.circleRadius: 40,
    this.spiralRadius: 20,
    this.startAngle: -180,
    this.deltaAlpha: 0.2,
    this.deltaSpiralRadius: 1,
  }) : super(key: key);

  @override
  _SlinkyLoadingIndicatorState createState() => _SlinkyLoadingIndicatorState();
}

class _SlinkyLoadingIndicatorState extends State<SlinkyLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late List<Color> _colors;
  late AnimationController _controller;
  late CurveTween _curveTween;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addListener(() {
      setState(() {});
    });
    _init();
    super.initState();
  }

  void _init() {
    _colors = RomanticColor.rainbowColorList(
        widget.colorCount, widget.colorAlphaValue);
    _curveTween = CurveTween(curve: widget.curve);
    _controller.duration = widget.duration;
    _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(SlinkyLoadingIndicator oldWidget) {
    _init();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
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
    painter.turnRight(widget.startAngle);
    final acv = _curveTween.transform(_controller.value);
    int i = 0;
    painter.drawSpiralByRadius(
      radius: widget.spiralRadius,
      alpha: acv * 360 / widget.circleCount,
      count: widget.circleCount,
      deltaRadius: acv * widget.deltaSpiralRadius,
      deltaAlpha: acv * widget.deltaAlpha,
      drawDot: (canvas, size) {
        canvas.drawOval(
          Rect.fromCenter(
              center: painter.currentPoint,
              width: widget.circleRadius * 2,
              height: Tween<double>(begin: 1, end: 2).transform(acv) *
                  widget.circleRadius),
          Paint()
            ..color = _colors[i++]
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        if (i >= _colors.length) {
          i = 0;
        }
      },
      canvas: canvas,
      size: size,
    );
  }
}
