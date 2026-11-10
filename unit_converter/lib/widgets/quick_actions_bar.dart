import 'package:flutter/material.dart';

class QuickActionsBar extends StatelessWidget {
  final ValueChanged<String> onSelectValue;
  final VoidCallback onClear;
  final VoidCallback onSwap;
  final Color accentColor;

  const QuickActionsBar({
    super.key,
    required this.onSelectValue,
    required this.onClear,
    required this.onSwap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final samples = ['1', '5', '10', '100', '1000'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Swap Units Button
          OutlinedButton.icon(
            onPressed: onSwap,
            icon: const Icon(Icons.swap_horiz_rounded, size: 16),
            label: const Text('Swap'),
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: accentColor,
              side: BorderSide(color: accentColor.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
          ),
          const SizedBox(width: 8),

          // Clear Button
          OutlinedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.backspace_outlined, size: 14),
            label: const Text('Clear'),
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: Colors.redAccent,
              side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.4)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
          ),
          const SizedBox(width: 8),

          // Preset sample number chips
          ...samples.map((val) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ActionChip(
                label: Text(val),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                side: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onPressed: () => onSelectValue(val),
              ),
            );
          }),
        ],
      ),
    );
  }
}

