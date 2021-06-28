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

class TurtleGraphicDemo extends StatefulWidget {
  @override
  _TurtleGraphicDemoState createState() => _TurtleGraphicDemoState();
}

class _TurtleGraphicDemoState extends State<TurtleGraphicDemo>
    with SingleTickerProviderStateMixin {
  late TurtleGraphic path;
  late AnimationController controller;
  late List<Color> colors;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    controller.addListener(() {
      setState(() {
        create();
      });
    });
    controller.repeat(reverse: true);
    colors = List.generate(10, (index) => randomColor());
    create();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TurtleGraphicDemo oldWidget) {
    colors = List.generate(10, (index) => randomColor());
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
              this.colors.map((e) => e).skip(6).toList(),
              [0.0, 0.3, 0.6, 1.0],
            ),
        ),
        size: MediaQuery.of(context).size,
      ),
    );
  }

  void create() {
    var av = controller.value;
    path = TurtleGraphic()
      ..genSpiral(
        alpha: 36,
        distance: Tween<double>(begin: -30, end: 30).transform(av),
        count: 12,
        builder: (path) {
          var a = 12.0;
          path.genSpiral(
            alpha: a,
            distance: Tween<double>(begin: 0, end: 10).transform(av),
            count: 360 ~/ a,
            builder: (path) {
              path.addOval(Rect.fromCenter(
                center: path.currentPoint,
                width: Tween<double>(begin: 2, end: 5).transform(av),
                height: Tween<double>(begin: 2, end: 5).transform(av),
              ));
            },
          );
        },
      );
  }
}
