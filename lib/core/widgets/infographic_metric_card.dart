import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/aura_colors.dart';
import '../theme/aura_typography.dart';
import 'glass_card.dart';

enum MetricType { wind, humidity, pressure, visibility }

/// Infographic-style metric card with visual representations
class InfographicMetricCard extends StatelessWidget {
  final MetricType type;
  final String value;
  final String label;
  final double? numericValue; // For visual calculations
  final Color? accentColor;

  const InfographicMetricCard({
    super.key,
    required this.type,
    required this.value,
    required this.label,
    this.numericValue,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? _getDefaultColor();

    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual representation
          SizedBox(
            height: 80,
            child: _buildVisual(color),
          ),
          const SizedBox(height: 16),
          // Value and label
          Text(
            value,
            style: AuraTypography.metricValue.copyWith(
              fontSize: 22,
              color: AuraColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AuraTypography.metricLabel.copyWith(
              fontSize: 12,
              color: AuraColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisual(Color color) {
    switch (type) {
      case MetricType.wind:
        return _WindVisual(color: color, intensity: numericValue ?? 0);
      case MetricType.humidity:
        return _HumidityVisual(color: color, percentage: numericValue ?? 0);
      case MetricType.pressure:
        return _PressureVisual(color: color, value: numericValue ?? 1013);
      case MetricType.visibility:
        return _VisibilityVisual(color: color, distance: numericValue ?? 10);
    }
  }

  Color _getDefaultColor() {
    switch (type) {
      case MetricType.wind:
        return AuraColors.skyBlue;
      case MetricType.humidity:
        return AuraColors.skyBlue;
      case MetricType.pressure:
        return AuraColors.twilightPurple;
      case MetricType.visibility:
        return AuraColors.twilightPurple;
    }
  }
}

/// Wind speed visual with flowing lines and arrow
class _WindVisual extends StatelessWidget {
  final Color color;
  final double intensity; // 0-100

  const _WindVisual({required this.color, required this.intensity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Flowing wind lines
        Positioned.fill(
          child: CustomPaint(
            painter: _WindLinesPainter(
              color: color.withOpacity(0.2),
              intensity: intensity,
            ),
          ),
        ),
        // Arrow icon
        Center(
          child: Transform.rotate(
            angle: math.pi / 4, // 45 degrees
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 40,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _WindLinesPainter extends CustomPainter {
  final Color color;
  final double intensity;

  _WindLinesPainter({required this.color, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw 3 flowing lines
    for (int i = 0; i < 3; i++) {
      final y = size.height * (0.3 + i * 0.2);
      final path = Path();
      path.moveTo(0, y);

      // Create wavy line
      for (double x = 0; x <= size.width; x += 5) {
        final wave = math.sin(x * 0.05 + i) * 3;
        path.lineTo(x, y + wave);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_WindLinesPainter oldDelegate) => false;
}

/// Humidity visual with water droplet and fill level
class _HumidityVisual extends StatelessWidget {
  final Color color;
  final double percentage; // 0-100

  const _HumidityVisual({required this.color, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 60,
        height: 80,
        child: CustomPaint(
          painter: _DropletPainter(
            color: color,
            fillPercentage: percentage / 100,
          ),
        ),
      ),
    );
  }
}

class _DropletPainter extends CustomPainter {
  final Color color;
  final double fillPercentage;

  _DropletPainter({required this.color, required this.fillPercentage});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final bottomY = size.height;

    // Create droplet shape
    final path = Path();
    path.moveTo(centerX, 0);

    // Right curve
    path.quadraticBezierTo(
      size.width, size.height * 0.4,
      size.width * 0.85, size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.75, bottomY,
      centerX, bottomY,
    );

    // Left curve
    path.quadraticBezierTo(
      size.width * 0.25, bottomY,
      size.width * 0.15, size.height * 0.7,
    );
    path.quadraticBezierTo(
      0, size.height * 0.4,
      centerX, 0,
    );
    path.close();

    // Draw outline
    final outlinePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(path, outlinePaint);

    // Draw fill
    if (fillPercentage > 0) {
      canvas.save();
      canvas.clipPath(path);

      final fillHeight = size.height * (1 - fillPercentage);
      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.6),
          ],
        ).createShader(Rect.fromLTWH(0, fillHeight, size.width, size.height));

      canvas.drawRect(
        Rect.fromLTWH(0, fillHeight, size.width, size.height),
        fillPaint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_DropletPainter oldDelegate) =>
      fillPercentage != oldDelegate.fillPercentage;
}

/// Pressure visual with gauge/barometer indicator
class _PressureVisual extends StatelessWidget {
  final Color color;
  final double value; // hPa value (typically 980-1050)

  const _PressureVisual({required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    // Normalize pressure to 0-1 (980-1050 range)
    final normalizedValue = ((value - 980) / 70).clamp(0.0, 1.0);

    return Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: CustomPaint(
          painter: _GaugePainter(
            color: color,
            value: normalizedValue,
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final Color color;
  final double value; // 0-1

  _GaugePainter({required this.color, required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Draw background arc
    final bgPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75, // Start angle
      math.pi * 1.5, // Sweep angle
      false,
      bgPaint,
    );

    // Draw value arc
    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5 * value,
      false,
      valuePaint,
    );

    // Draw needle
    final needleAngle = math.pi * 0.75 + (math.pi * 1.5 * value);
    final needleLength = radius - 10;
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw center dot
    canvas.drawCircle(center, 5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) => value != oldDelegate.value;
}

/// Visibility visual with distance indicator and fade effect
class _VisibilityVisual extends StatelessWidget {
  final Color color;
  final double distance; // km

  const _VisibilityVisual({required this.color, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fading circles representing visibility
        Center(
          child: SizedBox(
            width: 80,
            height: 80,
            child: CustomPaint(
              painter: _VisibilityCirclesPainter(
                color: color,
                distance: distance,
              ),
            ),
          ),
        ),
        // Eye icon in center
        Center(
          child: Icon(
            Icons.visibility_rounded,
            size: 32,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _VisibilityCirclesPainter extends CustomPainter {
  final Color color;
  final double distance;

  _VisibilityCirclesPainter({required this.color, required this.distance});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw 3 concentric circles with decreasing opacity
    for (int i = 1; i <= 3; i++) {
      final radius = (size.width / 2) * (i / 3);
      final opacity = 0.3 / i; // Fade out

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_VisibilityCirclesPainter oldDelegate) => false;
}
