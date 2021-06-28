import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_fractal/flutter_fractal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.black,
      ),
      routes: {
        RouteNames.turtle: (context) => TurtleGraphicDemo(),
        RouteNames.mandelbrot: (context) => MandelbrotDemo(),
      },
      home: HomePage(),
    );
  }
}

class RouteNames {
  static const turtle = 'turtle';
  static const mandelbrot = 'mandelbrot';
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.turtle);
              },
              child: Text('Turtle Graphic')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.mandelbrot);
              },
              child: Text('Mandelbrot Set')),
        ],
      ),
    );
  }
}

class MandelbrotDemo extends StatefulWidget {
  @override
  _MandelbrotDemoState createState() => _MandelbrotDemoState();
}

class _MandelbrotDemoState extends State<MandelbrotDemo> {
  MandelbrotPainter? mandelbrotPainter;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200), () {
      var size = MediaQuery.of(context).size;
      mandelbrotPainter =
          MandelbrotPainter(size.width.round(), size.height.round());
      int iterations = 20;
      for (var i = 0; i < iterations; ++i) {
        mandelbrotPainter!.update();
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mandelbrot'),
      ),
      body: mandelbrotPainter == null
          ? Container()
          : CustomPaint(
              painter: mandelbrotPainter,
              size: MediaQuery.of(context).size,
            ),
    );
  }
}

class TurtleGraphicDemo extends StatefulWidget {
  @override
  _TurtleGraphicDemoState createState() => _TurtleGraphicDemoState();
}

class _TurtleGraphicDemoState extends State<TurtleGraphicDemo> {
  late TurtleGraphic path;
  @override
  void initState() {
    create();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TurtleGraphicDemo oldWidget) {
    create();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('TurtleGraphic'),
      ),
      body: CustomPaint(
        painter: TurtleGraphicsPainter(
          path: path,
          painter: Paint()
            ..color = Colors.white
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..shader = ui.Gradient.radial(
              size.center(Offset.zero),
              size.width,
              [
                randomColor(),
                randomColor(),
                randomColor(),
                randomColor(),
              ],
              [0.0, 0.3, 0.6, 1.0],
            ),
        ),
        size: MediaQuery.of(context).size,
      ),
    );
  }

  void create() {
    path = TurtleGraphic();
    path
      ..turnRight(-90)
      ..genTree2Branches();
  }
}
