import 'dart:math';
import 'package:flutter/material.dart';

/// Particle model representing a single animated floating particle on the canvas
class Particle {
  double x;
  double y;
  double radius;
  double speedY;
  double speedX;
  double opacity;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedY,
    required this.speedX,
    required this.opacity,
    required this.color,
  });

  /// Factory constructor to generate random particle properties
  factory Particle.random(Size bounds, Random rng) {
    const colors = [
      Colors.cyanAccent,
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.indigoAccent,
      Colors.tealAccent,
    ];
    return Particle(
      x: rng.nextDouble() * bounds.width,
      y: rng.nextDouble() * bounds.height,
      radius: rng.nextDouble() * 3 + 1.5,
      speedY: -(rng.nextDouble() * 0.5 + 0.2), // float upwards
      speedX: (rng.nextDouble() - 0.5) * 0.4,   // slight horizontal drift
      opacity: rng.nextDouble() * 0.6 + 0.2,
      color: colors[rng.nextInt(colors.length)],
    );
  }

  /// Updates particle position and wraps around screen edges
  void update(Size bounds) {
    y += speedY;
    x += speedX;

    if (y < -10) {
      y = bounds.height + 10;
    }
    if (x < -10) x = bounds.width + 10;
    if (x > bounds.width + 10) x = -10;
  }
}

/// ParticleBackground widget creates a continuous canvas animation loop
class ParticleBackground extends StatefulWidget {
  final int particleCount;
  final Widget child;

  const ParticleBackground({
    super.key,
    this.particleCount = 50,
    required this.child,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> _particles = [];
  final Random _random = Random();
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    // Continuous animation loop driving 60 FPS repaint
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  void _initParticles(Size size) {
    if (size == _lastSize || size.width == 0 || size.height == 0) return;
    _lastSize = size;
    _particles = List.generate(
      widget.particleCount,
      (_) => Particle.random(size, _random),
    );
  }

  @override
  void didUpdateWidget(covariant ParticleBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.particleCount != widget.particleCount && _lastSize != Size.zero) {
      _particles = List.generate(
        widget.particleCount,
        (_) => Particle.random(_lastSize, _random),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initParticles(size);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Update positions every tick
            for (var particle in _particles) {
              particle.update(size);
            }
            return CustomPaint(
              painter: ParticlePainter(particles: _particles),
              child: widget.child,
            );
          },
        );
      },
    );
  }
}

/// CustomPainter rendering glowing particles and optional connection lines
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw connecting faint lines between nearby particles
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final p1 = particles[i];
        final p2 = particles[j];
        final dx = p1.x - p2.x;
        final dy = p1.y - p2.y;
        final dist = sqrt(dx * dx + dy * dy);

        if (dist < 100) {
          final linePaint = Paint()
            ..color = Colors.cyanAccent.withValues(alpha: (1.0 - dist / 100) * 0.15)
            ..strokeWidth = 1.0;
          canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), linePaint);
        }
      }
    }

    // Draw individual glowing particles
    for (var particle in particles) {
      // Outer glow
      paint.color = particle.color.withValues(alpha: particle.opacity * 0.3);
      canvas.drawCircle(Offset(particle.x, particle.y), particle.radius * 2.5, paint);

      // Core particle
      paint.color = particle.color.withValues(alpha: particle.opacity);
      canvas.drawCircle(Offset(particle.x, particle.y), particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
