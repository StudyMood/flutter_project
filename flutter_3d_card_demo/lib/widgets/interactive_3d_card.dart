import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Interactive3DCard widget - Teaches 3D perspective transformation,
/// gesture tracking, physics snap-back, and dynamic light reflection.
class Interactive3DCard extends StatefulWidget {
  final double maxTiltAngle; // Max tilt rotation in radians (~0.45 rad = 25 degrees)
  final double perspective;  // Matrix perspective value (0.001 gives realistic 3D depth)
  final double lightIntensity;
  final Widget? child;

  const Interactive3DCard({
    super.key,
    this.maxTiltAngle = 0.45,
    this.perspective = 0.001,
    this.lightIntensity = 0.5,
    this.child,
  });

  @override
  State<Interactive3DCard> createState() => _Interactive3DCardState();
}

class _Interactive3DCardState extends State<Interactive3DCard>
    with SingleTickerProviderStateMixin {
  // Normalized touch position from center: (-1.0, -1.0) top-left to (1.0, 1.0) bottom-right
  Offset _touchPosition = Offset.zero;

  // Animation controller & physics tween for returning to zero on release
  late AnimationController _resetController;
  late Animation<Offset> _resetAnimation;

  bool _isHoveredOrTouched = false;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _resetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _resetController,
        curve: Curves.elasticOut, // Elastic spring return effect!
      ),
    )..addListener(() {
        setState(() {
          _touchPosition = _resetAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  /// Updates touch coordinates relative to card center [-1.0, 1.0]
  void _updateTouchPosition(Offset localPosition, Size size) {
    if (size.width == 0 || size.height == 0) return;

    // Calculate center relative offset
    final double normalizedX = (localPosition.dx / size.width) * 2 - 1.0;
    final double normalizedY = (localPosition.dy / size.height) * 2 - 1.0;

    setState(() {
      _touchPosition = Offset(
        normalizedX.clamp(-1.0, 1.0),
        normalizedY.clamp(-1.0, 1.0),
      );
      _isHoveredOrTouched = true;
    });
  }

  /// Smoothly animates card back to rest (0, 0) position with spring curve
  void _resetPosition() {
    _resetAnimation = Tween<Offset>(
      begin: _touchPosition,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _resetController,
        curve: Curves.elasticOut,
      ),
    );
    _resetController.forward(from: 0.0);
    setState(() {
      _isHoveredOrTouched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardSize = Size(constraints.maxWidth, constraints.maxHeight);

        // --- MATH EXPLANATION ---
        // 1. rotateX is driven by Y drag (tilting top/bottom). Dragging DOWN rotates around X-axis.
        // 2. rotateY is driven by X drag (tilting left/right). Dragging RIGHT rotates around Y-axis.
        final double rotateX = -_touchPosition.dy * widget.maxTiltAngle;
        final double rotateY = _touchPosition.dx * widget.maxTiltAngle;

        // Perspective Matrix construction:
        // entry(3,2) represents the perspective projection factor (z-axis distortion).
        final Matrix4 transformMatrix = Matrix4.identity()
          ..setEntry(3, 2, widget.perspective)
          ..rotateX(rotateX)
          ..rotateY(rotateY);

        // Light reflection angle calculation:
        // Angle of light changes smoothly based on card inclination
        final double lightAngle = atan2(_touchPosition.dy, _touchPosition.dx);
        final double lightDistance = _touchPosition.distance.clamp(0.0, 1.0);

        return GestureDetector(
          onPanStart: (details) {
            _resetController.stop();
            _updateTouchPosition(details.localPosition, cardSize);
          },
          onPanUpdate: (details) {
            _updateTouchPosition(details.localPosition, cardSize);
          },
          onPanEnd: (_) => _resetPosition(),
          onPanCancel: () => _resetPosition(),
          child: MouseRegion(
            onHover: (event) {
              _resetController.stop();
              _updateTouchPosition(event.localPosition, cardSize);
            },
            onExit: (_) => _resetPosition(),
            child: AnimatedScale(
              scale: _isHoveredOrTouched ? 1.04 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: Transform(
                transform: transformMatrix,
                alignment: FractionalOffset.center,
                child: Container(
                  width: cardSize.width,
                  height: cardSize.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      // Dynamic shadow that shifts opposite to the tilt direction
                      BoxShadow(
                        color: Colors.cyanAccent.withValues(
                          alpha: _isHoveredOrTouched ? 0.35 : 0.15,
                        ),
                        blurRadius: _isHoveredOrTouched ? 30 : 15,
                        spreadRadius: _isHoveredOrTouched ? 2 : 0,
                        offset: Offset(
                          -_touchPosition.dx * 20,
                          -_touchPosition.dy * 20 + 10,
                        ),
                      ),
                      BoxShadow(
                        color: Colors.purpleAccent.withValues(
                          alpha: _isHoveredOrTouched ? 0.25 : 0.1,
                        ),
                        blurRadius: 40,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Stack(
                        children: [
                          // Base Gradient Surface
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF1E1E2E).withValues(alpha: 0.9),
                                  const Color(0xFF11111B).withValues(alpha: 0.95),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(
                                  alpha: _isHoveredOrTouched ? 0.4 : 0.15,
                                ),
                                width: 1.5,
                              ),
                            ),
                          ),

                          // Dynamic Holographic Light Highlight (Shimmer effect)
                          Positioned.fill(
                            child: ShaderMask(
                              blendMode: BlendMode.screen,
                              shaderCallback: (bounds) {
                                return RadialGradient(
                                  center: Alignment(
                                    _touchPosition.dx,
                                    _touchPosition.dy,
                                  ),
                                  radius: 0.9,
                                  colors: [
                                    Colors.white.withValues(
                                      alpha: widget.lightIntensity * lightDistance * 0.8,
                                    ),
                                    Colors.cyanAccent.withValues(
                                      alpha: widget.lightIntensity * lightDistance * 0.4,
                                    ),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.4, 1.0],
                                ).createShader(bounds);
                              },
                              child: Container(color: Colors.white.withValues(alpha: 0.05)),
                            ),
                          ),

                          // Holographic diagonal stripe overlay
                          Positioned.fill(
                            child: Opacity(
                              opacity: (widget.lightIntensity * lightDistance * 0.5).clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    transform: GradientRotation(lightAngle),
                                    colors: const [
                                      Colors.transparent,
                                      Colors.cyanAccent,
                                      Colors.purpleAccent,
                                      Colors.amberAccent,
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Card Content Body
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: widget.child ?? _buildDefaultCardContent(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Default Card Content demonstrating VIP Credit / Skill Pass UI
  Widget _buildDefaultCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Top Row: Brand Header & Chip
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.cyanAccent, Colors.blueAccent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'FLUTTER KING',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            // SIM Chip icon
            Container(
              width: 36,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.amber.shade400,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.shade200, width: 1),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 13,
                    left: 0,
                    right: 0,
                    child: Container(height: 1, color: Colors.black26),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 17,
                    child: Container(width: 1, color: Colors.black26),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Middle: Card Number / Key Concept
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3D PERSPECTIVE MATRIX',
              style: TextStyle(
                color: Colors.cyanAccent.withValues(alpha: 0.8),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '4092  8831  9012  2026',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.5,
                shadows: [
                  Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(1, 2)),
                ],
              ),
            ),
          ],
        ),

        // Bottom Row: Holder Name & Expiry
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DEVELOPER PASS',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'MASTER OF ANIMATIONS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VALID THRU',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '12/30',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            // Visa/Mastercard style overlapping circles
            SizedBox(
              width: 40,
              height: 25,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
