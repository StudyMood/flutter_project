import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const AiHealthTipsApp());
}

class AiHealthTipsApp extends StatefulWidget {
  const AiHealthTipsApp({super.key});

  @override
  State<AiHealthTipsApp> createState() => _AiHealthTipsAppState();
}

class _AiHealthTipsAppState extends State<AiHealthTipsApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '24 AI Health Tips & Prescription Generator',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: MainHomeScreen(
        onToggleTheme: _toggleTheme,
        currentThemeMode: _themeMode,
      ),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode currentThemeMode;

  const MainHomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.currentThemeMode,
  });

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.currentThemeMode == ThemeMode.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.health_and_safety, color: primaryColor, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '24 AI Health & Care',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    'Smart Tips & Prescription Assistant',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.tips_and_updates), text: '24 AI Tips'),
            Tab(icon: Icon(Icons.receipt_long), text: 'Prescription'),
            Tab(icon: Icon(Icons.medical_services), text: 'Health Guide'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AiTipsTab(),
          PrescriptionGeneratorTab(),
          HealthGuideTab(),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: 24 AI TIPS TAB
// -----------------------------------------------------------------------------

class AiTipItem {
  final int id;
  final String title;
  final String category;
  final String shortDescription;
  final String detailedTip;
  final String promptExample;
  final IconData icon;
  bool isBookmarked;

  AiTipItem({
    required this.id,
    required this.title,
    required this.category,
    required this.shortDescription,
    required this.detailedTip,
    required this.promptExample,
    required this.icon,
    this.isBookmarked = false,
  });
}

class AiTipsTab extends StatefulWidget {
  const AiTipsTab({super.key});

  @override
  State<AiTipsTab> createState() => _AiTipsTabState();
}

class _AiTipsTabState extends State<AiTipsTab> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Medical AI',
    'Wellness & Diet',
    'AI Diagnostics',
    'Symptom Logic',
    'Patient Care',
  ];

  late List<AiTipItem> _tipsList;

  @override
  void initState() {
    super.initState();
    _tipsList = _generate24Tips();
  }

  List<AiTipItem> _generate24Tips() {
    return [
      AiTipItem(
        id: 1,
        title: 'Symptom Structuring Prompting',
        category: 'Medical AI',
        shortDescription: 'Structure raw symptom text into clean medical chronologies for AI.',
        detailedTip: 'Always provide timeline, severity (1-10), triggering factors, and associated symptoms when asking AI for initial medical differential insights.',
        promptExample: 'Prompt: "Act as a clinical assistant. Organize these symptoms by onset, duration, and severity: [Symptoms]"',
        icon: Icons.assignment,
      ),
      AiTipItem(
        id: 2,
        title: 'Drug Interaction Verification',
        category: 'Medical AI',
        shortDescription: 'Double check overlapping active ingredients in multi-symptom OTC medicines.',
        detailedTip: 'When suggesting cold and pain medications, check for acetaminophen/paracetamol overlaps to avoid accidental over-dosage.',
        promptExample: 'Prompt: "Check if Paracetamol and Cetirizine can be safely taken together for a mild cold."',
        icon: Icons.medication,
      ),
      AiTipItem(
        id: 3,
        title: 'Hydration & Electrolyte Index',
        category: 'Wellness & Diet',
        shortDescription: 'Calculate optimal fluid intake based on body weight & fever temperature.',
        detailedTip: 'During high fever, metabolic rate increases by ~13% per °C elevation. Fluid requirements increase proportionally.',
        promptExample: 'Prompt: "Calculate daily hydration goal for a 65kg patient running 100°F fever for 2 days."',
        icon: Icons.water_drop,
      ),
      AiTipItem(
        id: 4,
        title: 'Fever Grading & Tepid Sponge Guide',
        category: 'AI Diagnostics',
        shortDescription: 'Categorize fever ranges and non-pharmacological cooling techniques.',
        detailedTip: 'Low grade (99-100.9°F), Moderate (101-102.9°F), High (≥103°F). Use tepid water (never ice water) for sponging.',
        promptExample: 'Prompt: "What are safe cooling measures for a child with 101°F fever prior to doctor visit?"',
        icon: Icons.thermostat,
      ),
      AiTipItem(
        id: 5,
        title: 'Red Flag Emergency Alerting',
        category: 'Symptom Logic',
        shortDescription: 'Identify critical danger signs requiring immediate ER visits.',
        detailedTip: 'Shortness of breath, severe chest pain, sudden numbness, or unresponsiveness must bypass regular home care.',
        promptExample: 'Prompt: "List emergency red flag symptoms associated with severe headache and fever."',
        icon: Icons.warning_amber_rounded,
      ),
      AiTipItem(
        id: 6,
        title: 'Sleep Hygiene AI Schedule',
        category: 'Wellness & Diet',
        shortDescription: 'Generate circadian rhythm alignment plans to accelerate immune recovery.',
        detailedTip: 'Deep sleep releases cytokines required for immune response. Target consistent 7-9 hour sleep windows.',
        promptExample: 'Prompt: "Create a 3-step evening wind-down routine for a patient recovering from flu."',
        icon: Icons.bedtime,
      ),
      AiTipItem(
        id: 7,
        title: 'Allergy vs Cold Differentiation',
        category: 'AI Diagnostics',
        shortDescription: 'Use AI pattern matching to distinguish viral cold from allergic rhinitis.',
        detailedTip: 'Colds often include low fever and body aches; allergies feature itchy eyes, clear discharge, and sneeze bursts without fever.',
        promptExample: 'Prompt: "Compare key differences between allergic rhinitis and early viral upper respiratory infection."',
        icon: Icons.compare_arrows,
      ),
      AiTipItem(
        id: 8,
        title: 'Dosage Timing Optimization',
        category: 'Patient Care',
        shortDescription: 'Organize medication schedules around meals for optimal absorption.',
        detailedTip: 'NSAIDS (Ibuprofen) should be taken after food to prevent gastric irritation. Antihistamines are best taken at bedtime.',
        promptExample: 'Prompt: "Format a 3-times daily medication schedule around breakfast, lunch, and dinner."',
        icon: Icons.schedule,
      ),
      AiTipItem(
        id: 9,
        title: 'Vitals Monitoring Protocol',
        category: 'Patient Care',
        shortDescription: 'Standardize recording pulse rate, SpO2, blood pressure, and body temp.',
        detailedTip: 'Measure vitals at resting state after 5 minutes of sitting still for accurate baseline comparison.',
        promptExample: 'Prompt: "Create a vital sign log table template for tracking daily temperature and oxygen level."',
        icon: Icons.monitor_heart,
      ),
      AiTipItem(
        id: 10,
        title: 'Dietary Recovery Plans',
        category: 'Wellness & Diet',
        shortDescription: 'Bland diet (BRAT) protocols for acute stomach upsets.',
        detailedTip: 'Bananas, Rice, Applesauce, Toast (BRAT) help solidify stool and soothe stomach mucosa during mild gastroenteritis.',
        promptExample: 'Prompt: "Provide a light meal plan suitable for stomach pain and mild nausea recovery."',
        icon: Icons.restaurant,
      ),
      AiTipItem(
        id: 11,
        title: 'Antibiotic Compliance Reminder',
        category: 'Patient Care',
        shortDescription: 'Emphasize completing full prescription courses to prevent resistance.',
        detailedTip: 'Never stop antibiotics early even if symptoms disappear. Premature stopping fosters drug-resistant bacteria.',
        promptExample: 'Prompt: "Explain in simple terms why antibiotic full course compliance is essential."',
        icon: Icons.verified_user,
      ),
      AiTipItem(
        id: 12,
        title: 'Pediatric Weight-Based Dosage',
        category: 'Medical AI',
        shortDescription: 'Weight-based liquid paracetamol dosage calculation guidance.',
        detailedTip: 'Pediatric dosing is strictly calculated by weight in kg (10-15 mg/kg per dose), NOT by age alone.',
        promptExample: 'Prompt: "What is standard mg/kg dosage formula for pediatric fever management?"',
        icon: Icons.child_care,
      ),
      AiTipItem(
        id: 13,
        title: 'Digital Eye Strain Relief (20-20-20 Rule)',
        category: 'Wellness & Diet',
        shortDescription: 'Mitigate screen fatigue using structured breaks & lubricating drops.',
        detailedTip: 'Every 20 minutes, look at an object 20 feet away for 20 seconds to relax ciliary eye muscles.',
        promptExample: 'Prompt: "Suggest eye exercises and ergonomics for someone working 9 hours on desktop."',
        icon: Icons.visibility,
      ),
      AiTipItem(
        id: 14,
        title: 'BP Reading Best Practices',
        category: 'AI Diagnostics',
        shortDescription: 'Avoid silent errors in digital home blood pressure monitors.',
        detailedTip: 'Rest arm at heart level, refrain from talking, keep feet flat on floor, and avoid caffeine 30 min before measurement.',
        promptExample: 'Prompt: "List common mistakes that give artificially high home blood pressure readings."',
        icon: Icons.favorite,
      ),
      AiTipItem(
        id: 15,
        title: 'Steam Inhalation Guidelines',
        category: 'Patient Care',
        shortDescription: 'Safe steam therapy for nasal congestion without facial burn risks.',
        detailedTip: 'Keep face at least 12 inches away from hot water basin. Limit sessions to 10 minutes maximum.',
        promptExample: 'Prompt: "What are safe home remedies for relieving severe nasal blockage in adults?"',
        icon: Icons.air,
      ),
      AiTipItem(
        id: 16,
        title: 'Cough Classification (Productive vs Dry)',
        category: 'AI Diagnostics',
        shortDescription: 'Select appropriate expectorants or suppressants based on cough type.',
        detailedTip: 'Dry tickly cough benefits from suppressants (Dextromethorphan); wet phlegm cough requires expectorants (Guaifenesin).',
        promptExample: 'Prompt: "Differentiate dry irritant cough from productive phlegm cough symptoms."',
        icon: Icons.spatial_audio_off,
      ),
      AiTipItem(
        id: 17,
        title: 'First Aid Burns Protocol',
        category: 'Symptom Logic',
        shortDescription: 'Immediate cool water immersion rule for first-degree thermal burns.',
        detailedTip: 'Run cool tap water over burn for 10-15 minutes immediately. Never apply ice, butter, or toothpaste.',
        promptExample: 'Prompt: "What is correct emergency first aid procedure for minor kitchen steam burns?"',
        icon: Icons.local_fire_department,
      ),
      AiTipItem(
        id: 18,
        title: 'Throat Salt Water Gargle Ratio',
        category: 'Wellness & Diet',
        shortDescription: 'Osmotic relief for sore inflamed pharynx tissue.',
        detailedTip: 'Dissolve 1/2 teaspoon of table salt in 1 cup of warm water. Gargle for 30 seconds 3 times daily.',
        promptExample: 'Prompt: "Explain how warm saline gargles reduce swelling in viral throat infections."',
        icon: Icons.clean_hands,
      ),
      AiTipItem(
        id: 19,
        title: 'Dehydration Skin Turgor Test',
        category: 'AI Diagnostics',
        shortDescription: 'Simple physical check for fluid depletion level.',
        detailedTip: 'Pinch skin on back of hand. If skin takes >2 seconds to return to flat position, moderate dehydration is indicated.',
        promptExample: 'Prompt: "How to check physical signs of mild to moderate dehydration at home?"',
        icon: Icons.touch_app,
      ),
      AiTipItem(
        id: 20,
        title: 'Vitamin D & Sun Exposure Window',
        category: 'Wellness & Diet',
        shortDescription: 'Optimize midday sunlight synthesis without sunburn.',
        detailedTip: '15 minutes of midday sun on arms & legs 3 times a week yields optimal natural Vitamin D synthesis.',
        promptExample: 'Prompt: "What are symptoms of Vitamin D deficiency and recommended safe sunshine duration?"',
        icon: Icons.wb_sunny,
      ),
      AiTipItem(
        id: 21,
        title: 'Pulse Oximeter Accuracy Check',
        category: 'Patient Care',
        shortDescription: 'Ensure valid SpO2 readings (cold hands & nail polish factors).',
        detailedTip: 'Warm cold fingers before applying pulse oximeter. Dark nail polish can attenuate sensor light accuracy.',
        promptExample: 'Prompt: "Why does cold finger temperature cause false low readings on pulse oximeters?"',
        icon: Icons.analytics,
      ),
      AiTipItem(
        id: 22,
        title: 'Stress Relief 4-7-8 Breathing',
        category: 'Wellness & Diet',
        shortDescription: 'Vagus nerve activation to lower rapid pulse and acute anxiety.',
        detailedTip: 'Inhale through nose for 4 seconds, hold breath for 7 seconds, exhale slowly through mouth for 8 seconds.',
        promptExample: 'Prompt: "Guide me through 4-7-8 deep breathing technique step-by-step."',
        icon: Icons.self_improvement,
      ),
      AiTipItem(
        id: 23,
        title: 'Medication Storage & Expiry Check',
        category: 'Patient Care',
        shortDescription: 'Avoid storing syrups and pills in hot, humid bathroom cabinets.',
        detailedTip: 'Store medicines in cool, dry places below 25°C away from direct light. Inspect liquid syrups for cloudiness.',
        promptExample: 'Prompt: "Why should prescription medications not be stored in bathroom medicine cabinets?"',
        icon: Icons.inventory_2,
      ),
      AiTipItem(
        id: 24,
        title: 'Telemedicine Consultation Preparation',
        category: 'Medical AI',
        shortDescription: 'Maximize 10-minute online doctor appointments with AI summary cards.',
        detailedTip: 'Prepare 3 bullet points: Main concern, timeline of symptoms, and current active medications list before video call.',
        promptExample: 'Prompt: "Generate a concise summary template to send my doctor before a virtual consultation."',
        icon: Icons.videocam,
      ),
    ];
  }

  List<AiTipItem> get _filteredTips {
    return _tipsList.where((tip) {
      final matchesCategory = _selectedCategory == 'All' || tip.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          tip.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tip.shortDescription.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tip.detailedTip.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _showTipDialog(AiTipItem tip) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(tip.icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '#${tip.id} ${tip.title}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Chip(
                label: Text(tip.category),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              const SizedBox(height: 12),
              const Text(
                'Clinical / Practical Guidance:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(tip.detailedTip, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Prompt Template:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      tip.promptExample,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Copy Prompt',
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: tip.promptExample));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI Prompt copied to clipboard!')),
              );
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTips;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        // Category bar & Search Header
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Search input
              TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search 24 AI Health Tips...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Category ChoiceChips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: primaryColor.withValues(alpha: 0.2),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Tips List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'No AI tips found matching criteria.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final tip = filtered[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withValues(alpha: 0.15),
                          child: Icon(tip.icon, color: primaryColor),
                        ),
                        title: Row(
                          children: [
                            Text(
                              '#${tip.id} ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tip.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              tip.shortDescription,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.teal.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tip.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                tip.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                color: tip.isBookmarked ? Colors.amber : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  tip.isBookmarked = !tip.isBookmarked;
                                });
                              },
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          ],
                        ),
                        onTap: () => _showTipDialog(tip),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: PRESCRIPTION GENERATOR TAB
// -----------------------------------------------------------------------------

class PrescriptionGeneratorTab extends StatefulWidget {
  const PrescriptionGeneratorTab({super.key});

  @override
  State<PrescriptionGeneratorTab> createState() => _PrescriptionGeneratorTabState();
}

class _PrescriptionGeneratorTabState extends State<PrescriptionGeneratorTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  String _gender = 'Male';
  String _severity = 'Mild';
  bool _isGenerating = false;
  bool _showOutput = false;

  String _outName = '';
  String _outAge = '';
  String _outGender = '';
  String _outSymptoms = '';
  String _outDiagnosis = '';
  List<Map<String, String>> _outMedicines = [];
  List<String> _outAdvice = [];
  String _rxId = '';

  final List<String> _quickSymptoms = [
    'Fever',
    'Cold & Cough',
    'Headache',
    'Stomach Pain',
    'Sore Throat',
    'Body Pain',
    'Acid Reflux',
  ];

  void _addQuickSymptom(String symptom) {
    final current = _symptomsController.text.trim();
    if (current.isEmpty) {
      _symptomsController.text = symptom;
    } else if (!current.toLowerCase().contains(symptom.toLowerCase())) {
      _symptomsController.text = '$current, $symptom';
    }
  }

  void _generatePrescription() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isGenerating = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final symptoms = _symptomsController.text.trim().toLowerCase();

    List<Map<String, String>> meds = [];
    List<String> advice = [
      'Drink plenty of warm water throughout the day.',
      'Get adequate rest (7-8 hours of sound sleep).',
      'Avoid oily, spicy, or heavy fried foods.',
    ];
    String diagnosis = 'General Consultation & Symptomatic Relief';

    if (symptoms.contains('fever')) {
      diagnosis = 'Mild Acute Viral Fever';
      meds.add({
        'name': 'Paracetamol 500mg',
        'dosage': '1 Tablet twice daily after meals (Max 3 days)',
        'type': 'Tablet',
      });
      advice.add('Monitor body temperature every 6 hours.');
    }

    if (symptoms.contains('cold') || symptoms.contains('cough') || symptoms.contains('throat')) {
      if (diagnosis.contains('Fever')) {
        diagnosis = 'Upper Respiratory Infection (URTI)';
      } else {
        diagnosis = 'Common Cold / Allergic Rhinitis';
      }
      meds.add({
        'name': 'Cetirizine 10mg',
        'dosage': '1 Tablet at bedtime for 5 days',
        'type': 'Tablet',
      });
      meds.add({
        'name': 'Warm Salt Gargle / Steam Inhalation',
        'dosage': '2-3 times daily',
        'type': 'Home Therapy',
      });
    }

    if (symptoms.contains('pain') || symptoms.contains('headache') || symptoms.contains('body')) {
      meds.add({
        'name': 'Ibuprofen 400mg',
        'dosage': '1 Tablet after meal when needed for pain',
        'type': 'Tablet',
      });
    }

    if (symptoms.contains('stomach') || symptoms.contains('acid') || symptoms.contains('reflux')) {
      diagnosis = 'Gastritis / Mild Indigestion';
      meds.add({
        'name': 'Pantoprazole 40mg',
        'dosage': '1 Tablet daily in morning before food (3 days)',
        'type': 'Capsule',
      });
      meds.add({
        'name': 'ORS Liquid / Electrolyte Supplement',
        'dosage': 'Sip gradually over the day',
        'type': 'Oral Solution',
      });
    }

    if (meds.isEmpty) {
      meds.add({
        'name': 'Multivitamin & Zinc Supplement',
        'dosage': '1 Tablet daily after breakfast for 7 days',
        'type': 'Supplement',
      });
      advice.add('Consult a registered physician if symptoms persist beyond 48 hours.');
    }

    final randomNum = (10000 + (name.hashCode % 89999)).abs();

    setState(() {
      _isGenerating = false;
      _showOutput = true;
      _outName = name;
      _outAge = age;
      _outGender = _gender;
      _outSymptoms = _symptomsController.text.trim();
      _outDiagnosis = diagnosis;
      _outMedicines = meds;
      _outAdvice = advice;
      _rxId = 'RX-AI-$randomNum';
    });
  }

  void _resetForm() {
    setState(() {
      _showOutput = false;
      _nameController.clear();
      _ageController.clear();
      _symptomsController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Input Form Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.edit_note, color: primaryColor, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'Patient RX Input Form',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Name & Age Row
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Patient Name *',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) =>
                                (val == null || val.trim().isEmpty) ? 'Enter patient name' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Age *',
                              prefixIcon: Icon(Icons.cake),
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) =>
                                (val == null || val.trim().isEmpty) ? 'Enter age' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Gender & Severity Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _gender,
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              prefixIcon: Icon(Icons.people),
                              border: OutlineInputBorder(),
                            ),
                            items: ['Male', 'Female', 'Other']
                                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                                .toList(),
                            onChanged: (val) => setState(() => _gender = val!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _severity,
                            decoration: const InputDecoration(
                              labelText: 'Severity',
                              prefixIcon: Icon(Icons.speed),
                              border: OutlineInputBorder(),
                            ),
                            items: ['Mild', 'Moderate', 'Severe']
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (val) => setState(() => _severity = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Symptoms Input
                    TextFormField(
                      controller: _symptomsController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Patient Symptoms *',
                        hintText: 'e.g. High fever, headache, dry cough since 2 days',
                        prefixIcon: Icon(Icons.sick),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          (val == null || val.trim().isEmpty) ? 'Please describe symptoms' : null,
                    ),
                    const SizedBox(height: 10),

                    // Quick symptom tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: _quickSymptoms.map((sym) {
                        return ActionChip(
                          avatar: const Icon(Icons.add, size: 14),
                          label: Text(sym, style: const TextStyle(fontSize: 12)),
                          onPressed: () => _addQuickSymptom(sym),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Generate Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: _isGenerating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.smart_toy),
                        label: Text(
                          _isGenerating ? 'Analyzing & Generating...' : 'Generate AI Prescription',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isGenerating ? null : _generatePrescription,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Output Prescription Card
          if (_showOutput)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: primaryColor, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // RX Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Rx',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                fontFamily: 'serif',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AI Clinical Prescription',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  'ID: $_rxId • Ref: Standard AI Care',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          tooltip: 'Copy Full Prescription',
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            final text = '''
=== AI CLINICAL PRESCRIPTION ===
Rx ID: $_rxId
Patient Name: $_outName
Age / Gender: $_outAge yrs / $_outGender
Symptoms: $_outSymptoms
Diagnosis: $_outDiagnosis

SUGGESTED MEDICATIONS:
${_outMedicines.map((m) => "- ${m['name']} (${m['type']}): ${m['dosage']}").join('\n')}

ADVICE:
${_outAdvice.map((a) => "- $a").join('\n')}

*Disclaimer: AI generated preliminary recommendation. Consult physician.*
''';
                            Clipboard.setData(ClipboardData(text: text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Prescription copied to clipboard!')),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Patient Meta Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Patient: $_outName',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Symptoms: $_outSymptoms', style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Age/Sex: $_outAge / $_outGender'),
                              Text('Diagnosis: $_outDiagnosis',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.teal,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Prescribed Medications:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 8),

                    // Medicines Table/List
                    Column(
                      children: _outMedicines.map((med) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: primaryColor.withValues(alpha: 0.15),
                                child: Icon(Icons.medication, size: 16, color: primaryColor),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      med['name']!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      'Dosage: ${med['dosage']}',
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Chip(
                                label: Text(med['type']!, style: const TextStyle(fontSize: 10)),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Clinical Advice & Dietary Guidelines:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _outAdvice
                          .map((adv) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Expanded(child: Text(adv, style: const TextStyle(fontSize: 13))),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 16),

                    // Disclaimer Callout
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.warning, color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Medical Disclaimer: This prescription is generated by AI logic for informational guidance only. Please consult a qualified doctor for actual medical treatment.',
                              style: TextStyle(fontSize: 11, color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Create New'),
                          onPressed: _resetForm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: HEALTH GUIDE TAB
// -----------------------------------------------------------------------------

class HealthGuideTab extends StatelessWidget {
  const HealthGuideTab({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    final List<Map<String, String>> guides = [
      {
        'title': 'Emergency First Response',
        'sub': 'Dial national helpline 108 or 112 for acute emergencies, severe bleeding, or unconsciousness.',
        'icon': 'local_hospital',
      },
      {
        'title': 'Fever & Infection Care',
        'sub': 'Maintain hydration, keep room well-ventilated, monitor temp every 4 hours, and avoid heavy blankets.',
        'icon': 'thermostat',
      },
      {
        'title': 'Chest Pain & Heart Red Flags',
        'sub': 'Crushing chest pressure radiating to left arm or jaw requires immediate emergency medical transport.',
        'icon': 'favorite',
      },
      {
        'title': 'Healthy Lifestyle Habits',
        'sub': 'Walk 30 minutes daily, stay hydrated with 2.5L water, and limit refined sugars to boost immunity.',
        'icon': 'directions_walk',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: primaryColor.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.medical_information, size: 36, color: primaryColor),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Health Reference Hub',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Essential medical awareness & safety protocols.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...guides.map((g) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryColor.withValues(alpha: 0.15),
                  child: Icon(
                    g['icon'] == 'local_hospital'
                        ? Icons.local_hospital
                        : g['icon'] == 'thermostat'
                            ? Icons.thermostat
                            : g['icon'] == 'favorite'
                                ? Icons.favorite
                                : Icons.directions_walk,
                    color: primaryColor,
                  ),
                ),
                title: Text(
                  g['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(g['sub']!),
                ),
              ),
            )),
      ],
    );
  }
}
