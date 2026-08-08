import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/intern_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/glass_container.dart';
import 'intern_profile_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;
  final _searchController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scannerAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _processScanResult(String code) {
    final provider = Provider.of<InternProvider>(context, listen: false);
    final intern = provider.findByInternIdOrQr(code);

    if (intern != null) {
      setState(() => _errorMessage = null);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InternProfileScreen(intern: intern),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'No intern found for code "$code". Please check the ID.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InternProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code & Barcode Scanner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Scanner View Box
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryOrange, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryOrange.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Camera grid line simulation
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      5,
                      (index) => Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),

                  // Scanner Framing Box
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.secondaryGreen, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  // Animated Red Laser Line
                  AnimatedBuilder(
                    animation: _scannerAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: 40 + (_scannerAnimation.value * 200),
                        child: Container(
                          width: 190,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const Positioned(
                    bottom: 12,
                    child: Text(
                      'Align QR / Barcode within frame',
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Manual Entry Glass Container
            GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Manual Verification / Test Scanner',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter Intern ID e.g. INT2026001',
                      prefixIcon: const Icon(Icons.qr_code_rounded, color: AppTheme.primaryOrange),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search_rounded, color: AppTheme.secondaryGreen),
                        onPressed: () => _processScanResult(_searchController.text),
                      ),
                    ),
                    onSubmitted: (val) => _processScanResult(val),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Scan Preset Buttons for easy testing
            GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Test Scans (Click to Simulate Scan):',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryOrange),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: provider.allInterns.map((intern) {
                      return ActionChip(
                        avatar: const Icon(Icons.qr_code_2_rounded, size: 16, color: Colors.white),
                        label: Text('${intern.fullName} (${intern.internId})'),
                        backgroundColor: AppTheme.secondaryGreen,
                        labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        onPressed: () => _processScanResult(intern.internId),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
