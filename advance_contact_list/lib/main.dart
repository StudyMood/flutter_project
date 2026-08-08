import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/contact_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ContactsApp());
}

class ContactsApp extends StatelessWidget {
  const ContactsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final contactService = ContactService();

    return ValueListenableBuilder<bool>(
      valueListenable: contactService.darkModeNotifier,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          title: 'Personal Contact',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        );
      },
    );
  }
}
