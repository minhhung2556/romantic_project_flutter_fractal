import 'package:flutter/material.dart';

import '../graphics/index.dart';
import '../utils/index.dart';

/// Inspired by [Chakra Pixel Led light](https://www.google.com/search?q=CHAKRA%20led%20light&tbm=isch&hl=en&tbs=rimg:CdelRn7SdgbUYbIxC7nDHHOc8AEAsgIMCgIIABABOgQIABAB&rlz=1C5CHFA_enVN942VN942&sa=X&ved=0CAIQrnZqFwoTCMC7pefxkPgCFQAAAAAdAAAAABAQ&biw=1792&bih=952)
class ChakraLoadingIndicator extends StatefulWidget {
  final int colorCount;
  final int colorAlphaValue;
  final Curve curve;
  final Duration duration;
  final int circleCount;
  final double circleRadius;
  final double spiralRadius;
  final double deltaAlpha;
  final double deltaSpiralRadius;

  /// Create a [ChakraLoadingIndicator].
  ///
  /// [colorCount], [colorAlphaValue] : to create the rainbow color list, see [RomanticColor.rainbowColorList].
  ///
  ///  [curve], [duration] : to custom the animation.
  ///
  ///  [circleCount], [circleRadius], [spiralRadius], [deltaAlpha], [deltaSpiralRadius] : to draw a Spiral, see [TurtleGraphicsCollection.drawSpiralByRadius]. Try yourself changing these fields to create a new effect.
  const ChakraLoadingIndicator({
    Key? key,
    this.colorCount: 30,
    this.colorAlphaValue: 255,
    this.curve: Curves.elasticInOut,
    this.duration: const Duration(seconds: 2),
    this.circleCount: 30,
    this.circleRadius: 40,
    this.spiralRadius: 20,
    this.deltaAlpha: 0.1,
    this.deltaSpiralRadius: 2,
  }) : super(key: key);

  @override
  _ChakraLoadingIndicatorState createState() => _ChakraLoadingIndicatorState();
}

class _ChakraLoadingIndicatorState extends State<ChakraLoadingIndicator>
    with SingleTickerProviderStateMixin {
  var rotating = 0.0;
  late List<Color> _colors;
  late AnimationController _controller;
  late CurveTween _tween;

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
    _tween = CurveTween(curve: widget.curve);
    _controller.duration = widget.duration;
    _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(ChakraLoadingIndicator oldWidget) {
    _init();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _drawing(TurtleGraphicsPainter painter, Canvas canvas, Size size) {
    painter.moveToPoint(size.center(Offset.zero));
    final acv = _tween.transform(_controller.value);
    final alpha = 360.0 / widget.circleCount;
    int i = 0;
    painter.turnRight(rotating++);
    if (rotating == 360) {
      rotating = 0.0;
    }
    painter.drawSpiralByRadius(
      alpha: alpha,
      radius: acv * widget.spiralRadius,
      count: widget.circleCount,
      deltaRadius: acv * widget.deltaSpiralRadius,
      deltaAlpha: acv * widget.deltaAlpha,
      drawDot: (canvas, size) {
        final alpha1 = 5.1;
        painter.drawSpiralByRadius(
          alpha: alpha1,
          radius: acv * widget.circleRadius,
          count: 360 ~/ alpha1,
          deltaAlpha: 1,
          deltaRadius: -1,
          drawDot: (canvas, size) {
            painter.drawPoint(
                canvas, Paint()..color = _colors[i++], painter.currentPoint, 1);
            if (i >= _colors.length) {
              i = 0;
            }
          },
          canvas: canvas,
          size: size,
        );
      },
      canvas: canvas,
      size: size,
    );
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
}
