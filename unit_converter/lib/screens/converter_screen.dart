import 'package:flutter/material.dart';
import '../state/converter_notifier.dart';
import '../widgets/category_selector.dart';
import '../widgets/unit_dropdown.dart';
import '../widgets/result_card.dart';
import '../widgets/quick_actions_bar.dart';
import '../widgets/history_bottom_sheet.dart';
import '../widgets/settings_dialog.dart';

class ConverterScreen extends StatelessWidget {
  final ConverterNotifier notifier;

  const ConverterScreen({super.key, required this.notifier});

  void _showValidationToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onConvertPressed(BuildContext context) {
    final result = notifier.convert(isManual: true);
    if (result == null && notifier.validationError != null) {
      _showValidationToast(context, notifier.validationError!);
    }
  }

  void _openHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HistoryBottomSheet(
        history: notifier.history,
        onSelectHistory: (item) => notifier.restoreHistory(item),
        onClearHistory: () => notifier.clearHistory(),
      ),
    );
  }

  void _openSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => SettingsDialog(notifier: notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryColor = notifier.selectedCategory.themeColor;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.sync_alt_rounded, color: categoryColor, size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              'Unit Converter',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ],
        ),
        actions: [
          // Conversion History Action with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.history_rounded),
                tooltip: 'History',
                onPressed: () => _openHistorySheet(context),
              ),
              if (notifier.history.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${notifier.history.length > 9 ? '9+' : notifier.history.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          // Preferences / Settings Action
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => _openSettingsDialog(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // 1. CATEGORY SELECTOR (Switch between measurement types)
              CategorySelector(
                categories: notifier.categories,
                selectedCategory: notifier.selectedCategory,
                onCategorySelected: (cat) => notifier.selectCategory(cat),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2. INPUT VALUE CARD
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: notifier.validationError != null
                              ? Colors.redAccent
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          width: notifier.validationError != null ? 1.5 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ENTER VALUE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                  color: isDark ? Colors.white60 : Colors.black54,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: categoryColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  notifier.selectedCategory.name,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: categoryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Numeric Input Field
                          TextField(
                            controller: notifier.inputController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                            decoration: InputDecoration(
                              hintText: '0.00',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              suffixIcon: notifier.inputController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.cancel_rounded, size: 22, color: Colors.grey),
                                      onPressed: () => notifier.clearInput(),
                                    )
                                  : null,
                            ),
                            onChanged: (val) => notifier.onInputChanged(val),
                            onSubmitted: (_) => _onConvertPressed(context),
                          ),

                          if (notifier.validationError != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.error_outline_rounded,
                                    color: Colors.redAccent, size: 16),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    notifier.validationError!,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 12),

                          // Quick Action Chips (Presets, Swap, Clear)
                          QuickActionsBar(
                            accentColor: categoryColor,
                            onSelectValue: (val) => notifier.setSampleValue(val),
                            onClear: () => notifier.clearInput(),
                            onSwap: () => notifier.swapUnits(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 3. SOURCE & TARGET DROPDOWNS (SPINNERS) WITH SWAP BUTTON
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Source Unit Dropdown
                        Expanded(
                          child: UnitDropdown(
                            label: 'From Unit',
                            selectedUnit: notifier.fromUnit,
                            units: notifier.selectedCategory.units,
                            accentColor: categoryColor,
                            onChanged: (unit) => notifier.setFromUnit(unit),
                          ),
                        ),

                        // Animated Swap Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Material(
                            color: categoryColor,
                            shape: const CircleBorder(),
                            elevation: 3,
                            shadowColor: categoryColor.withValues(alpha: 0.4),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => notifier.swapUnits(),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.swap_horiz_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Target Unit Dropdown
                        Expanded(
                          child: UnitDropdown(
                            label: 'To Unit',
                            selectedUnit: notifier.toUnit,
                            units: notifier.selectedCategory.units,
                            accentColor: categoryColor,
                            onChanged: (unit) => notifier.setToUnit(unit),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 4. CONVERT BUTTON
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _onConvertPressed(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: categoryColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: categoryColor.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bolt_rounded, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Convert',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 5. RESULT DISPLAY TEXTVIEW / CARD
                    ResultCard(
                      result: notifier.lastResult,
                      categoryColor: categoryColor,
                      precision: notifier.precision,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

