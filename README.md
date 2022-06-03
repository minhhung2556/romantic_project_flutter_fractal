# Flutter Fractal

A Flutter package to create a Fractal Art with multiple drawing types such as Turtle Graphic and Mathematics. It will be useful for your awesome app.
You can use this to create many of awesome artworks for your awesome apps. Such as: Loading indicator, Progressing indicator, Splash Screen, Button effects, ...

More from [Romantic Developer](https://pub.dev/publishers/romanticdeveloper.com/packages)

![Demo](./demo.gif)

### How to create your own art by using TurtleGraphicsPainter.
#### Define how to draw.
```dart
void _drawing(TurtleGraphicsPainter painter, Canvas canvas, Size size) {
  // Start at any point.
  painter.moveToPoint(size.center(Offset.zero));
  // Start turning by an angle, or you can use method setAngle.
  painter.turnRight(angle);
  // Use painter to draw somethings. See TurtleGraphicsCollection. 
  painter.drawSpiralByRadius(
    alpha: alpha,
    radius: spiralRadius,
    count: circleCount,
    deltaRadius: deltaSpiralRadius,
    deltaAlpha: deltaAlpha,
    drawDot: (canvas, size) {
      // Draw a point.
      painter.drawPoint(
          canvas, Paint()..color = Colors.white, painter.currentPoint, 1);
    },
    canvas: canvas,
    size: size,
  );
}

@override
Widget build(BuildContext context) {
  return CustomPaint(
    size: Size(w,h),
    painter: TurtleGraphicsPainter(
      onDrawing: _drawing,
    ),
  );
}
```

#### Find more in the widgets folder.
* ChakraLoadingIndicator
* SlinkyLoadingIndicator

### Development environment

```
[✓] Flutter (Channel stable, 3.0.1, on macOS 12.3.1 21E258 darwin-x64, locale en-VN)
    • Flutter version 3.0.1 at ~/fvm/versions/stable
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision fb57da5f94 (5 days ago), 2022-05-19 15:50:29 -0700
    • Engine revision caaafc5604
    • Dart version 2.17.1
    • DevTools version 2.12.2

[✓] Android toolchain - develop for Android devices (Android SDK version 30.0.3)
    • Android SDK at ~/Library/Android/sdk
    • Platform android-31, build-tools 30.0.3
    • ANDROID_HOME = ~/Library/Android/sdk
    • ANDROID_SDK_ROOT = ~/Library/Android/sdk
    • Java binary at: /Applications/Android Studio.app/Contents/jre/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 11.0.12+0-b1504.28-7817840)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 13.3.1)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • CocoaPods version 1.11.3

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2021.2)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 11.0.12+0-b1504.28-7817840)

[✓] VS Code (version 1.67.2)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.40.0
```