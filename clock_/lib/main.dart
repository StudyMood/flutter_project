import 'dart:async';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/sidebar_navigation.dart';
import 'screens/clock_screen.dart';
import 'screens/stopwatch_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/world_clock_screen.dart';

void main() {
  runApp(const ClockApp());
}

class ClockApp extends StatefulWidget {
  const ClockApp({super.key});

  @override
  State<ClockApp> createState() => _ClockAppState();
}

class _ClockAppState extends State<ClockApp> {
  bool _isDark = true;
  AppAccentColor _accent = AppAccentColor.cyan;
  int _selectedTab = 0;
  late DateTime _currentTime;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  void _selectAccent(AppAccentColor accent) {
    setState(() {
      _accent = accent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = AppTheme.buildTheme(isDark: _isDark, accent: _accent);

    return MaterialApp(
      title: 'Abhishek - Modern Clock & Time Suite',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 768;

            Widget currentScreen;
            switch (_selectedTab) {
              case 0:
                currentScreen = ClockScreen(
                  currentTime: _currentTime,
                  isDark: _isDark,
                  accent: _accent,
                );
                break;
              case 1:
                currentScreen = StopwatchScreen(
                  isDark: _isDark,
                  accent: _accent,
                );
                break;
              case 2:
                currentScreen = TimerScreen(
                  isDark: _isDark,
                  accent: _accent,
                );
                break;
              case 3:
                currentScreen = WorldClockScreen(
                  isDark: _isDark,
                  accent: _accent,
                );
                break;
              default:
                currentScreen = ClockScreen(
                  currentTime: _currentTime,
                  isDark: _isDark,
                  accent: _accent,
                );
            }

            if (isDesktop) {
              return Row(
                children: [
                  SidebarNavigation(
                    selectedIndex: _selectedTab,
                    onTabSelected: (idx) => setState(() => _selectedTab = idx),
                    isDark: _isDark,
                    onToggleTheme: _toggleTheme,
                    currentAccent: _accent,
                    onSelectAccent: _selectAccent,
                  ),
                  Expanded(
                    child: SafeArea(
                      child: currentScreen,
                    ),
                  ),
                ],
              );
            }

            // Mobile Layout with Bottom Navigation Bar
            return SafeArea(
              child: Column(
                children: [
                  Expanded(child: currentScreen),
                  NavigationBar(
                    selectedIndex: _selectedTab,
                    onDestinationSelected: (idx) => setState(() => _selectedTab = idx),
                    indicatorColor: _accent.color.withValues(alpha: 0.25),
                    destinations: const [
                      NavigationDestination(icon: Icon(Icons.access_time), label: "Clock"),
                      NavigationDestination(icon: Icon(Icons.timer_outlined), label: "Stopwatch"),
                      NavigationDestination(icon: Icon(Icons.hourglass_bottom), label: "Timer"),
                      NavigationDestination(icon: Icon(Icons.public), label: "World"),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
