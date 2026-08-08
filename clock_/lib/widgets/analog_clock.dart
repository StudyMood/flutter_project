import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnalogClock extends StatelessWidget {
  final DateTime dateTime;
  final Color accentColor;
  final bool isDark;

  const AnalogClock({
    super.key,
    required this.dateTime,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: CustomPaint(
        painter: _AnalogClockPainter(
          dateTime: dateTime,
          accentColor: accentColor,
          isDark: isDark,
        ),
      ),
    );
  }
}

class _AnalogClockPainter extends CustomPainter {
  final DateTime dateTime;
  final Color accentColor;
  final bool isDark;

  _AnalogClockPainter({
    required this.dateTime,
    required this.accentColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    // 1. Outer Ambient Glow Ring
    final glowPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(center, radius, glowPaint);

    // 2. Glass Base Circle
    final bgPaint = Paint()
      ..color = isDark
          ? const Color(0x1F1E293B)
          : const Color(0xE6FFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Border Rim
    final borderPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, borderPaint);

    // 3. Dial Ticks & Markers
    for (int i = 0; i < 60; i++) {
      final angle = (i * 6) * math.pi / 180;
      final isHourTick = i % 5 == 0;
      final tickLength = isHourTick ? 14.0 : 6.0;

      final startPos = Offset(
        center.dx + (radius - 12) * math.cos(angle),
        center.dy + (radius - 12) * math.sin(angle),
      );
      final endPos = Offset(
        center.dx + (radius - 12 - tickLength) * math.cos(angle),
        center.dy + (radius - 12 - tickLength) * math.sin(angle),
      );

      final tickPaint = Paint()
        ..color = isHourTick
            ? (isDark ? Colors.white70 : Colors.black87)
            : (isDark ? Colors.white24 : Colors.black26)
        ..strokeWidth = isHourTick ? 2.5 : 1.2
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(startPos, endPos, tickPaint);
    }

    // 4. Dial Numbers (12, 3, 6, 9)
    final textStyle = TextStyle(
      color: isDark ? const Color(0xE6FFFFFF) : const Color(0xFF0F172A),
      fontSize: size.width * 0.08,
      fontWeight: FontWeight.bold,
    );

    final numPosMap = {
      '12': Offset(center.dx, center.dy - radius + 45),
      '3': Offset(center.dx + radius - 45, center.dy),
      '6': Offset(center.dx, center.dy + radius - 45),
      '9': Offset(center.dx - radius + 45, center.dy),
    };

    numPosMap.forEach((text, offset) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(offset.dx - tp.width / 2, offset.dy - tp.height / 2));
    });

    // Calculations for hands
    final seconds = dateTime.second + (dateTime.millisecond / 1000.0);
    final minutes = dateTime.minute + (seconds / 60.0);
    final hours = (dateTime.hour % 12) + (minutes / 60.0);

    final secondAngle = (seconds * 6 - 90) * math.pi / 180;
    final minuteAngle = (minutes * 6 - 90) * math.pi / 180;
    final hourAngle = (hours * 30 - 90) * math.pi / 180;

    // 5. Hour Hand
    final hourHandLength = radius * 0.50;
    final hourPaint = Paint()
      ..color = isDark ? Colors.white : const Color(0xFF0F172A)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      Offset(
        center.dx + hourHandLength * math.cos(hourAngle),
        center.dy + hourHandLength * math.sin(hourAngle),
      ),
      hourPaint,
    );

    // 6. Minute Hand
    final minuteHandLength = radius * 0.70;
    final minutePaint = Paint()
      ..color = isDark ? Colors.white70 : const Color(0xFF334155)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      Offset(
        center.dx + minuteHandLength * math.cos(minuteAngle),
        center.dy + minuteHandLength * math.sin(minuteAngle),
      ),
      minutePaint,
    );

    // 7. Second Hand (Glowing Accent Color)
    final secondHandLength = radius * 0.82;
    final secondPaint = Paint()
      ..color = accentColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final secondEnd = Offset(
      center.dx + secondHandLength * math.cos(secondAngle),
      center.dy + secondHandLength * math.sin(secondAngle),
    );
    canvas.drawLine(center, secondEnd, secondPaint);

    // 8. Center Pivot Dot
    final centerDotOuter = Paint()..color = accentColor;
    final centerDotInner = Paint()..color = isDark ? Colors.white : Colors.black;
    canvas.drawCircle(center, 7, centerDotOuter);
    canvas.drawCircle(center, 3, centerDotInner);
  }

  @override
  bool shouldRepaint(covariant _AnalogClockPainter oldDelegate) {
    return oldDelegate.dateTime != dateTime ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.isDark != isDark;
  }
}
