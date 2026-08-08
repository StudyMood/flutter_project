import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TimerScreen extends StatefulWidget {
  final bool isDark;
  final AppAccentColor accent;

  const TimerScreen({
    super.key,
    required this.isDark,
    required this.accent,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _totalSeconds = 300; // Default 5 mins
  int _remainingSeconds = 300;
  bool _isRunning = false;
  Timer? _timer;

  final TextEditingController _hoursController = TextEditingController(text: "00");
  final TextEditingController _minutesController = TextEditingController(text: "05");
  final TextEditingController _secondsController = TextEditingController(text: "00");

  @override
  void dispose() {
    _timer?.cancel();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _applyInputValues() {
    final h = int.tryParse(_hoursController.text) ?? 0;
    final m = int.tryParse(_minutesController.text) ?? 0;
    final s = int.tryParse(_secondsController.text) ?? 0;
    final total = h * 3600 + m * 60 + s;
    setState(() {
      _totalSeconds = total > 0 ? total : 1;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _setPreset(int seconds) {
    _timer?.cancel();
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;

    _hoursController.text = h.toString().padLeft(2, '0');
    _minutesController.text = m.toString().padLeft(2, '0');
    _secondsController.text = s.toString().padLeft(2, '0');

    setState(() {
      _isRunning = false;
      _totalSeconds = seconds;
      _remainingSeconds = seconds;
    });
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      if (!_isRunning && _remainingSeconds == _totalSeconds) {
        _applyInputValues();
      }
      if (_remainingSeconds <= 0) return;

      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_remainingSeconds > 1) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _remainingSeconds = 0;
            _isRunning = false;
          });
          _showTimeUpDialog();
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    _applyInputValues();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.alarm_on, color: widget.accent.color, size: 28),
            const SizedBox(width: 10),
            const Text("Timer Finished!"),
          ],
        ),
        content: const Text("Your countdown duration has completed."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalSeconds > 0 ? (_remainingSeconds / _totalSeconds) : 0.0;
    final displayH = (_remainingSeconds ~/ 3600).toString().padLeft(2, '0');
    final displayM = ((_remainingSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final displayS = (_remainingSeconds % 60).toString().padLeft(2, '0');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "Countdown Timer",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 4),
          Text(
            "Visual radial alert-driven duration scheduler.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Timer Center Card
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(36),
              decoration: AppTheme.glassBoxDecoration(
                isDark: widget.isDark,
                accentColor: widget.accent.color,
              ),
              child: Column(
                children: [
                  // Circular Progress & Digits Widget
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Custom Radial Ring
                        CustomPaint(
                          size: const Size(240, 240),
                          painter: _TimerProgressPainter(
                            progress: progress,
                            accentColor: widget.accent.color,
                            isDark: widget.isDark,
                          ),
                        ),

                        // Center Digits or Inputs
                        if (_isRunning)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$displayH:$displayM:$displayS",
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Remaining",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: widget.accent.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTimeInput(_hoursController, "HH"),
                              const Text(" : ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              _buildTimeInput(_minutesController, "MM"),
                              const Text(" : ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              _buildTimeInput(_secondsController, "SS"),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Presets Row
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildPresetChip("1 Min", 60),
                      _buildPresetChip("5 Min", 300),
                      _buildPresetChip("10 Min", 600),
                      _buildPresetChip("30 Min", 1800),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _toggleTimer,
                        icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                        label: Text(_isRunning ? "Pause" : "Start"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.accent.color,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: _resetTimer,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Reset"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput(TextEditingController controller, String hint) {
    return SizedBox(
      width: 48,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (_) => _applyInputValues(),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.accent.color.withValues(alpha: 0.5)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.accent.color, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, int seconds) {
    final isSelected = !_isRunning && _totalSeconds == seconds;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _setPreset(seconds),
      selectedColor: widget.accent.color.withValues(alpha: 0.25),
      labelStyle: TextStyle(
        color: isSelected
            ? widget.accent.color
            : (widget.isDark ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? widget.accent.color : Colors.white24,
      ),
    );
  }
}

class _TimerProgressPainter extends CustomPainter {
  final double progress;
  final Color accentColor;
  final bool isDark;

  _TimerProgressPainter({
    required this.progress,
    required this.accentColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Background Track Circle
    final trackPaint = Paint()
      ..color = isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawCircle(center, radius, trackPaint);

    // Active Progress Arc
    final progressPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.isDark != isDark;
  }
}
