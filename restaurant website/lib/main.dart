import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UpperDeckRestroApp());
}

class UpperDeckRestroApp extends StatelessWidget {
  const UpperDeckRestroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upper Deck Restro - Luxury Rooftop Dining & Nightlife',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainScreen(),
    );
  }
}
