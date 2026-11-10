import 'package:flutter/material.dart';
import '../state/converter_notifier.dart';

class SettingsDialog extends StatelessWidget {
  final ConverterNotifier notifier;

  const SettingsDialog({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.tune_rounded),
          SizedBox(width: 8),
          Text('Preferences'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Decimal precision
            const Text(
              'Decimal Precision',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: [2, 4, 6].map((p) {
                final isSelected = notifier.precision == p;
                return ChoiceChip(
                  label: Text('$p decimals'),
                  selected: isSelected,
                  onSelected: (_) => notifier.setPrecision(p),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Live conversion toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Live Conversion', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text('Calculate automatically as you type', style: TextStyle(fontSize: 12)),
              value: notifier.isLiveMode,
              onChanged: (val) => notifier.toggleLiveMode(val),
            ),

            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            // Theme mode
            const Text(
              'Theme',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('System'),
                  selected: notifier.themeMode == ThemeMode.system,
                  onSelected: (_) => notifier.setThemeMode(ThemeMode.system),
                ),
                ChoiceChip(
                  label: const Text('Light'),
                  selected: notifier.themeMode == ThemeMode.light,
                  onSelected: (_) => notifier.setThemeMode(ThemeMode.light),
                ),
                ChoiceChip(
                  label: const Text('Dark'),
                  selected: notifier.themeMode == ThemeMode.dark,
                  onSelected: (_) => notifier.setThemeMode(ThemeMode.dark),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

