import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class GaugeRoundedProgressBar extends Equatable implements GaugeProgressBar {
  final Color? color;
  final GaugeAxisGradient? gradient;
  final Shader? shader;
  @override
  final GaugeProgressPlacement placement;

  const GaugeRoundedProgressBar({
    this.color,
    this.gradient,
    this.shader,
    this.placement = GaugeProgressPlacement.over,
  }) : assert(
          color != null || gradient != null || shader != null,
          'color, gradient or shader is required',
        );

  @override
  void paint(
    GaugeAxis axis,
    RadialGaugeLayout layout,
    Canvas canvas,
    double progress,
  ) {
    final progressBar = calculateRoundedArcPath(
      layout.circleRect,
      to: progress,
      degrees: axis.degrees,
      thickness: axis.style.thickness + 2,
    );

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeJoin = StrokeJoin.miter;

    if (shader != null) {
      paint.shader = shader!;
    } else if (gradient != null) {
      const rotationDifference = 270;
      final degrees = axis.degrees.clamp(10.0, 360.0);
      final rotationAngle = toRadians(rotationDifference - degrees / 2);

      paint.shader = ui.Gradient.sweep(
        layout.circleRect.center,
        gradient!.colors,
        gradient!.colorStops,
        gradient!.tileMode,
        0.0,
        toRadians(axis.degrees),
        GradientRotation(rotationAngle).transform(layout.circleRect).storage,
      );
    } else if (color != null) {
      paint.color = color!;
    }

    canvas.drawPath(progressBar, paint);
  }

  @override
  List<Object?> get props => [color, gradient, shader, placement];
}
