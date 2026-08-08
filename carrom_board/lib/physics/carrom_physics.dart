import 'dart:math';
import '../models/carrom_models.dart';

class CollisionEvent {
  final CarromPiece pieceA;
  final CarromPiece pieceB;
  final double impactForce;

  CollisionEvent(this.pieceA, this.pieceB, this.impactForce);
}

class WallHitEvent {
  final CarromPiece piece;
  final double impactForce;

  WallHitEvent(this.piece, this.impactForce);
}

class PocketEvent {
  final CarromPiece piece;
  final Pocket pocket;

  PocketEvent(this.piece, this.pocket);
}

class CarromPhysicsEngine {
  final double boardSize; // Virtual board size, e.g., 500.0
  final double frameWidth; // Width of board wooden border, e.g., 35.0
  final double friction; // Velocity damping factor per tick (e.g., 0.985)
  final double restitution; // Elasticity factor (0.88)
  final double minVelocityThreshold; // Speed below which piece comes to complete stop

  CarromPhysicsEngine({
    this.boardSize = 500.0,
    this.frameWidth = 35.0,
    this.friction = 0.984,
    this.restitution = 0.88,
    this.minVelocityThreshold = 0.2,
  });

  double get innerMin => frameWidth;
  double get innerMax => boardSize - frameWidth;

  /// Advance physics simulation by time step dt
  void step({
    required List<CarromPiece> pieces,
    required List<Pocket> pockets,
    required double dt,
    Function(CollisionEvent)? onCollision,
    Function(WallHitEvent)? onWallHit,
    Function(PocketEvent)? onPocketed,
  }) {
    // 1. Move active pieces & apply friction
    for (var piece in pieces) {
      if (piece.isPocketed) continue;

      if (piece.velocity.length > 0) {
        // Move position
        piece.position.x += piece.velocity.x * dt;
        piece.position.y += piece.velocity.y * dt;

        // Damping / Friction
        piece.velocity.x *= pow(friction, dt * 60).toDouble();
        piece.velocity.y *= pow(friction, dt * 60).toDouble();

        // Stop completely if slow
        if (piece.velocity.length < minVelocityThreshold) {
          piece.velocity.x = 0;
          piece.velocity.y = 0;
        }
      }
    }

    // 2. Wall Collisions (Board Cushion Bounces)
    for (var piece in pieces) {
      if (piece.isPocketed) continue;

      bool hitWall = false;
      double impactForce = 0;

      // Left Wall
      if (piece.position.x - piece.radius < innerMin) {
        piece.position.x = innerMin + piece.radius;
        impactForce = piece.velocity.x.abs();
        piece.velocity.x = -piece.velocity.x * restitution;
        hitWall = true;
      }
      // Right Wall
      else if (piece.position.x + piece.radius > innerMax) {
        piece.position.x = innerMax - piece.radius;
        impactForce = piece.velocity.x.abs();
        piece.velocity.x = -piece.velocity.x * restitution;
        hitWall = true;
      }

      // Top Wall
      if (piece.position.y - piece.radius < innerMin) {
        piece.position.y = innerMin + piece.radius;
        impactForce = max(impactForce, piece.velocity.y.abs());
        piece.velocity.y = -piece.velocity.y * restitution;
        hitWall = true;
      }
      // Bottom Wall
      else if (piece.position.y + piece.radius > innerMax) {
        piece.position.y = innerMax - piece.radius;
        impactForce = max(impactForce, piece.velocity.y.abs());
        piece.velocity.y = -piece.velocity.y * restitution;
        hitWall = true;
      }

      if (hitWall && onWallHit != null && impactForce > 2.0) {
        onWallHit(WallHitEvent(piece, impactForce));
      }
    }

    // 3. Piece-to-Piece Collisions
    for (int i = 0; i < pieces.length; i++) {
      var p1 = pieces[i];
      if (p1.isPocketed) continue;

      for (int j = i + 1; j < pieces.length; j++) {
        var p2 = pieces[j];
        if (p2.isPocketed) continue;

        double dist = p1.position.distanceTo(p2.position);
        double minDist = p1.radius + p2.radius;

        if (dist < minDist && dist > 0) {
          // Overlap resolution
          Vector2D normal = (p2.position - p1.position).normalize();
          double overlap = minDist - dist;
          
          // Separate pieces along collision normal
          p1.position.x -= normal.x * (overlap / 2);
          p1.position.y -= normal.y * (overlap / 2);
          p2.position.x += normal.x * (overlap / 2);
          p2.position.y += normal.y * (overlap / 2);

          // Relative velocity
          Vector2D relativeVel = p1.velocity - p2.velocity;
          double velAlongNormal = relativeVel.dot(normal);

          // Do not resolve if velocities are separating
          if (velAlongNormal > 0) {
            double impulseMagnitude = (-(1 + restitution) * velAlongNormal) /
                (1 / p1.mass + 1 / p2.mass);

            Vector2D impulse = normal * impulseMagnitude;
            p1.velocity.x += impulse.x / p1.mass;
            p1.velocity.y += impulse.y / p1.mass;
            p2.velocity.x -= impulse.x / p2.mass;
            p2.velocity.y -= impulse.y / p2.mass;

            if (onCollision != null && impulseMagnitude > 3.0) {
              onCollision(CollisionEvent(p1, p2, impulseMagnitude));
            }
          }
        }
      }
    }

    // 4. Pocket Detection
    for (var piece in pieces) {
      if (piece.isPocketed) continue;

      for (var pocket in pockets) {
        double dist = piece.position.distanceTo(pocket.position);
        // Pocket radius is e.g. 24, piece radius is e.g. 11 (coin) or 15 (striker)
        if (dist < pocket.radius) {
          // Smooth attraction pull into pocket center if close
          if (dist < pocket.radius * 0.75) {
            piece.isPocketed = true;
            piece.velocity = Vector2D(0, 0);
            piece.position = pocket.position.copy();
            if (onPocketed != null) {
              onPocketed(PocketEvent(piece, pocket));
            }
            break;
          } else {
            // Apply suction pull towards pocket center
            Vector2D suction = (pocket.position - piece.position).normalize() * 15.0;
            piece.velocity.x += suction.x * dt;
            piece.velocity.y += suction.y * dt;
          }
        }
      }
    }
  }

  /// Check if any piece is currently moving on board
  bool isAnyPieceMoving(List<CarromPiece> pieces) {
    for (var piece in pieces) {
      if (!piece.isPocketed && piece.velocity.length > 0.3) {
        return true;
      }
    }
    return false;
  }
}
