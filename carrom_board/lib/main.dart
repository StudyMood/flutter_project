import 'package:flutter/material.dart';
import 'widgets/carrom_game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CarromBoardApp());
}

class CarromBoardApp extends StatelessWidget {
  const CarromBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrom Board Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF12181B),
        useMaterial3: true,
      ),
      home: const CarromGameScreen(),
    );
  }
}
