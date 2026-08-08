import 'dart:math';
import 'package:flutter/material.dart';
import '../models/carrom_models.dart';

class CarromBoardPainter extends CustomPainter {
  final List<CarromPiece> pieces;
  final List<Pocket> pockets;
  final CarromPiece striker;
  final Vector2D? aimDirection;
  final double aimPower; // 0.0 to 1.0
  final bool isAiming;
  final String activePlayerName;
  final Color activePlayerColor;

  // Virtual board dimension
  final double virtualBoardSize = 500.0;
  final double frameWidth = 35.0;

  CarromBoardPainter({
    required this.pieces,
    required this.pockets,
    required this.striker,
    this.aimDirection,
    this.aimPower = 0.0,
    this.isAiming = false,
    required this.activePlayerName,
    required this.activePlayerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double scale = size.width / virtualBoardSize;
    canvas.scale(scale, scale);

    // 1. Render Outer Wooden Frame
    _drawBoardFrame(canvas);

    // 2. Render Board Surface Markings
    _drawBoardMarkings(canvas);

    // 3. Render Corner Pockets
    _drawPockets(canvas);

    // 4. Render Aiming Guideline & Power Vector
    if (isAiming && aimDirection != null && aimDirection!.length > 0) {
      _drawAimLine(canvas);
    }

    // 5. Render All Active Coins & Striker
    _drawPieces(canvas);
  }

  void _drawBoardFrame(Canvas canvas) {
    // Outer Border (Dark Walnut Wood)
    RRect outerFrame = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, virtualBoardSize, virtualBoardSize),
      const Radius.circular(20),
    );
    Paint outerPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF2C1810), Color(0xFF4A2511), Color(0xFF1E0E07)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, virtualBoardSize, virtualBoardSize));

    canvas.drawRRect(outerFrame, outerPaint);

    // Inner Cushion Shadow
    Paint innerShadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 10);
    canvas.drawRect(
      Rect.fromLTWH(frameWidth, frameWidth, virtualBoardSize - 2 * frameWidth,
          virtualBoardSize - 2 * frameWidth),
      innerShadow,
    );

    // Playing Board Surface (Ivory / Natural Wood Polish)
    Paint boardSurface = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFF5E6), Color(0xFFFBE4C4), Color(0xFFF2D1A3)],
        radius: 0.8,
      ).createShader(Rect.fromLTWH(
          frameWidth, frameWidth, virtualBoardSize - 2 * frameWidth,
          virtualBoardSize - 2 * frameWidth));

    canvas.drawRect(
      Rect.fromLTWH(frameWidth, frameWidth, virtualBoardSize - 2 * frameWidth,
          virtualBoardSize - 2 * frameWidth),
      boardSurface,
    );

    // Corner Metallic Brass Rivets
    Paint rivetPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
      ).createShader(const Rect.fromLTWH(0, 0, 500, 500));

    double rivetOffset = 18;
    canvas.drawCircle(Offset(rivetOffset, rivetOffset), 6, rivetPaint);
    canvas.drawCircle(Offset(virtualBoardSize - rivetOffset, rivetOffset), 6, rivetPaint);
    canvas.drawCircle(Offset(rivetOffset, virtualBoardSize - rivetOffset), 6, rivetPaint);
    canvas.drawCircle(Offset(virtualBoardSize - rivetOffset, virtualBoardSize - rivetOffset), 6, rivetPaint);
  }

  void _drawBoardMarkings(Canvas canvas) {
    Offset center = const Offset(250, 250);

    Paint darkLine = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Paint redLine = Paint()
      ..color = const Color(0xFFC0392B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Paint redFill = Paint()
      ..color = const Color(0xFFC0392B)
      ..style = PaintingStyle.fill;

    // Center Queen Circle
    canvas.drawCircle(center, 38.0, darkLine);
    canvas.drawCircle(center, 12.0, redLine);
    canvas.drawCircle(center, 12.0, redFill..color = const Color(0xFFC0392B).withValues(alpha: 0.3));
    canvas.drawCircle(center, 4.0, Paint()..color = const Color(0xFFC0392B));

    // Decorative Center Rose Star Lines
    for (int i = 0; i < 12; i++) {
      double angle = i * (pi / 6);
      canvas.drawLine(
        Offset(center.dx + 12 * cos(angle), center.dy + 12 * sin(angle)),
        Offset(center.dx + 38 * cos(angle), center.dy + 38 * sin(angle)),
        Paint()..color = const Color(0xFF8B4513).withValues(alpha: 0.5)..strokeWidth = 1.0,
      );
    }

    // Outer Concentric Decorative Ring
    canvas.drawCircle(center, 110.0, Paint()..color = const Color(0xFF8B4513).withValues(alpha: 0.25)..style = PaintingStyle.stroke..strokeWidth = 1.2);

    // Baseline Striker Zones (4 Sides)
    double baseStart = 115.0;
    double baseEnd = 385.0;
    double circleRad = 10.0;

    // Bottom Baseline (Player 1)
    _drawStrikerBaseline(canvas, Offset(baseStart, 420), Offset(baseEnd, 420), circleRad, darkLine, redFill);
    // Top Baseline (Player 2 / AI)
    _drawStrikerBaseline(canvas, Offset(baseStart, 80), Offset(baseEnd, 80), circleRad, darkLine, redFill);
    // Left Baseline
    _drawStrikerBaseline(canvas, Offset(80, baseStart), Offset(80, baseEnd), circleRad, darkLine, redFill, isVertical: true);
    // Right Baseline
    _drawStrikerBaseline(canvas, Offset(420, baseStart), Offset(420, baseEnd), circleRad, darkLine, redFill, isVertical: true);

    // Corner Foul Lines (Connecting baselines to corner pockets)
    _drawCornerFoulLine(canvas, const Offset(80, 80), const Offset(45, 45));
    _drawCornerFoulLine(canvas, const Offset(420, 80), const Offset(455, 45));
    _drawCornerFoulLine(canvas, const Offset(80, 420), const Offset(45, 455));
    _drawCornerFoulLine(canvas, const Offset(420, 420), const Offset(455, 455));
  }

  void _drawStrikerBaseline(Canvas canvas, Offset p1, Offset p2, double r, Paint linePaint, Paint circleFill, {bool isVertical = false}) {
    Paint doubleLine = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    if (!isVertical) {
      canvas.drawLine(Offset(p1.dx, p1.dy - 6), Offset(p2.dx, p2.dy - 6), doubleLine);
      canvas.drawLine(Offset(p1.dx, p1.dy + 6), Offset(p2.dx, p2.dy + 6), doubleLine);

      // Endpoint Circles
      canvas.drawCircle(p1, r, doubleLine);
      canvas.drawCircle(p1, r - 3, Paint()..color = const Color(0xFFC0392B));
      canvas.drawCircle(p2, r, doubleLine);
      canvas.drawCircle(p2, r - 3, Paint()..color = const Color(0xFFC0392B));
    } else {
      canvas.drawLine(Offset(p1.dx - 6, p1.dy), Offset(p2.dx - 6, p2.dy), doubleLine);
      canvas.drawLine(Offset(p1.dx + 6, p1.dy), Offset(p2.dx + 6, p2.dy), doubleLine);

      // Endpoint Circles
      canvas.drawCircle(p1, r, doubleLine);
      canvas.drawCircle(p1, r - 3, Paint()..color = const Color(0xFFC0392B));
      canvas.drawCircle(p2, r, doubleLine);
      canvas.drawCircle(p2, r - 3, Paint()..color = const Color(0xFFC0392B));
    }
  }

  void _drawCornerFoulLine(Canvas canvas, Offset from, Offset to) {
    Paint foulPaint = Paint()
      ..color = const Color(0xFFC0392B).withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(from, to, foulPaint);
  }

  void _drawPockets(Canvas canvas) {
    for (var pocket in pockets) {
      Offset pos = Offset(pocket.position.x, pocket.position.y);

      // Deep Recessed Pocket Shadow & Hole
      Paint pocketBg = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.black,
            const Color(0xFF111111),
            Colors.black.withValues(alpha: 0.9),
          ],
        ).createShader(Rect.fromCircle(center: pos, radius: pocket.radius));

      canvas.drawCircle(pos, pocket.radius, pocketBg);

      // Outer Pocket Metallic White / Gold Rim
      Paint pocketRim = Paint()
        ..color = const Color(0xFFD4AF37)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      canvas.drawCircle(pos, pocket.radius + 1, pocketRim);

      // Pocket Net Mesh effect
      Paint netPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..strokeWidth = 1.0;

      canvas.drawCircle(pos, pocket.radius * 0.6, netPaint..style = PaintingStyle.stroke);
    }
  }

  void _drawAimLine(Canvas canvas) {
    Offset strikerPos = Offset(striker.position.x, striker.position.y);
    Vector2D normDir = aimDirection!.normalize();

    double aimLength = 120.0 * (0.3 + aimPower * 0.7);
    Offset targetOffset = Offset(
      strikerPos.dx + normDir.x * aimLength,
      strikerPos.dy + normDir.y * aimLength,
    );

    // Aim Line Gradient (Cyan/Gold)
    Paint linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          activePlayerColor.withValues(alpha: 0.9),
          Colors.amberAccent.withValues(alpha: 0.5),
        ],
      ).createShader(Rect.fromPoints(strikerPos, targetOffset))
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // Draw Dashed or Solid Aim Line
    double dashWidth = 8.0, dashSpace = 4.0;
    double startDist = 0.0;
    while (startDist < aimLength) {
      double endDist = min(startDist + dashWidth, aimLength);
      canvas.drawLine(
        Offset(strikerPos.dx + normDir.x * startDist, strikerPos.dy + normDir.y * startDist),
        Offset(strikerPos.dx + normDir.x * endDist, strikerPos.dy + normDir.y * endDist),
        linePaint,
      );
      startDist += dashWidth + dashSpace;
    }

    // Aim Target Arrow Head
    double arrowSize = 10.0;
    double angle = atan2(normDir.y, normDir.x);
    Path arrowPath = Path()
      ..moveTo(targetOffset.dx, targetOffset.dy)
      ..lineTo(
        targetOffset.dx - arrowSize * cos(angle - pi / 6),
        targetOffset.dy - arrowSize * sin(angle - pi / 6),
      )
      ..lineTo(
        targetOffset.dx - arrowSize * cos(angle + pi / 6),
        targetOffset.dy - arrowSize * sin(angle + pi / 6),
      )
      ..close();

    canvas.drawPath(arrowPath, Paint()..color = Colors.amberAccent);

    // Impact Prediction Circle
    canvas.drawCircle(
      targetOffset,
      striker.radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawPieces(Canvas canvas) {
    // Draw coins first, striker on top
    List<CarromPiece> sortedPieces = List.from(pieces);
    sortedPieces.sort((a, b) {
      if (a.type == PieceType.striker) return 1;
      if (b.type == PieceType.striker) return -1;
      return 0;
    });

    for (var piece in sortedPieces) {
      if (piece.isPocketed) continue;

      Offset pos = Offset(piece.position.x, piece.position.y);

      // Drop Shadow under piece
      canvas.drawCircle(
        Offset(pos.dx + 2, pos.dy + 3),
        piece.radius,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );

      // Base Circle
      Paint mainPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            piece.primaryColor,
            piece.secondaryColor,
          ],
          center: const Alignment(-0.3, -0.3),
        ).createShader(Rect.fromCircle(center: pos, radius: piece.radius));

      canvas.drawCircle(pos, piece.radius, mainPaint);

      // Distinctive Center Patterns per Piece Type
      if (piece.type == PieceType.queen) {
        // Gold Star emblem on Queen
        _drawStar(canvas, pos, 5, piece.radius * 0.55, piece.radius * 0.25, Colors.amber);
      } else if (piece.type == PieceType.white) {
        // Ivory Ring
        canvas.drawCircle(
          pos,
          piece.radius * 0.5,
          Paint()
            ..color = const Color(0xFF4A3B32)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      } else if (piece.type == PieceType.black) {
        // Ebony Silver Ring
        canvas.drawCircle(
          pos,
          piece.radius * 0.5,
          Paint()
            ..color = const Color(0xFFC0C0C0).withValues(alpha: 0.8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      } else if (piece.type == PieceType.striker) {
        // Striker Glowing Outer Ring & Pattern
        canvas.drawCircle(
          pos,
          piece.radius * 0.65,
          Paint()
            ..color = Colors.cyanAccent.withValues(alpha: 0.9)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0,
        );
        canvas.drawCircle(
          pos,
          piece.radius * 0.3,
          Paint()..color = Colors.cyanAccent,
        );
      }

      // Specular Highlight (Glossy Gloss Shine)
      canvas.drawCircle(
        Offset(pos.dx - piece.radius * 0.3, pos.dy - piece.radius * 0.3),
        piece.radius * 0.25,
        Paint()..color = Colors.white.withValues(alpha: 0.4),
      );
    }
  }

  void _drawStar(Canvas canvas, Offset center, int points, double outerRadius, double innerRadius, Color color) {
    Path path = Path();
    double angleStep = pi / points;

    for (int i = 0; i < 2 * points; i++) {
      double r = (i % 2 == 0) ? outerRadius : innerRadius;
      double a = i * angleStep - pi / 2;
      double x = center.dx + r * cos(a);
      double y = center.dy + r * sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CarromBoardPainter oldDelegate) => true;
}
