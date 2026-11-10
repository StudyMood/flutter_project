import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_colors.dart';
import 'state/converter_notifier.dart';
import 'screens/converter_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatefulWidget {
  const UnitConverterApp({super.key});

  @override
  State<UnitConverterApp> createState() => _UnitConverterAppState();
}

class _UnitConverterAppState extends State<UnitConverterApp> {
  late final ConverterNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ConverterNotifier();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        return MaterialApp(
          title: 'Unit Converter',
          debugShowCheckedModeBanner: false,
          themeMode: _notifier.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: _notifier.selectedCategory.themeColor,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: AppColors.lightBg,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              surfaceTintColor: Colors.transparent,
            ),
            fontFamily: 'Roboto',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: _notifier.selectedCategory.themeColor,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: AppColors.darkBg,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              surfaceTintColor: Colors.transparent,
            ),
            fontFamily: 'Roboto',
          ),
          home: ConverterScreen(notifier: _notifier),
        );
      },
    );
  }
}

