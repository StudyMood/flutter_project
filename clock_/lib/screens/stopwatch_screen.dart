import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LapRecord {
  final int lapNumber;
  final String formattedTime;
  final Duration rawDuration;

  LapRecord({
    required this.lapNumber,
    required this.formattedTime,
    required this.rawDuration,
  });
}

class StopwatchScreen extends StatefulWidget {
  final bool isDark;
  final AppAccentColor accent;

  const StopwatchScreen({
    super.key,
    required this.isDark,
    required this.accent,
  });

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<LapRecord> _laps = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleStartPause() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
        _timer?.cancel();
      } else {
        _stopwatch.start();
        _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
          if (mounted) setState(() {});
        });
      }
    });
  }

  void _recordLap() {
    if (!_stopwatch.isRunning) return;
    final elapsed = _stopwatch.elapsed;
    final formatted = _formatTime(elapsed);

    setState(() {
      _laps.insert(
        0,
        LapRecord(
          lapNumber: _laps.length + 1,
          formattedTime: formatted,
          rawDuration: elapsed,
        ),
      );
    });
  }

  void _reset() {
    setState(() {
      _stopwatch.stop();
      _stopwatch.reset();
      _timer?.cancel();
      _laps.clear();
    });
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final ms = ((duration.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds.$ms";
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsed;
    final hours = elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final ms = ((elapsed.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
    final isRunning = _stopwatch.isRunning;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "Precision Stopwatch",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 4),
          Text(
            "High-fidelity millisecond interval tracking.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Main Card
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(36),
              decoration: AppTheme.glassBoxDecoration(
                isDark: widget.isDark,
                accentColor: widget.accent.color,
              ),
              child: Column(
                children: [
                  // Stopwatch Digits
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "$hours:$minutes:$seconds",
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        Text(
                          ".$ms",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: widget.accent.color,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Control Buttons Group
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      // Start/Pause Button
                      ElevatedButton.icon(
                        onPressed: _toggleStartPause,
                        icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                        label: Text(isRunning ? "Pause" : "Start"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.accent.color,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),

                      // Lap Button
                      OutlinedButton.icon(
                        onPressed: isRunning ? _recordLap : null,
                        icon: const Icon(Icons.flag_outlined),
                        label: const Text("Lap"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          side: BorderSide(
                            color: isRunning
                                ? (widget.isDark ? Colors.white60 : Colors.black54)
                                : Colors.grey.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),

                      // Reset Button
                      OutlinedButton.icon(
                        onPressed: (elapsed > Duration.zero) ? _reset : null,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Reset"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          side: BorderSide(
                            color: (elapsed > Duration.zero)
                                ? Colors.redAccent.withValues(alpha: 0.5)
                                : Colors.grey.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Laps List
          if (_laps.isNotEmpty) ...[
            Text(
              "Lap History",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _laps.length,
              itemBuilder: (context, index) {
                final lap = _laps[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: AppTheme.glassBoxDecoration(
                    isDark: widget.isDark,
                    accentColor: widget.accent.color,
                    borderRadius: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lap #${lap.lapNumber}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.accent.color,
                        ),
                      ),
                      Text(
                        lap.formattedTime,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
