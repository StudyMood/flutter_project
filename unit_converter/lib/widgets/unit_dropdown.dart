import 'package:flutter/material.dart';
import '../models/unit_item.dart';

class UnitDropdown extends StatelessWidget {
  final String label;
  final UnitItem selectedUnit;
  final List<UnitItem> units;
  final ValueChanged<UnitItem> onChanged;
  final Color accentColor;

  const UnitDropdown({
    super.key,
    required this.label,
    required this.selectedUnit,
    required this.units,
    required this.onChanged,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              width: 1.2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UnitItem>(
              value: selectedUnit,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down_rounded, color: accentColor, size: 28),
              elevation: 4,
              borderRadius: BorderRadius.circular(16),
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              onChanged: (UnitItem? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              items: units.map<DropdownMenuItem<UnitItem>>((UnitItem unit) {
                return DropdownMenuItem<UnitItem>(
                  value: unit,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          unit.symbol,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          unit.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

