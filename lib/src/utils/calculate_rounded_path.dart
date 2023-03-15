import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

Path calculateRoundedArcPath(
  Rect rect, {
  double from = 0.0,
  double to = 1.0,
  double degrees = 180.0,
  double thickness = 10.0,
}) {
  assert(from <= to, 'Cannot draw inverted arc.');

  final radius = rect.longestSide / 2;

  degrees = (degrees).clamp(10.0, 360.0);
  final part = to - from;
  final useDegrees = (degrees * part).clamp(10.0, 360.0);

  /// We are shifting arc angles to center it horizontally.
  final angleShift = (degrees - 180) / 2;
  final gaugeDegreesTween = Tween<double>(
    begin: -180.0 - angleShift,
    end: 0.0 + angleShift,
  );

  final circleCenter = rect.center;

  final halfThickness = thickness / 2;

  /// Can be helpful for multiple axes support.
  final startAngle = gaugeDegreesTween.transform(from);
  final endAngle = gaugeDegreesTween.transform(to);

  final innerRadius = radius - thickness;
  final centerRadius = radius - halfThickness;
  final outerRadius = radius;

  final cornerAngle = getArcAngle(halfThickness / 2 - 5, centerRadius);
  final largeArcMinAngle = 180.0 + toDegrees(cornerAngle * 2);

  final axisStartAngle = toRadians(startAngle) + cornerAngle;
  final axisEndAngle = toRadians(endAngle) - cornerAngle;

  final startOuterPoint =
      getPointOnCircle(circleCenter, axisStartAngle, outerRadius);
  final endOuterPoint =
      getPointOnCircle(circleCenter, axisEndAngle, outerRadius);
  final endInnerPoint =
      getPointOnCircle(circleCenter, axisEndAngle, innerRadius);
  final startInnerPoint =
      getPointOnCircle(circleCenter, axisStartAngle, innerRadius);
  final axisSurface = Path()
    ..moveTo(startOuterPoint.dx, startOuterPoint.dy)
    ..arcToPoint(
      endOuterPoint,
      largeArc: useDegrees > largeArcMinAngle,
      radius: Radius.circular(outerRadius),
    )
    ..arcToPoint(
      endInnerPoint,
      radius: Radius.zero,
    )
    ..arcToPoint(
      startInnerPoint,
      largeArc: useDegrees > largeArcMinAngle,
      radius: Radius.circular(innerRadius),
      clockwise: false,
    )
    ..arcToPoint(
      startOuterPoint,
      radius: Radius.zero,
    );

  return axisSurface;
}
