import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

Color randomColor([bool withAlpha = true]) {
  var ran = math.Random.secure();
  var a = withAlpha ? ran.nextInt(255) : 255;
  var g = ran.nextInt(255);
  var b = ran.nextInt(255);
  var r = ran.nextInt(255);
  return Color.fromARGB(a, r, g, b);
}

extension ColorEx on Color {
  /// build a color darker from its origin.
  get darker => Color.alphaBlend(this.withOpacity(0.5), Colors.black);
}
