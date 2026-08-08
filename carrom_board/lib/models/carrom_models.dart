import 'dart:math';
import 'package:flutter/material.dart';

/// Simple 2D Vector class for physics math
class Vector2D {
  double x;
  double y;

  Vector2D(this.x, this.y);

  Vector2D operator +(Vector2D other) => Vector2D(x + other.x, y + other.y);
  Vector2D operator -(Vector2D other) => Vector2D(x - other.x, y - other.y);
  Vector2D operator *(double scalar) => Vector2D(x * scalar, y * scalar);
  Vector2D operator /(double scalar) => Vector2D(x / scalar, y / scalar);

  double get length => sqrt(x * x + y * y);
  double get lengthSquared => x * x + y * y;

  Vector2D normalize() {
    double len = length;
    if (len == 0) return Vector2D(0, 0);
    return Vector2D(x / len, y / len);
  }

  double distanceTo(Vector2D other) {
    double dx = x - other.x;
    double dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }

  double dot(Vector2D other) => x * other.x + y * other.y;

  Vector2D copy() => Vector2D(x, y);

  @override
  String toString() => 'Vector2D(${x.toStringAsFixed(1)}, ${y.toStringAsFixed(1)})';
}

enum PieceType { striker, queen, white, black }

enum GameMode { twoPlayer, vsAI, practice }

enum TurnPhase { positioning, aiming, inMotion, roundComplete, gameOver }

class CarromPiece {
  final String id;
  final PieceType type;
  Vector2D position;
  Vector2D velocity;
  double radius;
  double mass;
  bool isPocketed;
  Color primaryColor;
  Color secondaryColor;
  int scorePoints;

  CarromPiece({
    required this.id,
    required this.type,
    required this.position,
    required this.radius,
    required this.mass,
    required this.primaryColor,
    required this.secondaryColor,
    required this.scorePoints,
    Vector2D? velocity,
    this.isPocketed = false,
  }) : velocity = velocity ?? Vector2D(0, 0);

  CarromPiece copyWith({Vector2D? position, Vector2D? velocity, bool? isPocketed}) {
    return CarromPiece(
      id: id,
      type: type,
      position: position ?? this.position.copy(),
      velocity: velocity ?? this.velocity.copy(),
      radius: radius,
      mass: mass,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      scorePoints: scorePoints,
      isPocketed: isPocketed ?? this.isPocketed,
    );
  }
}

class Pocket {
  final String id;
  final Vector2D position;
  final double radius;

  Pocket({required this.id, required this.position, required this.radius});
}

class PlayerInfo {
  final String id;
  String name;
  int score;
  PieceType? assignedPiece;
  bool isAI;

  PlayerInfo({
    required this.id,
    required this.name,
    this.score = 0,
    this.assignedPiece,
    this.isAI = false,
  });
}
