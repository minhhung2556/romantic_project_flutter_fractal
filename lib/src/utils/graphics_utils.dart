import 'dart:math' as math;
import 'dart:ui';

/// make a random color
Color randomColor([bool withAlpha = true, int minValue = 0]) {
  var ran = math.Random.secure();
  var a = math.max(
      minValue, math.min(255, minValue + (withAlpha ? ran.nextInt(255) : 255)));
  var g = math.max(minValue, math.min(255, minValue + ran.nextInt(255)));
  var b = math.max(minValue, math.min(255, minValue + ran.nextInt(255)));
  var r = math.max(minValue, math.min(255, minValue + ran.nextInt(255)));
  return Color.fromARGB(a, r, g, b);
}

List<Color> rainbowColorList(int size) {
  String _sinToHex(int i, double phase) {
    var sin = math.sin(math.pi / size * 2 * i + phase);
    var int = (sin * 127).floor() + 128;
    var hex = int.toRadixString(16);

    return hex.length == 1 ? "0" + hex : hex;
  }

  var rainbow = <Color>[];
  for (var i = 0; i < size; i++) {
    var red = _sinToHex(i, 0 * math.pi * 2 / 3); // 0   deg
    var blue = _sinToHex(i, 1 * math.pi * 2 / 3); // 120 deg
    var green = _sinToHex(i, 2 * math.pi * 2 / 3); // 240 deg
    rainbow.add(HexColor.fromHex('#FF' + red + green + blue));
  }

  return rainbow;
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
