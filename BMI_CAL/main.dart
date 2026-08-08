import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      home: const BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final TextEditingController _weightController = TextEditingController(text: '70');
  final TextEditingController _feetController = TextEditingController(text: '5');
  final TextEditingController _inchesController = TextEditingController(text: '8');
  final ScrollController _scrollController = ScrollController();

  bool? _isMale = true; // Gender toggle: true for Male, false for Female, null if not selected
  double? _bmi;
  String _bmiStatus = '';
  String _bmiMessage = '';
  Color _statusColor = Colors.green;

  // Dynamic gradient colors based on BMI status
  List<Color> _backgroundColors = [
    const Color(0xFF0F2027),
    const Color(0xFF203A43),
    const Color(0xFF2C5364),
  ];

  void _adjustValue(TextEditingController controller, double amount, {bool isInteger = false}) {
    double current = double.tryParse(controller.text) ?? 0.0;
    double newVal = current + amount;
    if (newVal < 0) newVal = 0.0;
    
    setState(() {
      controller.text = isInteger ? newVal.round().toString() : newVal.toStringAsFixed(1);
    });
  }

  void _calculateBMI() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    final double? weight = double.tryParse(_weightController.text);
    final double? feet = double.tryParse(_feetController.text);
    final double inches = double.tryParse(_inchesController.text) ?? 0.0;

    if (weight == null || feet == null || weight <= 0 || feet < 0 || inches < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('कृपया सही वजन और ऊंचाई दर्ज करें!'),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // Convert feet and inches to total inches
    double totalInches = (feet * 12.0) + inches;
    if (totalInches <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ऊंचाई 0 से अधिक होनी चाहिए!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // Convert total inches to meters (1 inch = 0.0254 meters)
    double heightInMeters = totalInches * 0.0254;
    // Calculate BMI: weight (kg) / height (m)^2
    double bmi = weight / (heightInMeters * heightInMeters);

    setState(() {
      _bmi = bmi;
      
      // Determine status, message, and background gradient colors based on BMI
      if (bmi < 18.5) {
        _bmiStatus = 'Underweight (कम वजन)';
        _statusColor = Colors.cyan;
        _bmiMessage = 'Healthy food aur thoda weight gain focus karein. (पौष्टिक भोजन लें और वजन बढ़ाने पर ध्यान दें।)';
        _backgroundColors = [
          const Color(0xFF076585),
          const Color(0xFF0F2027),
        ];
      } else if (bmi >= 18.5 && bmi < 25.0) {
        _bmiStatus = 'Normal (स्वस्थ वजन)';
        _statusColor = Colors.greenAccent;
        _bmiMessage = 'Perfect fitness! Aap bilkul fit hain. (शानदार! आप पूरी तरह से फिट हैं।)';
        _backgroundColors = [
          const Color(0xFF0A5C36),
          const Color(0xFF0F2027),
        ];
      } else if (bmi >= 25.0 && bmi < 30.0) {
        _bmiStatus = 'Overweight (अधिक वजन)';
        _statusColor = Colors.orangeAccent;
        _bmiMessage = 'Diet control aur regular exercise shuru karein. (संतुलित आहार लें और नियमित व्यायाम करें।)';
        _backgroundColors = [
          const Color(0xFF8A5103),
          const Color(0xFF0F2027),
        ];
      } else {
        _bmiStatus = 'Obese (अत्यधिक वजन)';
        _statusColor = Colors.redAccent;
        _bmiMessage = 'Health par dhyaan dein aur doctor ki salah lein. (स्वास्थ्य पर तुरंत ध्यान दें और चिकित्सक से परामर्श लें।)';
        _backgroundColors = [
          const Color(0xFF7A121F),
          const Color(0xFF0F2027),
        ];
      }
    });

    // Auto scroll down to see the results smoothly
    Future.delayed(const Duration(milliseconds: 150), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
      );
    });
  }

  void _reset() {
    setState(() {
      _weightController.text = '70';
      _feetController.text = '5';
      _inchesController.text = '8';
      _bmi = null;
      _bmiStatus = '';
      _bmiMessage = '';
      _isMale = true;
      _backgroundColors = [
        const Color(0xFF0F2027),
        const Color(0xFF203A43),
        const Color(0xFF2C5364),
      ];
    });
    
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _backgroundColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Title & Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _reset,
                        icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                        tooltip: 'Reset App',
                      ),
                      const Text(
                        'FIT BMI',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 48), // Balancing spacer
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Gender Selection Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildGenderCard(
                          title: 'MALE',
                          icon: Icons.male_rounded,
                          isSelected: _isMale == true,
                          activeColor: Colors.blueAccent,
                          onTap: () => setState(() => _isMale = true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildGenderCard(
                          title: 'FEMALE',
                          icon: Icons.female_rounded,
                          isSelected: _isMale == false,
                          activeColor: Colors.pinkAccent,
                          onTap: () => setState(() => _isMale = false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // main Inputs dashboard Card
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'ENTER YOUR DETAILS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 3-Column Inputs Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1st Column: Weight (WT)
                            Expanded(
                              child: _buildInteractiveInput(
                                label: 'WT (kg)',
                                controller: _weightController,
                                hint: '70',
                                onMinus: () => _adjustValue(_weightController, -1.0),
                                onPlus: () => _adjustValue(_weightController, 1.0),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 2nd Column: Feet (FT)
                            Expanded(
                              child: _buildInteractiveInput(
                                label: 'FT (feet)',
                                controller: _feetController,
                                hint: '5',
                                onMinus: () => _adjustValue(_feetController, -1.0, isInteger: true),
                                onPlus: () => _adjustValue(_feetController, 1.0, isInteger: true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 3rd Column: Inches (HT / Inch)
                            Expanded(
                              child: _buildInteractiveInput(
                                label: 'HT (inch)',
                                controller: _inchesController,
                                hint: '8',
                                onMinus: () => _adjustValue(_inchesController, -1.0, isInteger: true),
                                onPlus: () => _adjustValue(_inchesController, 1.0, isInteger: true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Calculate Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: (_bmi != null ? _statusColor : Colors.purpleAccent).withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _calculateBMI,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'CALCULATE BMI',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Results Section
                  if (_bmi != null) ...[
                    const SizedBox(height: 24),
                    _buildResultCard(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: activeColor.withValues(alpha: 0.15), blurRadius: 15)]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 44,
              color: isSelected ? activeColor : Colors.white60,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveInput({
    required String label,
    required TextEditingController controller,
    required String hint,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 12),
          // Minus / Plus adjustment row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSmallAdjustButton(icon: Icons.remove, onTap: onMinus),
              _buildSmallAdjustButton(icon: Icons.add, onTap: onPlus),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSmallAdjustButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _statusColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _statusColor.withValues(alpha: 0.08),
            blurRadius: 25,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            'YOUR BMI RESULT',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _bmi!.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: _statusColor,
              shadows: [
                Shadow(
                  color: _statusColor.withValues(alpha: 0.5),
                  blurRadius: 15,
                )
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _bmiStatus.toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: _statusColor,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          
          // Custom BMI Progress Gauge
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 10.0, end: _bmi ?? 10.0),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Column(
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, 24),
                    painter: BMIGaugePainter(bmi: value),
                  ),
                  const SizedBox(height: 8),
                  // Gauge markers and labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('10', style: TextStyle(fontSize: 10, color: Colors.white38)),
                      Text('Under', style: TextStyle(fontSize: 9, color: Colors.blueAccent)),
                      Text('Normal', style: TextStyle(fontSize: 9, color: Colors.greenAccent)),
                      Text('Over', style: TextStyle(fontSize: 9, color: Colors.orangeAccent)),
                      Text('Obese', style: TextStyle(fontSize: 9, color: Colors.redAccent)),
                      Text('40', style: TextStyle(fontSize: 10, color: Colors.white38)),
                    ],
                  )
                ],
              );
            },
          ),
          
          const SizedBox(height: 24),
          Text(
            _bmiMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _reset,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.autorenew_rounded, size: 18),
            label: const Text('Reset Again'),
          )
        ],
      ),
    );
  }
}

class BMIGaugePainter extends CustomPainter {
  final double bmi;
  BMIGaugePainter({required this.bmi});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final double width = size.width;
    final double height = size.height;
    const double trackHeight = 8.0;
    final double yPos = height - trackHeight;

    // Convert BMI to horizontal coordinates (Scale: BMI 10 to 40)
    double getX(double value) {
      double clamped = value.clamp(10.0, 40.0);
      return ((clamped - 10.0) / 30.0) * width;
    }

    final double x18_5 = getX(18.5);
    final double x25 = getX(25.0);
    final double x30 = getX(30.0);

    // Segment 1: Underweight (Blue)
    paint.color = Colors.blue.withValues(alpha: 0.6);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(0, yPos, x18_5, yPos + trackHeight),
        topLeft: const Radius.circular(4),
        bottomLeft: const Radius.circular(4),
      ),
      paint,
    );

    // Segment 2: Normal (Green)
    paint.color = Colors.greenAccent.withValues(alpha: 0.6);
    canvas.drawRect(
      Rect.fromLTRB(x18_5, yPos, x25, yPos + trackHeight),
      paint,
    );

    // Segment 3: Overweight (Orange)
    paint.color = Colors.orangeAccent.withValues(alpha: 0.6);
    canvas.drawRect(
      Rect.fromLTRB(x25, yPos, x30, yPos + trackHeight),
      paint,
    );

    // Segment 4: Obese (Red)
    paint.color = Colors.redAccent.withValues(alpha: 0.6);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(x30, yPos, width, yPos + trackHeight),
        topRight: const Radius.circular(4),
        bottomRight: const Radius.circular(4),
      ),
      paint,
    );

    // Draw pointer at current animated BMI
    if (bmi > 10.0) {
      final double pointerX = getX(bmi);
      final Paint pointerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      // Draw triangle pointing down
      final Path path = Path();
      path.moveTo(pointerX, yPos - 3);
      path.lineTo(pointerX - 5, yPos - 9);
      path.lineTo(pointerX + 5, yPos - 9);
      path.close();
      canvas.drawPath(path, pointerPaint);

      // Draw white outline circle on the track to highlight
      final Paint outerCirclePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(Offset(pointerX, yPos + (trackHeight / 2)), 6.0, outerCirclePaint);
      
      final Paint innerCirclePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(pointerX, yPos + (trackHeight / 2)), 3.0, innerCirclePaint);
    }
  }

  @override
  bool shouldRepaint(covariant BMIGaugePainter oldDelegate) {
    return oldDelegate.bmi != bmi;
  }
}
