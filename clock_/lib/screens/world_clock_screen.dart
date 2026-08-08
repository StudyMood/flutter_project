import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class WorldCity {
  final String name;
  final String timezoneName;
  final int offsetMinutes;

  const WorldCity({
    required this.name,
    required this.timezoneName,
    required this.offsetMinutes,
  });
}

const List<WorldCity> availableCities = [
  WorldCity(name: "New York", timezoneName: "EDT/EST", offsetMinutes: -240),
  WorldCity(name: "Los Angeles", timezoneName: "PDT/PST", offsetMinutes: -420),
  WorldCity(name: "Chicago", timezoneName: "CDT/CST", offsetMinutes: -300),
  WorldCity(name: "London", timezoneName: "BST/GMT", offsetMinutes: 60),
  WorldCity(name: "Paris", timezoneName: "CEST/CET", offsetMinutes: 120),
  WorldCity(name: "Kolkata (IST)", timezoneName: "IST", offsetMinutes: 330),
  WorldCity(name: "Singapore", timezoneName: "SGT", offsetMinutes: 480),
  WorldCity(name: "Tokyo", timezoneName: "JST", offsetMinutes: 540),
  WorldCity(name: "Sydney", timezoneName: "AEST", offsetMinutes: 600),
  WorldCity(name: "Auckland", timezoneName: "NZST", offsetMinutes: 720),
  WorldCity(name: "Dubai", timezoneName: "GST", offsetMinutes: 240),
  WorldCity(name: "Cairo", timezoneName: "EET", offsetMinutes: 180),
  WorldCity(name: "São Paulo", timezoneName: "BRT", offsetMinutes: -180),
];

class WorldClockScreen extends StatefulWidget {
  final bool isDark;
  final AppAccentColor accent;

  const WorldClockScreen({
    super.key,
    required this.isDark,
    required this.accent,
  });

  @override
  State<WorldClockScreen> createState() => _WorldClockScreenState();
}

class _WorldClockScreenState extends State<WorldClockScreen> {
  final List<WorldCity> _selectedCities = [
    const WorldCity(name: "New York", timezoneName: "EDT/EST", offsetMinutes: -240),
    const WorldCity(name: "London", timezoneName: "BST/GMT", offsetMinutes: 60),
    const WorldCity(name: "Tokyo", timezoneName: "JST", offsetMinutes: 540),
  ];

  WorldCity? _cityToSelect;
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  void _addCity() {
    if (_cityToSelect != null && !_selectedCities.contains(_cityToSelect)) {
      setState(() {
        _selectedCities.add(_cityToSelect!);
        _cityToSelect = null;
      });
    }
  }

  void _removeCity(WorldCity city) {
    setState(() {
      _selectedCities.remove(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    final utcNow = DateTime.now().toUtc();
    final localOffsetMin = DateTime.now().timeZoneOffset.inMinutes;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "Global Zones",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 4),
          Text(
            "Monitor key cities and zones concurrently.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Selector Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.glassBoxDecoration(
              isDark: widget.isDark,
              accentColor: widget.accent.color,
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<WorldCity>(
                      value: _cityToSelect,
                      hint: Text(
                        "Choose a timezone...",
                        style: TextStyle(
                          color: widget.isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      isExpanded: true,
                      dropdownColor: widget.isDark ? const Color(0xFF1E293B) : Colors.white,
                      items: availableCities.map((city) {
                        return DropdownMenuItem<WorldCity>(
                          value: city,
                          child: Text(
                            "${city.name} (${city.timezoneName})",
                            style: TextStyle(
                              color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _cityToSelect = val;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _addCity,
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accent.color,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Grid of Selected Cities
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900
                  ? 3
                  : (constraints.maxWidth > 600 ? 2 : 1);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.6,
                ),
                itemCount: _selectedCities.length,
                itemBuilder: (context, index) {
                  final city = _selectedCities[index];
                  final cityTime = utcNow.add(Duration(minutes: city.offsetMinutes));
                  final formattedTime = DateFormat('hh:mm').format(cityTime);
                  final formattedSec = DateFormat('ss').format(cityTime);
                  final ampm = DateFormat('a').format(cityTime);
                  final formattedDate = DateFormat('EEE, MMM d').format(cityTime);

                  // Relative offset from local user timezone
                  final diffMin = city.offsetMinutes - localOffsetMin;
                  final diffHours = (diffMin / 60.0);
                  final diffString = diffHours == 0
                      ? "Same time"
                      : "${diffHours > 0 ? '+' : ''}${diffHours.toStringAsFixed(1).replaceAll('.0', '')} HRS";

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppTheme.glassBoxDecoration(
                      isDark: widget.isDark,
                      accentColor: widget.accent.color,
                      borderRadius: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Bar: City Name & Remove
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  city.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  city.timezoneName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: widget.isDark ? Colors.white54 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              color: Colors.redAccent,
                              onPressed: () => _removeCity(city),
                            ),
                          ],
                        ),

                        // Center Time
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: widget.accent.color,
                              ),
                            ),
                            Text(
                              ":$formattedSec",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: widget.isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              ampm,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: widget.isDark ? Colors.white54 : Colors.black54,
                              ),
                            ),
                          ],
                        ),

                        // Bottom info: Date & Diff
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 13,
                                color: widget.isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.accent.color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                diffString,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: widget.accent.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
