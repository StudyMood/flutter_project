import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/carrom_models.dart';
import '../physics/carrom_physics.dart';
import '../services/audio_service.dart';
import 'carrom_painter.dart';

class CarromGameScreen extends StatefulWidget {
  const CarromGameScreen({super.key});

  @override
  State<CarromGameScreen> createState() => _CarromGameScreenState();
}

class _CarromGameScreenState extends State<CarromGameScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final CarromPhysicsEngine _physicsEngine = CarromPhysicsEngine(
    boardSize: 500.0,
    frameWidth: 35.0,
    friction: 0.984,
  );
  final CarromAudioService _audioService = CarromAudioService();

  // Game Setup & Entities
  List<CarromPiece> pieces = [];
  List<Pocket> pockets = [];
  late CarromPiece striker;

  // Players & Turn State
  GameMode gameMode = GameMode.vsAI;
  int activePlayerIndex = 0; // 0 for Player 1 (Bottom), 1 for Player 2 / AI (Top)
  PlayerInfo player1 = PlayerInfo(id: 'p1', name: 'Player 1 (White)', assignedPiece: PieceType.white);
  PlayerInfo player2 = PlayerInfo(id: 'p2', name: 'Carrom AI (Black)', assignedPiece: PieceType.black, isAI: true);

  TurnPhase turnPhase = TurnPhase.positioning;
  bool queenPocketedThisGame = false;
  PlayerInfo? queenOwner;
  bool queenNeedsCovering = false;

  // Aim & Launch state
  double strikerBaselineX = 250.0; // Range 120.0 to 380.0
  Vector2D aimVector = Vector2D(0, -1);
  double shotPower = 0.5; // 0.1 to 1.0
  bool isDraggingAim = false;
  Offset? dragStartPos;

  // Stats & Message Banner
  String statusMessage = "Position striker & aim your shot!";
  int totalShotsFired = 0;

  @override
  void initState() {
    super.initState();
    _initPockets();
    _resetBoard();

    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _initPockets() {
    double pocketRad = 23.0;
    double offset = 48.0;
    double endOffset = 500.0 - 48.0;

    pockets = [
      Pocket(id: 'top_left', position: Vector2D(offset, offset), radius: pocketRad),
      Pocket(id: 'top_right', position: Vector2D(endOffset, offset), radius: pocketRad),
      Pocket(id: 'bottom_left', position: Vector2D(offset, endOffset), radius: pocketRad),
      Pocket(id: 'bottom_right', position: Vector2D(endOffset, endOffset), radius: pocketRad),
    ];
  }

  void _resetBoard() {
    setState(() {
      pieces.clear();
      queenPocketedThisGame = false;
      queenOwner = null;
      queenNeedsCovering = false;
      activePlayerIndex = 0;
      turnPhase = TurnPhase.positioning;
      player1.score = 0;
      player2.score = 0;
      totalShotsFired = 0;

      // 1. Create Striker
      striker = CarromPiece(
        id: 'striker',
        type: PieceType.striker,
        position: Vector2D(250.0, 420.0),
        radius: 14.5,
        mass: 2.2,
        primaryColor: const Color(0xFF00E5FF),
        secondaryColor: const Color(0xFF00838F),
        scorePoints: 0,
      );
      pieces.add(striker);

      // 2. Create Queen (Center: 250, 250)
      pieces.add(
        CarromPiece(
          id: 'queen',
          type: PieceType.queen,
          position: Vector2D(250.0, 250.0),
          radius: 11.0,
          mass: 1.0,
          primaryColor: const Color(0xFFD50000),
          secondaryColor: const Color(0xFFFFD600),
          scorePoints: 50,
        ),
      );

      // 3. Create 9 White & 9 Black Coins around Queen
      _setupCarromCoinsPattern();
      _resetStrikerPosition();
      statusMessage = "Game Reset! ${player1.name}'s turn.";
    });
  }

  void _setupCarromCoinsPattern() {
    Vector2D center = Vector2D(250.0, 250.0);
    double coinRad = 11.0;

    // Inner Ring: 6 coins (3 White, 3 Black alternating)
    double innerRadius = coinRad * 2.1;
    for (int i = 0; i < 6; i++) {
      double angle = i * (pi / 3);
      bool isWhite = (i % 2 == 0);
      pieces.add(CarromPiece(
        id: 'inner_$i',
        type: isWhite ? PieceType.white : PieceType.black,
        position: Vector2D(center.x + innerRadius * cos(angle), center.y + innerRadius * sin(angle)),
        radius: coinRad,
        mass: 1.0,
        primaryColor: isWhite ? const Color(0xFFFFF8E7) : const Color(0xFF263238),
        secondaryColor: isWhite ? const Color(0xFFD7CCC8) : const Color(0xFF102027),
        scorePoints: isWhite ? 20 : 10,
      ));
    }

    // Outer Ring: 12 coins (6 White, 6 Black alternating)
    double outerRadius = coinRad * 4.1;
    for (int i = 0; i < 12; i++) {
      double angle = (i * (pi / 6)) + (pi / 12);
      bool isWhite = (i % 2 == 0);
      pieces.add(CarromPiece(
        id: 'outer_$i',
        type: isWhite ? PieceType.white : PieceType.black,
        position: Vector2D(center.x + outerRadius * cos(angle), center.y + outerRadius * sin(angle)),
        radius: coinRad,
        mass: 1.0,
        primaryColor: isWhite ? const Color(0xFFFFF8E7) : const Color(0xFF263238),
        secondaryColor: isWhite ? const Color(0xFFD7CCC8) : const Color(0xFF102027),
        scorePoints: isWhite ? 20 : 10,
      ));
    }
  }

  void _resetStrikerPosition() {
    strikerBaselineX = 250.0;
    double baselineY = (activePlayerIndex == 0) ? 420.0 : 80.0;
    striker.position = Vector2D(strikerBaselineX, baselineY);
    striker.velocity = Vector2D(0, 0);
    striker.isPocketed = false;

    // Reset Aim Vector pointing towards board center
    aimVector = (activePlayerIndex == 0) ? Vector2D(0, -1) : Vector2D(0, 1);
    turnPhase = TurnPhase.positioning;
  }

  void _onTick(Duration duration) {
    if (turnPhase != TurnPhase.inMotion) return;

    double dt = 1.0 / 60.0;
    List<PocketEvent> pocketedThisTick = [];

    _physicsEngine.step(
      pieces: pieces,
      pockets: pockets,
      dt: dt,
      onCollision: (evt) => _audioService.playCoinHit(evt.impactForce),
      onWallHit: (evt) => _audioService.playWallHit(evt.impactForce),
      onPocketed: (evt) {
        _audioService.playPocketSound();
        pocketedThisTick.add(evt);
      },
    );

    // If physics has stopped, process turn completion
    if (!_physicsEngine.isAnyPieceMoving(pieces)) {
      _evaluateTurnOutcome(pocketedThisTick);
    }

    setState(() {});
  }

  void _fireShot() {
    if (turnPhase == TurnPhase.inMotion || turnPhase == TurnPhase.gameOver) return;

    setState(() {
      turnPhase = TurnPhase.inMotion;
      totalShotsFired++;

      // Max velocity impulse e.g. 750
      double maxSpeed = 750.0;
      double speed = shotPower * maxSpeed;
      Vector2D launchDir = aimVector.normalize();

      striker.velocity = launchDir * speed;
      _audioService.playStrikerHit(shotPower * 20.0);
      statusMessage = "Shot launched!";
    });
  }

  void _evaluateTurnOutcome(List<PocketEvent> pocketedEvents) {
    List<CarromPiece> newlyPocketed = pieces.where((p) => p.isPocketed && p.id != 'striker_pocketed_marker').toList();

    PlayerInfo currentPlayer = (activePlayerIndex == 0) ? player1 : player2;

    bool strikerPocketed = striker.isPocketed;
    bool extraTurnGranted = false;

    for (var piece in newlyPocketed) {
      if (piece.type == PieceType.queen) {
        queenPocketedThisGame = true;
        queenNeedsCovering = true;
        currentPlayer.score += 50;
        statusMessage = "👑 QUEEN POCKETED! Pocket another coin to cover it!";
        extraTurnGranted = true;
      } else if (piece.type == PieceType.white || piece.type == PieceType.black) {
        if (queenNeedsCovering) {
          queenNeedsCovering = false;
          queenOwner = currentPlayer;
          statusMessage = "👑 Queen Covered successfully by ${currentPlayer.name}!";
        }

        // Add points
        currentPlayer.score += piece.scorePoints;
        extraTurnGranted = true;
        statusMessage = "Pocketed ${piece.type.name.toUpperCase()} coin (+${piece.scorePoints} pts)!";
      }
    }

    // Handle Striker Foul
    if (strikerPocketed) {
      currentPlayer.score = max(0, currentPlayer.score - 10);
      statusMessage = "⚠️ FOUL! Striker pocketed (-10 pts).";
      extraTurnGranted = false;
    }

    // Check Win Condition
    int remainingCoins = pieces.where((p) => !p.isPocketed && p.type != PieceType.striker).length;
    if (remainingCoins == 0) {
      turnPhase = TurnPhase.gameOver;
      PlayerInfo winner = player1.score >= player2.score ? player1 : player2;
      statusMessage = "🏆 GAME OVER! ${winner.name} WINS with ${winner.score} Points!";
      return;
    }

    // Switch turns if no coins pocketed or on foul
    if (!extraTurnGranted || strikerPocketed) {
      activePlayerIndex = (activePlayerIndex == 0) ? 1 : 0;
    }

    _resetStrikerPosition();

    // Trigger AI Shot if vs AI mode and it's AI's turn
    if (gameMode == GameMode.vsAI && activePlayerIndex == 1 && turnPhase != TurnPhase.gameOver) {
      _executeAITurn();
    }
  }

  void _executeAITurn() async {
    statusMessage = "🤖 AI is thinking...";
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    // AI Smart Aim Strategy: Find closest active target coin to any pocket
    CarromPiece? bestTarget;
    Pocket? bestPocket;
    double bestScore = 999999;

    List<CarromPiece> targetCoins = pieces.where((p) => !p.isPocketed && p.type != PieceType.striker).toList();

    if (targetCoins.isNotEmpty) {
      for (var coin in targetCoins) {
        for (var p in pockets) {
          double dist = coin.position.distanceTo(p.position);
          if (dist < bestScore) {
            bestScore = dist;
            bestTarget = coin;
            bestPocket = p;
          }
        }
      }
    }

    if (bestTarget != null && bestPocket != null) {
      // Position striker baseline close to target
      strikerBaselineX = bestTarget.position.x.clamp(120.0, 380.0);
      striker.position = Vector2D(strikerBaselineX, 80.0);

      // Aim direction vector towards coin
      Vector2D dir = bestTarget.position - striker.position;
      aimVector = dir.normalize();
      shotPower = (0.5 + Random().nextDouble() * 0.35).clamp(0.4, 0.9);

      _fireShot();
    }
  }

  @override
  Widget build(BuildContext context) {
    PlayerInfo activePlayer = (activePlayerIndex == 0) ? player1 : player2;

    return Scaffold(
      backgroundColor: const Color(0xFF12181B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E272C),
        elevation: 4,
        title: Row(
          children: const [
            Icon(Icons.sports_esports, color: Colors.amber),
            SizedBox(width: 10),
            Text('Carrom Board Pro', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_audioService.soundEnabled ? Icons.volume_up : Icons.volume_off, color: Colors.amber),
            onPressed: () {
              setState(() {
                _audioService.soundEnabled = !_audioService.soundEnabled;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.cyanAccent),
            onPressed: _showRulesDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.redAccent),
            onPressed: _resetBoard,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Mode & Scoreboard Header
            _buildScoreboardHeader(),

            // Status Banner
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E272B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
              ),
              child: Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),

            // Interactive Carrom Board Canvas
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onPanStart: (details) {
                        if (turnPhase != TurnPhase.positioning || activePlayer.isAI) return;
                        isDraggingAim = true;
                        dragStartPos = details.localPosition;
                      },
                      onPanUpdate: (details) {
                        if (!isDraggingAim || turnPhase != TurnPhase.positioning) return;
                        RenderBox renderBox = context.findRenderObject() as RenderBox;
                        Offset localPos = renderBox.globalToLocal(details.globalPosition);

                        // Convert touch coordinates to 500x500 virtual canvas coordinates
                        double scale = 500.0 / renderBox.size.width;
                        Vector2D touchVirtual = Vector2D(localPos.dx * scale, localPos.dy * scale);

                        Vector2D diff = touchVirtual - striker.position;
                        if (diff.length > 5) {
                          setState(() {
                            // Reverse drag direction for intuitive slingshot aim or direct aim
                            aimVector = diff.normalize();
                            shotPower = (diff.length / 150.0).clamp(0.2, 1.0);
                          });
                        }
                      },
                      onPanEnd: (_) {
                        if (isDraggingAim && turnPhase == TurnPhase.positioning) {
                          isDraggingAim = false;
                        }
                      },
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: CarromBoardPainter(
                          pieces: pieces,
                          pockets: pockets,
                          striker: striker,
                          aimDirection: aimVector,
                          aimPower: shotPower,
                          isAiming: (turnPhase == TurnPhase.positioning),
                          activePlayerName: activePlayer.name,
                          activePlayerColor: (activePlayerIndex == 0) ? Colors.cyanAccent : Colors.amberAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Controls Bar
            _buildBottomControls(activePlayer),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreboardHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFF182226),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Player 1 Card
          _buildPlayerScoreBadge(player1, isActive: activePlayerIndex == 0, color: Colors.cyanAccent),

          // Game Mode Dropdown
          DropdownButton<GameMode>(
            value: gameMode,
            dropdownColor: const Color(0xFF1E272C),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            underline: Container(height: 2, color: Colors.amber),
            onChanged: (newMode) {
              if (newMode != null) {
                setState(() {
                  gameMode = newMode;
                  player2.isAI = (gameMode == GameMode.vsAI);
                  player2.name = (gameMode == GameMode.vsAI) ? 'Carrom AI (Black)' : 'Player 2 (Black)';
                  _resetBoard();
                });
              }
            },
            items: const [
              DropdownMenuItem(value: GameMode.vsAI, child: Text("🤖 Vs AI Bot")),
              DropdownMenuItem(value: GameMode.twoPlayer, child: Text("👥 2 Players")),
              DropdownMenuItem(value: GameMode.practice, child: Text("🎯 Practice")),
            ],
          ),

          // Player 2 / AI Card
          _buildPlayerScoreBadge(player2, isActive: activePlayerIndex == 1, color: Colors.amberAccent),
        ],
      ),
    );
  }

  Widget _buildPlayerScoreBadge(PlayerInfo player, {required bool isActive, required Color color}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.2) : Colors.black26,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            player.name,
            style: TextStyle(
              color: isActive ? color : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${player.score} Pts',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(PlayerInfo activePlayer) {
    bool canShoot = (turnPhase == TurnPhase.positioning && (!activePlayer.isAI || gameMode == GameMode.practice));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Color(0xFF182226),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Striker Position Slider
          Row(
            children: [
              const Text("Position:", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              Expanded(
                child: Slider(
                  value: strikerBaselineX,
                  min: 120.0,
                  max: 380.0,
                  activeColor: Colors.cyanAccent,
                  inactiveColor: Colors.white12,
                  onChanged: canShoot
                      ? (val) {
                          setState(() {
                            strikerBaselineX = val;
                            double baselineY = (activePlayerIndex == 0) ? 420.0 : 80.0;
                            striker.position = Vector2D(strikerBaselineX, baselineY);
                          });
                        }
                      : null,
                ),
              ),
            ],
          ),

          // Shot Power & Fire Button
          Row(
            children: [
              const Text("Power:", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              Expanded(
                child: Slider(
                  value: shotPower,
                  min: 0.1,
                  max: 1.0,
                  activeColor: Colors.amberAccent,
                  inactiveColor: Colors.white12,
                  onChanged: canShoot
                      ? (val) {
                          setState(() {
                            shotPower = val;
                          });
                        }
                      : null,
                ),
              ),

              const SizedBox(width: 10),

              // FIRE SHOT Button
              ElevatedButton.icon(
                onPressed: canShoot ? _fireShot : null,
                icon: const Icon(Icons.flash_on, color: Colors.black),
                label: const Text("SHOOT", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  disabledBackgroundColor: Colors.grey.shade800,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E272C),
        title: const Text("🎯 Carrom Rules & Scoring", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("• White Coin: 20 Points", style: TextStyle(color: Colors.white)),
              Text("• Black Coin: 10 Points", style: TextStyle(color: Colors.white)),
              Text("• Queen (Red): 50 Points (Must pocket another coin to cover Queen)", style: TextStyle(color: Colors.amberAccent)),
              SizedBox(height: 10),
              Text("• Striker Foul: -10 Points penalty if Striker drops into any pocket.", style: TextStyle(color: Colors.redAccent)),
              SizedBox(height: 10),
              Text("Controls:", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
              Text("1. Use Position slider to align striker along baseline.", style: TextStyle(color: Colors.white70)),
              Text("2. Drag on board or use Power slider to set shot direction and speed.", style: TextStyle(color: Colors.white70)),
              Text("3. Press SHOOT to strike!", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Got it!", style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }
}
