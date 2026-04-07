import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Calculates the angle (in degrees) formed at [p2] by the
/// line segments p1→p2 and p3→p2.
///
/// Example usage — knee angle:
///   getAngleBetweenThreePoints(hipOffset, kneeOffset, ankleOffset)
///
/// Returns a value in the range [0, 180] degrees.
double getAngleBetweenThreePoints(Offset p1, Offset p2, Offset p3) {
  final double radians =
      math.atan2(p3.dy - p2.dy, p3.dx - p2.dx) -
      math.atan2(p1.dy - p2.dy, p1.dx - p2.dx);

  double degrees = radians * (180.0 / math.pi);

  // Normalise to [0, 360)
  degrees = degrees % 360;
  if (degrees < 0) degrees += 360;

  // Fold into [0, 180] so the angle is always the interior angle
  if (degrees > 180) degrees = 360 - degrees;

  return degrees;
}
