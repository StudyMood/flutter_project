import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/intern_provider.dart';
import 'themes/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DigiCodersApp());
}

class DigiCodersApp extends StatelessWidget {
  const DigiCodersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => InternProvider()),
      ],
      child: Consumer2<AuthProvider, InternProvider>(
        builder: (context, authProvider, internProvider, child) {
          return MaterialApp(
            title: 'DigiCoders Intern ID System',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: internProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: authProvider.isLoggedIn ? const DashboardScreen() : const LoginScreen(),
          );
        },
      ),
    );
  }
}
