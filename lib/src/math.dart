import 'dart:math';

const kDegToRad = pi / 180.0;
const kRadToDeg = 180.0 / pi;
double abs(double a) => a < 0 ? -a : a;
double toRad(double degree) => degree * kDegToRad;
double toDegree(double radians) => radians * kRadToDeg;

double factorial(double x) {
  if (x < 3) {
    if (x < 2)
      return 1;
    else
      return 2;
  } else {
    double res = 1;
    for (double i = 2; i <= x; i++) {
      res *= i;
    }
    return res;
  }
}

const int _kSignMask = 0x80000000;
const double _kATanB = 0.596227;
double atan2(double x, double y) {
  // Extract the sign bits
  int uxS = _kSignMask & x.round();
  int uyS = _kSignMask & y.round();

  // Determine the quadrant offset
  double q = ((~uxS & uyS) >> 29 | uxS >> 30).toDouble();

  // Calculate the arc tangent in the first quadrant
  double bxyA = abs(_kATanB * x * y);
  double num = bxyA + y * y;
  double atan1Q = num / (x * x + bxyA + num);

// Translate it to the proper quadrant
  int uatan2Q = (uxS ^ uyS) | atan1Q.round();
  return q + uatan2Q.toDouble();
}
