import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/analog_clock.dart';

class ClockScreen extends StatelessWidget {
  final DateTime currentTime;
  final bool isDark;
  final AppAccentColor accent;

  const ClockScreen({
    super.key,
    required this.currentTime,
    required this.isDark,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final hoursStr = DateFormat('hh').format(currentTime);
    final minutesStr = DateFormat('mm').format(currentTime);
    final secondsStr = DateFormat('ss').format(currentTime);
    final ampmStr = DateFormat('a').format(currentTime);
    final fullDateStr = DateFormat('EEEE, MMMM d, yyyy').format(currentTime);
    final dayOfWeekStr = "Today is ${DateFormat('EEEE').format(currentTime)}";
    final timeZoneOffset = currentTime.timeZoneOffset;
    final tzSign = timeZoneOffset.isNegative ? '-' : '+';
    final tzHours = timeZoneOffset.inHours.abs().toString().padLeft(2, '0');
    final tzMinutes = (timeZoneOffset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final tzString = "GMT$tzSign$tzHours:$tzMinutes (${currentTime.timeZoneName})";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "Active Time",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 4),
          Text(
            "Live high-precision atomic-aligned time keeping.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Cards Grid / Responsive Layout
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  // Digital Clock Card
                  Expanded(
                    flex: isWide ? 6 : 0,
                    child: Container(
                      width: isWide ? null : double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: AppTheme.glassBoxDecoration(
                        isDark: isDark,
                        accentColor: accent.color,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main Time Display
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  hoursStr,
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: accent.color,
                                    letterSpacing: -2,
                                  ),
                                ),
                                Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: 70,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white54 : Colors.black45,
                                  ),
                                ),
                                Text(
                                  minutesStr,
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    letterSpacing: -2,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      secondsStr,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                        color: accent.color,
                                      ),
                                    ),
                                    Text(
                                      ampmStr,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white70 : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Full Date
                          Text(
                            fullDateStr,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xE6FFFFFF) : const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dayOfWeekStr,
                            style: TextStyle(
                              fontSize: 15,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Timezone Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: accent.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: accent.color.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.language, size: 16, color: accent.color),
                                const SizedBox(width: 8),
                                Text(
                                  tzString,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: accent.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (isWide) const SizedBox(width: 24) else const SizedBox(height: 24),

                  // Analog Clock Card
                  Expanded(
                    flex: isWide ? 5 : 0,
                    child: Container(
                      width: isWide ? null : double.infinity,
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.all(28),
                      decoration: AppTheme.glassBoxDecoration(
                        isDark: isDark,
                        accentColor: accent.color,
                      ),
                      child: AnalogClock(
                        dateTime: currentTime,
                        accentColor: accent.color,
                        isDark: isDark,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
