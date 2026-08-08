import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SidebarNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final AppAccentColor currentAccent;
  final ValueChanged<AppAccentColor> onSelectAccent;

  const SidebarNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.isDark,
    required this.onToggleTheme,
    required this.currentAccent,
    required this.onSelectAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0x1F0F172A) : const Color(0xE6FFFFFF),
        border: Border(
          right: BorderSide(
            color: isDark ? const Color(0x1FAFFFFF) : const Color(0x1F000000),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: currentAccent.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.access_time_filled, color: currentAccent.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Abhishek Clock",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // Navigation Menu Items
          _buildNavItem(context, 0, Icons.access_time, "Clock"),
          _buildNavItem(context, 1, Icons.timer_outlined, "Stopwatch"),
          _buildNavItem(context, 2, Icons.hourglass_bottom, "Timer"),
          _buildNavItem(context, 3, Icons.public, "World Clock"),

          const Spacer(),

          // Settings Section (Theme & Accent)
          const Divider(height: 32),

          // Theme Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Theme",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              IconButton(
                onPressed: onToggleTheme,
                icon: Icon(
                  isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                  color: currentAccent.color,
                ),
                tooltip: "Toggle Theme",
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Accent Color Selector
          Text(
            "Accent Color",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: AppAccentColor.values.map((accent) {
              final isSelected = accent == currentAccent;
              return GestureDetector(
                onTap: () => onSelectAccent(accent),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: accent.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 2.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: accent.color.withValues(alpha: 0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTabSelected(index),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? currentAccent.color.withValues(alpha: 0.18)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: currentAccent.color.withValues(alpha: 0.4))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? currentAccent.color
                      : (isDark ? Colors.white60 : Colors.black54),
                  size: 20,
                ),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? currentAccent.color
                        : (isDark ? const Color(0xE6FFFFFF) : const Color(0xFF0F172A)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
