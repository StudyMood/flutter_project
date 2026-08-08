import 'package:flutter/material.dart';

void main() {
  runApp(const AgeCalculatorApp());
}

// Color Theme Model
class AppThemeOption {
  final String name;
  final Color primaryColor;
  final List<Color> gradientColors;

  const AppThemeOption({
    required this.name,
    required this.primaryColor,
    required this.gradientColors,
  });
}

final List<AppThemeOption> availableThemes = [
  const AppThemeOption(
    name: "Indigo",
    primaryColor: Colors.indigo,
    gradientColors: [Color(0xFF3F51B5), Color(0xFF1A237E)],
  ),
  const AppThemeOption(
    name: "Purple",
    primaryColor: Colors.deepPurple,
    gradientColors: [Color(0xFF7E57C2), Color(0xFF311B92)],
  ),
  const AppThemeOption(
    name: "Teal",
    primaryColor: Colors.teal,
    gradientColors: [Color(0xFF26A69A), Color(0xFF004D40)],
  ),
  const AppThemeOption(
    name: "Orange",
    primaryColor: Colors.deepOrange,
    gradientColors: [Color(0xFFFF7043), Color(0xFFBF360C)],
  ),
  const AppThemeOption(
    name: "Pink",
    primaryColor: Colors.pink,
    gradientColors: [Color(0xFFEC407A), Color(0xFF880E4F)],
  ),
  const AppThemeOption(
    name: "Cyan",
    primaryColor: Colors.cyan,
    gradientColors: [Color(0xFF00ACC1), Color(0xFF006064)],
  ),
];

class AgeCalculatorApp extends StatefulWidget {
  const AgeCalculatorApp({super.key});

  @override
  State<AgeCalculatorApp> createState() => _AgeCalculatorAppState();
}

class _AgeCalculatorAppState extends State<AgeCalculatorApp> {
  AppThemeOption _currentTheme = availableThemes[0];

  void _changeTheme(AppThemeOption newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgePulse',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _currentTheme.primaryColor,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F8FD),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _currentTheme.primaryColor,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF10111A),
      ),
      home: AgeCalculatorScreen(
        activeTheme: _currentTheme,
        onThemeChanged: _changeTheme,
      ),
    );
  }
}

class AgeCalculatorScreen extends StatefulWidget {
  final AppThemeOption activeTheme;
  final ValueChanged<AppThemeOption> onThemeChanged;

  const AgeCalculatorScreen({
    super.key,
    required this.activeTheme,
    required this.onThemeChanged,
  });

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  final TextEditingController _yearController = TextEditingController();
  DateTime? _selectedDate;

  // Calculation Results
  int? _years;
  int? _months;
  int? _days;
  int? _totalMonths;
  int? _totalWeeks;
  int? _totalDays;
  int? _nextBdayMonths;
  int? _nextBdayDays;
  String? _zodiacSign;

  bool _calculated = false;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _yearController.text = pickedDate.year.toString();
      });
    }
  }

  String _getZodiacSign(int month, int day) {
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return "Aries ♈";
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return "Taurus ♉";
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return "Gemini ♊";
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return "Cancer ♋";
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return "Leo ♌";
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return "Virgo ♍";
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return "Libra ♎";
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return "Scorpio ♏";
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return "Sagittarius ♐";
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) return "Capricorn ♑";
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return "Aquarius ♒";
    return "Pisces ♓";
  }

  void _calculateAge() {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();

    DateTime? birthDate = _selectedDate;

    final inputYear = int.tryParse(_yearController.text.trim());
    if (inputYear != null) {
      if (inputYear > now.year || inputYear < 1900) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter a valid birth year (1900 - current year)"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      if (_selectedDate == null || _selectedDate!.year != inputYear) {
        birthDate = DateTime(inputYear, 1, 1);
      }
    }

    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter birth year"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    if (birthDate.isAfter(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Birth date cannot be in the future!"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Precise Age Calculation
    int y = now.year - birthDate.year;
    int m = now.month - birthDate.month;
    int d = now.day - birthDate.day;

    if (d < 0) {
      m--;
      DateTime prevMonth = DateTime(now.year, now.month, 0);
      d += prevMonth.day;
    }

    if (m < 0) {
      y--;
      m += 12;
    }

    int tDays = now.difference(birthDate).inDays;
    int tMonths = (y * 12) + m;
    int tWeeks = tDays ~/ 7;

    // Next Birthday Calculation
    DateTime nextBday = DateTime(now.year, birthDate.month, birthDate.day);
    if (nextBday.isBefore(now) ||
        (nextBday.year == now.year &&
            nextBday.month == now.month &&
            nextBday.day == now.day)) {
      nextBday = DateTime(now.year + 1, birthDate.month, birthDate.day);
    }

    int remainingDays = nextBday.difference(now).inDays;
    int nbMonths = remainingDays ~/ 30;
    int nbDays = remainingDays % 30;

    String zodiac = _getZodiacSign(birthDate.month, birthDate.day);

    setState(() {
      _years = y;
      _months = m;
      _days = d;
      _totalMonths = tMonths;
      _totalWeeks = tWeeks;
      _totalDays = tDays;
      _nextBdayMonths = nbMonths;
      _nextBdayDays = nbDays;
      _zodiacSign = zodiac;
      _calculated = true;
    });
  }

  void _resetFields() {
    setState(() {
      _yearController.clear();
      _selectedDate = null;
      _years = null;
      _months = null;
      _days = null;
      _totalMonths = null;
      _totalWeeks = null;
      _totalDays = null;
      _nextBdayMonths = null;
      _nextBdayDays = null;
      _zodiacSign = null;
      _calculated = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reset Done"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.activeTheme.primaryColor.withValues(alpha: 0.15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  height: 28,
                  width: 28,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.bolt_rounded,
                    color: widget.activeTheme.primaryColor,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "AgePulse",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vibrant Theme Selector Bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.palette_rounded,
                          size: 18,
                          color: widget.activeTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Select UI Color Theme:",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: availableThemes.map((themeOpt) {
                          final isSelected = widget.activeTheme.name == themeOpt.name;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () => widget.onThemeChanged(themeOpt),
                              borderRadius: BorderRadius.circular(30),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: themeOpt.gradientColors,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: themeOpt.primaryColor.withValues(alpha: 0.5),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : [],
                                  border: isSelected
                                      ? Border.all(color: Colors.white, width: 2)
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    if (isSelected)
                                      const Padding(
                                        padding: EdgeInsets.only(right: 6),
                                        child: Icon(
                                          Icons.check_circle_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    Text(
                                      themeOpt.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                            isSelected ? FontWeight.bold : FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Animated Dynamic Header Card
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            widget.activeTheme.gradientColors[1],
                            widget.activeTheme.primaryColor.withValues(alpha: 0.8),
                          ]
                        : widget.activeTheme.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: widget.activeTheme.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          height: 64,
                          width: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.cake_rounded,
                            size: 52,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "AgePulse",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Smart Age & Birthday Tracker",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Input Card
              Card(
                elevation: 3,
                shadowColor: widget.activeTheme.primaryColor.withValues(alpha: 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.badge_rounded,
                            color: widget.activeTheme.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Enter Birth Details",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Birth Year Input Field
                      TextField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Enter Your Birth Year",
                          hintText: "e.g. 2000",
                          prefixIcon: Icon(
                            Icons.calendar_today_rounded,
                            color: widget.activeTheme.primaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.edit_calendar_rounded,
                              color: widget.activeTheme.primaryColor,
                            ),
                            onPressed: _presentDatePicker,
                            tooltip: "Select Date of Birth",
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                        ),
                      ),

                      if (_selectedDate != null) ...[
                        const SizedBox(height: 12),
                        Chip(
                          avatar: Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: widget.activeTheme.primaryColor,
                          ),
                          label: Text(
                            "Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: widget.activeTheme.primaryColor.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Calculate Button (Primary Theme Color)
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          child: ElevatedButton.icon(
                            onPressed: _calculateAge,
                            icon: const Icon(Icons.calculate_rounded),
                            label: const Text(
                              "Calculate Age",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.activeTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 4,
                              shadowColor: widget.activeTheme.primaryColor.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Reset Button (Check Another Age)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _resetFields,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text(
                            "Check Another Age",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: widget.activeTheme.primaryColor,
                              width: 1.5,
                            ),
                            foregroundColor: widget.activeTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Result Section Card
              Card(
                elevation: 4,
                shadowColor: widget.activeTheme.primaryColor.withValues(alpha: 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insights_rounded,
                            color: widget.activeTheme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Result Summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 25),

                      if (!_calculated)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            "Your Age will appear here",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      else ...[
                        // Primary Glowing Result Card
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.activeTheme.primaryColor.withValues(alpha: 0.12),
                                widget.activeTheme.primaryColor.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: widget.activeTheme.primaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Your Age is",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${_years!} Years ${_months != null && _months! > 0 ? '${_months!} Months ' : ''}${_days != null && _days! > 0 ? '${_days!} Days' : ''}"
                                    .trim(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: widget.activeTheme.primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Stats Grid (Total Months, Weeks, Days)
                        Row(
                          children: [
                            _buildStatCard(
                              context,
                              title: "Total Months",
                              value: "${_totalMonths ?? (_years! * 12)}",
                              icon: Icons.calendar_month_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildStatCard(
                              context,
                              title: "Total Weeks",
                              value: "${_totalWeeks ?? ((_years! * 365) ~/ 7)}",
                              icon: Icons.view_week_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildStatCard(
                              context,
                              title: "Total Days",
                              value: "${_totalDays ?? (_years! * 365)}",
                              icon: Icons.today_rounded,
                            ),
                          ],
                        ),

                        if (_nextBdayMonths != null) ...[
                          const SizedBox(height: 16),
                          // Birthday Countdown Banner
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade500.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.amber.shade700.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.card_giftcard_rounded, color: Colors.amber.shade800),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Next Birthday Countdown",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "${_nextBdayMonths!} Months & ${_nextBdayDays!} Days left",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        if (_zodiacSign != null) ...[
                          const SizedBox(height: 12),
                          // Zodiac Card
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: widget.activeTheme.primaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: widget.activeTheme.primaryColor.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.auto_awesome_rounded, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  "Zodiac Sign: $_zodiacSign",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: widget.activeTheme.primaryColor),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
