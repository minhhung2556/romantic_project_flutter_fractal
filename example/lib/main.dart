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
  List<TurtleGraphics>? paths;
  late AnimationController animationController;
  final kDirTween = Tween<double>(begin: -1, end: 1);
  final kAlphaTween = Tween<double>(begin: 0, end: 360);
  final kDeltaRadiusTween = Tween<double>(begin: -2, end: 2);
  late Color color, color1;
  late MandelbrotPainter mandelbrotPainter;
  @override
  void initState() {
    createColors();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    animationController.addListener(() {
      setState(() {
        createTurtle();
      });
    });
    animationController.repeat(reverse: true);

    mandelbrotPainter = MandelbrotPainter(200, 300);
    int iter = 120;
    for (var i = 0; i < iter; ++i) {
      mandelbrotPainter.update();
    }
    super.initState();
  }

  void createColors() {
    color = randomColor(false);
    color1 = randomColor(false);
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    createColors();
    super.didUpdateWidget(oldWidget);
  }

  void createTurtle() {
    var av = animationController.value;
    paths = [
      TurtleGraphics()..genC(20, 4),
      /*TurtleGraphics()
        ..genSpiral(
            alpha: 60,
            distance: 0,
            count: 6,
            builder: (TurtleGraphics path) {
              path.genTree2Branches(
                a: 20.0,
                deltaA1: av,
                deltaA2: av,
                N: 5,
                alpha1: Tween<double>(begin: -12, end: 12).transform(av),
                deltaAlpha1: Tween<double>(begin: -11, end: 11).transform(av),
                alpha2: Tween<double>(begin: -32, end: 32).transform(av),
                deltaAlpha2: Tween<double>(begin: -11, end: 11).transform(av),
              );
            }),*/
      /*TurtleGraphics()
        ..genSpiral(
            alpha: 60,
            distance: 50,
            count: 10,
            builder: (TurtleGraphics path) {
              path.genSpiralCircle(
                radius: Tween<double>(begin: -12, end: 12).transform(av),
                deltaRadius: av * 10,
                alpha: av,
                deltaAlpha: 0,
                distance: 5,
                deltaDistance: 10,
                count: 50,
              );
            }),*/
    ].reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var size = Size(screenSize.width / 2, screenSize.width / 2);
    var center = Offset.zero;
    // var center = size.center(Offset.zero);
    return Scaffold(
      backgroundColor: Colors.black,
      body: paths == null
          ? Container()
          :
          //
          /*Stack(
              children: paths!
                  .map((e) => Center(
                        child: CustomPaint(
                          painter: TurtleGraphicsPainter(
                            path: e,
                            painter: Paint()
                              ..color = Colors.white
                              ..strokeWidth = 2
                              ..style = PaintingStyle.stroke
                              ..strokeCap = StrokeCap.round
                              ..strokeJoin = StrokeJoin.round
                              ..shader = ui.Gradient.radial(
                                center,
                                size.width,
                                [color, color1, color, color1],
                                [0.0, 0.3, 0.6, 1.0],
                              ),
                          ),
                          size: size,
                        ),
                      ))
                  .toList(),
            ),*/
          Center(
              child: CustomPaint(
                painter: mandelbrotPainter,
                size: size,
              ),
            ),
    );
  }
}
