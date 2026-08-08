import 'package:flutter/material.dart';
import 'widgets/interactive_3d_card.dart';
import 'widgets/particle_background.dart';

void main() {
  runApp(const Flutter3DCardApp());
}

class Flutter3DCardApp extends StatelessWidget {
  const Flutter3DCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 3D Interactive Animations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F17),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.purpleAccent,
          surface: Color(0xFF181825),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Live control state variables
  double _tiltSensitivity = 0.45; // Max angle (~25 deg)
  double _perspectiveValue = 0.0012; // Z-distortion depth
  double _lightIntensity = 0.6;
  int _particleCount = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleBackground(
        particleCount: _particleCount,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top App Bar Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.cyanAccent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.layers_outlined,
                        color: Colors.cyanAccent,
                        size: 22,
                      ),
                    ),
                    const Column(
                      children: [
                        Text(
                          '3D INTERACTIVE UI',
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Advanced Motion & Math in Flutter',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.white70),
                      onPressed: () => _showMathExplanationDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Main Star Component: 3D Holographic Tilt Card
                Center(
                  child: SizedBox(
                    width: 350,
                    height: 220,
                    child: Interactive3DCard(
                      maxTiltAngle: _tiltSensitivity,
                      perspective: _perspectiveValue,
                      lightIntensity: _lightIntensity,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Drag instruction chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app, color: Colors.cyanAccent, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Touch or drag card to tilt in 3D space',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Control Panel Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181825).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.tune, color: Colors.purpleAccent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Live Physics & Render Controls',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, color: Colors.white10),

                      // Slider 1: Tilt Sensitivity
                      _buildControlSlider(
                        label: 'Tilt Max Angle (Matrix Rotation)',
                        value: _tiltSensitivity,
                        min: 0.1,
                        max: 0.9,
                        displayValue: '${(_tiltSensitivity * (180 / 3.14159)).round()}°',
                        onChanged: (val) => setState(() => _tiltSensitivity = val),
                      ),

                      // Slider 2: 3D Perspective Projection
                      _buildControlSlider(
                        label: 'Perspective Depth [Entry(3,2)]',
                        value: _perspectiveValue,
                        min: 0.0005,
                        max: 0.003,
                        displayValue: _perspectiveValue.toStringAsFixed(4),
                        onChanged: (val) => setState(() => _perspectiveValue = val),
                      ),

                      // Slider 3: Holographic Reflection Intensity
                      _buildControlSlider(
                        label: 'Holographic Light Sheen',
                        value: _lightIntensity,
                        min: 0.0,
                        max: 1.0,
                        displayValue: '${(_lightIntensity * 100).round()}%',
                        onChanged: (val) => setState(() => _lightIntensity = val),
                      ),

                      // Slider 4: Background Particle Density
                      _buildControlSlider(
                        label: 'Canvas Particle Density',
                        value: _particleCount.toDouble(),
                        min: 10,
                        max: 120,
                        divisions: 11,
                        displayValue: '${_particleCount.round()} particles',
                        onChanged: (val) => setState(() => _particleCount = val.toInt()),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Technical Learning Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan.shade900.withValues(alpha: 0.3),
                        Colors.purple.shade900.withValues(alpha: 0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.cyanAccent.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.school, color: Colors.cyanAccent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Key Flutter Concepts Mastered',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildConceptBullet(
                        title: 'Matrix4 Perspective',
                        desc: 'Matrix4.identity()..setEntry(3, 2, 0.001) enables real 3D camera depth in 2D UI.',
                      ),
                      _buildConceptBullet(
                        title: 'Gesture Normalization',
                        desc: 'Converting touch offsets (dx, dy) into normalized coordinates [-1.0, 1.0].',
                      ),
                      _buildConceptBullet(
                        title: 'Spring Return Physics',
                        desc: 'CurvedAnimation(curve: Curves.elasticOut) generates realistic recoil.',
                      ),
                      _buildConceptBullet(
                        title: 'CustomPainter Rendering',
                        desc: '60 FPS custom graphics loop with dynamic glowing canvas painting.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required String displayValue,
    required ValueChanged<double> onChanged,
    int? divisions,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                displayValue,
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: Colors.cyanAccent,
              inactiveTrackColor: Colors.white10,
              thumbColor: Colors.cyanAccent,
              overlayColor: Colors.cyanAccent.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConceptBullet({required String title, required String desc}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚡ ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: desc,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMathExplanationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.functions, color: Colors.cyanAccent),
            SizedBox(width: 8),
            Text('Mathematical Formula', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3D Matrix Transformation:',
              style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Matrix4 m = Matrix4.identity();\n'
              'm.setEntry(3, 2, 0.001); // 3D Perspective\n'
              'm.rotateX(-touchY * maxTilt);\n'
              'm.rotateY(touchX * maxTilt);',
              style: TextStyle(fontFamily: 'monospace', color: Colors.white70, fontSize: 11),
            ),
            SizedBox(height: 12),
            Text(
              'Touch Normalization:',
              style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'normX = (touch.dx / width) * 2 - 1.0;\n'
              'normY = (touch.dy / height) * 2 - 1.0;',
              style: TextStyle(fontFamily: 'monospace', color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }
}
