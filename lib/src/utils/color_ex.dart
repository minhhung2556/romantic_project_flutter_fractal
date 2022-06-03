import 'dart:math' as math;

import 'package:flutter/material.dart';

/// [RomanticColor] is an extension of [Color]. It contains some utility functions for color.
extension RomanticColor on Color {
  /// Create a randomColor.
  static Color randomColor([bool withAlpha = true, int minValue = 0]) {
    final ran = math.Random.secure();
    var a = withAlpha ? minValue + ran.nextInt(255 - minValue) : 255;
    var g = minValue + ran.nextInt(255 - minValue);
    var b = minValue + ran.nextInt(255 - minValue);
    var r = minValue + ran.nextInt(255 - minValue);
    return Color.fromARGB(a, r, g, b);
  }

  static String _sinToHex(int i, double phase, int size) {
    var sin = math.sin(math.pi / size * 2 * i + phase);
    var int = (sin * 127).floor() + 128;
    var hex = int.toRadixString(16);

    return hex.length == 1 ? "0" + hex : hex;
  }

  /// Create a rainbow color list.
  ///
  /// [size] : number of colors.
  ///
  /// [alphaValue] : alpha value of each color.
  static List<Color> rainbowColorList(int size, [int alphaValue = 255]) {
    var alpha = alphaValue.toRadixString(16);
    var rainbow = <Color>[];
    var part = math.pi * 2 / 3;
    for (var i = 0; i < size; i++) {
      var red = _sinToHex(i, 0, size); // 0   deg
      var blue = _sinToHex(i, part, size); // 120 deg
      var green = _sinToHex(i, 2 * part, size); // 240 deg
      rainbow.add(fromHex('#$alpha' + red + green + blue));
    }

    return rainbow;
  }

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      print('RomanticColor.fromHex.error: $e');
      return Colors.transparent;
    }
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
