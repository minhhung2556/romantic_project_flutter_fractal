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
      title: 'Romantic Developer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.black,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
  void didUpdateWidget(covariant HomePage oldWidget) {
    colors = List.generate(10, (index) => randomColor());
    create();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Romantic Developer'),
      ),
      backgroundColor: Colors.black,
      body: CustomPaint(
        painter: TurtleGraphicsPainter(
          path: path,
          brush: Paint()
            ..color = Colors.white
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..shader = ui.Gradient.radial(
              Offset.zero,
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
      ..addSpiral(
        alpha: 30,
        distance: Tween<double>(begin: 10, end: 30).transform(av),
        count: 12,
        builder: (path) {
          var a = 12.0;
          path.addSpiral(
            alpha: a,
            distance: Tween<double>(begin: 10, end: 40).transform(av),
            deltaDistance: 1,
            count: 360 ~/ a,
            deltaAlpha: 1,
            builder: (path) {
              path.addOval(Rect.fromCenter(
                center: path.currentPoint,
                width: Tween<double>(begin: 1, end: 5).transform(av),
                height: Tween<double>(begin: 1, end: 5).transform(av),
              ));
            },
          );
        },
      );
  }
}
